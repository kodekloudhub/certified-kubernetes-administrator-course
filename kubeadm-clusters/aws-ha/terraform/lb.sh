{
apt-get update
apt-get install -y haproxy

cat <<EOF > /etc/haproxy/haproxy.cfg
frontend kubernetes
    bind $(dig +short loadbalancer):6443
    option tcplog
    mode tcp
    default_backend kubernetes-control-nodes

backend kubernetes-control-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server control-1 $(dig +short controlplane01):6443 check fall 3 rise 2
    server control-2 $(dig +short controlplane02):6443 check fall 3 rise 2
    server control-3 $(dig +short controlplane03):6443 check fall 3 rise 2
EOF

systemctl restart haproxy

}