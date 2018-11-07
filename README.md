# Revista

Revista is a reference Elixir umbrella project deployed to AWS ECS with Docker
and Terraform. It was originally created for demonstration purposes in two talks
given by NewAperio:

1. Internal lunch and learn on umbrella apps
2. [Big Elixir] talk on deploying Elixir to AWS

[big elixir]: https://newaperio.com/blog/the-big-elixir

## Umbrella App

**Nick to add**

## Docker

This repo contains a production-ready [Docker] container. It uses a [multi-stage
build] to keep the final image as small as possible.

[docker]: https://www.docker.com
[multi-stage build]:
  https://docs.docker.com/develop/develop-images/multistage-build/

### Building

To build the image, first, make sure you have Docker installed locally. Then run
the following from the root of the repo:

```bash
docker build .
```

## Terraform

This repo contains [Terraform] configuration to manage the resources that
comprise the infrastructure on AWS necessary to run the app. It makes use of
such resources as Route53, RDS, EC2, ECS and more.

[terraform]: https://www.terraform.io

### File structure

The configuration is split across several Terraform modules. It follows the
[Gruntwork file layout]. A directory structure with explanations is below.

```text
infra
├── _base
├── global
│   ├── ecr
│   ├── iam
│   └── route53
└── prod
    ├── data-storage
    │   ├── auth
    │   └── cms
    ├── services
    │   └── web
    └── vpc
```

- `_base/` is a base Terraform module that holds defaults and can be duplicated
  to set up additional modules
- `global/` holds modules for resources that are not particular to any
  environment (including ECR, IAM, and Route53)
- `prod/` holds modules for production resources (the only environment in this
  example)
  - `data-storage/` holds modules for any data storage resources, such as the
    two RDS databases we use here
  - `services/` holds modules for any of the services in the environment, such
    as the single Elixir app on ECS
  - `vpc/` holds configuration for the networking resources

[gruntwork file layout]:
  https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa

### Deploying

To deploy changes to the infrastructure, change into any of the module
directories and run the Terraform commands.

```bash
terraform init  # if you haven't already
terraform plan  # to see changes Terraform will make
terraform apply # to execute changes
```

### Best Practices

When writing Terraform configuration files, here are our recommended best
practices.

- Group similar infrastructure into separate folders
- Use a combination of `main.tf`, `variables.tf`, and `outputs.tf` in every
  folder
- Always include `README.md` in every folder
  - Include a section to document the inputs (variables) and outputs
- Always include `version` declaration in the `provider` block (e.g. `~> 1.38`)
- Since Terraform is deterministic, try to keep lists alphabetized
- Run `terraform fmt` after every change to ensure consistent formatting
- Name resources using kebab-case (e.g. `foo-bar`)
  - Use snake_case when naming Terraform `resource` blocks to make it easy to
    reference later (e.g. `foo_bar`)
- Tag resources appropriately for easier organization
  - Add at the very least a `Name` tag in the format
    `{namespace}-{stage}-{name}-{extras}`
  - Also consider adding an `Env` tag if the resource is for a particular
    environment, such as `prod`, `stage`, or `qa`
- Use `this` as a name for resources when there's only one

## Advanced Topics

The talk on deployment and infrastructure was limited by time. There are many
more topics to explore. An excerpted list of other items you might need to
explore to get a production-grade deployment of Elixir on AWS is presented
below.

- Cluster Elixir containers (e.g. to make use of distributed ETS)
- Set up SSH forwarding to allow remote Observer sessions for debugging
- Docker Compose for local orchestration of containers
- Configure AWS short-lived tokens locally for secure CLI usage
- Reuse containers to set up CI/CD pipelines
- Use Terraform remote state module to allow seamless provisioning by multiple
  developers
- Duplicate resources in AWS to set up multiple environments (staging, QA, etc)
- Deploy additional infrastructure to secure your AWS resources (bastion
  instances, VPN, etc)
- Set up Kubernetes for multi-service discovery and orchestration
- Plus more!

## License

Copyright (c) 2017 NewAperio, LLC. It is licensed under the terms in the
[LICENSE](/LICENSE) file.

## About NewAperio

Revista is built by [NewAperio, LLC](https://newaperio.com).

NewAperio is a web and mobile design and development studio with offices in
Baton Rouge, LA and Denver, CO.
