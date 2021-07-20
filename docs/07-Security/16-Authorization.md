# Authorization
  - Take me to [Video Tutorial](https://kodekloud.com/topic/authorization/)
  
In this section, we will take a look at authorization in kubernetes

## Why do you need Authorization in your cluster?
- As an admin, you can do all operations
  ```
  $ kubectl get nodes
  $ kubectl get pods
  $ kubectl delete node worker-2
  ```
  
  ![at1](../../images/at1.PNG)
  
## Authorization Mechanisms
- There are different authorization mechanisms supported by kubernetes
  - Node Authorization
  - Attribute-based Authorization (ABAC)
  - Role-Based Authorization (RBAC)
  - Webhook
  
## Node Authorization

  ![node-auth](../../images/node-auth.png)
  
## ABAC

  ![abac](../../images/abac.PNG)
  
## RBAC

  ![rbac](../../images/rbac.PNG)

## Webhook
  
  ![webhook](../../images/webhook.PNG)
  
## Authorization Modes
- The mode options can be defined on the kube-apiserver

  ![mode](../../images/mode.PNG)
  
- When you specify multiple modes, it will authorize in the order in which it is specified

  ![mode1](../../images/mode1.PNG)
  
  
  #### K8s Reference Docs
  - https://kubernetes.io/docs/reference/access-authn-authz/authorization/
  
