# bup-sandbox

**Personal sandbox for testing and validating infrastructure and DevOps tasks**  
This repository is used to simulate and verify implementation steps before applying them in a work environment. It primarily focuses on Terraform modules, AWS configurations, and GitHub Actions CI/CD workflows.


## 📌 Purpose

- Safely test assigned infrastructure-related tasks
- Validate Terraform code and GitHub workflows
- Experiment with AWS services like S3, CloudTrail, VPC Flow Logs, etc.
- Gain clarity before applying changes in production-like environments


## 🧱 Structure
```
.
├── .github/
│   └── workflows/          # GitHub Actions workflows
├── modules/                # Terraform modules (e.g., s3)
├── services/               # Service-specific implementations (e.g., bu-logging)
└── README.md
```

## ⚙️ Stack Used

- **Terraform**
- **GitHub Actions**
- **AWS (S3, CloudTrail, VPC Flow Logs, IAM, etc.)**
- **VSCode**


## 🚀 CI/CD Workflow

> Triggered on push or PR to main branch.

Example steps:
- Checkout code
- Setup Terraform
- `terraform init` → `terraform validate` → `terraform plan`
- (Optional) Deploy to AWS for testing


## 🔐 Notes

- All configurations tested here are scoped to a personal AWS account.
- No confidential or client-identifiable information is included.
- Naming follows safe conventions (e.g., `bup-` prefix).


## 📬 Contact

For personal use only. Maintained by [codezag](https://github.com/codezag).
