# About
Terraform infrastrcture to run AWS ECS TeamCity Cluster

# Features

* Multi AZ (>1 because ALB)
* Setup TeamCity Server and Agent in AWS ECS with Capacity provider
* EFS Configuration for Teamcity Data directory

# Variables
| Variable | Default | Type | Description |
| -------- | ------- | ---- | -----------
| project_name | teamcity | string | Project name |
| environment | example | string | Project environment (example, staging, production, etc) |
| log_retention | 1 | number | Log retention (days) |
| vpc_cidr | 10.0.0.0/16 | string | VPC Network CIDR |
| vpc_azs | ["eu-central-1a", "eu-central-1b"] | list(string) | VPC Availability zones |
| vpc_public_subnets | ["10.0.10.0/24", "10.0.11.0/24"] | list(string) | VPC Private Subnet |
| vpc_private_subnets | ["10.0.0.0/24", "10.0.1.0/24"] | list(string) | VPC Private Subnets |
| ecs_asg_min_size | 2 | number | ECS ASG Minimal size |
| ecs_asg_max_size | 5 | number | ECS ASG Maximal size |
| server_container_image | jetbrains/teamcity-server:latest | string | TeamCity Server Container image |
| server_container_cpu | 2048 | number | TeamCity Server Request CPU |
| server_container_memory | 3584 | number | TeamCity Server Request Memory |
| server_container_data_dir | /data/teamcity_server/datadir | string | TeamCity Data Directory |
| agent_container_image | jetbrains/teamcity-agent:latest | string | TeamCity Agent Container image |
| agent_container_cpu | 2048 | number | TeamCity Agent Request CPU |
| agent_container_memory | 3072 | number | TeamCity Agent Request Memory |
| tags | - | map(string) | A map of tags to add to all resources |


# Install

* Initialization modules
```
terraform init
```
* Review plan
```
terraform plan
```
* Create infrstructure
```
terraform apply
```
```
 ( (
    ) )
  ........
  |      |]
  \      /   It's a coffee time
   `----'
```
* Credentioal for ECS Plugin
```
Outputs:

aws_access_key_id = XXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXX
bastion_ssh_cmd = ssh -A ec2-user@IP-ADDRESS
ecs_cluster_name = teamcity-example-agents
ecs_taskdefinition_name = teamcity-example-agent
instance_profile_arn = arn:aws:iam::360358977962:instance-profile/EcsClusterteamcity-example-agents-ecsEc2InstanceProfile
teamcity_url = http://teamcity-example-lb-1519469284.eu-central-1.elb.amazonaws.com
```

* See output for more info and wait 3-5 minutes.
* **You can find a Super user token in task logs** (AWS -> Services -> ECS -> 
Cluster -> Tasks -> Task -> Logs) or you can use aws cli
```
aws logs filter-log-events  --log-group-name "/aws/ecs/teamcity-example-server" --filter-pattern " Super user authentication token" --output text
```

Result
```
-aa1823cc6531	[TeamCity] Super user authentication token: 6144441052182724667 (use empty username with the token as the password to access the server)	1589165674308

```

# TODO
## Modules
* ~~VPC Module (Using official terraform module)~~
* ~~Bastion module~~
* ~~ECS Module~~
* ~~EFS Module~~
* ~~ALB Module~~

## Configuration
* ~~CloudWatch Logs~~
* ~~Run TeamCity Server with EFS volume~~
* ~~Run TeamCity Agents~~
* ~~Download Plugins when is first run~~

## Hacks
* ~~Write InitContainer analog for plugin download and watch configuration~~
* ~~https://github.com/terraform-providers/terraform-provider-aws/issues/11409~~
