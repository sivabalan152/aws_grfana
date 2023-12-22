terraform {
  cloud {
    organization = "demo152"

    workspaces {
      name = "testing"
    }
  }
}