.DEFAULT_GOAL := clean-dev-environment


# Environments
ci-environment:
	@ make -f Makefile.python-venv venv-frozen

dev-environment: pre-commit-install ci-environment

clean-dev-environment: clean dev-environment

refreeze-dev-requirements:
	@ make -f Makefile.python-venv refreeze-dev-requirements


# pre-commit
pre-commit-install:
	@ make -f Makefile.precommit pre-commit-install

pre-commit: ci-environment
	@ make -f Makefile.precommit pre-commit-run

# Clean
clean:
	@ make -f Makefile.precommit clean
	@ make -f Makefile.python-venv clean
