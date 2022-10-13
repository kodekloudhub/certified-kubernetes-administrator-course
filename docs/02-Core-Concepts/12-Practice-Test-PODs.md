# Practice Test - PODs
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-pods/)

## Here are the solutions to the practice test
1. <details>
   <summary>How many pods exist on the system?</summary>

   ```bash
   kubectl get pods
   ```

   Count the number of pods (if any)

   </details>

1. <details>
   <summary>Create a new pod with the nginx image.</summary>

   ```bash
   kubectl run nginx --image=nginx
   ```
   </details>

1. <details>
   <summary>How many pods are created now?</summary>

   ```bash
   kubectl get pods
   ```

   Count the number of pods (if any)

   To get the system to tell you you can also do this

   ```bash
   kubectl get pods --no-headers | wc -l
   ```

   * `--no-headers` should be obvious - output only the details.
   * `wc` is the word count program. `-l` tells it to count lines instead, and it will count the lines emitted by `kubectl`
   </details>

1. <details>
   <summary>What is the image used to create the new pods?</summary>

    `kubectl describe` outputs lots of information. The following will describe all pods whose name starts with `newpods`, and then we filter with `grep` to get what we are looking for.

    ```bash
    kubectl describe pod newpods | grep image
    ```

    We see that all three are pulling the same image.
   </details>

1. <details>
   <summary>Which nodes are these pods placed on?</summary>

    ```bash
    kubectl get pods -o wide
    ```

    Note the node column for each of the 3 `newpods` pods

   </details>

1. <details>
   <summary>How many containers are part of the pod webapp?</summary>

   ```bash
   kubectl describe pod webapp
   ```

   Look under the `Containers` section. Note there is `nginx` and `agentx`

   </details>

1. <details>
   <summary>What images are used in the new webapp pod?</summary>

   Examine the output from Q6. For each of the identified containers, look at `Image:`

   </details>

1. <details>
   <summary>What is the state of the container agentx in the pod webapp?</summary>

   ```bash
   kubectl describe pod webapp
   ```

   Examine the `State:` field for the `agentx` container.

   </details>

1. <details>
   <summary>Why do you think the container agentx in pod webapp is in error?</summary>

   Examine the output from Q8 and look in the `Events:` section at the end. Look at the event that says `failed to pull and unpack image ...`

   </details>

1. <details>
   <summary>What does the READY column in the output of the kubectl get pods command indicate?</summary>

   ```bash
   kubectl get pods
   ```

   Look at the `webapp` pod which we know has two containers and one is in error. You can deduce which of the answers is correct from this.

   </details>

1. <details>
   <summary>Delete the webapp Pod.</summary>

   ```bash
   kubectl delete pod webapp
   ```

   To delete the pod without any delay and confirmation, we can add `--force` flag. Note that in a real production system, forcing is a last resort as it can leave behind containers that haven't been cleaned up properly. Some may have important cleanup jobs to run when they are requested to terminate, which wouldn't get run.

   You can however use `--force` in the exam as it will gain you time. No exam pods rely on any of the above.

   </details>

1. <details>
   <summary>Create a new pod with the name redis and with the image redis123.</br>Use a pod-definition YAML file.</summary>

   To create the pod definition YAML file:

   `--dry-run=client` tells `kubectl` to test without actually doing anything. `-o yaml` says "Output what you would send to API server to the console", which we then redirect into the named file.

   ```bash
   kubectl run redis --image=redis123 --dry-run=client -o yaml > redis.yaml
   ```

   And now use the YAML you created to deploy the pod.

   ```bash
   kubectl create -f redis.yaml
   ```

   </details>

1. <details>
   <summary>Now change the image on this pod to redis.</br>Once done, the pod should be in a running state.</summary>

   There are three ways this can be done!

   1. Method 1</br>
      Edit your manifest file created in last question

      ```bash
      vi redis.yaml
      ```

      Fix the image name in the redis.yaml to `redis`, save and exit.

      Apply the edited yaml

      ```bash
      kubectl apply -f redis.yaml
      ```

   1. Method 2</br>
      Edit the running pod directly (note not all fields can be edited this way)

      ```
      kubectl edit pod redis
      ```

      This will bring the pod YAML up in `vi`. Edit it as per method 1. When you eixt `vi` the change will be immediately applied. If you make a mistake, you will be dropped back into `vi`

   1. Method 3</br>
      Patch the image directly. For this you need to know the `name` of the container in the pod, as we assign the new image to that name, as in `container_image_name=new_image`

      ```bash
      kubectl set image pod/redis redis=redis
      ```

   </details>
