---
name: omb-lsp-terraform
description: "Terraform LSP patterns — terraform-ls resource navigation, variable resolution, module references, and plan validation."
---

# Terraform LSP Guide

## When to Use LSP (vs Grep/Read)

- **Resource/attribute info** → `lsp_hover` on resource type or attribute
- **Find definition** → `lsp_goto_definition` on variable, module, or resource refs
- **Impact analysis** → `lsp_find_references` (who uses this variable/output)
- **Validation** → `lsp_diagnostics` on file (schema + syntax errors)
- **Safe rename** → `lsp_rename` on variables and locals

## Terraform-Specific Patterns

- **Resource attributes**: hover on `aws_instance.foo` shows all available attributes
- **Module navigation**: goto_definition on `module.vpc` jumps to module source
- **Variable tracing**: find_references on `var.env` shows all usage sites
- **Output resolution**: goto_definition on `module.vpc.vpc_id` finds the output
- **Data sources**: hover on data source shows returned attributes
- **Provider docs**: hover on resource type shows provider schema

## Decision Tree

1. "What attributes does this resource have?" → `lsp_hover`
2. "Where is this variable/module defined?" → `lsp_goto_definition`
3. "Who uses this variable/output?" → `lsp_find_references`
4. "Is this config valid?" → `lsp_diagnostics`
5. "Rename a variable safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Auto-fix?" → `lsp_code_actions`

## Validation Workflow

1. Edit `.tf` file
2. Run `lsp_diagnostics` — terraform-ls validates against provider schemas
3. Hover on flagged attributes to understand expected types
4. Use goto_definition to trace variable values through modules

## Module Navigation

- `lsp_goto_definition` on `source = "./modules/vpc"` opens the module
- `lsp_find_references` on a module output shows all consumers
- Hover on module block shows input variables and their types

## Common Pitfalls

- terraform-ls requires `terraform init` to download provider schemas
- Remote modules need to be fetched before LSP can analyze them
- Workspace-specific variables (`.tfvars`) may not be included in analysis
- State-dependent values (`terraform_remote_state`) cannot be resolved by LSP
