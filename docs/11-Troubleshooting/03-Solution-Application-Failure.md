# Solution Application Failure

  - Lets check the [Solution](https://kodekloud.com/courses/539883/lectures/13205964) of the Application Failure

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
           clusterIP: 10.110.6.201
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

        ```
        kubectl edit svc mysql-service -n beta
        ```
        ```
        apiVersion: v1
        kind: Service
        metadata:
          name: mysql-service
          namespace: beta
        spec:
          clusterIP: 10.110.6.201
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
       Press Esc, then qolon(:)
       :%s/sql0001/mysql/
       ```
       </details>

    4. Check Solution

       <details>

        ```
        kubectl edit deployment.apps/webapp-mysql -n delta

        Change the DB_User to root

        :%s/sql-user/root

        - name: DB_User
          value: root
        ```
       </details>

    5. Check Solution

       <details>

        ```
        kubectl edit deployment.apps/webapp-mysql -n delta

        Change the DB_User to root

        :%s/sql-user/root

        - name: DB_User
          value: root
        ```
       </details>

    6. Check Solution

       <details>
 
        ```
        kubectl edit pod mysql -n epsilon

        Replace the DB_Password with Correct password as shown below, delete the pod and re-create it

        :%s/passwooooorrddd/paswrd
        ```
       </details>
    
    7. Check Solution

       <details>
 
        ```
        kubectl edit deployment.apps/webapp-mysql -n zeta

        Change the DB_User to root

        :%s/sql-user/root

        - name: DB_User
          value: root
        ```

        ```
        Replace the DB_Password with Correct password as shown below, delete the pod and re-create it

        kubectl edit pod mysql -n zeta

        :%s/passwooooorrddd/paswrd

        
        ```

        ```
        kubectl edit svc web-service -n zeta

        Change the nodePort from 30088 to 30081

        :%s/30088/30081
        ```
       </details>