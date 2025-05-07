# Solution Troubleshoot Network

Lets have a look at the [Practice Test](https://kodekloud.com/topic/practice-test-troubleshoot-network/) of the Troubleshoot Network

Note that this lab is sequential. You must solve test 1 completely before you can solve test 2, i.e. you cannot skip test 1 and do test 2 only.

1. <details>
   <summary>Troubleshooting Test 1</summary>

   We are asked to ensure all the components are working, so first let's examine the cluster to see what state it is in.

   How many nodes, and their status?

   ```
   kubectl get nodes
   ```

   Seems OK...

   Next, the pods

   ```
   kubectl get pods -A
   ```

   Now we see that the `webapp` and `mysql` pods are stuck at `ContainerCreating`. We need to describe the pods and check the errors.

   You will note that they are complaining about `network: unable to allocate IP address`, so clearly we have a networking issue.

   When you did the `get pods` above, did you see any evidence of network support containers, like `flannel` or `weave`?

   No - so we need to install networking support.

   Let's install `Weave`

   ```
   kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
   ```

   Now wait for a minute or so for it to initialize, then check the application pods

   ```
   kubectl get pods -n triton
   ```

   </details>


1. <details>
   <summary>Troubleshooting Test 2</summary>

   Once again let's examine the cluster to see what state it is in.

   How many nodes, and their status?

   ```
   kubectl get nodes
   ```

   Seems OK...

   Next, the pods

   ```
   kubectl get pods -A
   ```

   The kube-proxy pod is not running. It is actually crash-looping which means it tries to start, then fails. As a result the rules needed to allow connectivity to the services have not been created. First place to look when diagnosing CrashLoopBackoff is the pod logs.

   1. Check the logs of the kube-proxy pod

      ```
      kubectl -n kube-system logs <name_of_the_kube_proxy_pod>
      ```

      We see that it cannot find a configuration file.

      Now try looking for the configuration in case it has a different name

      ```
      ls -l /var/lib/kube-proxy
      ```

      The directory is not found!

   1. Inspect the pod template spec in the `kube-proxy` daemonset.

      ```
      kubectl get ds -n kube-system kube-proxy -o yaml | less
      ```

      Scroll around and check volumes and volume mounts. Notice that a config map is mounted at the path `/var/lib/kube-proxy` within the pod.

   1. Inspect the config map

      ```
      kubectl describe cm -n kube-system kube-proxy
      ```

      Here we see that the files mounted by the config map are `config.conf` and `kubeconfig.conf`, but _not_ `configuration.conf`.

      These two files are

      * `config.conf` - This is the actual configuration that kube-proxy needs to load. This file refers to `kubeconfig.conf`
      * `kubeconfig.conf` - This is simply a kubeconfig file, same as you will find on the lab terminal in `~/.kube/config`. It is the credentials and address for kube-proxy to talk to the api server.

   1. Fix the command line arguments to `kube-proxy`

      ```
      kubectl edit ds -n kube-system kube-proxy
      ```

      Set the correct filename

      ```
      --config=/var/lib/kube-proxy/config.conf
      ```

      Finally, confirm it is running.

      ```
      kubectl get pods -n kube-system
      ```

   </details>
