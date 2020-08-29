project := $(notdir $(CURDIR))
NAME ?= my_analysis

ifeq ($(WINDOWS),TRUE)
	# please mind the unusual way to specify the path
	current_dir:=//c/Users/aaron/Documents/reproducible-research
else
	current_dir := $(CURDIR)
endif

build: Dockerfile
	docker build -t $(project) .

rebuild:
	docker build --no-cache -t $(project) .

analysis:
	docker run -dt --name=$(NAME) $(project) \
		Rscript -e 'rmarkdown::render("/home/analysis/analysis.Rmd", output_dir = "results/")'

export:
	docker cp $(NAME):/home/analysis/results $(current_dir)

clean:
	docker rm $(NAME)
