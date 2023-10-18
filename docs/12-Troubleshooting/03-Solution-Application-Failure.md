# Practice Test - Application Failure

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-application-failure/) of the Application Failure

### Solution

1.  <details>
    <summary>A simple 2 tier application is deployed in the <code>alpha</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.</summary>


    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

      It is telling us

      ```
      Name does not resolve
      ```

      This is a DNS lookup issue. Coredns does not know any service called `mysql-service`, however the architecture diagram says that there should be this service.

    1.  Examine services in the `alpha` namespace

        ```bash
        kubectl get service -n alpha
        ```

        We see there is a service `mysql` so the likelihood is that the service is deployed with incorrect name

    1.  Fix it

        Note that you cannot use `kubectl edit` to change a resource name.

        ```
        kubectl get service -n alpha mysql -o yaml > service.yaml
        vi service.yaml
        ```

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
          creationTimestamp: "2023-10-14T11:40:30Z"
          name: mysql           # <- Edit this to mysql-service
          namespace: alpha
          resourceVersion: "824"
          uid: d9a85021-547a-4a39-b254-0480830eab6a
        spec:
        ```

    1. Delete and recreate service

        ```bash
        kubectl delete svc mysql -n alpha
        kubectl create -f service.yaml
        ```

    </details>

2.  <details>
    <summary> The same 2 tier application is deployed in the <code>beta</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.</summary>

    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

        It is telling us

        ```
        Can't connect to MySQL server on 'mysql-service:3306'
        ```

        Which suggests that the service exists but the port settings may be incorrect.

    1. Edit the service

        ```
        kubectl edit service mysql-service -n beta
        ```

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
          creationTimestamp: "2023-10-14T11:54:04Z"
          name: mysql-service
          namespace: beta
          resourceVersion: "1166"
          uid: d6b07c71-5c49-4118-849a-0b12dd382597
        spec:
          clusterIP: 10.43.42.85
          clusterIPs:
          - 10.43.42.85
          internalTrafficPolicy: Cluster
          ipFamilies:
          - IPv4
          ipFamilyPolicy: SingleStack
          ports:
          - port: 3306        # <- Correct
            protocol: TCP
            targetPort: 8080  # <- Incorrect, should also be 3306
          selector:
            name: mysql
          sessionAffinity: None
          type: ClusterIP
        ```

        The mysql database server listens on port `3306` meaning that is the port that its pod will expose, and where `targetPort` should be pointing. We can verify that like this

        ```
        kubectl get po -n beta mysql -o jsonpath='{.spec.containers[*].ports[*].containerPort}'
        ```

        or simply get the yaml for the pod.

3.  <details>
    <summary>The same 2 tier application is deployed in the <code>gamma</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed or unresponsive. Troubleshoot and fix the issue.</summary>

    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

        It is telling us

        ```
         Can't connect to MySQL server on 'mysql-service:3306' (111 Connection refused)
        ```

        Which suggests that the service exists but there is something wrong with it.

    1. Edit the service

        ```
        kubectl edit service mysql-service -n gamma
        ```

        This time the name is correct, as are both the ports. So perhaps the pod selector is the issue

        Open an additional terminal (`+` button above terminal) so as not to have to quit vi now, and run

        ```
        kubectl get pods -n gamma --show-labels
        ```

        Note the labels. Always ignore `pod-template-hash` label. It is used internally by kubernetes.

        ```
        name=webapp-mysql,pod-template-hash=5456999f7b
        ```

        That doesn't match with `sql00001` in the service selector. Switch back to your vi session in Terminal 1 and fix the selector to use the correct value for the `name` label.

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
          creationTimestamp: "2023-10-14T12:04:31Z"
          name: mysql-service
          namespace: gamma
          resourceVersion: "1441"
          uid: 872dfbcd-0b1d-4292-85f6-803d62d05b0a
        spec:
          clusterIP: 10.43.21.189
          clusterIPs:
          - 10.43.21.189
          internalTrafficPolicy: Cluster
          ipFamilies:
          - IPv4
          ipFamilyPolicy: SingleStack
          ports:
          - port: 3306
            protocol: TCP
            targetPort: 3306
          selector:
            name: sql00001      # <- Fix this
          sessionAffinity: None
          type: ClusterIP
        ```

    </details>

4.  <details>
    <summary>The same 2 tier application is deployed in the <code>delta</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.</summary>

    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

        It is telling us

        ```
        Access denied for user 'sql-user'@'10.42.0.16'
        ```

        So this means the application is using an incorrect mysql user account. The architecture diagram in the question tells you what the correct credentials are.

        So this time the fix is going to be in the application deployment, rather than in the service.

    1.  Fix the deployment

        ```
        kubectl edit deployment webapp-mysql -n delta
        ```

        Scroll down to the container's environment section and fix the user name

        ```yaml
          template:
            metadata:
              creationTimestamp: null
              labels:
                name: webapp-mysql
              name: webapp-mysql
            spec:
              containers:
              - env:
                - name: DB_Host
                  value: mysql-service
                - name: DB_User
                  value: sql-user   # <- Fix this
                - name: DB_Password
                  value: paswrd
                image: mmumshad/simple-webapp-mysql
                imagePullPolicy: Always
                name: webapp-mysql

        ```

    </details>

5.  <details>
    <summary>The same 2 tier application is deployed in the <code>epsilon</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.</summary>

    The question indicates there are *two* issues that need fixing.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

        It is telling us

        ```
        Access denied for user 'sql-user'@'10.42.0.16'
        ```

        So it is another authentication issue.

    1. Check the deployment

        Vaildate the environment against the values provided in the architecture diagram. Looks like the same issue as previous question, so fix that the same way.

    1.  Wait! We fixed that, but it's *still* not working!

        Check the mysql pod, since mysql also needs some credential information on its end.

        We cannot use `kubectl edit` to change values of a standalone POD.

        ```
        kubectl get pod -n epsilon mysql -o yaml > mysql.yaml
        vi mysql.yaml
        ```

        ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
          creationTimestamp: "2023-10-14T12:21:51Z"
          labels:
            name: mysql
          name: mysql
          namespace: epsilon
          resourceVersion: "2002"
          uid: f369770b-be24-43c1-b754-d7e1396d6952
        spec:
          containers:
          - env:
            - name: MYSQL_ROOT_PASSWORD
              value: passwooooorrddd    # <- Fix this
            image: mysql:5.6
            imagePullPolicy: IfNotPresent
            name: mysql
            ports:
        ```

    1. Recreate the pod

        ```
        kubectl replace --force -f mysql.yaml
        ```

    </details>

6.  <details>
    <summary>The same 2 tier application is deployed in the <code>zeta</code> namespace. It must display a green web page on success. Click on the <code>App</code> tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.</summary>

    The question indicates there are *three* issues to fix.

    1. Click on the `App` button at the top of the terminal. Observe the error message.

        We get a `502 Bad Gateway` error.

        This is indicative that the lab display infrastructure cannot connect to the service it's supposed to. Examine the URL in the browser address bar

        ```
        30081-port-1795f98fde814933.labs.kodekloud.com/
        ```

        On KodeKloud labs, the `30081-port` part indicates a node port it's trying to connect to. Note also that the infrastructure diagram states that `30081` should be the `web-service` nodeport.

    1.  Examine `web-service` since that's how we view the app.

        ```
        kubectl edit service -n zeta web-service
        ```

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
          creationTimestamp: "2023-10-14T13:27:26Z"
          name: web-service
          namespace: zeta
          resourceVersion: "1530"
          uid: 9b655dda-675a-43ae-80e4-deadb3a38179
        spec:
          clusterIP: 10.43.48.98
          clusterIPs:
          - 10.43.48.98
          externalTrafficPolicy: Cluster
          internalTrafficPolicy: Cluster
          ipFamilies:
          - IPv4
          ipFamilyPolicy: SingleStack
          ports:
          - nodePort: 30088  # <- Edit this
            port: 8080
            protocol: TCP
            targetPort: 8080
          selector:
            name: webapp-mysql
          sessionAffinity: None
          type: NodePort
        ```

    1.  Retry the app in the browser

        We have seen this message before! Fix it as per above, using namesapce `zeta`.

    1.  Retry the app in the browser

        We have also seen this message before! Fix it as per above, using namesapce `zeta`.

    </details>
