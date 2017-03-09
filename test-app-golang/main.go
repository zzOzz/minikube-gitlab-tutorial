package main

import (
    "fmt"
    "net/http"
)
var buildstamp = "No Version Provided"
var githash = "No Version Provided"
var gittag = "No Version Provided"

func handler(w http.ResponseWriter, r *http.Request) {
    // fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
    fmt.Fprintf(w, "<html><script>setTimeout(function(){window.location.reload(1);}, 5000);</script><h1>Hello World</h1>%s - %s - %s</html>", gittag, githash, buildstamp)
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
