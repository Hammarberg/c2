appname := c2

CXX := clang++
CXXFLAGS := -O2 -std=c++17 -march=native
LDFLAGS :=
LDLIBS := -ldl

srcfiles := c2.cpp c2a.cpp json.cpp macro.cpp token.cpp tokfeed.cpp cmda.cpp template.cpp
objects  := $(patsubst %.cpp, %.o, $(srcfiles))

all: $(appname)

$(appname): $(objects)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $(appname) $(objects) $(LDLIBS)

depend: .depend

.depend: $(srcfiles)
	rm -f ./.depend
	$(CXX) $(CXXFLAGS) -MM $^>>./.depend;

clean:
	rm -f $(objects)

dist-clean: clean
	rm -f *~ .depend

include .depend
