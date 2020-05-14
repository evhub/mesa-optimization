.PHONY: run
run:
	arara mesa_optimization.tex

.PHONY: install
install:
	pip install -Ue .
