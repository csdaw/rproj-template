rproj-template
================

Template for my own reproducible research projects, using project in a
folder mentality. I have tried the project as a package (PARP) idea and
whilst it is a good idea, it can overcomplicate things unnecessarily.

This template uses: `git`, `renv`, `make`, and `docker`. It is based off
of Joel Nitta’s
[docker-renv-example](https://github.com/joelnitta/docker-renv-example)
and Aaron Peikert’s reproducible research
[workflow-showcase](https://github.com/aaronpeikert/workflow-showcase/tree/41e7bc740a9956dea743160aac24e88165b3ec33).

## Setup

Steps taken to create this template:

1.  Create a new repository on github.com. Initialise the repo with a
    README, .gitignore (for R), and appropriate LICENSE.
2.  In RStudio create a new project from a version control repository
    and paste the repo web URL (in this case
    <https://github.com/csdaw/rproj-template.git>).
3.  Open this project folder with your local R installation or IDE, or
    even mount it to a containerised development environment.
4.  Develop your analyses. In this case there is just a single
    representative Rmarkdown document which knits to pdf and produces 2
    figures.
5.  Copy the `Dockerfile`, `install_packages.R` and `renv_restore` from
    [docker-renv-example](https://github.com/joelnitta/docker-renv-example)
    to this folder.
6.  Modify the install\_packages.R script to suit the specific project
    requirements.
