# Practice Test - Storage Class
  
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-storage-class-2/)

#### Solution

  1. Check the Solution

     <details>

      ```
      0
      ```
    
     </details>

  2. Check the Solution

     <details>

      ```
      2
      ```
     </details>
 
  3. Check the Solution

     <details>

      ```
      local-storage
      ```
     </details>

  4. Check the Solution
    
     <details>

      ```
      WaitForFirstConsumer
      ```
      </details>

  5. Check the Solution

     <details>

      ```
      portworx-volume
      ```

     </details>

  6. Check the Solution

     <details>

      ```
      NO
      ```
     </details>

  7. Check the Solution

     <details>

      ```
      apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: local-pvc
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 500Mi
        storageClassName: local-storage
      ```
     </details>

  8. Check the Solution

     <details>

      ```
      Pending
      ```
     </details>

  9. Check the Solution

     <details>

      ```
      A Pod consuming the volume in not scheduled
      ```
     </details>

  10. Check the Solution

      <details>
 
       ```
       The Storage Class called local-storage makes use of VolumeBindingMode set to WaitForFirstConsumer. This will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.
       ```
      </details>

  11. Check the Solution

      <details>
 
       ```
       apiVersion: v1
       kind: Pod
       metadata:
         name: nginx
         labels:
           name: nginx
       spec:
           containers:
           - name: nginx
             image: nginx:alpine
             volumeMounts:
             - name: local-persistent-storage
               mountPath: /var/www/html
           volumes:
           - name: local-persistent-storage
             persistentVolumeClaim:
               claimName: local-pvc
       ```
      </details>

  12. Check the Solution

      <details>
 
       ```
       apiVersion: storage.k8s.io/v1
       kind: StorageClass
       metadata:
         name: delayed-volume-sc
       provisioner: kubernetes.io/no-provisioner
       volumeBindingMode: WaitForFirstConsumer
       ```
      </details>


