terraform {
  required_providers {
    kubernetes = {
          source = "hashicorp/kubernetes"
          version = "~> 2"
    }
  }
}

provider "kubernetes" {
  config_path = format("%s/%s/config", var.user_home_dir, var.cluster_name)
  insecure         = true
  alias            = "aro-atwlab"
}