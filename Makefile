appname := c2

CXX := clang++
CXXFLAGS := -O2 -std=c++17 -march=native
LDFLAGS :=
LDLIBS :=

srcfiles := c2.cpp c2a.cpp json.cpp macro.cpp token.cpp tokfeed.cpp cmda.cpp template.cpp library.cpp
objects  := $(patsubst %.cpp, %.o, $(srcfiles))

ifndef C2_PLATFORM
	ifneq ($(ProgramFiles),)
		C2_PLATFORM := Windows
	else ifneq ($(WSLENV),)
		C2_PLATFORM := Windows
	else
		C2_PLATFORM := $(shell uname)
	endif
endif

# Fix some special cases.
ifneq ($(filter Linux UNIX, $(C2_PLATFORM)),)
	LDLIBS := $(LDLIBS) -ldl
else ifeq ($(C2_PLATFORM),Windows)
	appname := $(appname).exe
endif

.PHONY: always clean depend dist-clean

all: $(appname) always

$(appname): $(objects)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $(appname) $(objects) $(LDLIBS)

always:
	@echo -n

depend: .depend always

.depend: $(srcfiles)
# Use clang++ to generate dependency list.
	$(CXX) $(CXXFLAGS) -MM $^ > .depend
ifeq ($(C2_PLATFORM),Windows)
	@echo "Converting non-continuation backslashes to slashes..."
	sed -i.bak -E 's:\\([[:alnum:]]):/\1:g' .depend
endif

clean:
	rm -f $(objects)

dist-clean: clean
	rm -f *~ .depend

debug:
	@echo C2_PLATFORM=$(C2_PLATFORM)
	@echo appname=$(appname)
	@echo CXX=$(CXX)
	@echo CXXFLAGS=$(CXXFLAGS)
	@echo LDFLAGS=$(LDFLAGS)
	@echo LDLIBS=$(LDLIBS)

install: all
	install -d /usr/local/bin
	install $(appname) /usr/local/bin
	install -d /usr/local/lib
	cp -r c2lib /usr/local/lib/

uninstall: all
	rm /usr/local/bin/$(appname)
	rm -rf /usr/local/lib/c2lib

include .depend
