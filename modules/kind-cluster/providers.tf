terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.10.0, < 1.0.0"
    }
  }
}
