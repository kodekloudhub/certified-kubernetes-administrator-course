# Practice Test - Backup and Restore Methods
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816654)
  
Solutions to practice test - Backup and Restore Methods
- Run the kubectl get deployments command
  
  <details>
  ```
  $ kubectl get deployments
  ```
  </details>
  
- Look at the ETCD Logs using command kubectl logs etcd-master -n kube-system or check the ETCD pod kubectl describe pod etcd-master -n kube-system

  <details>
  ```
  $ kubectl logs etcd-master -n kube-system (or)
  $ kubectl describe pod etcd-master -n kube-system
  ```
  </details>
  
- Use the command kubectl describe pod etcd-master -n kube-system and look for --listen-client-urls
  
  <details>
  ```
  $ kubectl describe pod etcd-master -n kube-system 
  ```
  </details>
    
- Check the ETCD pod configuration kubectl describe pod etcd-master -n kube-system
  
  <details>
  ```
  $ kubectl describe pod etcd-master -n kube-system
  ```
  </details>
  
- Check the ETCD pod configuration kubectl describe pod etcd-master -n kube-system
  
  <details>
  ```
  $ kubectl describe pod etcd-master -n kube-system
  ```
  </details>
  
- Run the below command to backup etcd. View answer file at [etcd-backup-and-restore](https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md)
  
  <details>
  ```
  $ ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/snapshot-pre-boot.db.
  ```
  </details>
  
- Wake up! We have a conference call! After the reboot the master nodes came back online, but none of our applications are accessible. Check the status of the applications on the cluster. What's wrong?
  
  <details>
  ```
  All of the above
  ```
  </details>
  
- Luckily we took a backup. Restore the original state of the cluster using the backup file. 
  - View answer file at [etcd-backup-and-restore](https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md#3-restore-etcd-snapshot-to-a-new-folder)
  
  

#### Take me to [Solutions to Practice Tests Video Tutorial](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/14450164)
