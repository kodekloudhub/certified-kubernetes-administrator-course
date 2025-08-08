# Install Software

For best results install required software using package managers.

* Windows - Use [chocolatey package manager](https://github.com/kodekloudhub/community-faq/blob/main/docs/how-tos/howto-package-management-on-windows.md)
* macOS - Use [HomeBrew](https://brew.sh/)
* Linux - Use the builtin package managers e.g. `apt`, `yum` etc.

Install the following if you don't aloready have it.

* [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)
* `kubectl`
   - [macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl-macOS/)
   - [Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
   - [Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
* `azure-cli`
    * [macOS](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)
    * [Linux](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest)
    * Windows
        ```
        choco install -y azure-cli
        ```


# Verify the installations

Open a new shell and verify that each of the above is correctly installed:

1. To verify Terraform, open powershell and type
    ```
    terraform version
    ```
1. To verify kubectl version, open powershell and type
    ```
    kubectl version --client
    ```
1. To verify Azure CLI version, open powershell and type
    ```
    az version
    ```

    Note that you may get an error here on Windows. If you do, then fix it by running the following in a command prompt started `as Administrator`

    ```
    "C:\Program Files\Microsoft SDKs\Azure\CLI2\python.exe" -m pip install pywin32 --force-reinstall
    ```


# Clone the repository

```bash
git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
cd certified-kubernetes-administrator-course/managed-clusters/aks/terraform_local
```

Once you have verified the software packages and cloned the repository, please proceed with next step.

Next: [Setting Variable](./03-setting-variable.md)
