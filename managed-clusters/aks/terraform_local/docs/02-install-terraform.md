# Install Terraform

Here we will install terraform and pull the configuration we are going to use down from Github.

Perform the following commands in the local machine

```Windows
Step 1: Download Terraform
1. Go to: https://developer.hashicorp.com/terraform/install#windows
2. Under the Windows section, find Binary Download.
3. Choose your architecture:
 • Select AMD64 (most common) if you're on a 64-bit machine.
4. Click Download.

Step 2: Unzip the Binary
1. Unzip the downloaded .zip file.
2. Inside, you'll find a single file: terraform.exe.
```
Step 3: Move and Set the PATH
1. Move terraform.exe to a permanent location, like:
   C:\Terraform
2. Add this folder (C:\Terraform) to your System Environment Variables:
 • Press Win + S, search for Environment Variables
 • Click “Edit the system environment variables”
 • In the System Properties window, click “Environment Variables…”
 • Under System variables, find and select Path, then click Edit
 • Click New, then paste:
   C:\Terraform
 • Click OK to close all dialogs

Step 4: Verify Installation
1. Open Command Prompt or PowerShell
   terraform version

# Clone the repository

```bash
git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
cd certified-kubernetes-administrator-course/managed-clusters/aks/terraform_local
```

Next: [Setting Variable](./03-setting-variable.md)
