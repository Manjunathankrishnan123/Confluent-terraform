variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)."
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The region of Confluent Cloud Network."
  type        = string
}

/*variable "cidr" {
  description = "The CIDR of Confluent Cloud Network."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID of the peer VPC owner (12 digits)."
  type        = string
}

variable "vpc_id" {
  description = "The AWS VPC ID of the peer VPC that you're peering with Confluent Cloud."
  type        = string
}

variable "routes" {
  description = "The AWS VPC CIDR blocks or subsets. This must be from the supported CIDR blocks and must not overlap with your Confluent Cloud CIDR block or any other network peering connection VPC CIDR."
  type        = list(string)
}*/

variable "customer_region" {
  description = "The region of the AWS peer VPC."
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS access key for lambda connector"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret access key for lambda connector"
  sensitive   = true
  type        = string
}

variable "database_hostname" {
  description = "MSQL Database hostname "
  sensitive   = true
  type        = string
}

variable "database_user" {
  description = "MSQL Database User "
  sensitive   = true
  type        = string
}

variable "database_password" {
  description = "MSQL Database Password "
  sensitive   = true
  type        = string
}

variable "database_table_list" {
  description = "MSQL Database Table list"
  sensitive   = true
  type        = string
}

variable "lambda_topics" {
  description = "Lambda Topic Name"
  sensitive   = true
  type        = string
}

variable "lambda_function_names" {
  description = "Lambda Function Name"
  sensitive   = true
  type        = string
}

variable "mongodb_topics" {
  description = "MongoDB Topic Name"
  sensitive   = true
  type        = string
}

variable "mongodb_host" {
  description = "MongoDB Host Name"
  sensitive   = true
  type        = string
}

variable "mongodb_password" {
  description = "MongoDB Password"
  sensitive   = true
  type        = string
}


