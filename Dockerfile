# Only run this after making renv.lock by
# running install_packages.R

FROM rocker/verse:4.0.0

RUN apt-get update

RUN mkdir rproj-template

COPY . ./rproj-template

WORKDIR /rproj-template

RUN Rscript renv_restore.R
