                        Internet
                           |
                           |
                     Public IP Address
                           |
                           |
                     +-------------+
                     | vm-web-01   |
                     | 10.0.1.4    |
                     +-------------+
                           |
                           |
                    NSG: nsg-web
                           |
                           |
        +-----------------------------------------+
        |          VNet: vnet-week1               |
        |           10.0.0.0/16                   |
        |                                         |
        |  +----------------+  +----------------+ |
        |  | web-subnet     |  | app-subnet     | |
        |  | 10.0.1.0/24    |  | 10.0.2.0/24    | |
        |  |                |  |                | |
        |  | vm-web-01      |  | vm-app-01      | |
        |  +----------------+  +----------------+ |
        +-----------------------------------------+




        week1-azure-networking-vm/
│
├── README.md
├── deploy.ps1
├── cleanup.ps1
│
├── config/
│   └── variables.ps1
│
├── scripts/
│   ├── 01-resource-group.ps1
│   ├── 02-networking.ps1
│   ├── 03-security.ps1
│   ├── 04-vm-web.ps1
│   └── 05-vm-app.ps1
│
├── docs/
│   ├── architecture.md
│   └── screenshots/
│
└── logs/
