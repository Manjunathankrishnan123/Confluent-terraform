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

resource "confluent_environment" "production" {
  display_name = "Production"
}


//Confluent standard cluster

resource "confluent_kafka_cluster" "standard" {
  display_name = "prod_standard_kafka_cluster"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = var.region
  standard {}

  environment {
    id = confluent_environment.production.id
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

resource "confluent_ksql_cluster" "prod-ksql-cluster-db" {
  display_name = "prod-ksql-cluster-db"
  csu          = 1
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  credential_identity {
    id = confluent_service_account.app-manager-prod.id
  }
  environment {
    id = confluent_environment.production.id
  }
  depends_on = [
    confluent_role_binding.app-manager-prod-kafka-cluster-admin,
    confluent_schema_registry_cluster.essentials
  ]
}

//SCHEMA REGISTRY
resource "confluent_schema_registry_cluster" "essentials" {
  package = data.confluent_schema_registry_region.essentialsdata.package

  environment {
    id = confluent_environment.production.id
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
    id = confluent_kafka_cluster.standard.id
  }
  topic_name    = "pksqlc-qw217PQ_FORM_W2"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "pksqlc-qw217PQ_FORM_NEC" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name    = "pksqlc-qw217PQ_FORM_NEC"
  partitions_count = 1
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

