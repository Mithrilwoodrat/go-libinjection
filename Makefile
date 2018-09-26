.PHONY: all init test build clean

libinjection_src = $(CURDIR)/libinjection
go_libinjection_src = $(CURDIR)/src/libinjection
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
GOPATH=${CURDIR}
BUILDDIR=$(CURDIR)/bin
WORKDIR=$(shell basename $(CURDIR))
PACKAGE=libinjection
OBJECTS=

all: init test

init:
	mkdir -p ${BUILDDIR}

libinjection.so: $(BUILDDIR)/libinjection_sqli.o ${BUILDDIR}/libinjection_xss.o ${BUILDDIR}/libinjection_html5.o
	gcc -dynamiclib -shared -o libinjection.so $^
	cp libinjection.so ./src/libinjection

$(BUILDDIR)/libinjection_sqli.o:
	gcc -std=c99 -Wall -Werror -fpic -c ${libinjection_src}/libinjection_sqli.c -o $(BUILDDIR)/libinjection_sqli.o
${BUILDDIR}/libinjection_xss.o:
	gcc -std=c99 -Wall -Werror -fpic -c $(libinjection_src)/libinjection_xss.c -o ${BUILDDIR}/libinjection_xss.o
${BUILDDIR}/libinjection_html5.o:
	gcc -std=c99 -Wall -Werror -fpic -c $(libinjection_src)/libinjection_html5.c -o ${BUILDDIR}/libinjection_html5.o

test: libinjection.so
	@cp ${libinjection_src}/*.h ./src/libinjection
	@cp libinjection.so ./src/libinjection
	@GOPATH=$(GOPATH) go test libinjection -v

clean:
	@rm -f ${BUILDDIR}/*
	@rm -f ${go_libinjection_src}/*.so
	@rm -f *.so ${BINARY}
	@rm -f ./src/libinjection/*.so
	@rm -f ./src/libinjection/*.h