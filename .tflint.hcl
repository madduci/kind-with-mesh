config {
  call_module_type    = "all"
  force               = false
  disabled_by_default = false
}


plugin "terraform" {
  enabled = true

  version = "0.13.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

# not recommended by ruleset
# Disallow // comments in favor of #	
rule "terraform_comment_syntax" {
  enabled = false
}

# recommended by ruleset
# Disallow legacy dot index syntax	
rule "terraform_deprecated_index" {
  enabled = true
}

# recommended by ruleset
# Disallow deprecated (0.11-style) interpolation	
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# recommended by ruleset
# Disallow deprecated lookup() function with only 2 arguments.	
rule "terraform_deprecated_lookup" {
  enabled = true
}

# not recommended by ruleset, but for proper documentation its enabled
# Disallow output declarations without description	
rule "terraform_documented_outputs" {
  enabled = true
}

# not recommended by ruleset, but for proper documentation its enabled
# Disallow variable declarations without description	
rule "terraform_documented_variables" {
  enabled = true
}

# recommended by ruleset
# Disallow comparisons with [] when checking if a collection is empty	
rule "terraform_empty_list_equality" {
  enabled = true
}

# recommended by ruleset
# Disallow duplicate keys in a map object	
rule "terraform_map_duplicate_keys" {
  enabled = true
}

# recommended by ruleset
# Disallow specifying a git or mercurial repository as a module source without pinning to a version
rule "terraform_module_pinned_source" {
  enabled = true
}

# recommended by ruleset
# Checks that Terraform modules sourced from a registry specify a version	
rule "terraform_module_version" {
  enabled = true
}

# not recommended by ruleset. But for setting snake_case naming convention it will be activated and setted explicit.
# Enforces naming conventions for resources, data sources, etc	
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

# recommended by ruleset
# Require that all providers have version constraints through required_providers	
rule "terraform_required_providers" {
  enabled = true
}

# recommended by ruleset
# Disallow terraform declarations without require_version	
rule "terraform_required_version" {
  enabled = true
}

# not recommended by ruleset, also it will force stucture changes for code like no specific variable files. for better maintenance aspectives this flag is disabled
# Ensure that a module complies with the Terraform Standard Module Structure	
rule "terraform_standard_module_structure" {
  enabled = false
}

# recommended by ruleset
# Disallow variable declarations without type	
rule "terraform_typed_variables" {
  enabled = true
}

# recommended by ruleset
# Disallow variables, data sources, and locals that are declared but never used	
rule "terraform_unused_declarations" {
  enabled = true
}

# not recommended by ruleset, but cleans up the code
# Check that all required_providers are used in the module	
rule "terraform_unused_required_providers" {
  enabled = true
}

# recommended by ruleset
# terraform.workspace should not be used with a "remote" backend with remote execution in Terraform v1.0.x
rule "terraform_workspace_remote" {
  enabled = true
}
