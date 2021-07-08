
FINMAP_REPO = https://github.com/math-comp/finmap.git
FINMAP_TAG = 1.5.1
FINMAP_WORKDIR = workdir/finmap

BIGENOUGH_REPO = https://github.com/math-comp/bigenough.git
BIGENOUGH_TAG = 1.0.0
BIGENOUGH_WORKDIR = workdir/bigenough

MULTINOMIALS_REPO = https://github.com/math-comp/multinomials.git
MULTINOMIALS_TAG = 1.5.4
MULTINOMIALS_WORKDIR = workdir/multinomials

.PHONY: all get

all: $(FINMAP_WORKDIR) $(BIGENOUGH_WORKDIR) $(MULTINOMIALS_WORKDIR)
	# Some libs depend on other libs, these should be installed until composed build lands in Dune
	dune build $(FINMAP_WORKDIR)/coq-mathcomp-finmap.install       && dune install coq-mathcomp-finmap
	dune build $(BIGENOUGH_WORKDIR)/coq-mathcomp-bigenough.install && dune install coq-mathcomp-bigenough
	dune build

get: $(FINMAP_WORKDIR) $(BIGENOUGH_WORKDIR) $(MULTINOMIALS_WORKDIR)

$(FINMAP_WORKDIR):
	git clone --depth=1 --no-checkout -b $(FINMAP_TAG) $(FINMAP_REPO) $(FINMAP_WORKDIR)
	( cd $(FINMAP_WORKDIR) && git checkout $(FINMAP_TAG) && git apply ../../etc/finmap.patch )

$(BIGENOUGH_WORKDIR):
	git clone --depth=1 --no-checkout -b $(BIGENOUGH_TAG) $(BIGENOUGH_REPO) $(BIGENOUGH_WORKDIR)
	( cd $(BIGENOUGH_WORKDIR) && git checkout $(BIGENOUGH_TAG) )
	cp dune-files/lib/bigenough/* $(BIGENOUGH_WORKDIR)/

$(MULTINOMIALS_WORKDIR):
	git clone --depth=1 --no-checkout -b $(MULTINOMIALS_TAG) $(MULTINOMIALS_REPO) $(MULTINOMIALS_WORKDIR)
	( cd $(MULTINOMIALS_WORKDIR) && git checkout $(MULTINOMIALS_TAG) )

install:
	dune install coq-mathcomp-multinomials

uninstall:
	dune uninstall ${addprefix coq-mathcomp-, finmap bigenough multinomials}
