# Ingress Annotations and rewrite-target

  - Take me to [Lecture](https://kodekloud.com/topic/ingress-annotations-and-rewrite-target/)

In this section, we will take a look at **Ingress annotations and rewrite-target**

- Different Ingress controllers have different options to customize the way it works. Nginx Ingress Controller has many options but we will take a look into the one of the option "Rewrite Target" option.

- Kubernetes Version 1.18

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



#### Reference Docs

- https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
- https://kubernetes.github.io/ingress-nginx/examples/
- https://kubernetes.github.io/ingress-nginx/examples/rewrite/
- https://github.com/kubernetes/ingress-nginx/blob/master/docs/troubleshooting.md