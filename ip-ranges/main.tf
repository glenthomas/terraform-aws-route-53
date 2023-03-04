output cloudflare_ips {
  value = [
    {
      cidr        = "173.245.48.0/20"
    },
    {
      cidr        = "103.21.244.0/22"
    },
    {
      cidr        = "103.22.200.0/22"
    },
    {
      cidr        = "103.31.4.0/22"
    },
    {
      cidr        = "141.101.64.0/18"
    },
    {
      cidr        = "108.162.192.0/18"
    },
    {
      cidr        = "190.93.240.0/20"
    },
    {
      cidr        = "188.114.96.0/20"
    },
    {
      cidr        = "197.234.240.0/22"
    },
    {
      cidr        = "198.41.128.0/17"
    },
    {
      cidr        = "162.158.0.0/16"
    },
    {
      cidr        = "162.159.0.0/16"
    },
    {
      cidr        = "104.16.0.0/16"
    },
    {
      cidr        = "104.17.0.0/16"
    },
    {
      cidr        = "104.18.0.0/16"
    },
    {
      cidr        = "104.19.0.0/16"
    },
    {
      cidr        = "104.20.0.0/16"
    },
    {
      cidr        = "104.21.0.0/16"
    },
    {
      cidr        = "104.22.0.0/16"
    },
    {
      cidr        = "104.23.0.0/16"
    },
    {
      cidr        = "104.24.0.0/16"
    },
    {
      cidr        = "104.25.0.0/16"
    },
    {
      cidr        = "104.26.0.0/16"
    },
    {
      cidr        = "104.27.0.0/16"
    },
    {
      cidr        = "172.64.0.0/16"
    },
    {
      cidr        = "172.65.0.0/16"
    },
    {
      cidr        = "172.66.0.0/16"
    },
    {
      cidr        = "172.67.0.0/16"
    },
    {
      cidr        = "172.68.0.0/16"
    },
    {
      cidr        = "172.69.0.0/16"
    },
    {
      cidr        = "172.70.0.0/16"
    },
    {
      cidr        = "172.71.0.0/16"
    },
    {
      cidr        = "131.0.72.0/22"
    },
  ]
}

output route53_health_check_ips {
  value = [
    {
      key         = "ap-southeast-2"
      description = "Route 53 health check in ap-southeast-2"
      cidr        = "54.252.254.192/26"
    },
    {
      key         = "sa-east-1"
      description = "Route 53 health check in sa-east-1"
      cidr        = "177.71.207.128/26"
    },
    {
      key         = "ap-southeast-1"
      description = "Route 53 health check in ap-southeast-1"
      cidr        = "54.255.254.192/26"
    },
    {
      key         = "cn-north-1"
      description = "Route 53 health check in cn-north-1"
      cidr        = "52.80.198.0/25"
    },
    {
      key         = "us-west-2"
      description = "Route 53 health check in us-west-2"
      cidr        = "54.244.52.192/26"
    },
    {
      key         = "ap-southeast-1-2"
      description = "Route 53 health check in ap-southeast-1"
      cidr        = "54.251.31.128/26"
    },
    {
      key         = "cn-north-1-2"
      description = "Route 53 health check in cn-north-1"
      cidr        = "52.80.197.0/25"
    },
    {
      key         = "us-west-1"
      description = "Route 53 health check in us-west-1"
      cidr        = "54.241.32.64/26"
    },
    {
      key         = "us-west-2-2"
      description = "Route 53 health check in us-west-2"
      cidr        = "54.245.168.0/26"
    },
    {
      key         = "sa-east-1-2"
      description = "Route 53 health check in sa-east-1"
      cidr        = "54.232.40.64/26"
    },
    {
      key         = "cn-north-1-3"
      description = "Route 53 health check in cn-north-1"
      cidr        = "52.80.197.128/25"
    },
    {
      key         = "cn-northwest-1"
      description = "Route 53 health check in cn-northwest-1"
      cidr        = "52.83.35.128/25"
    },
    {
      key         = "ap-northeast-1"
      description = "Route 53 health check in ap-northeast-1"
      cidr        = "54.248.220.0/26"
    },
    {
      key         = "cn-northwest-1-2"
      description = "Route 53 health check in cn-northwest-1"
      cidr        = "52.83.35.0/25"
    },
    {
      key         = "eu-west-1"
      description = "Route 53 health check in eu-west-1"
      cidr        = "176.34.159.192/26"
    },
    {
      key         = "ap-southeast-2-2"
      description = "Route 53 health check in ap-southeast-2"
      cidr        = "54.252.79.128/26"
    },
    {
      key         = "cn-northwest-1-3"
      description = "Route 53 health check in cn-northwest-1"
      cidr        = "52.83.34.128/25"
    },
    {
      key         = "us-west-1-2"
      description = "Route 53 health check in us-west-1"
      cidr        = "54.183.255.128/26"
    },
    {
      key         = "ap-northeast-1-2"
      description = "Route 53 health check in ap-northeast-1"
      cidr        = "54.250.253.192/26"
    },
    {
      key         = "GLOBAL"
      description = "Route 53 health check in GLOBAL"
      cidr        = "15.177.0.0/18"
    },
    {
      key         = "eu-west-1-2"
      description = "Route 53 health check in eu-west-1"
      cidr        = "54.228.16.0/26"
    },
    {
      key         = "us-east-1"
      description = "Route 53 health check in us-east-1"
      cidr        = "107.23.255.0/26"
    },
    {
      key         = "us-east-1-2"
      description = "Route 53 health check in us-east-1"
      cidr        = "54.243.31.192/26"
    },
  ]
}
