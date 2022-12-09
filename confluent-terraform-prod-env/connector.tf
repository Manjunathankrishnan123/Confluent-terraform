// FILE FOR CONNECTORS NEEDED AND ACLS FOR SPECIFIC TOPICS 
//  https://docs.confluent.io/cloud/current/connectors/limits.html#microsoft-sql-server-cdc-source-connector-debezium

resource "confluent_service_account" "app-connector-prod" {
  display_name = "app-connector-prod"
  description  = "Service account for connector in standard cluster"
}

resource "confluent_api_key" "app-connector-prod-kafka-api-key" {
  display_name = "app-connector-prod-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-connector-prod' service account"

  # Set optional `disable_wait_for_ready` attribute (defaults to `false`) to `true` if the machine where Terraform is not run within a private network
  # disable_wait_for_ready = true

  owner {
    id          = confluent_service_account.app-connector-prod.id
    api_version = confluent_service_account.app-connector-prod.api_version
    kind        = confluent_service_account.app-connector-prod.kind
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

resource "confluent_kafka_acl" "app-connector-prod-write-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "prod"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}
resource "confluent_kafka_acl" "app-connector-prod-write-on-dbhistory-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "dbhistory.prod.lcc-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}
resource "confluent_kafka_acl" "app-connector-prod-create-on-dbhistory-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "dbhistory.prod.lcc-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-describe-config-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "DESCRIBE_CONFIGS"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-read-on-target-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-create-on-dlq-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-write-on-dlq-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-create-on-success-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}


resource "confluent_kafka_acl" "app-connector-prod-create-on-all-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "prod"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-write-on-success-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-create-on-error-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-write-on-error-lcc-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-read-on-connect-lcc-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "GROUP"
  resource_name = "connect-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

//ACL FOR NEW TOPICS TERRAFORM
resource "confluent_kafka_acl" "app-connector-prod-read-on-pksql-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "pksqlc-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-describe-on-pksql-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "pksqlc-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "app-connector-prod-read-on-dbhistory-lcc-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "GROUP"
  resource_name = "prod-dbhistory"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.app-connector-prod.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-prod-kafka-api-key.id
    secret = confluent_api_key.app-manager-prod-kafka-api-key.secret
  }
}


//AWS LAMBDA SINK CONNECTOR TEST
resource "confluent_connector" "lambdasink" {
  environment {
    id = confluent_environment.production.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }

  config_sensitive = {
    "aws.access.key.id"     = var.aws_access_key_id
    "aws.secret.access.key" = var.aws_secret_access_key
  }

  config_nonsensitive = {
    "connector.class"          = "LambdaSink"
    "name"                     = "PROD_LAMBDACONNECTOR"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.app-connector-prod.id
    "topics"                   = var.lambda_topics
    "aws.lambda.topic2function.map" = var.lambda_function_names
    "aws.lambda.configuration.mode" = "multiple"
    "aws.lambda.region"        = var.customer_region
    "input.data.format"        = "AVRO"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_connector.sql-cdc-source,
    confluent_kafka_acl.app-connector-prod-write-on-topic,
    confluent_kafka_acl.app-connector-prod-describe-on-cluster,
    confluent_kafka_acl.app-connector-prod-read-on-target-topic,
    confluent_kafka_acl.app-connector-prod-create-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-read-on-connect-lcc-group,
  ]

  lifecycle {
    prevent_destroy = false
  }
}

//Confluent Microsoft sql cdc Source connector

resource "confluent_connector" "sql-cdc-source" {
  environment {
    id = confluent_environment.production.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }

  config_sensitive = {
    "database.password"        = var.database_password
  }

  config_nonsensitive = {
    "connector.class"          = "SqlServerCdcSource"
    "name"                     = "PROD_CDC_ETF"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.app-connector-prod.id
    "database.hostname"        = var.database_hostname
    "database.port"            = "1433"
    "database.user"            = var.database_user
    "database.dbname"          = "ExpressTaxFilingsDB_Dev"
    "database.server.name"     = "prod"
    "table.include.list"       = var.database_table_list
    "snapshot.mode"            = "schema_only"
    "output.data.format"       = "AVRO"
    "output.key.format"        = "AVRO"
    "tasks.max"                = "1"
    "decimal.handling.mode"    = "double"
    "json.output.decimal.format" = "NUMERIC"
}

  depends_on = [
    confluent_kafka_acl.app-connector-prod-create-on-all-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-dbhistory-topic,
    confluent_schema_registry_cluster.essentials,
    confluent_kafka_acl.app-connector-prod-create-on-dbhistory-topic,
    confluent_kafka_acl.app-connector-prod-describe-on-cluster,
    confluent_kafka_acl.app-connector-prod-read-on-target-topic,
    confluent_kafka_acl.app-connector-prod-read-on-connect-lcc-group,
    confluent_kafka_acl.app-connector-prod-read-on-dbhistory-lcc-group
  ]

  lifecycle {
    prevent_destroy = false
  }
}

// MONGODB ATLAS SINK 
resource "confluent_connector" "mongodbatlasSink" {
  environment {
    id = confluent_environment.production.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }

  config_sensitive = {
    "connection.host"     = var.mongodb_host
    "connection.password" = var.mongodb_password
  }

  config_nonsensitive = {
    "connector.class"          = "MongoDbAtlasSink"
    "name"                     = "PROD_MONGODBATLAS_CONNECTOR"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.app-connector-prod.id
    "topics"                   = var.mongodb_topics
    "connection.user"          = "root"
    "database"                 = "LinkDB_Dev" 
    "collection"               = "Link_Return_Detail"
    "input.data.format"        = "AVRO"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_connector.sql-cdc-source,
    confluent_kafka_acl.app-connector-prod-write-on-topic,
    confluent_kafka_acl.app-connector-prod-describe-on-cluster,
    confluent_kafka_acl.app-connector-prod-read-on-target-topic,
    confluent_kafka_acl.app-connector-prod-create-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-read-on-connect-lcc-group,
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_connector" "redisSink" {
  environment {
    id = confluent_environment.production.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }

  config_sensitive = {
    "redis.hostname"     = var.redis_host
    "redis.password"     = var.redis_password
    "redis.portnumber"   = var.redis_portnumber 
  }

  config_nonsensitive = {
    "connector.class"          = "RedisSink"
    "name"                     = "PROD_RedisSink_CONNECTOR"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.app-connector-prod.id
    "topics"                   = var.redis_topics
    "input.data.format"        = "STRING"
    "input.key.format"         = "STRING"
    "principal"                = "User:${confluent_service_account.app-connector-prod.id}"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_connector.sql-cdc-source,
    confluent_kafka_acl.app-connector-prod-write-on-topic,
    confluent_kafka_acl.app-connector-prod-describe-on-cluster,
    confluent_kafka_acl.app-connector-prod-read-on-target-topic,
    confluent_kafka_acl.app-connector-prod-create-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-prod-create-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-write-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-prod-read-on-connect-lcc-group,
  ]

  lifecycle {
    prevent_destroy = false
  }
}

