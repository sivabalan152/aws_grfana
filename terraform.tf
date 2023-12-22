terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     grafana = {
         source  = "grafana/grafana"
         version = "1.40.1"
      }
  }
}


provider "aws" {
  region = "ap-southeast-2"
}
provider "grafana" {
  alias = "cloud"

  url  = "https://${aws_grafana_workspace.workspace.id}.grafana-workspace.${var.region}.amazonaws.com"
  auth = aws_grafana_workspace_api_key.key.key
}