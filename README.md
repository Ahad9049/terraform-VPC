# Terraform AWS VPC Module

A reusable and modular Terraform project for provisioning an AWS Virtual Private Cloud (VPC) across multiple environments (Development, Staging, and Production).

The project follows Infrastructure as Code (IaC) best practices by separating reusable modules from environment-specific configurations, making deployments scalable, maintainable, and easy to manage.

---

## 📁 Project Structure

```text
terraform-vpc/
│
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── dev.tfvars
│   │   └── backend.tf
│   │
│   ├── staging/
│   │
│   └── prod/
│
└── README.md
```

---

## 🚀 Features

- Reusable Terraform VPC Module
- Multi-Environment Deployment
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables & Route Table Associations
- Availability Zones Support
- Configurable using Variables
- Modular & Scalable Infrastructure
- Infrastructure as Code (IaC)

---

## 🏗️ Infrastructure Components

| Resource | Purpose |
|----------|---------|
| VPC | Creates an isolated virtual network |
| Public Subnets | Hosts internet-facing resources |
| Private Subnets | Hosts secure internal resources |
| Internet Gateway | Provides internet access to public subnets |
| NAT Gateway | Allows private subnets to access the internet securely |
| Route Tables | Controls network traffic |
| Route Table Associations | Associates subnets with route tables |
| Availability Zones | Deploys resources across multiple AZs for high availability |

---

## 📂 Module

The reusable VPC module contains:

- `main.tf` → Defines all AWS networking resources
- `variables.tf` → Input variables for customization
- `outputs.tf` → Exposes resource IDs for other modules

This module can be reused in multiple environments without duplicating code.

---

## 🌍 Environments

Separate configurations are maintained for:

- Development
- Staging
- Production

Each environment can have its own:

- Region
- CIDR Blocks
- Tags
- Backend Configuration
- Variable Values

---

## ⚙️ Prerequisites

- Terraform >= 1.5
- AWS CLI
- AWS Account
- Configured AWS Credentials

Verify your credentials:

```bash
aws configure
```

---

## 🚀 Deployment

Navigate to an environment.

Example:

```bash
cd environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Review execution plan:

```bash
terraform plan -var-file="dev.tfvars"
```

Deploy infrastructure:

```bash
terraform apply -var-file="dev.tfvars"
```

Destroy infrastructure:

```bash
terraform destroy -var-file="dev.tfvars"
```

---

## 📤 Outputs

After deployment Terraform provides outputs such as:

- VPC ID
- Public Subnet IDs
- Private Subnet IDs
- Internet Gateway ID
- NAT Gateway ID

These outputs can be consumed by other Terraform modules.

---

## 💡 Benefits of This Architecture

- Reusable Infrastructure
- Environment Isolation
- Easy Maintenance
- Reduced Code Duplication
- Faster Deployments
- Consistent Infrastructure
- Production-Ready Project Structure

---

## 📚 Technologies Used

- Terraform
- AWS VPC
- AWS Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- AWS CLI
- Git

---

## 📖 Future Improvements

- Security Group Module
- EC2 Module
- Application Load Balancer
- Auto Scaling Group
- RDS Module
- S3 Backend with DynamoDB State Locking
- GitHub Actions CI/CD
- CloudWatch Monitoring

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

Feel free to fork the repository and submit a pull request.

---

## 📄 License

This project is licensed under the MIT License.
