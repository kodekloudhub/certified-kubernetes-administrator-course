# Cluster State Questions

This comes up in both CKA and CKAD tests and is about questions that ask you to write for instance the pods consuming most CPU or most memory to a file, or some other kinds of question such as listing Pod IPs normally using jsonpath or custom columns. These questions are often marked incorrect at the end of the exam and cause much consternation amongst students.

Now the more attentive students may realize why this is the case. If you get such a question near the start of the mock, and then you have questions further on that require you to make deployments into the same cluster, then this is going to change things! The pod that was consuming the most CPU when you answered that question may no longer be the top consumer by the end of the exam, as some newly deployed pod may have a higher CPU usage.

This type of question is about cluster state, and the state of the cluster changes whenever you deploy or delete resources. The marking script can only consider the cluster state after you press `End Exam`. The trick here is to defer answering such questions until you are about to end the exam. Ideally (though this is not always feasible), create a script to answer the question and test it while you are still on the question. Then, when you are about to press the `End Exam` button, run the script again and it will update the file with what the current state is. This should now get the question to pass. In the real exam, you should not have to do this as it is likely that one of the exam clusters is dedicated to such questions so its state won't change by the end of the exam.

## Examples

### Example 1

Store the `pod names` and their `ip addresses` from all namespaces at `/root/pod_ips_ckad02_svcn` where the output is sorted by their IPs.

Please ensure the format as shown below:
```
POD_NAME        IP_ADDR
pod-1           ip-1
pod-3           ip-2
pod-2           ip-3
...
```
---
From the required output, this clearly requires Custom Columns

1. Work out the custom columns command to get the required output

    Note the use of the `--context` argument here. This ensures the command is run on the correct cluster, irrespective of whether you ran `kubectl config use-context`

    ```
    kubectl --context=cluster3 get pods -A -o custom-columns="POD_NAME:.metadata.name,IP_ADDR:.status.podIP" --sort-by=".status.podIP"
    ```

1.  Adjust this to write to the output file and check the output

    ```
    kubectl --context=cluster3 get pods -A -o custom-columns="POD_NAME:.metadata.name,IP_ADDR:.status.podIP" --sort-by=".status.podIP" > /root/pod_ips_ckad02_svcn
    ```

    Check it
    ```bash
    cat /root/pod_ips_ckad02_svcn
    ```

1.  Now use `vi` to create a file `run-at-end.sh`

    ```
    vi run-at-end.sh
    ```

    Paste the entire kubectl command from above (step 2) into this file. If you have already created this script for a previous similar question, then simply add this line to the file, so the script will answer all such questions when you run it.

1.  Test it

    ```
    rm -f /root/pod_ips_ckad02_svcn
    source run-at-end.sh
    cat /root/pod_ips_ckad02_svcn
    ```

    The output should be the same

1.  Finally when you are finished and before pressing `End Exam`, re-run your script

    ```
    source run-at-end.sh
    ```

### Example 2

Find the pod that consumes the most CPU and store the result to the file `/opt/high_cpu_pod` in the following format<br/>`cluster_name,namespace,pod_name`.

The pod could be in any namespace in any of the clusters that are currently configured on the student-node.

---

Since it says "in any of the clusters", this will really test your skills of bash scripting, plus `kubectl top` has no JSON output option making it even more difficult to script. Having said that, the best way to solve this question is to write the requirements down on your notepad then answer the question manually at the end before you press `End Exam`. Note that you do not need to navigate back to the question to provide the answer - just do it from your notes.

Use a similar approach whether the stat is CPU or memory, or the resource is Pods or Nodes.

* Manual version
    1. Get all the cluster names

        ```
        kubectl config get-contexts -o name
        ```

    1.  Examine the pod usage on each cluster. Run this command with each value for `--context`

        ```
        kubectl --context=cluster1 top pods -A --sort-by=cpu
        ```

    1. When you have determined the top pod across all clusters, then you can create the output file in vi and manually add the information in the requested format.

* Scripted version

    Note - To do it this way would probably take longer than you want to spend unless you're already a shell scripting guru!

    ```bash
    for ctx in $(kubectl config get-contexts -o name)
    do
        kubectl --context=$ctx top pod --no-headers -A --sort-by=cpu | head -1 | awk -v ctx=$ctx '{printf "%s,%s,%s,%s\n", ctx, $1, $2, $3}'
    done | sort -t ',' -k4 -h | tail -1 | sed -E 's/,[0-9]+[a-z]*$//i' > /opt/high_cpu_pod
    ```

    There is a lot going on here, isn't there?

    As a working DevOps engineer, this is the sort of thing you would be expected to be able to come up with in your day-to-day job - indeed the lab engineer who developed the marking script for this lab would have to use something like the above! Hence it is important to know how to *use* Linux as well as Kubernetes to be successful in a Kubernetes job. You don't need to know it to Sys Admin level (e.g RHCSA, LFCS).<br/>The following courses are recommended:
    * [Linux Basics](https://kodekloud.com/courses/the-linux-basics-course/)
    * [Shell Scripts for Beginners](https://kodekloud.com/courses/shell-scripts-for-beginners/)
    * [Advanced Bash Scripting](https://kodekloud.com/courses/advanced-bash-scripting/)

    So, what is actually going on?

    1. The `for` loop lists the cluster contexts one by one storing the cluster name in the variable `ctx`
    1. With each context, the `kubectl top pods` command is executed with `-A` for all namespaces...
        1. `--no-headers` removes the column headers from the output.
        1. `--sort-by=cpu` ensures the pod we need from this cluster is the first pod listed. In `kubectl top`, sort order is descending.
        1. Then we pipe the output to `head -1` to get only the first line of results (the top pod for this cluster).
        1. Then we pipe it to `awk` to format the output close to what we need, passing in the cluster name so we can include it in the output. The output will look like this
            ```
            cluster1,default,frontend-stable-cka05-arch,396m
            ```
    1. After `done` there will be one line like above for each of the clusters. It would look like this, and note they are in cluster order, not CPU usage order:
        ```text
        cluster1,default,frontend-stable-cka05-arch,396m
        cluster2,kube-system,kube-apiserver-cluster2-controlplane,43m
        cluster3,kube-system,metrics-server-7b67f64457-9cqrd,5m
        cluster4,kube-system,kube-apiserver-cluster4-controlplane,32m
        ```
    1. Pipe to `sort` so we get the highest CPU pod *across all clusters* to the end of the list. `sort` works in ascending order.
        1. `-t ','` sets the field separator to be comma.
        1. `-k4` means sort by the fourth field (the one containing the CPU value).
        1. `-h` means "human" sort, taking into account any SI unit (i.e. the `m` for milli-cpu`). The output will now look like this:
            ```text
            cluster3,kube-system,metrics-server-7b67f64457-9cqrd,5m
            cluster4,kube-system,kube-apiserver-cluster4-controlplane,32m
            cluster2,kube-system,kube-apiserver-cluster2-controlplane,43m
            cluster1,default,frontend-stable-cka05-arch,396m
            ```

    1. Pipe to `tail -1` to get the last entry in the sorted list which is the one we need, which will yield
        ```
        cluster1,default,frontend-stable-cka05-arch,396m
        ```
    1. Finally pipe to `sed` to remove the CPU value and only output the first 3 fields as required by the question. The `sed` expression matches comma, followed by one or more digits, followed by zero or more letters, followed by end of line using extended regex (`-E`) and replaces it with an empty string, thus deleting the matched text. This yields the required output:
        ```
        cluster1,default,frontend-stable-cka05-arch
        ```
        Then redirect the output to the requested file.
