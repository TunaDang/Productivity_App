.PHONY: test check

build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

start:
	OCAMLRUNPARAM=b dune exec bin/main.exe

check:
	@bash check.sh

finalcheck:
	@bash check.sh final

zip:
	rm -f todoList.zip
	zip -r todoList.zip . -x@exclude.lst

clean:
	dune clean
	rm -f todoList.zip

doc:
	dune build @doc
