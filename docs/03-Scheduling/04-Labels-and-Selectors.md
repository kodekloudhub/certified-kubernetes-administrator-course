# Labels and Selectors
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9816604)
  
In this section, we will take a look at **`Labels and Selectors`**

Labels and Selectors are standard methods to group things together.
- Lets say you have set of different species 
  
  ![lables-animals](../../images/labels-animals.PNG)
  
- A user wants to filter them based on different criteria such as based on  **`Class`** or **`Kind`** or **`Color`**

  ![lc](../../images/lc.PNG)
  ![lk](../../images/lk.PNG)
  ![lco](../../images/lco.PNG)
  
- And not just group, you want to filter them based on a criteria such a all **`Green Color - Animals`**

  ![lg](../../images/lg.PNG)
  
- With multiple criteria such as **`Green Color and that is also a Bird`**

  ![lg](../../images/lg.PNG)
  
#### Labels are properties attach to each item.

  ![labels-ckc](../../images/labels-ckc.PNG)
  
#### Selectors help you to filter these items
 
  ![sl](../../images/sl.PNG)
  
How are labels and selectors are used in kubernetes?
- We have created different types of objects in kubernetes such as **`PODs`**, **`ReplicaSets`**, **`Deployments`** etc.
  
  ![ls](../../images/ls.PNG)
  
- To group objects by thier types

  ![lt](../../images/lt.PNG)
  
- View objects by applicaton
  
  ![la](../../images/la.PNG)
  
- To group objects by thier function
 
  ![lf](../../images/lf.PNG)
 
- To filter specific objects

  ![lse](../../images/lse.PNG)

How do you specify lables?
 
 ![lpod](../../images/lpod.PNG)
 
Once the pod is created, to select the pod with labels run the below command
```
$ kubectl get pods --selector app=App1
```

Kubernetes use lablels to connect different objects together

  ![lrs](../../images/lrs.PNG)

For services
 
  ![lrs1](../../images/lrs1.PNG)
  
## Annotations
- While labels and selectors are used to group objects, annotations are used to record other details for informative purpose.
  
  ![annotations](../../images/annotations.PNG)
