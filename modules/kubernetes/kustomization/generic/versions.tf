terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.6"
    }
  }
}
