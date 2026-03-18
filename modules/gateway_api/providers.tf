terraform {
  required_version = ">= 1.8.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}
