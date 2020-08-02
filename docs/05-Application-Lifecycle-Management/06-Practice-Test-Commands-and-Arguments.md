# Practice Test - Commands and Arguments
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816639)
  
Solutions to practice test - commands and arguments
- Run the command 'kubectl get pods' and count the number of pods.
  ```
  $ kubectl get pods
  ```
- Run the command 'kubectl describe pod' and look for command option
  ```
  $ kubectl describe pod
  ```
- Set the command option to ['sleep', '5000']. Answer file at: /var/answers/answer-ubuntu-sleeper-2.yaml

- Both sleep and 1200 should be defined as a string. Answer file at: /var/answers/answer-ubuntu-sleeper-3.yaml

- Answer file at: /var/answers/answer-ubuntu-sleeper-3-2.yaml

- Inspect the file 'Dockerfile' given at /root/webapp-color. What command is run at container startup?
  ```
  python app.py
  ```
- Inspect the file 'Dockerfile2' given at /root/webapp-color. What command is run at container startup?
  ```
  python app.py --color red
  ```
- The 'command' (entrypoint) is overridden in the pod definition. So the answer is --color green

- Inspect the two files under directory 'webapp-color-3'. What command is run at container startup?
  ```
  python app.py --color pink
  ```
- Answer file located at /var/answers/answer-webapp-color-green.yaml
