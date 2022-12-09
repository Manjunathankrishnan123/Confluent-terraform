terraform {
  required_version = ">= 0.14.0"
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "staging" {
  display_name = "Staging"
}

#CONFLUENT NETWORK CREATION
/*resource "confluent_network" "peering" {
  display_name     = "Peering Network"
  cloud            = "AWS"
  region           = var.region
  cidr             = var.cidr
  connection_types = ["PEERING"]
  environment {
    id = confluent_environment.staging.id
  }
}

resource "confluent_peering" "aws" {
  display_name = "AWS Peering"
  aws {
    account         = var.aws_account_id
    vpc             = var.vpc_id
    routes          = var.routes
    customer_region = var.customer_region
  }
  environment {
    id = confluent_environment.staging.id
  }
  network {
    id = confluent_network.peering.id
  }
}*/


#Confluent basic cluster
resource "confluent_kafka_cluster" "basic" {
  display_name = "stage_basic_kafka_cluster"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = var.region
  basic {}

  environment {
    id = confluent_environment.staging.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

//INCLUDE SCHEMA REGISTRY

data "confluent_schema_registry_region" "essentialsdata" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_ksql_cluster" "stage-ksql-cluster-db" {
  display_name = "stage-ksql-cluster-db"
  csu          = 1
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  credential_identity {
    id = confluent_service_account.app-manager.id
  }
  environment {
    id = confluent_environment.staging.id
  }
  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin,
    confluent_schema_registry_cluster.essentials
  ]
}

//SCHEMA REGISTRY
resource "confluent_schema_registry_cluster" "essentials" {
  package = data.confluent_schema_registry_region.essentialsdata.package

  environment {
    id = confluent_environment.staging.id
  }

  region {
    id = data.confluent_schema_registry_region.essentialsdata.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

//TOPIC CREATION TERRAFORM

resource "confluent_kafka_topic" "pksqlc-qw217PQ_FORM_W2" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name    = "pksqlc-qw217PQ_FORM_W2"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "pksqlc-qw217PQ_FORM_NEC" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name    = "pksqlc-qw217PQ_FORM_NEC"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

