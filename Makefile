EMACS ?= emacs
CASK ?= cask

CURL=curl --silent -L
ERT_URL=http://git.savannah.gnu.org/cgit/emacs.git/plain/lisp/emacs-lisp/ert.el?h=emacs-24
ERT=ert
CL_URL=https://raw.githubusercontent.com/emacsmirror/cl-lib/master/cl-lib.el
CL=cl-lib

.PHONY: test test-deferred test-concurrent compile clean print-deps travis-ci

test: test-deferred test-deferred-compiled test-concurrent test-concurrent-compiled

test-deferred:
	$(CASK) exec ert-runner test/deferred-test.el

test-deferred-compiled: deferred.elc
	$(CASK) exec ert-runner -l deferred.elc test/deferred-test.el

test-concurrent:
	$(CASK) exec ert-runner test/concurrent-test.el

test-concurrent-compiled: concurrent.elc
	$(CASK) exec ert-runner -l concurrent.elc test/concurrent-test.el

compile: deferred.elc concurrent.elc

%.elc: %.el
	$(EMACS) -batch -L . -f batch-byte-compile $<

clean:
	rm -rfv *.elc

print-deps:
	@echo "----------------------- Dependencies -----------------------"
	$(EMACS) --version
	@echo "------------------------------------------------------------"

travis-ci: print-deps
	$(MAKE) clean test
	$(MAKE) compile test
