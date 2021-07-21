# Using PVC in PODs

  - Take me the [Lecture](https://kodekloud.com/topic/using-pvc-in-pods/)

In this section, we will take a look at **Using PVC in PODs**

- In this case, Pods access storage by using the claim as a volume. Persistent Volume Claim must exist in the same namespace as the Pod using the claim. 
- The cluster finds the claim in the Pod's namespace and uses it to get the Persistent Volume backing the claim. The volume is then mounted to the host and into the Pod.
- Persistent Volume is a cluster-scoped and Persistent Volume Claim is a namespace-scoped.

#### Create the Persistent Volume

```
pv-definition.yaml

kind: PersistentVolume
apiVersion: v1
metadata:
    name: pv-vol1
spec:
    accessModes: [ "ReadWriteOnce" ]
    capacity:
     storage: 1Gi
    hostPath:
     path: /tmp/data
```
```
$ kubectl create -f pv-definition.yaml

```

#### Create the Persistent Volume Claim

```
pvc-definition.yaml

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
spec:
  accessModes: [ "ReadWriteOnce" ]
  resources:
   requests:
     storage: 1Gi
```
```
$ kubectl create -f pvc-definition.yaml
```

#### Create a Pod

```
pod-definition.yaml

apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: web
  volumes:
    - name: web
      persistentVolumeClaim:
        claimName: myclaim
```
```
$ kubectl create -f pod-definition.yaml

```

#### List the Pod,Persistent Volume and Persistent Volume Claim

```
$ kubectl get pod,pvc,pv

```

#### References Docs

- https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes



