
COMPONENTS = finmap bigenough multinomials analysis

FINMAP_REPO = https://github.com/math-comp/finmap.git
FINMAP_TAG = 1.5.2
FINMAP_WORKDIR = workdir/finmap

BIGENOUGH_REPO = https://github.com/math-comp/bigenough.git
BIGENOUGH_TAG = 1.0.1
BIGENOUGH_WORKDIR = workdir/bigenough

MULTINOMIALS_REPO = https://github.com/math-comp/multinomials.git
MULTINOMIALS_TAG = 1.5.5
MULTINOMIALS_WORKDIR = workdir/multinomials

HB_REPO = https://github.com/math-comp/hierarchy-builder.git
HB_TAG = v1.3.0
HB_WORKDIR = workdir/hierarchy-builder

ANALYSIS_REPO = https://github.com/math-comp/analysis.git
ANALYSIS_TAG = 0.5.3
ANALYSIS_WORKDIR = workdir/analysis

GIT_FLAGS = -c advice.detachedHead=false --depth=1

.PHONY: all get elpi-hack

all: $(FINMAP_WORKDIR) $(BIGENOUGH_WORKDIR) $(MULTINOMIALS_WORKDIR) $(HB_WORKDIR) $(ANALYSIS_WORKDIR) elpi-hack
	# Some libs depend on other libs, these should be installed until composed build lands in Dune
	dune build $(FINMAP_WORKDIR)/coq-mathcomp-finmap.install       && dune install coq-mathcomp-finmap
	dune build $(BIGENOUGH_WORKDIR)/coq-mathcomp-bigenough.install && dune install coq-mathcomp-bigenough
	dune build $(HB_WORKDIR)/coq-hierarchy-builder.install         && dune install coq-hierarchy-builder
	dune build

get: $(FINMAP_WORKDIR) $(BIGENOUGH_WORKDIR) $(MULTINOMIALS_WORKDIR) $(HB_WORKDIR) $(ANALYSIS_WORKDIR)

elpi-hack:
	mkdir -p /tmp/jscoq-addons/elpi
	ln -sf $(realpath $(HB_WORKDIR)/HB) /tmp/jscoq-addons/elpi/

$(FINMAP_WORKDIR):
	git clone $(GIT_FLAGS) -b $(FINMAP_TAG) $(FINMAP_REPO) $(FINMAP_WORKDIR)
	#( cd $(FINMAP_WORKDIR) && git apply ../../etc/finmap.patch )

$(BIGENOUGH_WORKDIR):
	git clone $(GIT_FLAGS) -b $(BIGENOUGH_TAG) $(BIGENOUGH_REPO) $(BIGENOUGH_WORKDIR)
	cp dune-files/lib/bigenough/* $(BIGENOUGH_WORKDIR)/

$(MULTINOMIALS_WORKDIR):
	git clone $(GIT_FLAGS) -b $(MULTINOMIALS_TAG) $(MULTINOMIALS_REPO) $(MULTINOMIALS_WORKDIR)

$(HB_WORKDIR):
	git clone $(GIT_FLAGS) -b $(HB_TAG) $(HB_REPO) $(HB_WORKDIR)
	( cd $(HB_WORKDIR) && git apply ../../etc/hierarchy-builder-8.16.patch )
	cp dune-files/lib/hierarchy-builder/* $(HB_WORKDIR)/

$(ANALYSIS_WORKDIR):
	git clone $(GIT_FLAGS) -b $(ANALYSIS_TAG) $(ANALYSIS_REPO) $(ANALYSIS_WORKDIR)
	( cd $(ANALYSIS_WORKDIR) && git apply ../../etc/analysis-8.16.patch )
	cp -r dune-files/lib/analysis/* $(ANALYSIS_WORKDIR)/

install:
	dune install ${addprefix coq-mathcomp-, $(COMPONENTS)}

uninstall:
	dune uninstall ${addprefix coq-mathcomp-, $(COMPONENTS)}
