# Practice Test - Application Failure

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-application-failure/) of the Application Failure

    ### Solution

    1. Check Solution 

       <details>

        ```
         kubectl delete svc mysql -n alpha
        ```
        
        ```
         apiVersion: v1
         kind: Service
         metadata:
           name: mysql-service
           namespace: alpha
         spec:
           ports:
           - port: 3306
             protocol: TCP
             targetPort: 3306
           selector:
             name: mysql
           sessionAffinity: None
           type: ClusterIP
         status:
           loadBalancer: {}
        ```   
       </details>

    2. Check Solution

       <details>
  
       You can edit the `mysql-service` service and change the targetPort "8080" to "3306".
        ```
        kubectl edit svc mysql-service -n beta
        ```
        
       OR
        
       Delete the `mysql-service` service and then apply below manifest:
        ```
        kubectl delete svc mysql-service -n beta
        ```
  
        ```
        apiVersion: v1
        kind: Service
        metadata:
          name: mysql-service
          namespace: beta
        spec:
          ports:
          - port: 3306
            protocol: TCP
            targetPort: 3306
          selector:
            name: mysql
          sessionAffinity: None
          type: ClusterIP
        status:
          loadBalancer: {}
        ```
       </details>

    3. Check Solution

       <details>

       ```
       kubectl edit svc mysql-service -n gamma
       Press Esc, then colon(:)
       :%s/sql00001/mysql/
       ```
       </details>

    4. Check Solution

       <details>

        ```
        kubectl edit deployment.apps/webapp-mysql -n delta

        Change the DB_User's value to root.

        :%s/sql-user/root

        - name: DB_User
          value: root
        ```
       </details>

    5. Check Solution

       <details>
 
        ```
        kubectl edit pod mysql -n epsilon

        Replace the DB_Password with the correct password as shown below, then delete the pod and re-create it again.
        
        :%s/passwooooorrddd/paswrd
        
        save the file with ":wq" in vi editor and it will create a temporary file with random name under the default path /tmp/kubectl-edit-xxxxx.yaml. After deleting the existing one, re-create it again with kubectl apply -f or kubectl create -f command.
        
        In the "webapp-mysql" deployments, change the DB_User's value to root.
        
        kubectl edit deployment.apps/webapp-mysql -n epsilon

        :%s/sql-user/root

        - name: DB_User
          value: root
          
        save the file and exit with ":wq" in vi editor. 
        ```
       </details>
    
    6. Check Solution

       <details>
 
        ```
        kubectl edit deployment.apps/webapp-mysql -n zeta

        Change the DB_User's value to root.

        :%s/sql-user/root

        - name: DB_User
          value: root
        ```

        ```
        Replace the DB_Password with the correct password as shown below, delete the pod and re-create it.

        kubectl edit pod mysql -n zeta

        :%s/passwooooorrddd/paswrd
     
        save the file with ":wq" in vi editor and it will create a temporary file with random name under the default path /tmp/kubectl-edit-xxxxx.yaml. After deleting the existing one, re-create it again with kubectl apply -f or kubectl create -f command. 
        ```

        ```
        kubectl edit svc web-service -n zeta

        Change the nodePort from "30088" to "30081".

        :%s/30088/30081
        ```
       </details>
