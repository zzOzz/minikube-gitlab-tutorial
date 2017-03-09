.DEFAULT_GOAL := all
all: gobuild

gobuild:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -X main.gittag=`git describe --tags`  -X main.buildstamp=`date -u '+%Y-%m-%d_%I:%M:%S%p'` -X main.githash=`git rev-parse HEAD`" -a -installsuffix cgo -o app

gox:
	gox -osarch="linux/amd64 darwin/amd64" -ldflags "-X main.gittag=`git describe --tags` -X main.buildstamp=`date -u '+%Y-%m-%d_%I:%M:%S%p'` -X main.githash=`git rev-parse HEAD`"
	mv test-app-golang_linux_amd64 main
	chmod +x main

run:
	./main

init:
	rm -fr .git
	git init
	curl --header "PRIVATE-TOKEN: nyGKftBCcFEUWKzsQpV1" -X DELETE "http://gitlab/api/v3/projects/root%2Ftest-app-golang"
	sleep 3
	curl --header "PRIVATE-TOKEN: nyGKftBCcFEUWKzsQpV1" -X POST "http://gitlab/api/v3/projects?name=test-app-golang"
	sleep 3
	git remote add origin http://gitlab/root/test-app-golang.git
	git add .
	git commit -a -m "Initial Commit"
	git tag 1.0
	git push -u origin 1.0
