# Only run this after making renv.lock by
# running install_packages.R

FROM csdaw/rmarkdown-tinytex:4.0.2

RUN apt-get update

# make a folder for the self-contained analysis
RUN mkdir /home/analysis

# copy all necessary files
COPY . /home/analysis

# set the correct working directory
WORKDIR /home/analysis

# restore the renv project to have access to the packages
# required for knitting analysis.Rmd
RUN Rscript renv_restore.R
