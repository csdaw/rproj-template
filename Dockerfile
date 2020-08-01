# Only run this after making renv.lock by
# running install_packages.R

FROM csdaw/rmarkdown-tinytex:4.0.2

RUN apt-get update

RUN mkdir /home/rproj-template

COPY . /home/rproj-template

WORKDIR /home/rproj-template

RUN Rscript renv_restore.R
