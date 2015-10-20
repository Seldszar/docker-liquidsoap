# Liquidsoap Docker

Docker container to install a customized version of Liquidsoap, compiled from sources.

## How to use

Launch a Liquidsoap script :

    docker run seldszar/liquidsoap <input file>

To get help about Liquidsoap usage, type the following command :

    docker run seldszar/liquidsoap --help

## Customize Liquidsoap installation

If you want to add or remove some packages from Liquidsoap, you can edit the `PACKAGES` file and (un)comment packages you want.

## Known issues

 - It's currently impossible to compile `ocaml-aacplus` and `ocaml-fdkaac` modules due to the lack of official dependency. In the future, these dependencies will be compiled from source during build process.

## Useful links

 - [Github repository](https://github.com/Seldszar/docker-liquidsoap)
 - [Docker container page](https://index.docker.io/u/seldszar/liquidsoap/)
 - [Liquidsoap website](http://liquidsoap.fm/)
 - [Liquidsoap documentation](http://liquidsoap.fm/doc-svn/documentation.html)
