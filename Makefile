projekt := $(notdir $(CURDIR))

ifeq ($(WINDOWS),TRUE)
	# please mind the unusual way to specify the path
	current_dir:=//c/Users/aaron/Documents/reproducible-research
	home_dir:=$(current_dir)
	uid:=
else
	current_dir := $(CURDIR)
	home_dir := $(current_dir)
	uid = $(shell id -u)
endif

ifeq ($(DOCKER),TRUE)
	run:= docker run --rm --user $(uid) -v $(current_dir):/home/$(projekt) $(projekt)
	current_dir=/home/$(projekt)
endif

all: analysis.pdf README.md

build: Dockerfile
	docker build -t $(projekt) .

rebuild:
	docker build --no-cache -t $(projekt) .

README.md: README.Rmd
	$(run) Rscript -e 'rmarkdown::render("$(current_dir)/$<")'

analysis.pdf: analysis.Rmd
	$(run) Rscript -e 'rmarkdown::render("$(current_dir)/$<")'
