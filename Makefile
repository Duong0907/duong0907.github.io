# .PHONY: all init install serve clean

all: init install serve

init:
	bundle init
	bundle add jekyll --version "~> 4.4.1"
	bundle config set --local path 'vendor/bundle'

install:
	bundle install
	bundle exec jekyll new --force --skip-bundle .
	bundle add webrick
	bundle install

serve:
	bundle exec jekyll serve --livereload

clean:
	rm -rf _site .jekyll-cache vendor
