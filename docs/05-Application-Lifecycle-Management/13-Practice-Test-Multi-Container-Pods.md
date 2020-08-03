# Practice Test - Multi-Container Pods
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/10589159)
  
Solutions to practice test - multi-container pods
- Identify the number of containers running in the 'red' pod.
  ```
  $ kubectl get pod red
  ```
- Identify the name of the containers running in the 'blue' pod.
  ```
  $ kubectl describe pod blue
  ```
- Answer file is located at /var/answers/answer-yellow.yaml
  ```
  $ kubectl create -f /var/answers/answer-yellow.yaml
  ```
- We have deployed an application logging stack in the elastic-stack namespace. Inspect it.
  ```
  $ kubectl get pods -n elastic-stack
  ```
- Inspect the Kibana UI using the link above your terminal. There shouldn't be any logs for now.

- Run `kubectl describe pod -n elastic-stack`
  ```
  $ kubectl describe pod -n elastic-stack
  ```
- Run the command 'kubectl -n elastic-stack exec -it app cat /log/app.log'
  ```
  $ kubectl -n elastic-stack exec -it app cat /log/app.log
  ```
- Answer file is located at /var/answers/answer-app.yaml
  
- Inspect the Kibana UI. You should now see logs appearing in the 'Discover' section. You might have to wait for a couple of minutes for the logs to populate. You might have to create an index pattern to list the logs. If not sure check this video: https://bit.ly/2EXYdHf

- 
  
