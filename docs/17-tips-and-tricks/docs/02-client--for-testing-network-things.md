# Client for testing network things

Often you will get questions that require you to test network polices, or look something up in the Kubernetes DNS. There is a one size fits all pod that you can deploy that has all the network testing tools you could possibly want, including

* curl
* nslookup
* netstat
* dig
* telnet
* nc

and many more.

You run it like so. Commit the image name to memory - this image is a lifesaver! There is nothing to stop you using it in the exam.

```
kubectl run tester --image wbitt/network-multitool
```

When the pod is running, you can exec into it and run the commands

```
$ kubectl exec tester -it -- bash

/# curl something
/# nslookup something-else
/# exit
```

Or run the commands directly if you need to send the results to a file

```
$ kubectl exec tester -it -- nslookup my-service.default.svc > /opt/some-file.txt
```

