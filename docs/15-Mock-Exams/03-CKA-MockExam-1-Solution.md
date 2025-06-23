# Mock Exam 1 Solution

  1. Apply below manifests:

     <details>
     
     ```
     apiVersion: v1
     kind: Pod
     metadata:
       name: mc-pod
       namespace: mc-namespace
     spec:
       volumes:
         - name: shared-volume
           emptyDir: {}
       containers:
       - image: nginx:1-alpine
         name: mc-pod-1
         env:
           - name: NODE_NAME
             valueFrom:
               fieldRef:
                 fieldPath: spec.nodeName
       - name: mc-pod-2
         image: busybox:1
         command:
           - "sh"
           - "-c"
           - "while true; do date >> /var/log/shared/date.log; sleep 1; done"
         volumeMounts:
           - name: shared-volume
             mountPath: /var/log/shared
       - name: mc-pod-3
         image: busybox:1
         command:
           - "sh"
           - "-c"
           - "tail -f /var/log/shared/date.log"
         volumeMounts:
           - name: shared-volume
             mountPath: /var/log/shared
         resources: {}
       dnsPolicy: ClusterFirst
       restartPolicy: Always
     ```
     </details>

  2. Run the below command for solution:

     <details>
     
     ```
     ssh bob@node01
     sudo su
     cd /root/
     dpkg -i ./cri-docker_0.3.16.3-0.debian.deb
     systemctl start cri-docker
     systemctl enable cri-docker
     ```
     </details>

  3. Create the required text file, save the following VerticalPodAutoscaler CRDs into `/root/vpa-crds.txt`:

     
     <details>

     ```
     verticalpodautoscalercheckpoints.autoscaling.k8s.io   
     verticalpodautoscalers.autoscaling.k8s.io
     ```
     </details>


  4. Run the below command for solution:

     <details>
     
     ```
     kubectl expose pod messaging --port=6379 --name=messaging-service
     ```
     </details>

  5. Run the below command for solution:

     <details>
     
     ```
     kubectl create deployment hr-web-app --image=kodekloud/webapp-color --replicas=2
     ```
     </details>