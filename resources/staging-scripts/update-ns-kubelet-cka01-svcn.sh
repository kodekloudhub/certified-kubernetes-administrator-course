#!/bin/bash

ssh cluster1-controlplane "KUBE_DNS=\$(kubectl get svc -n kube-system kube-dns -o jsonpath='{.spec.clusterIP}'); \
ssh cluster1-node02 sed -i "s/\$KUBE_DNS/10.96.0.1/g" /var/lib/kubelet/config.yaml; \
ssh cluster1-node02 systemctl restart kubelet"

export KUBECONFIG=/root/.kube/clusters/cluster1_config
kubectl apply -f - << EOF
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  name: curlme-cka01-svcn
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: curlme-cka01-svcn
status:
  loadBalancer: {}
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: curlme-cka01-svcn
  name: curlme-cka01-svcn
spec:
  nodeName: cluster1-node01
  containers:
  - image: nginx:latest
    name: curlme-cka01-svcn
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: curlpod-cka01-svcn
  name: curlpod-cka01-svcn
spec:
  nodeName: cluster1-node02
  containers:
  - args:
    - sleep
    - "86400"
    image: curlimages/curl
    name: curlpod-cka01-svcn
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
EOF
