terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "existing" {
  id = "vpc-00441fec4aa7837b0"
}

output "vpc_id" {
  value = data.aws_vpc.existing.id
}

output "vpc_cidr_block" {
  value = data.aws_vpc.existing.cidr_block
}

data "aws_ecs_cluster" "existing" {
  cluster_name = "acme-equipment-cluster"
}

output "ecs_cluster_arn" {
  value = data.aws_ecs_cluster.existing.arn
}

data "aws_ecs_service" "existing" {
  service_name = "acme-equipment-service"
  cluster_arn  = data.aws_ecs_cluster.existing.arn
}

output "ecs_service_name" {
  value = data.aws_ecs_service.existing.service_name
}

output "ecs_service_status" {
  value = data.aws_ecs_service.existing.status
}
