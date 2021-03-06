# Web Kubectl Interface

![webkubectl](https://raw.githubusercontent.com/akhilrajmailbox/Web-Kubectl/master/img/webkube.png)

This is an custom application which can used for communicate with your k8s Cluster without any kubectl configuration on your local system. `web-kubectl` have these features...

* `2FA` Authentication
* Web interface
* Security and Permission customization with `rbac`
* Awesome terminal Interface


## Two Factor Authentication with Google Authenticator

I set up [SSH two factor authentication on Ubuntu 16.04](https://www.linuxbabe.com/ubuntu/ssh-two-factor-authentication-ubuntu-16-04-google-authenticator) server using the well-known Google Authenticator. Once you set it up, the security of your SSH server will be hugely increased.

Two factor authentication, also known as two-step verification, requires you to enter two pieces of information in order to login. Google Authenticator generates a one-time password using a shared secret key and the current time. Not only do you need to provide the correct username and password, but also have to enter a one-time password generated by Google Authenticator to log in to your SSH server.


After your deployment, check the logs for the deployment and scan the QR Code / take the key with `Google Authenticator` application on your phone, thats it. done...!


![2fa](https://raw.githubusercontent.com/akhilrajmailbox/Web-Kubectl/master/img/webkubetoken.png)


## Conifgure ServiceAccount for the deployment

**Note** : Need custom ServiceAccount for `web-kubectl`


This is an example `ServiceAccount` creation yaml file. before creating the rbac, update the following terms in `rbac.yaml` file.

* `namespace: web-kub` with your namespace
* `verbs: ["get", "watch", "list"]` > this configuration having readonly permission, if you need more privilege for your `web-kubectl` to your cluster and `verbs: ["create"]` for `pods/exec` to run exec commands, you can [update](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) it, example : `verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]`

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webkubsrvaccount
  namespace: web-kub
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: webkub-clusterrole
rules:
# Just an example, feel free to change it
- apiGroups: [""]
  resources: ["*"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: webkub-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: webkubsrvaccount
  namespace: web-kub
roleRef:
  kind: ClusterRole
  name: webkub-clusterrole
  apiGroup: rbac.authorization.k8s.io
---
## for pod exec commands
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: webkub-pod-clusterrole
rules:
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: webkub-pod-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: webkubsrvaccount
  namespace: web-kub
roleRef:
  kind: ClusterRole
  name: webkub-pod-clusterrole
  apiGroup: rbac.authorization.k8s.io
```

Create the rbac on your cluster after update the file

```
kubectl create ns web-kub
kubectl apply -f rbac.yaml
```


## Configure Helm charts on your k8s server if your helm client version < 3.x.x

```
kubectl create serviceaccount --namespace=kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

## helm chart deployment on kubernetes (TL;DR;)

```
helm repo add ar-webkub https://akhilrajmailbox.github.io/Web-Kubectl/docs
helm install ar-webkub/web-kub -n web-kubectl --namespace=web-kub --set ssh.username=kubectl,ssh.password=randompassword
```

**Note** : The default `ssh.username` is `kubectl` but default `ssh.password` is empty. so if you forget to pass these variables, then your deployment will crash. (not passing `ssh.password` is because of some security concern)


## chart Configuration

The following table lists the configurable parameters of the `web-kub` chart and default values.

| Parameter                          | Description                                      | Default                                                   |
| ---------------------------------- | ------------------------------------------------ | ----------------------------------------------------------|
| replicaCount                       | number of pods to deploy                         | 1                                                         |
| image.repository                   | image repository                                 | akhilrajmailbox/web-kubectl                               |
| image.tag                          | image tag                                        | 1.0.1                                                     |
| image.pullPolicy                   | image repository                                 | Always                                                    |
| serviceaccount                     | Service Account for the deployment to communicate with k8s             | webkubsrvaccount                                                        |
| ssh.username                       | username for ssh / web access                    | kubectl                                                   |
| ssh.password                       | password for the user `ssh.username`             | -                                                         |
| kubeconfig                         | enable / disbale auto configuration for kubectl  | true                                                      |
| service.port                       | TCP port                                         | 80                                                        |
| service.type                       | K8S service type exposing ports, e.g. `ClusterIP`| LoadBalancer                                              |
| persistence.enabled                | enable / disable persistence volume              | ReadWriteOnce                                             |
| persistence.accessMode             | Use volume as ReadOnly or ReadWrite              | ReadWriteOnce                                             |
| persistence.annotations            | Persistent Volume annotations                    | {}                                                        |
| persistence.size                   | Size of data volume (adjust for production!)     | 50Gi                                                      |
| persistence.storageClass           | Storage class of PVC                             | default                                                   |
| resources.requests.cpu             | minimum CPU for deployment                       | 100m                                                      |
| resources.requests.memory          | minimum memory for deployment                    | 128Mi                                                     |
| nodeSelector                       | Node labels for pod assignment                   | {}                                                        |
| tolerations                        | Toleration labels for pod assignment             | []                                                        |
| affinity                           | Affinity settings for pod assignment             | {}                                                        |