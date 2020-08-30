rproj-template
================

Template for my own reproducible R projects, which constructs a
self-contained docker image using `renv`, `make`, and `docker`.
Ultimately, only `docker` (and optionally `make`) is required to
reproduce the results of the fake analysis (`analysis.Rmd`).

How to reproduce the analysis?
------------------------------

### Quick way

Only requires `docker` installed.

1.  Pull the `rproj-template` docker image from here
2.  Navigate to the directory you want the `results/` folder to be
3.  Launch a docker container with the current directory mounted and
    knit `analysis.Rmd`, for example using this command:

<!-- -->

    docker run -dt -v $PWD/results/:/home/analysis/results rproj-template \
    Rscript -e 'rmarkdown::render("/home/analysis/analysis.Rmd", output_dir = "results/")'

### Complete way

Only requires `make` and `docker` installed. Takes several minutes for
packages to install from source into `renv` library (stringi is really
slow…). The `rproj-template` image is built from scratch (very quick!).

1.  Clone this repository
2.  Run `make all`

How does it work?
-----------------

The R packages required for an analysis are installed into a `renv`
library using a temporary Docker container (with a volume mount). Then a
Docker image is built into which the `renv` library and the analysis
(`analysis.Rmd`) are copied, and the `renv` library is initialised. This
image is completely self-contained and should be archived somewhere
other than Docker Hub, for example [figshare](https://figshare.com), as
Docker Hub is not an archive service. Then to reproduce the results of
the analysis, one simply needs to pull (or rebuild) the image, run a
container with a host directory mounted, and knit `analysis.Rmd` to
produce a `results/` folder with the output.

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
    -   renv.lock
    -   renv/
    -   results/
