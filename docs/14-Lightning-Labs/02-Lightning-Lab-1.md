# Lightining Lab 1

  - I am ready! [Take me to Lightning Lab 1](https://kodekloud.com/topic/lightning-lab-1-2/)

## Solution to LL-1

   1. Use below commands step-by-step as mentioned:

      <details>
   
      ```
      On Controlplane Node:-

      kubectl drain controlplane --ignore-daemonsets
      apt-get install kubeadm=1.20.0-00
      kubeadm  upgrade plan
      kubeadm  upgrade apply v1.20.0
      apt-get install kubelet=1.20.0-00
      systemctl daemon-reload
      systemctl restart kubelet
      kubectl uncordon controlplane
      kubectl drain node01 --ignore-daemonsets
      
      
      On Worker Node:-
      
      apt-get update
      apt-get install kubeadm=1.20.0-00
      kubeadm upgrade node
      apt-get install kubelet=1.20.0-00
      systemctl daemon-reload
      systemctl restart kubelet     

      Back on Controlplane Node:-
      
      kubectl uncordon node01
      kubectl get pods -o wide | grep gold (make sure this is scheduled on controlplane node)
      ```
      </details>

   2. Execute below command:

      <details>
   
      ```
      kubectl -n admin2406 get deployment -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace --sort-by=.metadata.name > /opt/admin2406_data
      ```
      </details>

   3. Use below command and fix the issue:

      <details>

      ```
      Make sure the port for the kube-apiserver is correct.

      Change port from 2379 to 6443 using below command
      
      vi /root/CKA/admin.kubeconfig

      Now replace the port 2379 with 6443
      
      Run:
      
      kubectl cluster-info --kubeconfig /root/CKA/admin.kubeconfig
      ```
      </details>
    
   4. Use below command for the solution:

      <details>
     
      ```
      kubectl create deployment nginx-deploy --image=nginx:1.16
      kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record
      ```
      </details>
    
   5. Apply/refer below yaml to create a PersistentVolumeClaim:
      
      <details>

      ```
      apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: mysql-alpha-pvc
        namespace: alpha
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 1Gi
        storageClassName: slow
      ```
      </details>
  
   6. Execute below command for etcd backup:

      <details>

      ```
      ETCDCTL_API='3' etcdctl snapshot save --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --endpoints=127.0.0.1:2379 /opt/etcd-backup.db
      ```
      </details>

   7. Apply below manifest for the solution:

      <details>

      ```
      apiVersion: v1
      kind: Pod
      metadata:
        creationTimestamp: null
        labels:
          run: secret-1401
        name: secret-1401
        namespace: admin1401
      spec:
        volumes:
        - name: secret-volume
          secret:
            secretName: dotfile-secret
        containers:
        - command:
          - sleep
          args:
          - "4800"
          image: busybox
          name: secret-admin
          volumeMounts:
          - name: secret-volume
            readOnly: true
            mountPath: "/etc/secret-volume"     
      ```
      </details>


