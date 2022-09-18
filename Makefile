clean:
	@rm -f *.html

html:
	@docker run --rm -v $(PWD):/home/marp/app/ -e LANG=$LANG marpteam/marp-cli tt-presentation.md

dev:
	@docker run --rm -v $(PWD):/home/marp/app/ -e LANG=$(LANG) -p 8080:8080 -p 37717:37717 marpteam/marp-cli -s .

