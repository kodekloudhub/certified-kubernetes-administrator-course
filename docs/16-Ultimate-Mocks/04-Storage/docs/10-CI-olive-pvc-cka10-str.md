# Cluster 1, Storage, olive-pvc-cka10-str

For this question, please set the context to `cluster1` by running:


```
kubectl config use-context cluster1
```

We want to deploy a python based application on the cluster using a template located at `/root/olive-app-cka10-str`.yaml on `student-node`. However, before you proceed we need to make some modifications to the YAML file as per details given below:


* The YAML should also contain a persistent volume claim with name `olive-pvc-cka10-str` to claim a `100Mi` of storage from `olive-pv-cka10-str PV`.
* Update the deployment to add a sidecar container, which can use `busybox` image (you might need to add a sleep command for this container to keep it running.)
* Share the `python-data` volume with this container and mount the same at path `/usr/src`. Make sure this container only has `read` permissions on this volume.
* Finally, create a pod using this YAML and make sure the POD is in `Running` state.

### Missing from the question, but required to pass

* Create a nodeport service for this deployment with the following specification
    * Node port: `32006`
    * Name: `olive-svc-cka10-str`


---

### Solution

1.  Examine what we have...

    ```
    cat /root/olive-app-cka10-str
    ```

    The PVC volume claim is already present. Look for the PVC

    ```
    kubectl get pvc
    ```

    It is not present, therefore it will have to be created first.

    ```
    kubectl get pv
    ```

    The PV exists. Note the `ACCESS MODES` and `STORAGECLASS`, which are required in the PVC manifest, along with the storage request given in the question.

1.  Prepare manfiest for the new PVC

    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: olive-pvc-cka10-str
    spec:
      accessModes:
      - ReadWriteMany
      resources:
        requests:
          storage: 100Mi
      storageClassName: olive-stc-cka10-str
    ```

    Then create it. It will not bind yet until the pod is created.

1.  Adjust the pod as directed, and add the service to the end.

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: olive-app-cka10-str
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: olive-app-cka10-str
        spec:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: kubernetes.io/hostname
                    operator: In
                    values:
                      - cluster1-node01
          containers:
          - name: busybox
            image: busybox
            command:        # <- Any variation of sleep command should work.
            - bin/sh        # Needs to sleep long enough to get to end of test.
            - -c
            - sleep 10000
            volumeMounts:
            - mountPath: /usr/src
              name: python-data
              readOnly: true
          - name: python
            image: poroko/flask-demo-app
            ports:
            - containerPort: 5000
            volumeMounts:
            - name: python-data
              mountPath: /usr/share/
          volumes:
          - name: python-data
            persistentVolumeClaim:
              claimName: olive-pvc-cka10-str
      selector:
        matchLabels:
          app: olive-app-cka10-str

    ---

    apiVersion: v1
    kind: Service
    metadata:
      name: olive-svc-cka10-str
      namespace: default
    spec:
      ports:
      - nodePort: 32006
        port: 5000
        protocol: TCP
        targetPort: 5000
      selector:
        app: olive-app-cka10-str
      type: NodePort
    ```

1.  Create the resources

    ```
    kubectl apply -f /root/olive-app-cka10-str
    ```