rproj-template
================

![Docker
Pulls](https://img.shields.io/docker/pulls/csdaw/rproj-template)
![Docker Image Size
(tag)](https://img.shields.io/docker/image-size/csdaw/rproj-template/latest)
[![dockerfile](https://img.shields.io/badge/dockerfile%20on-github-blue.svg)](https://github.com/csdaw/rproj-template)
[![base](https://img.shields.io/badge/depends%20on-csdaw%2Frmarkdown--tinytex-blue)](https://hub.docker.com/csdaw/rmarkdown-tinytex "Docker base image")

Template for my own containerised reproducible R projects, constructed
using using `renv`, `make`, and `docker`. Ultimately, only `docker` (and
optionally `make`) is required to reproduce the results of the fake
analysis (`analysis.Rmd`).

How to reproduce the analysis document?
---------------------------------------

### Quick way

Only requires `docker` installed.

1.  Pull the `rproj-template` docker image from
    [here](https://hub.docker.com/repository/docker/csdaw/rproj-template)
    with `docker pull csdaw/rproj-template`
2.  Navigate to the directory you want the `results/` folder to be
3.  Launch a docker container with the current directory mounted and
    knit `analysis.Rmd`, for example using this command:

<!-- -->

    docker run -dt -v $PWD/results/:/home/analysis/results csdaw/rproj-template \
    Rscript -e 'rmarkdown::render("/home/analysis/analysis.Rmd", output_dir = "results/")'

### Complete way (recommended)

Only requires `make` and `docker` installed. Takes several minutes for
packages to install from source into `renv` library (`stringi` is really
slow… :weary:). The `rproj-template` image is built from scratch (very
quick! :sunglasses:).

1.  Clone this repository
2.  Run `make all`

**Note: Docker Desktop for Windows users** need to manually edit the
Makefile and set `current_path` to the current directory and use
`make all WINDOWS=TRUE`. Hopefully future releases of Docker for Windows
will not require this workaround.

How do I adapt this template for my own project?
------------------------------------------------

1.  Clone this repository
2.  Modify or replace `analysis.Rmd` with your own analysis. Also add
    any raw data files, R scripts, etc. your analysis relies upon.
3.  Ensure any output of `analysis.Rmd` will go into a folder called
    `results/`
4.  Add the packages your analysis relies on to `install_packages.R`
5.  If you rename `analysis.Rmd` be sure to replace the name in the
    `Makefile`
6.  Run `make all`

How does it work?
-----------------

The R packages required for an analysis are installed into a `renv`
library using a temporary Docker container (with a volume mount). Then a
Docker image is built into which the `renv` library and the analysis
(`analysis.Rmd`) are copied, and the `renv` library is initialised. This
image is completely self-contained and should be archived somewhere
other than Docker Hub, for example [figshare](https://figshare.com) or
[Zenodo](https://zenodo.org), as Docker Hub is not an archive service.
Then to reproduce the results of the analysis, one simply needs to pull
(or rebuild) the image, run a container with a host directory mounted,
and knit `analysis.Rmd` to produce a `results/` folder with the output.

This template is based off of Joel Nitta’s
[docker-renv-example](https://github.com/joelnitta/docker-renv-example)
and Aaron Peikert’s reproducible research
[workflow-showcase](https://github.com/aaronpeikert/workflow-showcase/tree/41e7bc740a9956dea743160aac24e88165b3ec33).

How did I make this template?
-----------------------------

Steps taken to create this template (in case I forget):

1.  Create a new repository on github. Initialise the repo with a
    README, .gitignore (for R), and appropriate LICENSE.
2.  In RStudio create a new project from a version control repository
    and paste the repo web URL (in this case
    `https://github.com/csdaw/rproj-template.git`).
3.  Open this project and develop the analysis. In this case there is
    just a single representative Rmarkdown document which knits to pdf
    and produces 2 figures.
4.  Copy the `Dockerfile`, `install_packages.R` and `renv_restore` from
    [docker-renv-example](https://github.com/joelnitta/docker-renv-example)
    to this folder.
5.  Copy the Makefile from
    [workflow-showcase](https://github.com/aaronpeikert/workflow-showcase/tree/41e7bc740a9956dea743160aac24e88165b3ec33).
6.  Modify the copied Makefile and Dockerfile to suit the specific
    project parameters. Remember the R version in the Dockerfile
    **must** match the R version in the container used to run
    `install_packages.R` (see commit history for full changes).
7.  Run `make prepare`. This deletes the `results/` folder and its
    contents, if present.
8.  Run `make renv`. This executes `install_packages.R` in a container
    which creates:
    -   renv.lock
    -   .Rprofile (modified if it already existed)
    -   renv/activate.R
    -   Various other files in renv/ that should not be commited
9.  Run `make build`. This builds a docker image containing the contents
    of the current directory.
10. Run `make results`. This launches a container from the image and
    knits `analysis.Rmd` to produces `results/`.
11. Run `make clean` to remove the container.
12. Commit the following files and folders:
    -   `renv.lock`
    -   `renv/`
    -   `results/`
