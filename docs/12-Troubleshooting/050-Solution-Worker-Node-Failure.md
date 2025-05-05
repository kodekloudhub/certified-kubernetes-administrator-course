# Solution Worker Node Failure

  - Lets have a look at the [Practice Test](https://kodekloud.com/topic/practice-test-worker-node-failure/) of the Worker Node Failure

   ### Solution

   1. <details>
      <summary>Fix the broken cluster</summary>

      * Fix `node01`

      1. Check the nodes

         ```bash
         kubectl get nodes
         ```

         We see that `node01` has a status of `NotReady`. This usually means that communication with the node's kubelet has been lost.

      1. Go to the node and investigate

         ```bash
         ssh node01
         ```

      1. Check kubelet status

         ```bash
         systemctl status kubelet
         ```

         We can see from the output that kublet is not running, in fact it has exited. Therefore we should try starting it.

      1. Start kubelet

         ```bash
         systemctl start kubelet
         ```

      1. Now check it is OK.

         ```bash
         systemctl status kubelet
         ```

         Now we can see it is `active (running)`, which is good.

      1. Return to controlplane

         ```bash
         exit
         ```

      1. Check nodes again

         ```bash
         kubectl get nodes
         ```

         It is good!

      </details>

   2. <details>
      <summary>The cluster is broken again. Investigate and fix the issue.</summary>

      * Fix cluster

      1. Check the nodes

         ```bash
         kubectl get nodes
         ```

         We see that `node01` has a status of `NotReady`. This usually means that communication with the node's kubelet has been lost.

      1. Go to the node and investigate

         ```bash
         ssh node01
         ```

      1. Check kubelet status

         ```bash
         systemctl status kubelet
         ```

         We can see from the output that it is crashlooping `activating (auto-restart)`, therefore this is likey a configuration issue.

      1. Check kubelet logs

         ```bash
         journalctl -u kubelet
         ```

         There is a lot of information, however the error we are interested in, which is the cause of all other errors is this one

         ```
         "failed to construct kubelet dependencies: unable to load client CA file /etc/kubernetes/pki/WRONG-CA-FILE.crt: open /etc/kubernetes/pki/WRONG-CA-FILE.crt: no such file or directory"
         ```

         If kubelet cannot load its certificates, then it cannot autheticate with API server. This is a fatal error, so kubelet exits.

      1.  Check the indicated directory for certificates

            ```bash
            ls -l /etc/kubernetes/pki
            ```

            We see it contains `ca.crt` which we will assume is the correct certificate, therefore we need to find the kubelet configuration file and correct the error there.

      1. Locate kubelet's configuration file

         kubelet is an operating system service, so its service unit file will give us that info

         ```bash
         systemctl cat kubelet
         ```

         Note this line

         ```
         Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
         ```

         There is the config YAML file

      1. Fix configuration

         ```bash
         vi /var/lib/kubelet/config.yaml
         ```

         ```yaml
         apiVersion: kubelet.config.k8s.io/v1beta1
         authentication:
         anonymous:
           enabled: false
         webhook:
           cacheTTL: 0s
           enabled: true
         x509:
           clientCAFile: /etc/kubernetes/pki/WRONG-CA-FILE.crt # <- Fix this
         authorization:
         mode: Webhook
         ```

         Note that you can perform the same edit with a single `sed` command. This is quicker than editing in vi.

         ```bash
         sed -i 's/WRONG-CA-FILE.crt/ca.crt/g' /var/lib/kubelet/config.yaml
         ```

      1. Check status

         Wait a few seconds, kubelet will be auto-restarted.

         ```bash
         systemctl status kubelet
         ```

         Now we can see it is `active (running)`, which is good. If it is not, then you made a mistake when editing the config file, probably broke the YAML syntax or did not edit the certificate filename correctly. Return to step `vii.` above and fix it.

      1. Return to controlplane

         ```bash
         exit
         ```

      1. Check nodes again

         ```bash
         kubectl get nodes
         ```

         It is good!
      </details>

   3. <details>
      <summary>The cluster is broken again. Investigate and fix the issue.</summary>

      * Fix cluster

      1. Check the nodes

         ```bash
         kubectl get nodes
         ```

         We see that `node01` has a status of `NotReady`. This usually means that communication with the node's kubelet has been lost.

      1. Go to the node and investigate

         ```bash
         ssh node01
         ```

      1. Check kubelet status

         ```bash
         systemctl status kubelet
         ```

         We can see it is `active (running)`, however the API server still thinks there is an issue. So we must again go to the kubelet logs.

      1. Check kubelet logs

         ```bash
         journalctl -u kubelet
         ```

         There is a lot of information, however the error we are interested in, which is the cause of all other errors is this one

         ```
          "Unable to register node with API server" err="Post \"https://controlplane:6553/api/v1/nodes\": dial tcp 192.10.46.12:6553: connect: connection refused" node="node01"
          ```

         What do you know about the usual port for API server? It's not `6553`! kubelet uses a kubeconfig file to connect to API server just like kubectl does, so we need to locate and fix that.

      1. Locate kubelet's kubeconfig file

         kubelet is an operating system service, so its service unit file will give us that info

         ```bash
         systemctl cat kubelet
         ```

         Note this line

         ```
         Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
         ```

         There are two kubeconfigs. The first one is used when a node is created and is joining the cluster. The second one is used for normal operation. It is therefore the second one we are interested in.

      1. Fix the kubeconfig

         Port should be `6443`

         ```bash
         vi /etc/kubernetes/kubelet.conf
         ```

         ```yaml
         apiVersion: v1
         clusters:
         - cluster:
            certificate-authority-data: REDACTED
            server: https://controlplane:6553  # <- Fix this
         name: default-cluster
         contexts:
         - context:
            cluster: default-cluster
            namespace: default
            user: default-auth
         name: default-context
         current-context: default-context
         kind: Config
         preferences: {}
         users:
         - name: default-auth
         user:
            client-certificate: /var/lib/kubelet/pki/kubelet-client-current.pem
            client-key: /var/lib/kubelet/pki/kubelet-client-current.pem
         ```

         Note that you can perform the same edit with a single `sed` command. This is quicker than editing in vi.

         ```bash
         sed -i 's/6553/6443/g' /etc/kubernetes/kubelet.conf
         ```

      1. Restart kubelet

         Since kubelet is already running (not crashlooping), we need to restart it so it gets the updated kubeconfig

         ```bash
         systemctl restart kubelet
         ```

      1. Check status

         ```bash
         systemctl status kubelet
         ```

         Now we can see it is `active (running)`, which is good. If it is not, then you made a mistake when editing the kubeconfig, probably broke the YAML syntax. Return to step `vi.` above and fix it.

      1. Return to controlplane

         ```bash
         exit
         ```

      1. Check nodes again

         ```bash
         kubectl get nodes
         ```

         It is good! If it is not, then you probably made a mistake setting the port number. Return to `node01` and redo from step `vi.` above.

      </details>