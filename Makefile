appname := c2

CXX := clang++
CXXFLAGS := -O2 -std=c++17 -march=native
LDFLAGS :=
LDLIBS := -ldl

srcfiles := c2.cpp c2a.cpp json.cpp macro.cpp token.cpp tokfeed.cpp cmda.cpp template.cpp
objects  := $(patsubst %.cpp, %.o, $(srcfiles))

.PHONY: clean depend dist-clean

all: $(appname)

$(appname): $(objects)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $(appname) $(objects) $(LDLIBS)

depend: .depend

.depend: $(srcfiles)
# Use clang++ to generate dependency list.
	$(CXX) $(CXXFLAGS) -MM $^ > .depend
# Use sed to convert non-continuation backslashes to slashes.
	sed -i.bak -E 's:\\([[:alnum:]]):/\1:g' .depend

clean:
	rm -f $(objects)

dist-clean: clean
	rm -f *~ .depend

include .depend
