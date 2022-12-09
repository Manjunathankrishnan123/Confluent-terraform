//SERVICE ACCOUNT AND RBAC

//'app-manager-prod' service account is required in this configuration to grant ACLs
//to 'app-producer-prod' and 'app-consumer' service accounts.

resource "confluent_service_account" "app-manager-prod" {
  display_name = "app-manager-prod"
  description  = "Service account to manage 'stage_standard_kafka_cluster' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-prod-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager-prod.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.standard.rbac_crn
}

resource "confluent_api_key" "app-manager-prod-kafka-api-key" {
  display_name = "app-manager-prod-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager-prod' service account"

  # Set optional `disable_wait_for_ready` attribute (defaults to `false`) to `true` if the machine where Terraform is not run within a private network
  # disable_wait_for_ready = true

  owner {
    id          = confluent_service_account.app-manager-prod.id
    api_version = confluent_service_account.app-manager-prod.api_version
    kind        = confluent_service_account.app-manager-prod.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.production.id
    }
  }
}


//PRODUCER SERVICE ACCOUNT

resource "confluent_kafka_acl" "app-producer-prod-write-on-topic" {
  kafka_cluster { 
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "*"     //* for all topics
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-producer-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id   //Created from service account app-manager-prod
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret 
  }
}

resource "confluent_service_account" "app-producer-prod" {
  display_name = "app-producer-prod"
  description  = "Service account to produce to 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_api_key" "app-producer-prod-kafka-api-key" {
  display_name = "app-producer-prod-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-producer-prod' service account"

  # Set optional `disable_wait_for_ready` attribute (defaults to `false`) to `true` if the machine where Terraform is not run within a private network
  # disable_wait_for_ready = true

  owner {
    id          = confluent_service_account.app-producer-prod.id
    api_version = confluent_service_account.app-producer-prod.api_version
    kind        = confluent_service_account.app-producer-prod.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.production.id
    }
  }
}
