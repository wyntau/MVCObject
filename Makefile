compile:
	./node_modules/.bin/coffee -c MVCObject.coffee

test:
	@./node_modules/.bin/mocha

.PHONY: compile test