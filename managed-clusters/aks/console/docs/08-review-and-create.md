# Review and Create

## Final Checklist

Here is a summary of settings you should have configured in each of the UI sections. Where a form field is not mentioned, then you should not change it, leaving it with its default setting.

1. **Basics**
    * **Resource Group**: Choose the only available option in the list
    * **Cluster Preset Configuration**: `Dev/Test`
    * **Kubernetes Cluster Name**: `kodekloud-demo`
    * **Region**: `(US) East US`
1. **Node Pools**

    There should only be `agentpool` here. If there is also `userpool`, select and delete it.

    * **Node size**: [Change](./05-node-pools.md) it to `Standard D2s_v3`
    * **Scale method**: `manual`
    * **Node count**: `2`
1. **Networking**
    * **DNS name prefix**: Must be globally unique. Set to `kodekloud-demo-` followed by a few random digits of your choice, e.g. `kodekloud-demo-321435423`
1. **Integrations**
    * All options here should be un-checked.
1. **Monitoring**
    * All options here should be un-checked.
1. **Security**
    * All options here should be un-checked.
1. **Advanced**
    * Change nothing here.
1. **Tags**
    * You should be able to add tags if you want, but they are not required.

## Deploy

Press the `Review and Create` button at the bottom of the browser window. It should think about it for a few seconds then produce a summary screen with a `Create` button at the bottom.

Press the `Create` button. It will take several minutes to provision, so go and make tea/coffee :smile:!

When it completes, you should see this

![image](../images/08-create-deployment-complete.png)

Click on `Go to resource`

You may see an error similar to the following, but it is an expected issue in the Azure Playground and doesn’t impact any AKS features, so just ignore it.

> The client 'odl_user_1278229@cloudlabs4kodeKloud.onmicrosoft.com' with object id 'da188846-792f-40be-8c62-ed65018e3a6e' does not have authorization to perform action 'Microsoft.Resources/subscriptions/resourceGroups/read' over scope '/subscriptions/1ca63aff-186a-4e2b-b3bc-f7dddf1d8969/resourceGroups/MC_ODL-azure-1278229_kodekloud-demo_eastus' or the scope is invalid. If access was recently granted, please refresh your credentials.


Next: [Connect to Cluster](./09-connect.md)

