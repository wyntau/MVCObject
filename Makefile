compile:
	./node_modules/.bin/coffee -c mvcobject.coffee
	./node_modules/.bin/uglifyjs --compress --mangle --output mvcobject.min.js -- mvcobject.js

test:
	@./node_modules/.bin/mocha

.PHONY: compile test