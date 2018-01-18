MCCORTEX := ./bin/mccortex63
PIP := pip3
FIXTURE_PACKAGE := down/cortex-tools-fixtures.tar.bz2
PY_ENV := pipenv run
TEST_COMMAND := $(PY_ENV) pytest --benchmark-autosave

benchmark:
	$(TEST_COMMAND) benchmark

setup: python-dependencies
	$(MAKE) get-fixtures
	$(MAKE) fixtures

python-dependencies:
	pipenv install
	$(PY_ENV) $(PIP) install cortexpy

$(FIXTURE_PACKAGE):
	cd down; gdrive download $(FIXTURE_PACKAGE_GDRIVE_ID)

get-fixtures: $(FIXTURE_PACKAGE)
	tar -xf $^

package-fixtures:
	find fixtures -type f -name '*.fna' | xargs tar -cjf $(FIXTURE_PACKAGE)

fixtures: fixtures/Pabies_coding_sequence/Pabies1.0-all-cds.ctx

fixtures/Pabies_coding_sequence/Pabies1.0-all-cds.ctx: fixtures/Pabies_coding_sequence/Pabies1.0-all-cds.fna
	$(MCCORTEX) build --force --sort --memory 2G -k 47 --sample pabies_reference_cds --seq $< $@


.PHONY: setup benchmark
.DELETE_ON_ERROR:
