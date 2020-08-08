# RBAC
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808259)

In this section, we will take a look at RBAC

## How do we create a role?
- So we create a role defination file with the API version set to **`rbac.authorization.k8s.io/v1`** and kind set to **`Role`**
- Each role has 3 sections
  - apiGroups
  - resources
  - verbs
- We can add multiple rules for a single role.
- create the role with kubectl command
  ```
  $ kubectl create -f developer-role.yaml
  ```

## The next step is to link the user to that role.
- For this we create another object called **`RoleBinding`**. This role binding object links a user object to a role.
- The kind is **`RoleBinding`**
- It has 2 sections
  - subjects - where we specify the user details.
  - roleRef  - where we provide the details of the role we created.
- create the role binding using kubectl command
  ```
  $ kubectl create -f devuser-developer-binding.yaml
  ```
- Also note that the roles and role bindings fall under the scope of namespace.

  ![rbac1](../../images/rbac1.PNG)
  
- To list roles
  ```
  $ kubectl get roles
  ```
- To list rolebindings
  ```
  $ kubectl get rolebindings
  ```
- To describe role 
  ```
  $ kubectl describe role developer
  ```
  
  ![rbac2](../../images/rbac2.PNG)
    
- To describe rolebinding
  ```
  $ kubectl describe rolebinding devuser-developer-binding
  ```
  
  ![rbac3](../../images/rbac3.PNG)
  
#### What if you being a user would like to see if you have access to a particular resource in the cluster.
## Check Access

- You can use the kubectl auth command
  ```
  $ kubectl auth can-i create deployments
  $ kubectl auth can-i delete nodes
  ```
  ```
  $ kubectl auth can-i create deployments --as dev-user
  $ kubectl auth can-i create pods --as dev-user
  ```
  ```
  $ kubectl auth can-i create pods --as dev-user --namespace test
  ```
  
  ![rbac4](../../images/rbac4.PNG)
  
## Resource Names
- Note on resource names we just saw how you can provide access to users for resources like pods within the namespace.
- You can go one level down and allow access to specific resources alone.
    
  ![rbac5](../../images/rbac5.PNG)
  
