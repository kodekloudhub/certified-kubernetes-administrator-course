# Practice Test - Persistent Volume Claims

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-persistent-volume-claims/)

#### Solution

  1. Check the Solution

     <details>

      ```
      OK
      ```
    
     </details>

  2. Check the Solution

     <details>

      ```
      OK
      ```
     </details>
 
  3. Check the Solution

     <details>

      ```
      No
      ```
     </details>

  4. Check the Solution
    
     <details>

      ```
      apiVersion: v1
      kind: Pod
      metadata:
        name: webapp
      spec:
        containers:
        - name: event-simulator
          image: kodekloud/event-simulator
          env:
          - name: LOG_HANDLERS
            value: file
          volumeMounts:
          - mountPath: /log
            name: log-volume
      
        volumes:
        - name: log-volume
          hostPath:
            # directory location on host
            path: /var/log/webapp
            # this field is optional
            type: Directory
      ```
      </details>

  5. Check the Solution

     <details>

      ```
      apiVersion: v1
      kind: PersistentVolume
      metadata:
        name: pv-log
      spec:
        accessModes:
          - ReadWriteMany
        capacity:
          storage: 100Mi
        hostPath:
          path: /pv/log
      ```

     </details>

  6. Check the Solution

     <details>

      ```
      kind: PersistentVolumeClaim
      apiVersion: v1
      metadata:
        name: claim-log-1
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 50Mi
      ```
     </details>

  7. Check the Solution

     <details>

      ```
      PENDING
      ```
     </details>

  8. Check the Solution

     <details>

      ```
      AVAILABLE
      ```
     </details>

  9. Check the Solution

     <details>

      ```
      Access Modes Mismatch
      ```
     </details>

  10. Check the Solution

      <details>
 
       ```
       kind: PersistentVolumeClaim
       apiVersion: v1
       metadata:
         name: claim-log-1
       spec:
         accessModes:
           - ReadWriteMany
         resources:
           requests:
             storage: 50Mi
       ```
      </details>

  11. Check the Solution

      <details>
 
       ```
       100Mi
       ```
      </details>

  12. Check the Solution

      <details>
 
       ```
       apiVersion: v1
       kind: Pod
       metadata:
         name: webapp
       spec:
         containers:
         - name: event-simulator
           image: kodekloud/event-simulator
           env:
           - name: LOG_HANDLERS
             value: file
           volumeMounts:
           - mountPath: /log
             name: log-volume
       
         volumes:
         - name: log-volume
           persistentVolumeClaim:
             claimName: claim-log-1
       ```
      </details>

  13. Check the Solution

      <details>
 
       ```
       Retain
       ```
      </details>

  14. Check the Solution

      <details>
 
       ```
       The PV is not delete but not available
       ```
      </details>

  15. Check the Solution

      <details>
 
       ```
       The PVC is stuck in `terminating` state
       ```
      </details>

  16. Check the Solution

      <details>
 
       ```
       The PVC is being used by a POD
       ```
      </details>

  17. Check the Solution

      <details>
 
       ```
       kubectl delete pod webapp
       ```
      </details>

  18. Check the Solution

      <details>
 
       ```
       Deleted
       ```
      </details>

  19. Check the Solution

      <details>
 
       ```
       Released
       ```
      </details>