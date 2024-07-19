all: check coverage

.PHONY: \
    check \
    clean \
    coverage \
    format \
    green \
    init \
    install \
    red \
    refactor \
    setup \
    tests

check:
	R -e "library(styler)" \
      -e "resumen <- style_dir('R')" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE

clean:
	rm --force *.tar.gz
	rm --force --recursive tests/testthat/_snaps
	rm --force NAMESPACE

coverage: setup tests
	Rscript tests/testthat/coverage.R

format:
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

init: init_git setup tests

init_git:
	git config --global --add safe.directory /workdir
	git config --global user.name "Ciencia de Datos • GECI"
	git config --global user.email "ciencia.datos@islas.org.mx"

setup: clean install

install:
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check validate.tdp_0.1.0.tar.gz && \
    R CMD INSTALL validate.tdp_0.1.0.tar.gz

tests:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

red: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& git restore tests/testthat/ \
	|| (git add tests/testthat/ && git commit -m "🛑🧪 Fail tests")
	chmod g+w -R .

green: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/ && git commit -m "✅ Pass tests") \
	|| git restore R/
	chmod g+w -R .

refactor: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/ tests/testthat/ && git commit -m "♻️  Refactor") \
	|| git restore .
	chmod g+w -R .
