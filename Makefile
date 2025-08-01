.PHONY: install clean lint format test coverage build remove-playwright-binaries restore-playwright-binaries

install:
	pip install -e ".[dev]"

run:
	env/bin/tunacode

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

lint:
	ruff check . && ruff format .

lint-check:
	ruff check .
	ruff format --check .

test:
	venv/bin/python -m pytest -q tests/unit tests/characterization tests/test_security.py tests/test_agent_output_formatting.py tests/test_prompt_changes_validation.py

coverage:
	pytest --cov=src/tunacode --cov-report=term

build:
	python -m build

remove-playwright-binaries:
	@echo "Removing Playwright binaries for testing..."
	@MAC_CACHE="$(HOME)/Library/Caches/ms-playwright"; \
	LINUX_CACHE="$(HOME)/.cache/ms-playwright"; \
	if [ -d "$$MAC_CACHE" ]; then \
		mv "$$MAC_CACHE" "$$MAC_CACHE"_backup; \
		echo "Playwright binaries moved to $$MAC_CACHE"_backup; \
	elif [ -d "$$LINUX_CACHE" ]; then \
		mv "$$LINUX_CACHE" "$$LINUX_CACHE"_backup; \
		echo "Playwright binaries moved to $$LINUX_CACHE"_backup; \
	else \
		echo "No Playwright binaries found. Please run 'playwright install' first if you want to test the reinstall flow."; \
	fi

restore-playwright-binaries:
	@echo "Restoring Playwright binaries..."
	@MAC_CACHE="$(HOME)/Library/Caches/ms-playwright"; \
	LINUX_CACHE="$(HOME)/.cache/ms-playwright"; \
	if [ -d "$$MAC_CACHE"_backup ]; then \
		mv "$$MAC_CACHE"_backup "$$MAC_CACHE"; \
		echo "Playwright binaries restored from $$MAC_CACHE"_backup; \
	elif [ -d "$$LINUX_CACHE"_backup ]; then \
		mv "$$LINUX_CACHE"_backup "$$LINUX_CACHE"; \
		echo "Playwright binaries restored from $$LINUX_CACHE"_backup; \
	else \
		echo "No backed up Playwright binaries found. Nothing to restore."; \
	fi
