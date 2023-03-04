# AWS Route 53 Terraform Modules

Terraform modules for AWS Route 53.

## Modules

The following modules are available

| Module Name                       | Purpose                                                                                                                            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| app-domain                        | Create a subdomain Route 53 hosted zone for your application                                                                       |
| app-alias                         | Create a subdomain Route 53 alias for your application                                                                             |
| app-certificate                   | Create a certificate for your application                                                                                          |
| app-component-domain              | Create a subdomain Route 53 hosted zone for one of your application's components                                                   |
| app-component-alias               | Create a subdomain Route 53 alias for a component of your application                                                              |
| app-component-regional-alias      | Create a subdomain Route 53 alias for a component of your application with an additional regional alias with latency based routing |
| app-component-api-gateway-domains | Create custom domains for your API Gateway to map your custom DNS to a stage                                                       |
| app-component-certificate         | Create a certificate for a component of your application                                                                           |
| app-domain-lookup                 | Retrieve the zone ID of an app domain                                                                                              |
| app-component-domain-lookup       | Retrieve the zone ID of an app component domain                                                                                    |
| http-health-check                 | Add a Route53 HTTP health check for your regional domain                                                                           |
| ip-ranges                         | Outputs known IP address CIDRs                                                                                                     |

### app-domain

Use this module to create a subdomain Route 53 hosted zone for your application in a particular environment
e.g. myapp.prod.mydomain.com
You will need to supply 2 AWS terraform providers, which allows for support of deploying the app hosted zone to an account separate from the environment hosted zone.

#### Inputs

| Name                            | Description                                                                 |
| ------------------------------- | --------------------------------------------------------------------------- |
| app_name                        | The name for your subdomain                                                 |
| environment_name                | The environment (e.g. dev/uat/prod/etc.)                                    |
| root_domain                     | The root domain name                                                        |
| tags                            | The resource tags in the form of a map of key/value pairs                   |
| provider - aws.app_zone         | An aws provider configured for deploying the app hosted zone record         |
| provider - aws.environment_zone | An aws provider configured for accessing the environment hosted zone record |

#### Outputs

| Name                  | Description                                        |
| --------------------- | -------------------------------------------------- |
| app_zone_id           | The ID of the created hosted zone record           |
| app_domain_name       | The domain name of the created hosted zone record  |
| app_zone_name_servers | The name servers of the created hosted zone record |

#### Example usage

```hcl
# These 2 aws providers are the same, but demonstrate how zones could be in different accounts by using different provider configurations.

provider "aws" {
  alias = "app_zone"
  assume_role {
    role_arn = var.assume_role_arn
  }
}

provider "aws" {
  alias = "environment_zone"
  assume_role {
    role_arn = var.assume_role_arn
  }
}

module "my_app_domain" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-domain"
    providers {
      aws.app_zone = "aws.app_zone"
      aws.environment_zone = "aws.environment_zone"
    }
    root_domain      = "mydomain.com"
    app_name         = "my-app"
    environment_name = "dev"
}
```

### app-alias

Use this module to create a subdomain Route 53 alias for your application in a particular environment
e.g. myapp.prod.mydomain.com

#### Inputs

| Name                 | Description                                                                  |
| -------------------- | ---------------------------------------------------------------------------- |
| app_name             | The name for your subdomain                                                  |
| environment_name     | The environment (e.g. dev/uat/prod/etc.)                                     |
| alias_target_name    | DNS domain name for a target resource (Route53, CloudFront, S3 bucket, etc.) |
| alias_target_zone_id | Zone ID for a target resource                                                |
| hosted_zone_id       | The zone ID of the app domain                                                |
| root_domain          | The root domain name                                                         |

#### Outputs

| Name            | Description                                                                              |
| --------------- | ---------------------------------------------------------------------------------------- |
| app_domain_name | The domain name of the app alias record. Returns before the Route 53 resource is created |
| app_alias_fqdn  | The domain name of the app alias record. Returns after the Route 53 resource is created  |

#### Example usage

```hcl
data "aws_route53_zone" "app_zone" {
  name = "my-app.dev.mydomain.com."
}

module "my_app_alias" {
    source               = "github.com/glenthomas/terraform-aws-route-53//app-alias"
    root_domain          = "mydomain.com"
    environment_name     = "dev"
    app_name             = "my-app"
    alias_target_name    = aws_api_gateway_domain_name.regional_domain.regional_domain_name
    alias_target_zone_id = aws_api_gateway_domain_name.regional_domain.regional_zone_id
    hosted_zone_id       = data.aws_route53_zone.app_zone.zone_id
}
```

### app-certificate

Use this module to create a certificate for your application in a particular environment.
This module must be deployed to each region where the certificate is required.

WARNING: Validation process can take time to complete.

#### Inputs

| Name                | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| app_name            | The name for your subdomain                                              |
| environment_name    | The environment (e.g. dev/uat/prod/etc.)                                 |
| wait_for_validation | Values yes/no. Yes waits for the certificate validation to be completed. |
| app_zone_id         | The zone id of the application.                                          |
| root_domain         | The root domain name                                                     |
| tags                | The resource tags in the form of a map of key/value pairs                |

#### Outputs

| Name            | Description                            |
| --------------- | -------------------------------------- |
| certificate_id  | The ID of the created ACM certificate  |
| certificate_arn | The ARN of the created ACM certificate |

#### Example usage

```hcl
module "my_app_domain_cert" {
    source              = "github.com/glenthomas/terraform-aws-route-53//app-certificate"
    root_domain         = "mydomain.com"
    app_name            = "my-app"
    environment_name    = "dev"
    wait_for_validation = "yes"
    app_zone_id         = module.app_domain_lookup.app_zone_id
}
```

### app-component-domain

Use this module to create a subdomain Route 53 hosted zone for one of your application's components in a particular environment
e.g. api.myapp.prod.mydomain.com

#### Inputs

| Name             | Description                                                                                  |
| ---------------- | -------------------------------------------------------------------------------------------- |
| app_name         | The name for your subdomain                                                                  |
| environment_name | The environment (e.g. dev/uat/prod/etc.)                                                     |
| component_name   | The component (e.g. api/db/etc.)                                                             |
| app_zone_id      | The hosted zone ID of the app domain (app_zone_id output of app-domain or app-domain-lookup) |
| root_domain      | The root domain name                                                                         |
| tags             | The resource tags in the form of a map of key/value pairs                                    |

#### Outputs

| Name                        | Description                                        |
| --------------------------- | -------------------------------------------------- |
| component_zone_id           | The ID of the created hosted zone record           |
| component_domain_name       | The domain name of the created hosted zone record  |
| component_zone_name_servers | The name servers of the created hosted zone record |

#### Example usage

```hcl
module "my_app_component_domain" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-domain"
    root_domain      = "mydomain.com"
    app_name         = "my-app"
    environment_name = "dev"
    component_name   = "api"
}
```

### app-component-alias

Use this module to create a subdomain Route 53 alias for a component of your application in a particular environment
e.g. api.myapp.prod.mydomain.com

If you have a regional component, create the regional component alias first using the regional-component-alias module and use the component_latency_domain_name and component_zone_id outputs for the alias_target_name and alias_target_zone_id inputs of this module.
This will result in DNS routing like the following:

```
                                                             |-->eu-west-1.api.myapp.prod.mydomain.com
api.myapp.prod.mydomain.com-->geo.api.myapp.prod.mydomain.com--|
                                                             |-->us-east-1.api.myapp.prod.mydomain.com
```

#### Inputs

| Name                 | Description                                                                  |
| -------------------- | ---------------------------------------------------------------------------- |
| app_name             | The name for your subdomain                                                  |
| environment_name     | The environment (e.g. dev/uat/prod/etc.)                                     |
| component_name       | The component (e.g. api/db/etc.)                                             |
| alias_target_name    | DNS domain name for a target resource (Route53, CloudFront, S3 bucket, etc.) |
| alias_target_zone_id | Zone ID for a target resource                                                |
| hosted_zone_id       | The zone ID of the app/component domain                                      |
| root_domain          | The root domain name                                                         |

#### Outputs

| Name                  | Description                                                                                    |
| --------------------- | ---------------------------------------------------------------------------------------------- |
| component_domain_name | The domain name of the component alias record. Returns before the Route 53 resource is created |
| component_alias_fqdn  | The domain name of the component alias record. Returns after the Route 53 resource is created  |

#### Example usage

```hcl
data "aws_route53_zone" "component_zone" {
  name = "api.my-app.dev.mydomain.com."
}

module "my_api_alias" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-alias"
    root_domain       = "mydomain.com"
    environment_name  = "dev"
    app_name          = "my-app"
    component_name    = "api"
    alias_target_name = "geo.${data.aws_route53_zone.component_zone.name}"
    alias_target_zone_id = data.aws_route53_zone.component_zone.zone_id
}
```

### app-component-regional-alias

Use this module to create a subdomain Route 53 alias for a component of your application in a particular environment with an additional regional alias with latency based routing.
e.g. geo.api.myapp.prod.mydomain.com and eu-west-1.api.myapp.prod.mydomain.com

Repeat this module for each region you will deploy your component to.

#### Inputs

| Name                 | Description                                                                      |
| -------------------- | -------------------------------------------------------------------------------- |
| app_name             | The name for your subdomain                                                      |
| environment_name     | The environment (e.g. dev/uat/prod/etc.)                                         |
| component_name       | The component (e.g. api/db/etc.)                                                 |
| region_name          | The AWS region (e.g. eu-west-1/us-east-1/etc.)                                   |
| root_domain          | The root domain name                                                             |
| alias_target_name    | DNS domain name for a target resource (CloudFront distribution, S3 bucket, etc.) |
| alias_target_zone_id | Zone ID for a target resource                                                    |
| hosted_zone_id       | The zone ID of the app/component domain                                          |
| health_check_id      | The ID of a Route 53 health check for the regional alias record                  |

#### Outputs

| Name                           | Description                                                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------------- |
| component_domain_name          | The domain name of the component. Returns before the Route 53 resource is created                       |
| component_regional_domain_name | The domain name of the component regional alias record. Returns before the Route 53 resource is created |
| component_regional_alias_fqdn  | The domain name of the component regional alias record. Returns after the Route 53 resource is created  |
| component_latency_domain_name  | The domain name of the latency routed alias record. Returns before the Route 53 resource is created     |
| component_latency_alias_fqdn   | The domain name of the latency routed alias record. Returns after the Route 53 resource is created      |
| hosted_zone_id                 | The zone ID of the hosted zone where DNS records are deployed. Same as the hosted_zone_id input value.  |

#### Example usage

```hcl
resource "aws_s3_bucket" "test_bucket" {
  bucket = "eu-west-1.api.dev.mydomain.com"
  acl    = "public-read"
  region = "eu-west-1"
  website {
    index_document = "index.html"
  }
}

module "my_api_domain_eu_west_1" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-regional-alias"
    root_domain      = "mydomain.com
    app_name         = "my-app"
    environment_name = "dev"
    component_name   = "api"
    region_name      = "eu-west-1"
    component_alias_target_name = aws_s3_bucket.test_bucket.website_domain
    component_alias_target_zone_id = aws_s3_bucket.test_bucket.hosted_zone_id
}
```

### app-component-certificate

Use this module to create a certificate for a component of your application in a particular environment. The certificate will cover any regional domains too.
This module must be deployed to each region where the certificate is required.

WARNING: Validation process can take time to complete.

#### Inputs

| Name                | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| app_name            | The name for your subdomain                                              |
| environment_name    | The environment (e.g. dev/uat/prod/etc.)                                 |
| component_name      | The component name (e.g. myapp)                                          |
| root_domain         | The root domain name                                                     |
| wait_for_validation | Values yes/no. Yes waits for the certificate validation to be completed. |
| app_zone_id         | The zone id of the application.                                          |
| component_zone_id   | The zone id of the component.                                            |
| tags                | The resource tags in the form of a map of key/value pairs                |

#### Outputs

| Name            | Description                            |
| --------------- | -------------------------------------- |
| certificate_id  | The ID of the created ACM certificate  |
| certificate_arn | The ARN of the created ACM certificate |

#### Example usage

```hcl
module "my_api_domain_cert" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-certificate"
    root_domain         = "mydomain.com
    app_name            = "my-app"
    environment_name    = "dev"
    component_name      = "api"
    wait_for_validation = "yes",
    app_zone_id         = module.app_domain_lookup.app_zone_id
    component_zone_id   = module.app_component_domain_lookup.component_zone_id
}
```

### app-component-api-gateway-domains

Use this module to create API Gateway custom domains for a component of your application in a particular environment in the current region.
This will add the following example domains to your API gateway:

- api.myapp.prod.mydomain.com
- geo.api.myapp.prod.mydomain.com
- eu-west-1.api.myapp.prod.mydomain.com

Repeat this module for each region you will deploy your API gateway to.

#### Inputs

| Name                   | Description                                                                      |
| ---------------------- | -------------------------------------------------------------------------------- |
| app_name               | The name for your subdomain                                                      |
| environment_name       | The environment (e.g. dev/uat/prod/etc.)                                         |
| component_name         | The component (e.g. api/db/etc.)                                                 |
| root_domain            | The root domain name                                                             |
| api_gateway_id         | The AWS region (e.g. eu-west-1/us-east-1/etc.)                                   |
| api_gateway_stage_name | DNS domain name for a target resource (CloudFront distribution, S3 bucket, etc.) |
| certificate_arn        | Zone ID for a target resource                                                    |

#### Outputs

| Name                             | Description                                                                             |
| -------------------------------- | --------------------------------------------------------------------------------------- |
| api_gateway_regional_zone_id     | The hosted zone ID for creating an alias record for the API gateway's regional endpoint |
| api_gateway_regional_domain_name | The hostname for the custom domain's regional endpoint.                                 |

#### Example usage

```hcl
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "my-gateway"
}

resource "aws_api_gateway_deployment" "api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "production"
}

module "my_api_domain_cert" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-certificate"
    root_domain         = "mydomain.com"
    app_name            = "my-app"
    environment_name    = "dev"
    component_name      = "api"
    wait_for_validation = "yes"
    app_zone_id         = module.app_domain_lookup.app_zone_id
    component_zone_id   = module.app_component_domain_lookup.component_zone_id
}

module "my_api_gateway_domains" {
    source = "github.com/glenthomas/terraform-aws-route-53//app-component-api-gateway-domains"
    root_domain            = "mydomain.com"
    app_name               = "my-app"
    environment_name       = "dev"
    component_name         = "api"
    api_gateway_id         = aws_api_gateway_rest_api.api_gateway.id
    api_gateway_stage_name = aws_api_gateway_deployment.api_gateway.stage_name
    certificate_arn        = module.my_api_domain_cert.certificate_arn
}
```

### app-domain-lookup

Use this module to retrieve the zone ID of an app domain.

#### Inputs

| Name             | Description                                             |
| ---------------- | ------------------------------------------------------- |
| app_name         | The name for your subdomain                             |
| environment_name | The environment (e.g. dev/uat/prod/etc.)                |
| root_domain      | The root domain name                                    |

#### Outputs

| Name                  | Description                                        |
| --------------------- | -------------------------------------------------- |
| app_zone_id           | The ID of the app hosted zone record               |
| app_domain_name       | The domain name of the created hosted zone record  |
| app_zone_name_servers | The name servers of the created hosted zone record |

### app-component-domain-lookup

Use this module to retrieve the zone ID of an app component domain.

#### Inputs

| Name             | Description                                             |
| ---------------- | ------------------------------------------------------- |
| app_name         | The name for your subdomain                             |
| environment_name | The environment (e.g. dev/uat/prod/etc.)                |
| component_name   | The component (e.g. api/db/etc.)                        |
| root_domain      | The root domain name                                    |

#### Outputs

| Name                          | Description                                                                                     |
| ----------------------------- | ----------------------------------------------------------------------------------------------- |
| component_zone_id             | The ID of the component hosted zone record                                                      |
| component_domain_name         | The domain name of the component hosted zone record                                             |
| component_latency_domain_name | The domain name of the latency routed alias record (as created by app-component-regional-alias) |
| component_zone_name_servers   | The name servers of the component hosted zone record                                            |

### http-health-check

Use this module to create a Route 53 HTTP health check and CloudWatch alarms.

#### Inputs

| Name                | Description                                                                                                |
| ------------------- | ---------------------------------------------------------------------------------------------------------- |
| domain_name         | The fully qualified domain name of the endpoint to be checked                                              |
| port                | The port of the endpoint to be checked. Defaults to 443                                                    |
| resource_path       | The path that you want Amazon Route 53 to request when performing health checks. Defaults to /health       |
| request_interval    | The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. Defaults to 10 |
| failure_threshold   | The number of consecutive health checks that an endpoint must pass or fail to switch status. Defaults to 3 |
| alarm_name          | A prefix for the name of the CloudWatch alarms, which matches deployment role convention.                  |
| alarm_topic_arn     | An optional SNS topic ARN to send alarm notifications to.                                                  |
| tags                | The resource tags in the form of a map of key/value pairs                                                  |
| provider - aws.current-region | An aws provider configured for deploying the regional health check                               |
| provider - aws.us-east-1      | An aws provider configured for deploying CloudWatch alarms to us-east-1                          |

#### Outputs

| Name                        | Description                                                                 |
| --------------------------- | --------------------------------------------------------------------------- |
| health_check_id             | The ID of the health check                                                  |

#### Example usage

```hcl
module "app_component_regional_alias" {
  source               = "github.com/glenthomas/terraform-aws-route-53//app-component-regional-alias"
  root_domain          = "mydomain.com"
  app_name             = "my-app"
  environment_name     = "dev"
  component_name       = "api"
  region_name          = data.aws_region.current.name
  alias_target_name    = aws_api_gateway_domain_name.lambda_gateway_regional_domain.regional_domain_name
  alias_target_zone_id = aws_api_gateway_domain_name.lambda_gateway_regional_domain.regional_zone_id
  hosted_zone_id       = module.app_component_domain_lookup.component_zone_id
  health_check_id      = module.regional_health_check.health_check_id
}

module "regional_health_check" {
  source         = "github.com/glenthomas/terraform-aws-route-53//http-health-check"
  domain_name    = module.app_component_regional_alias.component_regional_domain_name
  alarm_name     = "${var.app_name}-${var.component_name}"
  providers {
    aws.current-region = aws
    aws.us-east-1      = aws.us-east-1
  }
}
```

### ip-ranges

Use this module to retrieve static IP address ranges. Useful for WAF IP whitelisting.

#### Outputs

| Name                     | Description                                                                       |
| ------------------------ | --------------------------------------------------------------------------------- |
| cloudflare_ips           | List of objects containing cidr for Cloudflare                                    |
| route53_health_check_ips | List of objects containing cidr for Route 53 health checkers                      |

#### Example usage

```hcl
module ip_ranges {
  source = "github.com/glenthomas/terraform-aws-route-53//ip-ranges"
}

resource "aws_waf_ipset" "route53_health_checks" {
  name = "route53_health_checks"

  dynamic "ip_set_descriptors" {
    for_each = module.ip_ranges.route53_health_check_ips
    content {
      type = "IPV4"
      value = ip_set_descriptors.value["cidr"]
    }
  }
}
```
