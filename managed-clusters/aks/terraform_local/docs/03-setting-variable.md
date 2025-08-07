# Setting Up Environment Variables for Terraform on Windows

This guide helps you configure your environment for running Terraform using either **Git Bash** or **PowerShell** on Windows.

---

## Step 1: Navigate to the Project Directory

Open a terminal (Git Bash or PowerShell) in the folder where this repository has been downloaded or cloned.

---

## Step 2: Set Environment Variables

These variables are required for authenticating with Azure.

### **Linux, MacOS or Git Bash on Windows**

Run the following commands (replace values with your actual credentials):

```bash
export TF_VAR_ARM_CLIENT_ID=<Paste the value>
export TF_VAR_ARM_CLIENT_SECRET=<Paste the value>
export TF_VAR_ARM_TENANT_ID=<Paste the value>
export TF_VAR_ARM_SUBSCRIPTION_ID=<Paste the value>
```
###  Using **Powershell (Windows)**

Run the following commands (quotes required):
```
$env:TF_VAR_ARM_CLIENT_ID = "<Paste the value>"
$env:TF_VAR_ARM_CLIENT_SECRET = "<Paste the value>"
$env:TF_VAR_ARM_TENANT_ID = "<Paste the value>"
$env:TF_VAR_ARM_SUBSCRIPTION_ID = "<Paste the value>"
```
---
## Step 3: Configure main.tf for Your Shell

Terraform uses the external data source to fetch environment variables via a script. Use the block corresponding to your shell.

✅ If Using Linux, MacOS or Git Bash on Windows
Uncomment the following block in main.tf & ☑️ Comment out the PowerShell block if present.:
```
data "external" "environment" {
  program = ["bash", "${path.module}/environment.sh"]
}
```
✅ If Using PowerShell (Windows)
Uncomment the following block in main.tf & ☑️ Comment out the Bash block if present.:
```
data "external" "environment" {
  program = ["powershell", "-ExecutionPolicy", "Bypass", "-File", "${path.module}/environment.ps1"]
}
```

* Only one external block (Git Bash or PowerShell) should be active at a time.
* These environment variables are temporary and available only in the current terminal session.

Next: [Deploy Cluster](./04-deploy-cluster.md)
