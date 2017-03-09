.DEFAULT_GOAL := all
all: gobuild

01-start-minikube:
	minikube start --memory 4096 --vm-driver xhyve
	sleep 30
	minikube ip
	@echo add minikube ip
	atom /etc/hosts

02-ingress:
	kubectl create -f ingress
	kubectl get pod --all-namespaces -w

03-docker-registry:
	kubectl create -f docker-registry
	kubectl get pod --all-namespaces -w

04-gitlab:
	kubectl create -f gitlab
	sleep 10
	kubectl logs -f --namespace gitlab $(kubectl get pod --namespace gitlab -l 'service=gitlab' -o json |jq '.items[0].metadata.name' -r)
	open http://gitlab/profile/account
	@echo export GITLAB_PRIVATE_TOKEN="***"

05-gitlab-runner:
	kubectl create -f gitlab-runner
	sleep 10
	open http://gitlab/admin/runners
	kubectl get pod --all-namespaces -w

06-push-app:
	cd test-app-golang && rm -fr .git
	cd test-app-golang && git init
	sleep 3
	curl --header "PRIVATE-TOKEN: $(GITLAB_PRIVATE_TOKEN)" -X POST "http://gitlab/api/v3/projects?name=test-app-golang"
	sleep 3
	cd test-app-golang && echo "1.0" > VERSION
	cd test-app-golang && git remote add origin http://gitlab/root/test-app-golang.git
	cd test-app-golang && git add .
	cd test-app-golang && git commit -a -m "Initial Commit "`cat VERSION`
	cd test-app-golang && git tag `cat VERSION`
	cd test-app-golang && git push -u origin `cat VERSION`
	sleep 10
	open http://gitlab/root/test-app-golang/pipelines

07-test-tag:
	cd test-app-golang && echo "1.0.2" > VERSION
	cd test-app-golang && git commit -a -m "test version "`cat VERSION`
	cd test-app-golang && git tag `cat VERSION`
	cd test-app-golang && git push origin `cat VERSION`
	sleep 10
	open http://gitlab/root/test-app-golang/pipelines

clean:
	curl --header "PRIVATE-TOKEN: $(GITLAB_PRIVATE_TOKEN)" -X DELETE "http://gitlab/api/v3/projects/root%2Ftest-app-golang"
