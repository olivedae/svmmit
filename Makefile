# Manifest makefile for svmmit

SVN=$(realpath .)/.tests/svmmit
LIST=a b c d

all: clean build fills

.PHONY : build clean

build:
	mkdir .tests && cd .tests && \
	svnadmin create svmmit  && \
	svn import $(SVN) file://$(SVN)/trunk -m "Initial import of project" && \
	svn co file://$(SVN)/trunk ./working_copy

fills: $(addprefix fill-, $(LIST))

fill-%:
	cd ./.tests/working_copy && \
	echo " \
	<?php\n\nclass $* {\n\tpublic function testing() {\n\n\t}\n}" > $*.php && \
	svn add $*.php && \
	svn commit -m "Example commit $*"

clean:
	rm -rf .tests {a..f}.php
