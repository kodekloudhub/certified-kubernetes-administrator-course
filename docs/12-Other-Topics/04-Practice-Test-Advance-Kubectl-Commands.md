# Practice Test for Advance Kubectl Commands

  - Take me to [Advance Practice Test for Kubectl Commands](https://kodekloud.com/courses/539883/lectures/10781738)

  ### Solution

   1. Check Solution 

       <details>
       
        ```
        kubectl get nodes -o json > /opt/outputs/nodes.json
        ```   
       </details>

   2. Check Solution 

       <details>

        ```
        kubectl get node node01 -o json > /opt/outputs/node01.json
        ```   
       </details>

   3. Check Solution

       <details>

        ```
        kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' > /opt/outputs/node_names.txt
        ```
       </details>

   4. Check Solution

       <details>

        ```
        kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os.txt
        ```
       </details>

   5. Check Solution

       <details>

        ```
        kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.users[*].name}" > /opt/outputs/users.txt
        ```
       </details>

   6. Check Solution

       <details>

        ```
        kubectl get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt
        ```
       </details>

   7. Check Solution

       <details>

        ```
        kubectl get pv --sort-by=.spec.capacity.storage -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt
        ```
       </details>

   8. Check Solution

       <details>

        ```
        kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" > /opt/outputs/aws-context-name
        ```
       </details>
       
       
       
