# Terraform Infrastructure

This configuration adopts the existing production EC2 instance and security
group. It does not create a second server, and it must never be applied before
the import steps below.

## Prerequisites

- Terraform 1.5 or newer
- AWS credentials supplied through the standard AWS credential chain
  (environment variables, shared credentials file, or an AWS profile)
- Read access to inspect the existing EC2 and VPC resources

Copy `terraform.tfvars.example` to `terraform.tfvars` and replace the
placeholders with the current AWS values. The local file is ignored and must
never be committed. No passwords, tokens, or access keys belong in Terraform
files.

## Initialize and import

From the repository root:

```bash
cd terraform
terraform init
terraform import aws_instance.production i-02318fd1b3f7f89b3
terraform import aws_security_group.production sg-REPLACE_WITH_EXISTING_SECURITY_GROUP_ID
```

Replace the security group placeholder with the ID already attached to
`devops-demo-server`. Import only; do not run `terraform apply` as part of this
initial setup.

## Validate and review safely

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

Review the plan carefully. `prevent_destroy = true` protects both imported
resources, while lifecycle settings preserve the existing instance storage,
network placement, public IP behavior, and security-group rules. A plan that
proposes replacement, destruction, or unexpected rule changes must not be
applied; first update the variables/configuration to match AWS.

The security group documents SSH (22), API (8000), and HTTP (80) access. It
does not include public PostgreSQL access (5432). The existing named Docker
volume and application deployment remain outside Terraform and are managed by
Docker Compose and GitHub Actions.
