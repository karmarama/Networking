RUBY := $(shell command -v ruby 2>/dev/null)
HOMEBREW := $(shell command -v brew 2>/dev/null)
HOMEBREW_FRAMEWORKS_DIRECTORY = /usr/local/Frameworks
HOMEBREW_FRAMEWORKS_EXISTS := $(shell command find $(HOMEBREW_FRAMEWORKS_DIRECTORY) -type d 2>/dev/null)

default: bootstrap

.PHONY: bootstrap
bootstrap: \
	check_for_ruby \
	check_for_homebrew \
	update_homebrew \
	install_swift_lint

.PHONY: check_for_ruby
check_for_ruby:
	$(info Checking for Ruby ...)

ifeq ($(RUBY),)
	$(error Ruby is not installed)
endif

.PHONY: check_for_homebrew
check_for_homebrew:
	$(info Checking for Homebrew ...)

ifeq ($(HOMEBREW),)
	$(error Homebrew is not installed)
endif
	
ifeq ($(HOMEBREW_FRAMEWORKS_EXISTS),)
	$(warning Run these commands to manually create the Homebrew Frameworks directory:) \
	$(warning sudo mkdir $(HOMEBREW_FRAMEWORKS_DIRECTORY)) \
	$(warning sudo chown $$USER $(HOMEBREW_FRAMEWORKS_DIRECTORY)) \
	$(error Homebrew Frameworks directory does not exist)
endif

.PHONY: update_homebrew
update_homebrew:
	$(info Update Homebrew ...)

	brew update

.PHONY: install_swift_lint
install_swift_lint:
	$(info Install swiftlint ...)

	brew unlink swiftlint || true
	brew install swiftlint
	brew link --overwrite swiftlint