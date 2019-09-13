requirements.txt: requirements.in
	pip-compile --no-index requirements.in -o requirements.txt


install:
	pip install --upgrade pip
	pip install -r requirements.txt
	jupyter labextension install jupyterlab_vim


upgrade:
	pip-compile --upgrade --no-index requirements.in -o requirements.txt


.PHONY: install upgrade
