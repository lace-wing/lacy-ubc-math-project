SRC = $(wildcard src/*.typ)
CONF = $(wildcard src/*.pkl)

# config: $(CONF)
# 	pkl eval $? -f yaml -o $(subst .pkl,.yaml,$?)

clean:
	rm -f src/*.pdf
	rm -f src/*.yaml
	rm -f template/*.pdf
	rm -f test/*.pdf
