#!/bin/bash

export KUBECONFIG=/root/.kube/clusters/cluster3_config

cat <<EOF > /tmp/index.html
<html>
<head><title>Hello World!</title>
  <style>
    html {
      font-size: 500.0%;
    }
    div {
      text-align: center;
    }
  </style>
</head>
<body>
  <div>Hello World!</div>
</body>
</html>
EOF

kubectl create configmap test-html --from-file /tmp/index.html

kubectl apply -f - <<eof
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-cka04-svcn
  labels:
    run: nginx-cka04-svcn
spec:
  ports:
    - port: 80
      protocol: TCP
  selector:
    app: nginx-cka04-svcn

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-cka04-svcn
spec:
  selector:
    matchLabels:
      app: nginx-cka04-svcn
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx-cka04-svcn
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html-volume
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html-volume
        configMap:
          name: test-html
eof
