.PHONY: lint test check lockrefresh publish

lint:
	cd test && wippy lint $(WIPPY_LINT_ARGS) --ns 'kickside.docs' --ns 'kickside.docs.*'

test:
	@output="$$(cd test && wippy test $(WIPPY_TEST_ARGS) 2>&1)"; status=$$?; \
	printf '%s\n' "$$output"; \
	if [ $$status -ne 0 ] || printf '%s\n' "$$output" | grep -qE 'FAILED|No tests found' || \
		! printf '%s\n' "$$output" | grep -q 'PASSED' || \
		! printf '%s\n' "$$output" | grep -qE '[1-9][0-9]* tests'; then exit 1; fi

check:
	python3 scripts/check_pages.py

lockrefresh:
	cd test && wippy update --src-dir .

publish:
	@echo "Releases use GitHub Release Please (.github/workflows/release.yml)." >&2
	@exit 1
