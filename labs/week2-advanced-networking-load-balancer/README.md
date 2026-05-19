# Week 2: Advanced Networking with Azure Load Balancer

This project demonstrates how to deploy a highly available web tier in Microsoft Azure using PowerShell.

## What This Project Deploys

- Resource Group
- Virtual Network with two subnets:
  - `web-subnet`
  - `app-subnet`
- Two Ubuntu web servers:
  - `vm-web-01`
  - `vm-web-02`
- One private application server:
  - `vm-app-01`
- NGINX installed automatically on both web servers
- Azure Standard Load Balancer
- Health Probe
- Backend Pool
- Load Balancing Rule

## Architecture

Internet → Public IP → Azure Load Balancer → NGINX Web Servers → Private App Server

## Project Structure

week2-advanced-networking-load-balancer/
├── deploy.ps1
├── validate.ps1
├── cleanup.ps1
├── config/
│   └── variables.ps1
├── modules/
│   ├── New-ResourceGroup.ps1
│   ├── New-Networking.ps1
│   ├── New-Security.ps1
│   ├── New-VirtualMachines.ps1
│   ├── Install-Nginx.ps1
│   ├── New-LoadBalancer.ps1
│   └── Add-BackendPoolMembers.ps1
└── docs/
    └── diagrams/

## Deployment
Connect-AzAccount
.\deploy.ps1

## Validation
.\validate.ps1

Open the Load Balancer public IP in your browser and refresh several times to see responses alternating between:

Hello from vm-web-01
Hello from vm-web-02

## To delete the setup in Azure
.\cleanup.ps1

## Demonstrated Skills
Azure Virtual Networking
Network Security Groups
Ubuntu VM deployment
NGINX automation
Azure Standard Load Balancer
Health probes and backend pools
Idempotent PowerShell scripting

## Learning Outcome
After completing this project, you will understand how Azure distributes traffic across multiple backend servers and how to build a simple highly available web architecture.

## Architecture Diagram
docs/diagrams/week2-architecture.png
