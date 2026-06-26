provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

variable "aws_region" {
  default = "us-east-1"
}

variable "gcp_project" {
  default = "teamos-production"
}

variable "gcp_region" {
  default = "us-central1"
}

# AWS Kubernetes Cluster (EKS)
resource "aws_eks_cluster" "teamos_eks" {
  name     = "teamos-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }
}

# GCP Kubernetes Cluster (GKE)
resource "google_container_cluster" "teamos_gke" {
  name     = "teamos-gke-cluster"
  location = var.gcp_region
  initial_node_count = 3
  node_config {
    machine_type = "e2-standard-4"
  }
}

# AWS RDS Postgres Database
resource "aws_db_instance" "teamos_postgres" {
  identifier           = "teamos-db"
  allocated_storage    = 50
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.r6g.xlarge"
  username             = "teamos_admin"
  password             = "SecureDBPassword123!"
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
}

# AWS ElastiCache Redis
resource "aws_elasticache_replication_group" "teamos_redis" {
  replication_group_id          = "teamos-cache"
  replication_group_description = "Redis Cache Cluster"
  node_type                     = "cache.m6g.large"
  num_cache_clusters            = 2
  parameter_group_name          = "default.redis7"
}

# AWS S3 Bucket (Object Storage)
resource "aws_s3_bucket" "teamos_uploads" {
  bucket = "teamos-enterprise-file-storage"
}

# Mock IAM role and subnets for compilation
resource "aws_iam_role" "eks_role" {
  name = "eks-role"
  assume_role_policy = "{}"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = "vpc-123"
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = "vpc-123"
  cidr_block = "10.0.2.0/24"
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnets"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
