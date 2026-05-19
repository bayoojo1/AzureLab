# Traffic Flow

This document explains how traffic moves through the Week 2 Azure environment.

## End-to-End Request Flow

1. A user enters the Load Balancer public IP address into a browser.
2. Azure Load Balancer receives the HTTP request.
3. The health probe checks which backend servers are healthy.
4. The request is forwarded to either:
   - `vm-web-01`, or
   - `vm-web-02`
5. NGINX serves the response.
6. The response is returned to the user.

## Internal Application Flow

The web servers can communicate privately with `vm-app-01` over the Azure Virtual Network.

Example:

```text
vm-web-01 (10.0.1.x)
        ↓
vm-app-01 (10.0.2.x)


Failover Scenario

If vm-web-01 stops responding on port 80:

The health probe marks it as unhealthy.
Azure Load Balancer removes it from rotation.
All traffic is sent to vm-web-02.

Users continue accessing the application without interruption.

Security Flow
Public Access
Allowed only to the Load Balancer public IP.
Private Access
Web servers communicate with the application server using private IP addresses.
Restricted Resources
vm-app-01 is not directly accessible from the internet.
Example Test

Refresh the Load Balancer IP multiple times.

Expected responses:

Hello from vm-web-01
Hello from vm-web-02

This confirms that traffic is being distributed across both servers.
