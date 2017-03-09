## K8s Gitlab Deployment


### Install minikube
https://github.com/kubernetes/minikube/releases
~~~
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.17.1/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
~~~

### Init minikube
~~~
#minikube start --memory 4096 --vm-driver virtualbox
#minikube start --memory 4096 --vm-driver vmwarefusion
minikube start --memory 4096 --vm-driver xhyve
~~~

### Add ip to hostfile

Add these entries in your hostfile

~~~
echo $(minikube ip)" gitlab"
echo $(minikube ip)" helloworld"
~~~

### Create ingress controller
~~~
kubectl create -f ingress
~~~

### Create internal docker-registry
~~~
kubectl create -f docker-registry
~~~

### Create gitlab server
~~~
kubectl create -f gitlab
~~~

You can create secret with
~~~
kubectl create secret generic gitlab-secret --namespace gitlab --from-file=./gitlab/GITLAB_OMNIBUS_CONFIG --from-file=./gitlab/REGISTRATION_TOKEN
~~~

### Create gitlab runner
~~~
kubectl create -f gitlab-runner
~~~

#### Create test-app project

http://gitlab/projects/new

### Testing App

#### Create deployment for this App
~~~
kubectl create -f test-app/k8s/ -R
~~~

#### Publishing source on gitlab
~~~
cd test-app
git init
git remote add origin http://gitlab/root/test-app.git
git add .
git commit -a -m "Initial commit"
git push -u origin master
cd ..
~~~

### Creation cert for local domain
~~~
openssl req -new -x509 -keyout tls.key -out tls.crt -days 3650 -nodes
kubectl create secret generic local-wildcard --namespace kube-system --from-file=tls.crt="./tls.crt" \
--from-file=tls.key="./tls.key"
~~~
