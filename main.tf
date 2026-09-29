terraform {
  required_providers {
    env0 = { source = "env0/env0" }
  }
}

provider "env0" {}

variable "project_id" {
  type = string
}

# 3 method + path keys x 1,000 reads: each key stays under its 950/min budget only if the
# 2,000/min total holds the run back.
data "env0_projects" "list" {
  count = 1000
}

data "env0_project" "one" {
  count = 1000
  id    = var.project_id
}

data "env0_organization" "org" {
  count = 1000
}

output "reads" {
  value = length(data.env0_projects.list) + length(data.env0_project.one) + length(data.env0_organization.org)
}
