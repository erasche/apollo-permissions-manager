.PHONY: build


NPM:=$(shell which npm)
YARN:=$(shell which yarn)

installer = $(NPM)

ifdef YARN
	installer = $(YARN)
endif

all: run

run: node_modules  ## Run the server
	@echo "********************************"
	@echo "* open http://localhost:10000/ *"
	@echo "********************************"
	./node_modules/.bin/webpack-dev-server --progress --colors --devtool cheap-module-inline-source-map --hot --debug --inline --host 0.0.0.0 --port 8080

build: node_modules  ## Compile a project for deployment
	./node_modules/.bin/webpack  --progress --colors --devtool source-map

node_modules: package.json
	$(installer) install

.PHONY: help

deploy: ## Deploy to github.io
	./node_modules/.bin/webpack;
	rm -rf dist;
	mkdir -p dist;
	cp -Rv build dist/;
	cp -Rv partials dist/;
	cp index.html dist;
	./node_modules/.bin/gh-pages -d dist

help:
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


clean:  ## Remove artefacts
	rm -rf build dist node_modules
