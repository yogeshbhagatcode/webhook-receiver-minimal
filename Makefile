DIFF_COVER_BASE_BRANCH=main
PYTHON_ENV=py38
VIRTUAL_ENV?=/webhook_receiver/venv
VENV_BIN=${VIRTUAL_ENV}/bin

help:
	@echo ''
	@echo 'Makefile for the Open edX Webhooks project.'
	@echo ''
	@echo 'Usage:'
	@echo '    make requirements                          install requirements for local development'
	@echo '    make migrate                               apply migrations'
	@echo '    make serve                                 start the dev server at localhost:8002'
	@echo '    make clean                                 delete generated byte code and coverage reports'
	@echo '    make validate_python                       run Python unit tests and quality checks'
	@echo '    make fast_validate_python                  run Python unit tests (in parallel) and quality checks'
	@echo '    make quality                               run pycodestyle and Pylint'
	@echo '    make validate                              Run Python and JavaScript unit tests and linting'
	@echo '    make html_coverage                         generate and view HTML coverage report'
	@echo '    make e2e                                   run end to end acceptance tests'
	@echo '    make extract_translations                  extract strings to be translated'
	@echo '    make dummy_translations                    generate dummy translations'
	@echo '    make compile_translations                  generate translation files'
	@echo '    make fake_translations                     install fake translations'
	@echo '    make pull_translations                     pull translations from Transifex'
	@echo '    make update_translations                   install new translations from Transifex'
	@echo '    make clean_static                          delete compiled/compressed static assets'
	@echo '    make static                                compile and compress static assets'
	@echo '    make detect_changed_source_translations    check if translation files are up-to-date'
	@echo '    make check_translations_up_to_date         install fake translations and check if translation files are up-to-date'
	@echo '    make production-requirements               install requirements for production'
	@echo '    make validate_translations                 validate translations'
	@echo '    make check_keywords                        scan Django models in installed apps for restricted field names'
	@echo ''

requirements:
	pip3 install -r requirements/local.txt --exists-action w

requirements.tox:
	pip3 install -U pip==20.0.2
	pip3 install -r requirements/test.txt --exists-action w

production-requirements:
	pip3 install -r requirements/production.txt --exists-action w

migrate: ## Apply database migrations
	${VENV_BIN}/python manage.py migrate --no-input

serve: requirements.tox

clean:
	find . -name '*.pyc' -delete
	rm -rf coverage htmlcov

clean_static:

run_check_isort: requirements.tox

run_isort: requirements.tox

run_pycodestyle: requirements.tox

run_pep8:
	tox -e flake8

quality: run_pep8

validate_python: clean requirements.tox
	tox

acceptance: clean requirements.tox
	tox

fast_validate_python: clean requirements.tox
	tox

validate: validate_python quality

theme_static: requirements.tox

static: theme_static requirements.tox

html_coverage: requirements.tox

diff_coverage: validate fast_diff_coverage

fast_diff_coverage: requirements.tox

e2e: requirements.tox

extract_translations: requirements.tox

dummy_translations: requirements.tox

compile_translations: requirements.tox

fake_translations: extract_translations dummy_translations compile_translations

pull_translations:

push_translations:

update_translations: pull_translations fake_translations

# extract_translations should be called before this command can detect changes
detect_changed_source_translations: requirements.tox

check_translations_up_to_date: fake_translations detect_changed_source_translations

# Validate translations
validate_translations: requirements.tox

# Scan the Django models in all installed apps in this project for restricted field names
check_keywords: requirements.tox

export CUSTOM_COMPILE_COMMAND = make upgrade
upgrade: ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in

# Targets in a Makefile which do not produce an output file with the same name as the target name
.PHONY: help requirements migrate serve clean validate_python quality validate_js validate html_coverage e2e \
	extract_translations dummy_translations compile_translations fake_translations pull_translations \
	push_translations update_translations fast_validate_python clean_static production-requirements
