# Practice Test Networking Weave

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-networking-weave/)

#### Solution 

  1. <details>
      <summary>How many Nodes are part of this cluster?</summary>

      ```bash
      kunbectl get nodes
      ```

      > 2

     </details>

  2. <details>
      <summary>What is the Networking Solution used by this cluster?</summary>

      Two ways to do this:

      1.
         ```bash
         kubectl get pods -n kube-system
         ```

      1.
         ```bash
         ls -l /opt/cni/bin
         ```

      In both you see evidence of

      > weave

     </details>

  3. <details>
      <summary>How many weave agents/peers are deployed in this cluster?</summary>

      ```bash
      kubectl get pods -n kube-system
      ```

      > 2

     </details>

  4. <details>
      <summary>On which nodes are the weave peers present?</summary>

      ```bash
      kubectl get pods -n kube-system -o wide
      ```

      > One on every node

     </details>

  5. <details>
      <summary>Identify the name of the bridge network/interface created by weave on each node.</summary>

      At either host...

      ```bash
      ip addr list
      ```

      > weave

      In actual fact, the network interface is `weave` and the bridge is implemented by `vethwe-datapath@vethwe-bridge` and `vethwe-bridge@vethwe-datapath`

     </details>

  6. <details>
      <summary>What is the POD IP address range configured by weave?</summary>

      Examine output of previous connad for `weave` interface. Note its IP begins with `10.`, so...

      > 10.X.X.X

     </details>

  7. <details>
      <summary>What is the default gateway configured on the PODs scheduled on node01?</summary>

      Now we can deduce this from the naswer to the previous question. Since we know weave's IP range, its gateway must be on the same network. However we can verify that by starting a pod which is known to contain the `ip` tool.

      Remember this [container image](https://github.com/wbitt/Network-MultiTool). It is extremely useful for debugging cluster networking issues!

      ```bash
      kubectl run testpod --image=wbitt/network-multitool
      ```

      Wait for it to be running.

      ```bash
      kubectl exec -it testpod -- ip route
      ```

      Note the first line of the output. This is the answer.
     </details>