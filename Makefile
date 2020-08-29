project := $(notdir $(CURDIR))
NAME ?= my_analysis

ifeq ($(WINDOWS),TRUE)
	# please mind the unusual way to specify the path
	current_dir:=//c/Users/charlotte/Documents/rproj-template
else
	current_dir := $(CURDIR)
endif

all: prepare renv build analysis

prepare:
	if [ -d "results" ]; then rm -r results;	fi

renv:
	docker run -dt --name=make_renv -v $(current_dir):/home/$(project) rocker/r-ver:4.0.2 bash; \
	docker exec -i make_renv bash -c "cd /home/$(project) && Rscript install_packages.R"; \
	docker stop make_renv; \
	docker rm make_renv

build: Dockerfile
	docker build -t $(project) .

rebuild:
	docker build --no-cache -t $(project) .

analysis: prepare results stop clean

results:
	docker run -dt --name=$(NAME) -v $(current_dir)/results/:/home/analysis/results $(project) \
	Rscript -e 'rmarkdown::render("/home/analysis/analysis.Rmd", output_dir = "results/")'

stop:
	docker stop $(NAME)

clean:
	docker rm $(NAME)

.PHONY: all analysis
