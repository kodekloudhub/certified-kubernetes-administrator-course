# Connect to Cluster

We will connect to the cluster using the Azure CloudShell.

![image](../images/09-connect.png)

When you click on **Connect**, it will pop up a window to the right. Click on the **Open Cloud Shell** link

1. At the popup that opens, select `Bash`
1. At the next popup, select the following
    * Mount storage account
    * Subscription - select from the drop-down. There should be only one choice, something like `azurekmlprod`
    * Press `Apply`
1. At the `Mount Storage Account` popup, select `I want to create a storage account` and press `Next`
1. Now select the following from the `Create storage account` popup
    * `Subscription` - Do not change this.
    * `Resource gorup` - select from the drop-down. There should be only one choice.
    * `Storage account name` - Anything you like or random characters typed from your keyboard. At least 16.
    * `File share` - Anything you like or random characters typed from your keyboard. At least 16.
    * `Region` - Select `(US) East US` from the dropdown
    * Press `Create`, wait for it to deploy, then for the bash prompt to appear.

The cloud shell window will open at the bottom of your browser window and will automatically run the two commands that are required to set up cluster connectivity.

![image](../images/09c-cloudshell.png)

Now you can run commands against the cluster, and you're done!

```text
odl_user [ ~ ]$ kubectl get nodes
NAME                                STATUS   ROLES   AGE   VERSION
aks-agentpool-33115789-vmss000000   Ready    agent   27m   v1.28.5
aks-agentpool-33115789-vmss000001   Ready    agent   26m   v1.28.5
odl_user [ ~ ]$ kubectl run nginx --image=nginx
pod/nginx created
odl_user [ ~ ]$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          8s
odl_user [ ~ ]$ 
```


