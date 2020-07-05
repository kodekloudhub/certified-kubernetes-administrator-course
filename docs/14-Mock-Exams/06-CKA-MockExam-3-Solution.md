# Mock Exam 3 Solution

  Is it tough? Want to see the [solution](https://kodekloud.com/courses/539883/lectures/11459153) ?

1. Run the below Command for Solution 

     <details>

     ```
     kubectl create serviceaccount pvviewer
     kubectl create clusterrole pvviewer-role --resource=persistentvolumes --verb=list
     kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer
     ```

     ```
     apiVersion: v1
     kind: Pod
     metadata:
       creationTimestamp: null
       labels:
         run: pvviewer
       name: pvviewer
     spec:
       containers:
       - image: redis
         name: pvviewer
         resources: {}
       serviceAccountName: pvviewer
     ```
     </details>

2. Run the below Command for Solution 

     <details>
 
     ```
     kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/node_ips
     ```
     </details>
 
3. Run the below Command for Solution  
 
     <details>
 
     ```
     apiVersion: v1
     kind: Pod
     metadata:
       name: multi-pod
     spec:
       containers:
       - image: nginx
         name: alpha
         env:
         - name: name
           value: alpha
       - image: busybox
         name: beta
         command: ["sleep", "4800"]
         env:
         - name: name
           value: beta
     status: {}
     ```
     </details>
 
4. Run the below Command for Solution
 
     <details>
     
     ```
     apiVersion: v1
     kind: Pod
     metadata:
       name: non-root-pod
     spec:
       securityContext:
         runAsUser: 1000
         fsGroup: 2000
       containers:
       - name: non-root-pod
         image: redis:alpine
     ```
     </details>
 
5. Run the below Command for Solution  
 
     <details>
 
     ```
     apiVersion: networking.k8s.io/v1
     kind: NetworkPolicy
     metadata:
       name: ingress-to-nptest
       namespace: default
     spec:
       podSelector:
         matchLabels:
           role: np-test-1
       policyTypes:
       - Ingress
       ingress:
       - ports:
         - protocol: TCP
           port: 80
     ```
     </details>
   
6. Run the below Command for Solution 
 
     <details>
 
     ```
     kubectl taint node node01 env_type=production:NoSchedule
     ```

     ```
     apiVersion: v1
     kind: Pod
     metadata:
       name: prod-redis
     spec:
       containers:
       - name: prod-redis
         image: redis:alpine
       tolerations:
       - effect: Noschedule
         key: env_type
         operator: Equal
         value: prodcution     
     ```
     </details>
 
7. Run the below Command for Solution 
 
     <details>
 
     ```
     kubectl create namespace hr
     kubectl run hr-pod --image=redis:alpine --namespace=hr --labels=environment=production,tier=frontend
     ```
     </details>

8. Run the below Command for Solution

     <details>

     ```
     vi /root/super.kubeconfig

     Change the 2379 port to 6443 and run the below command to verify
     
     kubectl cluster-info --kubeconfig=/root/super.kubeconfig     
     ```
     </details>

9. Run the below Command for Solution
   
     <details>
     
     ```
     sed -i 's/kube-contro1ler-manager/kube-controller-manager/g' kube-controller-manager.yaml
     ```
     </details>