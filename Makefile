git=git
brew=brew

TEST_HOMEBREW_TAP?=aws/homebrew-aws-next
export HOMEBREW_PREFIX=$(shell $(brew) --prefix)

export HOMEBREW_DEVELOPER=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BOOTSNAP=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_VERIFY_ATTESTATIONS=1

.default: check-style

dev-setup: test-tap

fmt format:
	$(brew) style --fix .

test-tap:
	@-echo "(re)initialize tap worktree" >&2; sleep 1;
	-$(git) worktree remove $(GIT_FORCE) $(HOMEBREW_PREFIX)/Library/Taps/$(TEST_HOMEBREW_TAP)
	$(git) worktree add $(HOMEBREW_PREFIX)/Library/Taps/$(TEST_HOMEBREW_TAP) HEAD

check: check-style check-audit

check-style:
	$(brew) style .

check-audit:
	$(brew) audit --signing --os=all --arch=all --online --tap $(TEST_HOMEBREW_TAP)
