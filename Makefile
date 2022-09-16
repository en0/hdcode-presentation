SLIDES_DIR = .

clean:
	@rm -f *.html

single:
	@docker run --rm -v $(PWD):/home/marp/app/ -e LANG=$LANG marpteam/marp-cli --html true $(deck)

slides:
	$(foreach file, $(wildcard $(SLIDES_DIR)/*.md), docker run --rm -v $(PWD):/home/marp/app/ -e LANG=$LANG marpteam/marp-cli --html true $(file);)

copy:
	mkdir -p output/
	$(foreach file, $(wildcard $(SLIDES_DIR)/*.html), rm output/$(file); mv $(file) output/;)

