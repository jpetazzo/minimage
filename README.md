# minimage

Examples and experiments with multi-stage builds, static binaries, and
other techniques to obtain MINimal IMAGEs.

This repository contains code samples and Dockerfiles
to illustrate a series of blog posts about image size
optimization. You can read this series in English:
[part 1](https://www.ardanlabs.com/blog/2020/02/docker-images-part1-reducing-image-size.html),
[part 2](https://www.ardanlabs.com/blog/2020/02/docker-images-part2-details-specific-to-different-languages.html),
[part 3](https://www.ardanlabs.com/blog/2020/04/docker-images-part3-going-farther-reduce-image-size.html);
or in French:
[part 1](https://enix.io/fr/blog/cherie-j-ai-retreci-docker-part1/),
[part 2](https://enix.io/fr/blog/cherie-j-ai-retreci-docker-part2/),
[part 3](https://enix.io/fr/blog/cherie-j-ai-retreci-docker-part3/).


## Ingredients

This repository contains some sample code:
- hello.c: hello world in C
- hello.go: hello world in Go
- hello.py: hello world in Python
- hello.rs: hello world in Rust
- pyds.py: doesn't do anything except import a few data science packages
- pyyaml.py: doesn't do anything excpet `import yaml` (PyYAML)
- whatsmyip.go: Go code making one HTTP request to canihazip.com

And a bunch of Dockerfiles to build that code.


## Wow that's a lot of Dockerfiles

The goal is to show many combinations of build and run
stages: do they work? What's the size of the final image?

Each Dockerfile has a pretty long name, with the following convention:

`Dockerfile.PROGRAM-TO-BUILD.BUILD-IMAGE[.RUN-IMAGE]`

So, for instance, `Dockerfile.hello-java.openjdk-8.openjdk-8-jre-alpine`
means that the Dockerfile builds the `hello.java` code sample,
using `openjdk:8` as the build stage, and `openjdk:8-jre-alpine`
as the run stage.

For single-stage builds (like `Dockerfile.hello-rust.rust-alpine`)
there is no `RUN-IMAGE`.

Sometimes, the name of the Dockerfile also includes
special build parameters, for instance:

- `Dockerfile.hello-c.alpine-static.scratch` doesn't mean
  that the build stage is using an image named `alpine:static`,
  but that it's using `alpine` and building the program with extra
  flags to generate a static binary;
- `Dockerfile.whatsmyip.golang-nocgo.scratch` doesn't mean
  that the build stage is using an image named `golang:nocgo`,
  but that it's using `golang` and building the program with
  extra options to disable cgo.


## Show me the sizes of the images!

If you want to compare the sizes of all these images, you can do:

```bash
docker-compose build
docker images minimage | sort
```


## Do these images all work?

No! Some of them won't. This shows that some combinations
of build and run images are invalid, for reasons explained
in the supporting blog post.

If you want to *test* these images, you can do:
```bash
docker-compose up
docker-compose ps
```

The images that work will show `Exit 0`. If you want to check
what's wrong with the ones that show something else (like
`Exit 1` or `Exit 127`), you can run e.g.
`docker-compose up whatsmyip.golang.scratch` or
`docker run minimage:whatsmyip.golang.scratch`.


## Python wheels

Check the `pyds` and `pyyaml` examples to see how to leverage
multi-stage builds with Python on Alpine. This is useful for
Python packages that use native code. When installing these
packages on a glibc system, Python can download pre-compiled
versions of the packages; but on Alpine (which uses musl) Python
cannot use the pre-compiled versions, and it must recompile.

This recompilation can take a lot of time and disk space,
especially on big data science packages like numpy, scipy,
pandas...

If you want small images with Python and data science workloads
(or anything that requires native code), the easiest solution
is to use `python:slim`. But if you really want to use `python:alpine`,
you can build wheels in a first stage, and install them in a
second stage, as is done here in `pyds` and `pyyaml`.

This is not perfect (we end up copying the wheels before installing
them, which wastes a bit of disk space), but I hope you'll find it
helpful anyway!


## Extra info

The Compose file is generated automatically using the script
`mkcompose.sh`.

There are some Dockerfiles that won't even build. These ones
have the special extension `.err` and added to a separate
Compose file, because having them in the same Compose file
would break the build of the others (Compose stops as soon
as one build fails).


## Contributing

If you want to add code samples or Dockerfiles, feel free to!
