confluent_cloud_api_key = "WSCBTYXSTRN5VJ5P"
#confluent_cloud_api_secret = ""

# Cross-region AWS PrivateLink connections are not supported yet.
region = "us-east-1"

# The region of the AWS peer VPC.
customer_region = "us-east-1"

# The CIDR of Confluent Cloud Network
#cidr = "172.16.0.0/16"

# The AWS Account ID of the peer VPC owner.
# You can find your AWS Account ID here (https://console.aws.amazon.com/billing/home?#/account) under My Account section of the AWS Management Console. Must be a 12 character string.
#aws_account_id = ""

# The AWS VPC ID of the peer VPC that you're peering with Confluent Cloud.
# You can find your AWS VPC ID here (https://console.aws.amazon.com/vpc/) under Your VPCs section of the AWS Management Console. Must start with `vpc-`.
#vpc_id = "vpc-0413ad43081c0661d"

# The AWS VPC CIDR blocks or subsets.
# This must be from the supported CIDR blocks and must not overlap with your Confluent Cloud CIDR block or any other network peering connection VPC CIDR (learn more about the requirements [here](https://docs.confluent.io/cloud/current/networking/peering/aws-peering.html#vpc-peering-on-aws)).
# You can find AWS VPC CIDR [here](https://console.aws.amazon.com/vpc/) under **Your VPCs -> Target VPC -> Details** section of the AWS Management Console.
#routes = ["172.31.0.0/16"]

#Microsoft SQL source configurations
database_hostname = "129.80.52.22"  
database_user = "sa"  
database_table_list = "dbo.etf_Returns,dbo.etf_Form_W2,dbo.etf_Static_Country,dbo.etf_Static_State"

#MongoDB AtlasSink Configurations
mongodb_host = "cluster0.homja.mongodb.net"
mongodb_topics = "pksqlc-qw217PQ_FORM_NEC,pksqlc-qw217PQ_FORM_W2"


#AWS Lambda Sink Configurations
lambda_topics = "pksqlc-qw217PQ_FORM_NEC,pksqlc-qw217PQ_FORM_W2"
lambda_function_names = "pksqlc-qw217PQ_FORM_W2;formw2byjson-production-pdf,pksqlc-qw217PQ_FORM_NEC;form1099byjson-production-pdf"
