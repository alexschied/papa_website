.PHONY: serve draft build clean install

serve:
	bundle exec jekyll serve 

draft:
	bundle exec jekyll serve --livereload --drafts --future

build:
	bundle exec jekyll build

clean:
	bundle exec jekyll clean

install:
	bundle install
