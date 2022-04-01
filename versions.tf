terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  required_version = "~> 1.1"
}
