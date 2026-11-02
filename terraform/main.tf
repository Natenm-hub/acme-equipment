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
  profile = "acme-terraform"
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

resource "aws_cloudwatch_dashboard" "acme_monitoring" {
  dashboard_name = "Acme-Equipment-Monitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 6
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ServiceName",
              "acme-equipment-service",
              "ClusterName",
              "acme-equipment-cluster",
              { id = "m1" }
            ],
            [
              ".",
              "MemoryUtilization",
              ".",
              ".",
              ".",
              ".",
              { id = "m2" }
            ]
          ]
          region = "eu-north-1"
          title  = "ECS CPU and Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = 6
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            [
              "AWS/ECS",
              "LiveTaskCount",
              "ServiceName",
              "acme-equipment-service",
              "ClusterName",
              "acme-equipment-cluster",
              { id = "m1" }
            ]
          ]
          region = "eu-north-1"
          title  = "LiveTaskCount"
        }
      }
    ]
  })
}

