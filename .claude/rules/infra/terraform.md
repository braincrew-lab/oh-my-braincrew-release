---
paths: ["terraform/**", "infra/**/*.tf", "*.tf"]
---

# Terraform Conventions

## Module Structure
```
terraform/
  modules/
    <module>/
      main.tf
      variables.tf
      outputs.tf
  environments/
    dev/
    staging/
    prod/
```
- One module per logical resource group
- Environments consume modules with different variables
- Keep modules reusable — no hardcoded values

## State Management
- Use remote backend (S3 + DynamoDB, GCS, Terraform Cloud)
- Enable state locking to prevent concurrent modifications
- Never store state in version control
- Use `terraform_remote_state` data source sparingly — prefer outputs

## Variable Naming
- Use snake_case for all variables
- Prefix with resource context: `db_instance_type`, `vpc_cidr`
- Always add `description` and `type` to variables
- Use `validation` blocks for input constraints
- Provide `default` only for optional variables

## Output Conventions
- Output values needed by other modules or external consumers
- Use descriptive names: `database_endpoint`, `cluster_arn`
- Add `description` to every output
- Mark sensitive outputs with `sensitive = true`

## Provider Versioning
- Pin provider versions with `~>` operator: `~> 5.0`
- Pin Terraform version with `required_version`
- Run `terraform init -upgrade` intentionally, not automatically

## Workflow
- Always run `terraform plan` before `terraform apply`
- Review plan output for unexpected changes (especially destroys)
- Use `terraform fmt` and `terraform validate` in CI
- Tag all resources with `project`, `environment`, `managed-by`
