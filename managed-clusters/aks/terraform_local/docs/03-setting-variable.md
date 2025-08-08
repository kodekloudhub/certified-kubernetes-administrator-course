# Setting Up Environment Variables for Terraform

Now we need to set various envornment variables requirede by terraform which concern authentication with Azure. These are the values gathered earlier in this guide.

---

## Step 1: Navigate to the Project Directory

Open a terminal (bash for Linux or macOS, or PowerShell/GitBash for Windows) in the folder where this repository has been downloaded or cloned.

---

## Step 2: Set Environment Variables

These variables are required for authenticating with Azure.

### **Using Linux, MacOS or Windows Git Bash**

Run the following commands (replace values with your actual credentials):

```bash
export TF_VAR_ARM_CLIENT_ID=<Paste the value>
export TF_VAR_ARM_CLIENT_SECRET=<Paste the value>
export TF_VAR_ARM_TENANT_ID=<Paste the value>
export TF_VAR_ARM_SUBSCRIPTION_ID=<Paste the value>
```

###  Using **Powershell (Windows)**

Run the following commands (quotes required):
```pwsh
$env:TF_VAR_ARM_CLIENT_ID = "<Paste the value>"
$env:TF_VAR_ARM_CLIENT_SECRET = "<Paste the value>"
$env:TF_VAR_ARM_TENANT_ID = "<Paste the value>"
$env:TF_VAR_ARM_SUBSCRIPTION_ID = "<Paste the value>"
```
---
## Step 3: Configure <code>main.tf</code> for Your Shell

Terraform uses the external data source to fetch environment variables via a script. Use the block corresponding to your shell.

* If Using PowerShell (Windows)

    Uncomment the following block in `main.tf` and comment out the Bash block if present.:
    ```
    data "external" "environment" {
      program = ["powershell", "-ExecutionPolicy", "Bypass", "-File", "${path.module}/environment.ps1"]
    }
    ```

* For all other environments

    Uncomment the following block in `main.tf` and comment out the PowerShell block if present.:
    ```
    data "external" "environment" {
      program = ["bash", "${path.module}/environment.sh"]
    }
    ```
* Only one external block (Git Bash or PowerShell) should be active at a time.
* These environment variables are temporary and available only in the current terminal session.

Next: [Deploy Cluster](./04-deploy-cluster.md)
