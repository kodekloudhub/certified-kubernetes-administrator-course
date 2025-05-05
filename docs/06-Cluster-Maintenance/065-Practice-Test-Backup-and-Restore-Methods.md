# Practice Test - Backup and Restore Methods
Take me to [Practice Test](https://kodekloud.com/topic/practice-test-backup-and-restore-methods/)

Solutions to practice test - Backup and Restore Methods

1.  <details>
    <summary>How many deployments exist in the cluster?</summary>

    ```
    kubectl get deployments
    ```
    </details>

1.  <details>
    <summary>What is the version of ETCD running on the cluster?</summary>

    ```
    kubectl describe pod -n kube-system etcd-controlplane
    ```

    Find the entry for `Image`
    </details>

1.  <details>
    <summary>At what address can you reach the ETCD cluster from the controlplane node?</summary>

    ```
    kubectl describe pod -n kube-system etcd-controlplane
    ```

    Under `Command` find `--listen-client-urls`
    </details>

1.  <details>
    <summary>Where is the ETCD server certificate file located?</summary>

    On kubeadm clusters like this one, the default location for certificate files is `/etc/kubernetes/pki/etcd`

    Choose the correct certificate
    </details>

1.  <details>
    <summary>Where is the ETCD CA Certificate file located?</summary>

    On kubeadm clusters like this one, the default location for certificate files is `/etc/kubernetes/pki/etcd`

    Choose the correct certificate
    </details>

1.  <details>
    <summary>Take a snapshot of the ETCD database using the built-in snapshot functionality.</br>Store the backup file at location <b>/opt/snapshot-pre-boot.db</b></summary>

    ```
    ETCDCTL_API=3 etcdctl snapshot save \
      --cacert=/etc/kubernetes/pki/etcd/ca.crt \
      --cert=/etc/kubernetes/pki/etcd/server.crt \
      --key=/etc/kubernetes/pki/etcd/server.key \
      /opt/snapshot-pre-boot.db
    ```
    </details> 

1. Information only.


1.  <details>
    <summary>Wake up! We have a conference call! After the reboot the master nodes came back online, but none of our applications are accessible. Check the status of the applications on the cluster. What's wrong?</summary>

    > All of the above
    </details>

1.  <details>
    <summary>Luckily we took a backup. Restore the original state of the cluster using the backup file.</summary>

    1. Restore the backup to a new directory

        ```
        ETCDCTL_API=3 etcdctl snapshot restore \
          --data-dir /var/lib/etcd-from-backup \
          /opt/snapshot-pre-boot.db
        ```

    1. Modify the `etcd` pod to use the new directory.

        To do this, we need to edit the `volumes` section and change the `hostPath` to be the directory we restored to.

        ```
        vi /etc/kubernetes/manifests/etcd.yaml
        ```

        ```yaml
          volumes:
          - hostPath:
              path: /etc/kubernetes/pki/etcd
              type: DirectoryOrCreate
            name: etcd-certs
          - hostPath:
              path: /var/lib/etcd      # <- change this
              type: DirectoryOrCreate
            name: etcd-data
        ```

        New value: `/var/lib/etcd-from-backup`

        Save this and wait for up to a minute for the `etcd` pod to reload.

    1. Verify

        ```
        kubectl get deployments
        kubectl get services
        ```
    </details>

See also: https://github.com/kodekloudhub/community-faq/blob/main/docs/etcd-faq.md
