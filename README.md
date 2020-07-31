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
7.  Launch a container with the specific R version that you want and
    with the project folder mounted, using the following command (Be
    sure to replace the path on the left side of :
    (`~/repos/docker-renv-example/`) with the path to the project folder
    on your machine):

`docker run -it -e DISABLE_AUTH=true -v
~/repos/rproj-template/:/home/rstudio/rproj-template rocker/verse:4.0.0
bash`

8.  This will open a bash shell within the container. Navigate to the
    mounted project folder within the container:

`cd home/rstudio/project`

9.  Run the install\_packages.R script within the container (this may
    take a while depending on the number of packages that are installed
    from source):

`Rscript install_packages.R`

10. Exit the container with using `exit`. The `install_packages.R`
    script has generated the following files and directories:
      - renv.lock
      - .Rprofile (modified if it already existed)
      - renv/activate.R
      - Various other files in renv/ that should not be commited
11. Commit the renv files above.
12. If you need to adjust your analysis at this stage (or any stage up
    until step x) you can do the following:
      - Run `renv::deactivate()` in your project folder. This will
        modify (or delete) the .Rprofile file.
      - Then you can change your analysis however you like without renv
        complaining.
      - If you need to install extra packages you’ll have to repeat
        steps 7-11.
      - Once you’ve made any modifications, simply run
        `renv::activate()` to return the .Rprofile back to where it was.
13. Otherwise, copy the Makefile from
    [workflow-showcase](https://github.com/aaronpeikert/workflow-showcase/tree/41e7bc740a9956dea743160aac24e88165b3ec33).
14. Modify the copied Makefile and Dockerfile to suit the specific
    project parameters. Remember the R version in the Dockerfile
    **must** match the R version in the container used to run
    `install_packages.R`.
