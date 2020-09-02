# Practice Test CKA Ingress 1

  - Take me to [Lab](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/10402088)

#### Solution 

  1. Check the Solution

     <details>

      ```
      Ok
      ```
     </details>
  
  2. Check the Solution

     <details>

      ```
      INGRESS-SPACE
      ```
     </details>

  3. Check the Solution

     <details>

      ```
      NGINX-INGRESS-CONTROLLER
      ```
     </details>

  4. Check the Solution

     <details>

      ```
      APP-SPACE
      ```
     </details>

  5. Check the Solution

     <details>

      ```
      3
      ```
     </details>

  6. Check the Solution

     <details>

      ```
      APP-SPACE
      ```
     </details>

  7. Check the Solution

     <details>

      ```
      INGRESS-WEAR-WATCH
      ```
     </details>

  8. Check the Solution

     <details>

      ```
      ALL-HOSTS(*)
      ```
     </details>

  9. Check the Solution

     <details>

      ```
      WEAR-SERVICE
      ```
     </details>

  10. Check the Solution

      <details>

       ```
        /WATCH
       ```
      </details>

  11. Check the Solution

      <details>

       ```
        DEFAULT-HTTP-BACKEND
       ```
      </details>

  12. Check the Solution

      <details>

       ```
        404-ERROR-PAGE
       ```
      </details>

  13. Check the Solution

      <details>

       ```
        OK
       ```
      </details>

  14. Check the Solution

      <details>
 
        ```
        kubectl edit ingress --namespace app-space
 
        Change the path from /watch to /stream
    
        OR
 
        apiVersion: v1
        items:
        - apiVersion: extensions/v1beta1
          kind: Ingress
          metadata:
            annotations:
              nginx.ingress.kubernetes.io/rewrite-target: /
              nginx.ingress.kubernetes.io/ssl-redirect: "false"
            name: ingress-wear-watch
            namespace: app-space
          spec:
            rules:
            - http:
                paths:
                - backend:
                    serviceName: wear-service
                    servicePort: 8080
                  path: /wear
                  pathType: ImplementationSpecific
                - backend:
                    serviceName: video-service
                    servicePort: 8080
                  path: /stream
                  pathType: ImplementationSpecific
          status:
            loadBalancer:
              ingress:
              - {}
        kind: List
        metadata:
          resourceVersion: ""
          selfLink: ""
       ```
      </details>

  15. Check the Solution

      <details>

       ```
        OK
       ```
      </details>

  16. Check the Solution

      <details>

       ```
        404 ERROR PAGE
       ```
      </details>

  17. Check the Solution

      <details>

       ```
        OK
       ```
      </details>

  18. Check the Solution

      <details>

       ```
        Run the command 'kubectl edit ingress --namespace app-space' and add a new Path entry for the new service.

        OR

       apiVersion: v1
       items:
       - apiVersion: extensions/v1beta1
         kind: Ingress
         metadata:
           annotations:
             nginx.ingress.kubernetes.io/rewrite-target: /
             nginx.ingress.kubernetes.io/ssl-redirect: "false"
           name: ingress-wear-watch
           namespace: app-space
         spec:
           rules:
           - http:
               paths:
               - backend:
                   serviceName: wear-service
                   servicePort: 8080
                 path: /wear
                 pathType: ImplementationSpecific
               - backend:
                   serviceName: video-service
                   servicePort: 8080
                 path: /stream
                 pathType: ImplementationSpecific
               - backend:
                   serviceName: food-service
                   servicePort: 8080
                 path: /eat
                 pathType: ImplementationSpecific
         status:
           loadBalancer:
             ingress:
             - {}
       kind: List
       metadata:
         resourceVersion: ""
         selfLink: ""
       ```
      </details>

  19. Check the Solution

      <details>

       ```
        OK
       ```
      </details>

  20. Check the Solution

      <details>

       ```
        CRITICAL-SPACE
       ```
      </details>

  21. Check the Solution

      <details>

       ```
        WEBAPP-PAY
       ```
      </details>

  22. Check the Solution

      <details>

       ```
        apiVersion: extensions/v1beta1
        kind: Ingress
        metadata:
          name: test-ingress
          namespace: critical-space
          annotations:
            nginx.ingress.kubernetes.io/rewrite-target: /
        spec:
          rules:
          - http:
              paths:
              - path: /pay
                backend:
                  serviceName: pay-service
                  servicePort: 8282
        ```
        </details>

  23. Check the Solution

      <details>

       ```
        OK
       ```
      </details>
