# Architecture Overview

This project deploys a highly available web tier in Azure using two Ubuntu virtual machines running NGINX behind an Azure Standard Load Balancer.

## Components

### Azure Load Balancer
- Public-facing entry point
- Receives HTTP traffic on port 80
- Distributes requests across healthy backend VMs

### Web Tier
- `vm-web-01`
- `vm-web-02`
- Ubuntu Server 24.04 LTS
- NGINX installed automatically

### Application Tier
- `vm-app-01`
- Ubuntu Server 24.04 LTS
- Private IP only (no public exposure)

### Networking
- Virtual Network: `vnet-week2`
- Address Space: `10.0.0.0/16`

#### Subnets
- `web-subnet` → `10.0.1.0/24`
- `app-subnet` → `10.0.2.0/24`

### Security
- Network Security Group applied to `web-subnet`
- Allows:
  - SSH (22)
  - HTTP (80)

## High Availability

The Azure Load Balancer uses a health probe on port 80 to determine which web servers are healthy.

If one server becomes unavailable, traffic is automatically routed to the remaining healthy server.

## Security Design Decisions

- Web servers are accessed only through the Load Balancer.
- Application server has no public IP.
- Network segmentation isolates web and application tiers.
- NSGs restrict inbound traffic.

## Diagram

See:

- docs/diagrams/week2-architecture.png
