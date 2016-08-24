# Liquidsoap

[![dockeri.co](http://dockeri.co/image/seldszar/liquidsoap)](https://hub.docker.com/r/seldszar/liquidsoap/)

[![GitHub issues](https://img.shields.io/github/issues/seldszar/docker-liquidsoap.svg "GitHub issues")](https://github.com/seldszar/docker-liquidsoap) [![GitHub stars](https://img.shields.io/github/stars/seldszar/docker-liquidsoap.svg "GitHub stars")](https://github.com/seldszar/docker-liquidsoap)

Another Liquidsoap Docker image, with some bonuses.

## Supported tags and respective `Dockerfile` links

 - [`1.2.1`, `1.2`, `1`, `latest` (1.2/Dockerfile)](https://github.com/Seldszar/docker-liquidsoap/blob/master/1.2/Dockerfile)
 - [`1.2.1-onbuild`, `1.2-onbuild`, `1-onbuild`, `onbuild` (1.2/onbuild/Dockerfile)](https://github.com/Seldszar/docker-liquidsoap/blob/master/1.2/onbuild/Dockerfile)

## How to use this image

### Create a `Dockerfile` in your Liquidsoap project

```dockerfile
FROM seldszar/liquidsoap:onbuild

# replace this with your application's default port
EXPOSE 8000
```

You can then build and run the Docker image:

```console
$ docker build -t my-liquidsoap-app .
$ docker run -it --rm --name my-running-app my-liquidsoap-app
```

#### Notes

 - The image assumes that your application has a file named `ls_script.liq` to bootstrap.

### Run the Liquidsoap Docker image

If you don't need to build a custom container, you can just run Liquidsoap and copy your application directly.

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/app -w /usr/src/app seldszar/liquidsoap:1 liquidsoap ls_script.liq
```

## Additional features

 - You can customize you Liquidsoap installation by editing the `LIQUIDSOAP_PACKAGES` environment variable.

## Image Variants

The seldszar/liquidsoap images come in many flavors, each designed for a specific use case.

### `seldszar/liquidsoap:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of. This tag is based off of buildpack-deps. buildpack-deps is designed for the average user of docker who has many images on their system. It, by design, has a large number of extremely common Debian packages. This reduces the number of packages that images that derive from it need to install, thus reducing the overall size of all images on your system.

### `seldszar/liquidsoap:onbuild`

This image makes building derivative images easier. For most use cases, creating a Dockerfile in the base of your project directory with the line FROM seldszar/liquidsoap:onbuild will be enough to create a stand-alone image for your project.

While the onbuild variant is really useful for "getting off the ground running" (zero to Dockerized in a short period of time), it's not recommended for long-term usage within a project due to the lack of control over when the ONBUILD triggers fire (see also docker/docker#5714, docker/docker#8240, docker/docker#11917).

Once you've got a handle on how your project functions within Docker, you'll probably want to adjust your Dockerfile to inherit from a non-onbuild variant and copy the commands from the onbuild variant Dockerfile (moving the ONBUILD lines to the end and removing the ONBUILD keywords) into your own file so that you have tighter control over them and more transparency for yourself and others looking at your Dockerfile as to what it does. This also makes it easier to add additional requirements as time goes on (such as installing more packages before performing the previously-ONBUILD steps).
