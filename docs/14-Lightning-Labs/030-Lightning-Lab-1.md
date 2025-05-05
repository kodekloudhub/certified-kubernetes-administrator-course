# Lightning Lab 1

  - I am ready! [Take me to Lightning Lab 1](https://kodekloud.com/topic/lightning-lab-1-2/)

## Solution to LL-1

1.  <details>
    <summary>Upgrade the current version of kubernetes from 1.28.0 to 1.29.0 exactly using the kubeadm utility.</summary>

    Make sure that the upgrade is carried out one node at a time starting with the controlplane node. To minimize downtime, the deployment `gold-nginx` should be rescheduled on an alternate node before upgrading each node.


    Upgrade `controlplane` node first and drain node `node01` before upgrading it. Pods for `gold-nginx` should run on the controlplane node subsequently.

    **Upgrade `controlplane`**

    1.  Update package repo

        ```bash
        apt update
        ```

    1.  Check madison to see what kubernetes packages are available

        ```bash
        apt-cache madison kubeadm
        ```

        Note that only 1.28 versions are present, meaning you have to grab the 1.29 repos

    1.  Grab kubernetes 1.29 repos

        For this, we need to edit the apt source file which you should find is `/etc/apt/sources.list.d/kubernetes.list`

        ```bash
        vi /etc/apt/sources.list.d/kubernetes.list
        ```

        FInd any occurrence of `1.28` in this file and change it to `1.29`, then save and exit from vi.

    1.  Now run madison again to find out the package version for 1.29

        ```bash
        apt-cache madison kubeadm
        ```

        You should see the following in the list

        > `kubeadm | 1.29.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages`

        Now we know the package version is `1.29.0-1.1` we can proceed with the upgrade

    1. Drain node

        ```
        kubectl drain controlplane --ignore-daemonsets
        ```

    1. Upgrade kubeadm

        ```
        apt-mark unhold kubeadm
        apt install -y kubeadm=1.29.0-1.1
        ```

    1. Plan and apply upgrade

        ```
        kubeadm upgrade plan
        kubeadm upgrade apply v1.29.0
        ```

    1. Upgrade the kubelet

        ```
        apt-mark unhold kubelet
        apt install -y kubelet=1.29.0-1.1
        systemctl daemon-reload
        systemctl restart kubelet
        ```

    1. Reinstate controlplane node

        ```
        kubectl uncordon controlplane
        ```

    1. Upgrade kubectl

        ```
        apt-mark unhold kubectl
        apt install -y kubectl=1.29.0-1.1
        ```

    1. Re-hold packages

        ```
        apt-mark hold kubeadm kubelet kubectl
        ```

    **Upgrade `node01`**

    1. Drain the worker node

        ```
        kubectl drain node01 --ignore-daemonsets
        ```

    1. Go to worker node

        ```
        ssh node01
        ```

    1. As before, you will need to update the package caches for v1.29

        Follow the same steps as you did on `controlplane`

    1. Upgrade kubeadm

        ```
        apt-mark unhold kubeadm
        apt install -y kubeadm=1.29.0-1.1
        ```

    1. Upgrade node

        ```
        kubeadm upgrade node
        ```

    1. Upgrade the kubelet

        ```
        apt-mark unhold kubelet
        apt install kubelet=1.29.0-1.1
        systemctl daemon-reload
        systemctl restart kubelet
        ```

    1. Re-hold packages

        ```
        apt-mark hold kubeadm kubelet
        ```

    1. Return to controlplane

        ```
        exit
        ```

    1. Reinstate worker node

        ```
        kubectl uncordon node01
        ```

    1. Verify `gold-nginx` is scheduled on controlplane node

        ```
        kubectl get pods -o wide | grep gold-nginx
        ```

    **TIP**

    To do cluster upgrades faster and save at least 3 minutes, you can work on both nodes at the same time.

    While `kubeadm upgrade apply` is running on `controlplane`, which takes some minutes, open a second terminal and perform steps `ii`, `iii` and `iv` of "Upgrade `node01`", so that it is ready for `kubeadm upgrade node` as soon as you have drained it.


    </details>

2.  <details>
    <summary>Print the names of all deployments in the admin2406 namespace in the following format...</summary>

    This is a job for `custom-columns` output of kubectl

    ```
    kubectl -n admin2406 get deployment -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace --sort-by=.metadata.name > /opt/admin2406_data
    ```
    </details>

3.  <details>
    <summary>A kubeconfig file called admin.kubeconfig has been created in /root/CKA. There is something wrong with the configuration. Troubleshoot and fix it.</summary>

    First, let's test this kubeconfig

    ```
    kubectl get pods --kubeconfig /root/CKA/admin.kubeconfig
    ```

    Notice the error message.

    Now look at the default kubeconfig for the correct setting.

    ```
    cat ~/.kube/config
    ```

    Make the correction

    ```
    vi /root/CKA/admin.kubeconfig
    ```

    Test

    ```
    kubectl get pods --kubeconfig /root/CKA/admin.kubeconfig
    ```
  </details>

4.  <details>
    <summary>Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update.</summary>

    ```
    kubectl create deployment nginx-deploy --image=nginx:1.16
    kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record
    ```

    You may ignore the deprecation warning.

    </details>

5.  <details>
    <summary>A new deployment called alpha-mysql has been deployed in the alpha namespace. However, the pods are not running. Troubleshoot and fix the issue.</summary>

    The deployment should make use of the persistent volume alpha-pv to be mounted at /var/lib/mysql and should use the environment variable MYSQL_ALLOW_EMPTY_PASSWORD=1 to make use of an empty root password.

    Important: Do not alter the persistent volume.

    Inspect the deployment to check the environment variable is set. Here I'm using `yq` which is like `jq` but for YAML to not have to view the _entire_ deployment YAML, just the section beneath `containers` in the deployment spec.

    ```
    kubectl get deployment -n alpha alpha-mysql  -o yaml | yq e .spec.template.spec.containers -
    ```

    Find out why the deployment does not have minimum availability. We'll have to find out the name of the deployment's pod first, then describe the pod to see the error.

    ```
    kubectl get pods -n alpha
    kubectl describe pod -n alpha alpha-mysql-xxxxxxxx-xxxxx
    ```

    We find that the requested PVC isn't present, so create it. First, examine the Persistent Volume to find the values for access modes, capacity (storage), and storage class name

    ```
    kubectl get pv alpha-pv
    ```

    Now use `vi` to create a PVC manifest

    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mysql-alpha-pvc
      namespace: alpha
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
      storageClassName: slow
    ```
  </details>

6.  <details>
    <summary>Take the backup of ETCD at the location /opt/etcd-backup.db on the controlplane node.</summary>

    This question is a bit poorly worded. It requires us to make a backup of etcd and store the backup at the given location.

    Know that the certificates we need for authentication of `etcdctl` are located in `/etc/kubernetes/pki/etcd`

    ```
    ETCDCTL_API='3' etcdctl snapshot save \
      --cacert=/etc/kubernetes/pki/etcd/ca.crt \
      --cert=/etc/kubernetes/pki/etcd/server.crt \
      --key=/etc/kubernetes/pki/etcd/server.key \
      /opt/etcd-backup.db
    ```

    Whilst we _could_ also use the argument `--endpoints=127.0.0.1:2379`, it is not necessary here as we are on the controlplane node, same as `etcd` itself. The default endpoint is the local host.
    </details>

7.  <details>
    <summary>Create a pod called secret-1401 in the admin1401 namespace using the busybox image....</summary>

    The container within the pod should be called `secret-admin` and should sleep for 4800 seconds.

    The container should mount a read-only secret volume called secret-volume at the path `/etc/secret-volume`. The secret being mounted has already been created for you and is called `dotfile-secret`.

    1. Use imperative command to get a starter manifest

        ```
        kubectl run secret-1401 -n admin1401 --image busybox --dry-run=client -o yaml --command -- sleep 4800 > admin.yaml
        ```

    1. Edit this manifest to add in the details for mounting the secret

        ```
        vi admin.yaml
        ```

        Add in the volume and volume mount sections seen below

        ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
          creationTimestamp: null
          labels:
            run: secret-1401
          name: secret-1401
          namespace: admin1401
        spec:
          volumes:
          - name: secret-volume
            secret:
              secretName: dotfile-secret
          containers:
          - command:
            - sleep
            - "4800"
            image: busybox
            name: secret-admin
            volumeMounts:
            - name: secret-volume
              readOnly: true
              mountPath: /etc/secret-volume
        ```

    1. And create the pod

        ```
        kubectl create -f admin.yaml
        ```

  </details>


