# Practice Test CKA Ingress 2

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-cka-ingress-networking-2/)

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
      kubectl create namespace ingress-space
      ```
     </details>

  3. Check the Solution

     <details>

      ```
      kubectl create configmap nginx-configuration --namespace ingress-space
      ```
     </details>

  4. Check the Solution

     <details>

      ```
      kubectl create serviceaccount ingress-serviceaccount --namespace ingress-space
      ```
     </details>

  5. Check the Solution

     <details>

      ```
      Ok

      kubectl get roles,rolebindings --namespace ingress-space
      ```
     </details>

  6. Check the Solution

     <details>

      ```
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: ingress-controller
        namespace: ingress-space
      spec:
        replicas: 1
        selector:
          matchLabels:
            name: nginx-ingress
        template:
          metadata:
            labels:
              name: nginx-ingress
          spec:
            serviceAccountName: ingress-serviceaccount
            containers:
              - name: nginx-ingress-controller
                image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
                args:
                  - /nginx-ingress-controller
                  - --configmap=$(POD_NAMESPACE)/nginx-configuration
                  - --default-backend-service=app-space/default-http-backend
                env:
                  - name: POD_NAME
                    valueFrom:
                      fieldRef:
                        fieldPath: metadata.name
                  - name: POD_NAMESPACE
                    valueFrom:
                      fieldRef:
                        fieldPath: metadata.namespace
                ports:
                  - name: http
                    containerPort: 80
                  - name: https
                    containerPort: 443
      ```
     </details>
  
  7. Check the Solution

     <details>

      ```
      apiVersion: v1
      kind: Service
      metadata:
        name: ingress
        namespace: ingress-space
      spec:
        type: NodePort
        ports:
        - port: 80
          targetPort: 80
          protocol: TCP
          nodePort: 30080
          name: http
        - port: 443
          targetPort: 443
          protocol: TCP
          name: https
        selector:
          name: nginx-ingress
      ```
     </details>

  8. Check the Solution

     <details>

      ```
      apiVersion: extensions/v1beta1
      kind: Ingress
      metadata:
        name: ingress-wear-watch
        namespace: app-space
        annotations:
          nginx.ingress.kubernetes.io/rewrite-target: /
          nginx.ingress.kubernetes.io/ssl-redirect: "false"
      spec:
        rules:
        - http:
            paths:
            - path: /wear
              backend:
                serviceName: wear-service
                servicePort: 8080
            - path: /watch
              backend:
                serviceName: video-service
                servicePort: 8080
      ```
     </details>

  9. Check the Solution

     <details>

      ```
      OK
      ```
     </details>