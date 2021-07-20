# Solution Troubleshoot Network

  - Lets have a look at the [Practice Test](https://kodekloud.com/topic/practice-test-troubleshoot-network/) of the Troubleshoot Network

    ### Solution

    1. Check Solution

       <details>

        ```
         The pods are in a pending state? Does the cluster have a Network Addon installed?
		 Install Weave using:
		 kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
        ```
        </details>

    2. Check Solution

       <details>

        ```
         The kube-proxy pods are not running. As a result the rules needed to allow connectivity to the services have not been created.

         1. Check the logs of the kube-proxy pods
         kubectl -n kube-system logs <name_of_the_kube_proxy_pod>

         2. The configuration file "/var/lib/kube-proxy/configuration.conf" is not valid. The configuration path does not match the data in the ConfigMap.
         kubectl -n kube-system describe configmap kube-proxy shows that the file name used is "config.conf" which is mounted in the kube-proxy daemonset pods at the path /var/lib/kube-proxy/config.conf

         3. However in the DaemonSet for kube-proxy, the command used to start the kube-proxy pod makes use of the path /var/lib/kube-proxy/configuration.conf.

          Correct this path to /var/lib/kube-proxy/config.conf as per the ConfigMap and recreate the kube-proxy pods.

          This should get the kube-proxy pods back in a running state.
        ```
       </details>

    3. Check Solution

       <details>

        ```
         The kube-dns service is not working as expected. The first thing to check is if the service has a valid endpoint? Does it point to the kube-dns/core-dns?

         Run: kubectl -n kube-system get ep kube-dns

         If there are no endpoints for the service, inspect the service and make sure it uses the correct selectors and ports.

         Run: kubectl -n kube-system describe svc kube-dns

         Note that the selector used is: k8s-app=core-dns

         If you compare this with the label set on the coredns deployment and its pods, you will see that the selector should be k8s-app=kube-dns

         Modify the kube-dns service and update the selector to k8s-app=kube-dns
         (Easiest way is to use the kubectl edit command)
        ```
       </details>




       
