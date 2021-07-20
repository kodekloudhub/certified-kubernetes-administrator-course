# Mock Exam 3 Solution


1. Run the below command for solution: 

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

2. Run the below command for solution: 

     <details>
 
     ```
     kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/CKA/node_ips
     ```
     </details>
 
3. Run the below command for solution:  
 
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
 
4. Run the below command for solution:
 
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
 
5. Run the below command for solution:  
 
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
           run: np-test-1
       policyTypes:
       - Ingress
       ingress:
       - ports:
         - protocol: TCP
           port: 80
     ```
     </details>
   
6. Run the below command for solution: 
 
     <details>
 
     ```
     kubectl taint node node01 env_type=production:NoSchedule
     ```

     Deploy `dev-redis` pod and to ensure that workloads are not scheduled to this `node01` worker node.
     ```
     kubectl run dev-redis --image=redis:alpine

     kubectl get pods -owide
     ```

     Deploy new pod `prod-redis` with toleration to be scheduled on `node01` worker node.
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
       - effect: NoSchedule
         key: env_type
         operator: Equal
         value: production     
     ```

     View the pods with short details: 
     ```
     kubectl get pods -owide | grep prod-redis
     ```
     </details>
 
7. Run the below command for solution: 
 
     <details>
 
     ```
     kubectl create namespace hr
     kubectl run hr-pod --image=redis:alpine --namespace=hr --labels=environment=production,tier=frontend
     ```
     </details>

8. Run the below command for solution:

     <details>

     ```
     vi /root/CKA/super.kubeconfig

     Change the 2379 port to 6443 and run the below command to verify
     
     kubectl cluster-info --kubeconfig=/root/CKA/super.kubeconfig     
     ```
     </details>

9. Run the below command for solution:
   
     <details>
     
     ```
     sed -i 's/kube-contro1ler-manager/kube-controller-manager/g' kube-controller-manager.yaml
     ```
     </details>


