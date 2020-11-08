provider "aws" {
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.

  assume_role = "${var.workspace_iam_roles[terraform.workspace]}"
}