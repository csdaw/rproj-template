# Install packages to a docker image with renv

### Initialize renv ###

# Install renv
install.packages("renv", repos = "https://cran.rstudio.com/")

# Initialize renv, but don't let it try to find packages to install itself.

renv::consent(provided = TRUE)

renv::init(
  bare = TRUE,
  force = TRUE,
  restart = FALSE
  )

renv::activate()

### Setup repositories ###

# Install packages that install packages.
install.packages("BiocManager", repos = "https://cran.rstudio.com/")
install.packages("remotes", repos = "https://cran.rstudio.com/")

# Specify repositories so they get included in
# renv.lock file.
my_repos <- BiocManager::repositories()
my_repos["CRAN"] <- "https://cran.rstudio.com/"
options(repos = my_repos)

### Install packages ###

# All packages will be installed to
# the project-specific renv library.

# Here we are just installing one package per repository
# as an example. If you want to install others, just add
# them to the vectors.

# Install CRAN packages
# Can use remotes::install_version to install a specific version
cran_packages <- c("ggplot2")
install.packages(cran_packages)

# Install bioconductor packages
bioc_packages <- c("limma")
BiocManager::install(bioc_packages)

# Install github packages
github_packages <- c("csdaw/ggprism")
remotes::install_github(github_packages)

### Take snapshot ###

renv::snapshot(type = "simple")
