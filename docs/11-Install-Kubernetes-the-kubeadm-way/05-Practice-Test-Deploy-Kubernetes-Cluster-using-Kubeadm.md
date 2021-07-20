# Practice Test - Install kubernetes cluster using kubeadm tool

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-deploy-a-kubernetes-cluster-using-kubeadm/)

# Solutions for practice test - Install Using Kubeadm

  1. Check the solution

     <details>
     
      ```
      sudo apt-get update && sudo apt-get install -y apt-transport-https curl
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
      deb https://apt.kubernetes.io/ kubernetes-xenial main
      EOF
      sudo apt-get update
      sudo apt-get install -y kubelet kubeadm kubectl
      sudo apt-mark hold kubelet kubeadm kubectl
      ```
     </details>

  2. Check the solution

     <details>
      
      ```
      kubelet --version
      ``` 
     </details>

  3. Check the solution

     <details>
      
      ```
      0
      ``` 
     </details>

  5. Click on **`OK`**

  6. Check the solution

     <details>
      
      ```
      kubeadm init
      ``` 
     </details>

  7. Click on **`OK`**

  8. Click on **`Check`** 

  9. Check the solution

     <details>

      ```
      kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
      ```
     </details>





