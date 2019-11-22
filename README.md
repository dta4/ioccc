![](https://github.com/dta4/ioccc/workflows/Dockerization/badge.svg)

This is a working, but very simple dummy project, that shall help to
* integrate open source projects into your On-Prem CI/CD pipeline
* provide a blue print for [Alpine][4] based dockerization

---

It implements a browser based simulation of *reaction-diffusion systems* using [WebSockets][8], build in memoriam and as reminiscence to [Alan Turing][2]. The 3.045 bytes of code come from [Yusuke Endoh][0] and were an [IOCCC winner][1] in 2015.

[Reaction-diffusion systems][3], proposed by Alan Turing in \[1\], are mathematical models in which two chemical substances are transformed into each other (*local chemical reactions*) and spread out (*diffusion*). Their interactions sometimes form non-trivial patterns, such as spots, spiral, dappling and labyrinths.

### Local build and run

```bash
make

# point your browser to http://localhost:10042/ after running the following command
tcpserver -v 127.0.0.1 10042 src/oregonator src/ioccc.txt
^C

make clean
```

### Local docker build and run

```bash
docker build --tag=ioccc .
```

Build the application stuff during docker image building via
* a single docker build with temporary virtual environments
```bash
apk add --no-cache --virtual .fetch-deps ... && \
apk add --no-cache --virtual .build-deps ... && \
... && \
apk del .fetch-deps .build-deps
```
* a [multi-stage docker build][6]
* or by feeding pre-build artefacts from somewhere

For the moment a multi-stage Dockerfile is provided. We are working on providing the other two examples.

A working `docker-entrypoint.sh` skeleton for configuring the container during bootstrapping is provided.   
It is **strongly recommended** to use the *entrypoint pattern* to [initialize container data at runtime][7] from the beginning for each image that is exposing a daemon as the service.

```bash
# access the container during development
docker run -p 10042:10042 -it --rm --name ioccc ioccc /bin/bash

# run the container during development
docker run -p 10042:10042 --rm --name ioccc ioccc
^C

# run the container in production
docker run -p 10042:10042 -d --rm --name ioccc ioccc

# point your browser to http://localhost:10042/ in any case...
```

### Releasing

To bump a new version, run locally:

```bash
make clean
make release v=0.1.0
```

You need write permissions to the upstream.  
Remember that `make` is using git [**hub** CLI][9]. There is a [Wiki page][10] with some further examples.

### TODO

- [ ] automated [DockerHub][5] publishing
- [x] releasing and publishing on GitHub via local build environment
- [ ] provide additional Dockerfiles
- [ ] [Tini][12] as explicit `init` for containers instead of `--init`
- [ ] [mo][14] as [mustache][13] template engine


> Written with [StackEdit](https://stackedit.io/).

---

\[1\] Turing, A. M., "The Chemical Basis of Morphogenesis", Philosophical Transactions of the Royal Society, 1952.

[0]: https://github.com/mame
[1]: http://ioccc.org/winners.html#E
[2]: https://en.wikipedia.org/wiki/Alan_Turing
[3]: https://en.wikipedia.org/wiki/Reaction%E2%80%93diffusion_system
[4]: https://alpinelinux.org/
[5]: https://hub.docker.com/r/dta4/ioccc
[6]: https://docs.docker.com/develop/develop-images/multistage-build/
[7]: https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
[8]: https://en.wikipedia.org/wiki/WebSocket
[9]: https://hub.github.com/
[10]: https://github.com/dta4/commons/wiki/GitHub-Workflow
[12]: https://github.com/krallin/tini
[13]: https://mustache.github.io/
[14]: https://github.com/tests-always-included/mo
