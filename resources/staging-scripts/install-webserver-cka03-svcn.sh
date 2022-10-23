#!/bin/bash

kubectl run -n kube-public server1-cka03-svcn --image=nginx --kubeconfig=/root/.kube/clusters/cluster2_config

until [[ `kubectl get pods server1-cka03-svcn -n kube-public --context=cluster2 -o jsonpath='{.status.containerStatuses[].ready}'` == true ]]; do sleep 2; done;

#nohup kubectl --kubeconfig=/root/.kube/clusters/cluster2_config port-forward --address 0.0.0.0 -n kube-public server1-cka03-svcn 9999:80 &

cat <<EOF > /lib/systemd/system/webserver.service
[Unit]
Description=kubectl proxy 8888
After=network.target

[Service]
User=root
ExecStart=/bin/bash -c "/usr/bin/kubectl --kubeconfig=/root/.kube/clusters/cluster2_config port-forward --address 0.0.0.0 -n kube-public server1-cka03-svcn 9999:80"
StartLimitInterval=0
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable webserver.service --now

kubectl --context=cluster3 apply -f - << EOF
apiVersion: v1
kind: Service
metadata:
  name: external-webserver-cka03-svcn
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9999
EOF
