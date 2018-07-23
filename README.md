**Cybernode**

To use cybernode CLI (now available only through go package):

- Install GO SDK (https://golang.org/doc/install)
- Run `go get https://github.com/cybercongress/cybernode`
- Now project is available under `$GOPATH/src/github.com/cybercongress/cybernode`
- Install glide (https://glide.sh/)
- In project root dir run `glide install --strip-vendor`
- Run `go install`
- Now cybernode binary is available in your `$GOPATH/bin` folder. You could add it to path and use it like`cybernode --help` command.
 Or go into `$GOPATH/bin` and use it like `./cybernode --help`
