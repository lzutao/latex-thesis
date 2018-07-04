LATEX=pdflatex
# Use -synctex=1 for sync with PDF viewer and Editor
LATEXOPT=--shell-escape
# interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
# Using nonstopmode or batchmode
NONSTOP=--interaction=batchmode
BUILDDIR=builddir

LATEXMK=latexmk
LATEXMKOPT=-bibtex -pdf -outdir=$(BUILDDIR) -use-make \
			-pdflatex="$(LATEX) $(LATEXOPT) $(NONSTOP)"
CONTINUOUS=-pvc

MAIN=main
SOURCES=$(MAIN).tex Makefile
# FIGURES := $(shell find images/* -type f)

# You want $(LATEXMK) to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: all clean clean-all

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: $(MAIN).pdf

####################
# CUSTOM BUILD RULES
####################

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

######################
# MAIN $(LATEXMK) RULE
######################

# pdf tells $(LATEXMK) to generate PDF directly (instead of DVI).
# pdflatex="" tells $(LATEXMK) to call a specific backend with specific options.
# use-make tells $(LATEXMK) to call make for generating missing files.

$(MAIN).pdf: $(MAIN).tex
	$(LATEXMK) $(LATEXMKOPT) $(MAIN)

clean:
	$(LATEXMK) -c -outdir=$(BUILDDIR)

# -bibtex also removes the .bbl files (http://tex.stackexchange.com/a/83384/79184).
clean-all:
	$(LATEXMK) -C -bibtex -outdir=$(BUILDDIR)

