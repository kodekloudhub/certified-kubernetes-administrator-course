# Mock Exam 2 Solution
  
  
  1. Apply below manifests:

     <details>
     ```
     apiVersion: storage.k8s.io/v1
     kind: StorageClass
     metadata:
       name: local-sc
       annotations:
         storageclass.kubernetes.io/is-default-class: "true"
     provisioner: kubernetes.io/no-provisioner
     allowVolumeExpansion: true
     volumeBindingMode: WaitForFirstConsumer
     ```
     </details>

  2. Apply below manifests:

     <details>
 
     ```
     apiVersion: apps/v1
     kind: Deployment
     metadata:
       name: logging-deployment
       namespace: logging-ns
     spec:
       replicas: 1
       selector:
         matchLabels:
           app: logger
         template:
           metadata:
             labels:
               app: logger
           spec:
             volumes:
               - name: log-volume
                 emptyDir: {}
             containers:
               - name: app-container
                 image: busybox
                 command:
                   - 'sh'
                   - '-c'
                   - 'while true; do echo "Log entry" >> /var/log/app/app.log; sleep 5; done'
                 volumeMounts:
                   name: log-volume
                   mountPath: /var/log/app
               
               - name: log-agent
                 image: busybox
                 command:
                   - 'sh'
                   - '-c'
                   - 'tail -f /var/log/app/app.log'
                 volumeMounts:
                   name: log-volume
                   mountPath: /var/log/app 
     ```
     </details>
 
  3. Apply below manifests:

     <details>

     ```
     apiVersion: networking.k8s.io/v1
     kind: Ingress
     metadata:
       name: webapp-ingress
       namespcae: ingress-ns
       annotations:
         nginx.ingress.kubernetes.io/rewrite-target: /
     spec:
       ingressClassName: nginx
       rules:
         - host: kodekloud-ingress.app
           http:
             paths:
               - path: /
                 pathType: Prefix
                 backend:
                   service:
                     name: webapp-svc
                     port:
                       number: 80
     ```
     </details>

  4. Run the below command for solution:

     <details>
     
     ```
     kubectl create deployment nginx-deploy --image=nginx:1.16 --replicas=1
     kubectl set image deployment/nginx-deploy nginx=nginx:1.17
     ```
     </details>

  5. Run the below command for solution:

     <details>
     ```
     apiVersion: certificates.k8s.io/v1
     kind: CertificateSigningRequest
     metadata:
       name: john-developer
     spec:
       contents of myuser.csr
       request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQU16cFhHNUVnenFkNUdWMC9BZ1F3SEJDSDhpUy8yOE5rWVpudTU3dHN6VktIV0x2Cm9jOERlaCtOc3JQdmRMVlN0ei9ac0dOV21TZEpKc2RPTWZRblR4ckxtRUlhZXNRMHFTbElzd0M3RnF2Qk5CRCsKbVh2azNlVVVWVGIxZWRVTEVxY2prRENtdGVubHFERm5mcmtCQ3VweXd5OUt4VTJQNWVoZHllSXZTWlZ5NGlXbgpFbXVXNC9hR245WlFGa3NORUhLQSswMUtUSExoK2plaW5xNURFWlkvSDhMY0hpYmNHdkZycGp6TGN4SElwd1pVCkxyZHRpNzNaeHJtU2dxektDUGdBQ3M3K1MzSHZZamE2Z1dCRG1USXpsZkV3aXpYeTU3dmMrQklIRlBHY1FuN3MKMkdmZ3lrem9WdkwxWmZGRitNaHNSc3ZDdmN2S1Zzb293bE5WQnpFQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQmkwNXBuTkdpa3ZqcGtScTZ5TUZHRnlNZmppb3o4YXRXTW1ReHhrUEF2ZkNBQzVlbzBHS29JCldOVkQrQkRsNmp2SG5VcUlzZkFUZHZpYkhpMGFaTml6TmtQTjAwd2dTQTZQN3BGSW5zam1sSDE3bmdsNXJZUmkKTGo5U1FjY2plVktJZ3Y4OUtpTlZVRjBKZTc3N1Ruc24zQUIvUDVJSlhQeXRKSy9GRUxYRXhKZTZTa3NMdnBCNgpRQ3Z3NzI0Yzg1THErQlV5c0pkUnh2ZUwxQy85cVZWN2tMTmUxY3pXUFFHU3dYc3lPaTB1M3lhRjRjaWdCa2h5CmdzczJYdkFaUnJkNTM2Ry9ZdWc3emRuNnNvN0ZOeVdGMUhxTEdueHpoSFV5c2k1dGtxbmhCbDF2K1VtOW9Rd0MKNTZjQ1NoR1Y4ZzlLazF0Ykl2UDlXSGVCSEorY1F4VkIKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
       signerName: kubernetes.io/kube-apiserver-client
       expirationSeconds: 86400  # one day
       usages:
         - digital signature
         - key encipherment
         - client auth
     ```

     ```
     kubectl certificate approve john-developer
     ```

     ```
     apiVersion: rbac.authorization.k8s.io/v1
     kind: Role
     metadata:
       namespace: development
       name: developer
     rules:
       - apiGroups: [""]
         resources: ["pods"]
         verbs: ["create", "list", get", "update", "delete"]
     ---
     apiVersion: rbac.authorization.k8s.io/v1
     kind: RoleBinding
     metadata:
       name: john-developer-role-binding
       namespace: development
     subjects:
       - kind: User
         name: john
         apiGroup: rbac.authorization.k8s.io
     roleRef:
       kind: Role
       name: developer
       apiGroup: rbac.authorization.k8s.io
     ```

     ```
     kubectl auth can-i create pods --as=john -n development
     ```
     </details>
  
  6. Run the below command for solution:

     <details>
 
     ```
      apiVersion: certificates.k8s.io/v1
      kind: CertificateSigningRequest
      metadata:
        name: john-developer
      spec:
        signerName: kubernetes.io/kube-apiserver-client
        request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQUt2Um1tQ0h2ZjBrTHNldlF3aWVKSzcrVVdRck04ZGtkdzkyYUJTdG1uUVNhMGFPCjV3c3cwbVZyNkNjcEJFRmVreHk5NUVydkgyTHhqQTNiSHVsTVVub2ZkUU9rbjYra1NNY2o3TzdWYlBld2k2OEIKa3JoM2prRFNuZGFvV1NPWXBKOFg1WUZ5c2ZvNUpxby82YU92czFGcEc3bm5SMG1JYWpySTlNVVFEdTVncGw4bgpjakY0TG4vQ3NEb3o3QXNadEgwcVpwc0dXYVpURTBKOWNrQmswZWhiV2tMeDJUK3pEYzlmaDVIMjZsSE4zbHM4CktiSlRuSnY3WDFsNndCeTN5WUFUSXRNclpUR28wZ2c1QS9uREZ4SXdHcXNlMTdLZDRaa1k3RDJIZ3R4UytkMEMKMTNBeHNVdzQyWVZ6ZzhkYXJzVGRMZzcxQ2NaanRxdS9YSmlyQmxVQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQ1VKTnNMelBKczB2czlGTTVpUzJ0akMyaVYvdXptcmwxTGNUTStsbXpSODNsS09uL0NoMTZlClNLNHplRlFtbGF0c0hCOGZBU2ZhQnRaOUJ2UnVlMUZnbHk1b2VuTk5LaW9FMnc3TUx1a0oyODBWRWFxUjN2SSsKNzRiNnduNkhYclJsYVhaM25VMTFQVTlsT3RBSGxQeDNYVWpCVk5QaGhlUlBmR3p3TTRselZuQW5mNm96bEtxSgpvT3RORStlZ2FYWDdvc3BvZmdWZWVqc25Yd0RjZ05pSFFTbDgzSkljUCtjOVBHMDJtNyt0NmpJU3VoRllTVjZtCmlqblNucHBKZWhFUGxPMkFNcmJzU0VpaFB1N294Wm9iZDFtdWF4bWtVa0NoSzZLeGV0RjVEdWhRMi80NEMvSDIKOWk1bnpMMlRST3RndGRJZjAveUF5N05COHlOY3FPR0QKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
        usages:
        - digital signature
        - key encipherment
        - client auth
        groups:
        - system:authenticated
       ```
 
      ```
      kubectl certificate approve john-developer
      kubectl create role developer --resource=pods --verb=create,list,get,update,delete --namespace=development
      kubectl create rolebinding developer-role-binding --role=developer --user=john --namespace=development
      kubectl auth can-i update pods --as=john --namespace=development
      ```
  
     </details>
 
  7. Run the below command for solution:

     <details>
 
     ```
     kubectl run nginx-resolver --image=nginx
     kubectl expose pod nginx-resolver --name=nginx-resolver-service --port=80 --target-port=80 --type=ClusterIP
     kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup nginx-resolver-service
     kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup nginx-resolver-service > /root/CKA/nginx.svc
 
     Get the IP of the nginx-resolver pod and replace the dots(.) with hyphon(-) which will be used below.
 
     kubectl get pod nginx-resolver -o wide
     kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup <P-O-D-I-P.default.pod> > /root/CKA/nginx.pod
 
     ```
 
     </details>

  8. Run the below command for solution:

     <details>
 
     ```
     kubectl run nginx-critical --image=nginx --dry-run=client -o yaml > static.yaml
     
     cat static.yaml - Copy the contents of this file.
 
     kubectl get nodes -o wide
     ssh node01 
     OR
     ssh <IP of node01>
 
     Check if static-pod directory is present which is /etc/kubernetes/manifests if not then create it.
     mkdir -p /etc/kubernetes/manifests
 
     Paste the contents of the file(static.yaml) copied in the first step to file nginx-critical.yaml.
 
     Move/copy the nginx-critical.yaml to path /etc/kubernetes/manifests/
 
     cp nginx-critical.yaml /etc/kubernetes/manifests
 
     Go back to master node
 
     kubectl get pods 
     ```
 
     </details>

  

