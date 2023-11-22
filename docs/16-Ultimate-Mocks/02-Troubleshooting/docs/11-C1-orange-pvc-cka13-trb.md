# Bind the orange-pvc-cka13-trb

For this question, please set the context to cluster1 by running:

```
kubectl config use-context cluster1
```

There is an existing persistent volume called orange-pv-cka13-trb. A persistent volume claim called orange-pvc-cka13-trb is created to claim storage from orange-pv-cka13-trb.

However, this PVC is stuck in a Pending state. As of now, there is no data in the volume.

Troubleshoot and fix this issue, making sure that orange-pvc-cka13-trb PVC is in Bound state.

---

### Solution

1. Describe the PVC and determine the issue

    ```
    kubectl describe pvc orange-pvc-cka13-trb
    ```

    Note the message "requested PV is too small". We must adjust the PVC to fit

2.  Describe the PV and determine its properties. Note that PVC properties must be adjusted to match

    ```
    kubectl describe pv orange-pv-cka13-trb
    ```

3.  Adjust the PVC. Note that you cannot directly edit a PVC size to be smaller, so we have to replace it.

    ```
    kubectl get pvc orange-pvc-cka13-trb -o yaml  > pvc.yaml
    vi pvc.yaml
    ```

    Change the requested size to match the size of the PV. Save and exit vi, then replace the PVC with the edited manifest:

    ```
    kubectl replace --force -f pvc.yaml
    ```
