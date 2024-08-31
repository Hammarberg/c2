TARGET_EXEC ?= c2

BUILD_DIR := build
SRC_DIR := source

SRCS := $(shell find $(SRC_DIR) | grep .cpp)

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)
MODE := normal

INC_DIRS := $(SRC_DIR) ./
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -Wno-unused-result

ifeq ($(MODE),debug)
	CXXFLAGS := -O0 -g
else ifeq ($(MODE),optimize)
	CXXFLAGS := -O2 -flto=auto
else ifeq ($(MODE),native)
	CXXFLAGS := -O2 -flto=auto -march=native
else
	CXXFLAGS ?= -O2
endif

OS := $(shell uname -o)

ifneq ($(ProgramFiles),)
	TARGET_EXEC := $(TARGET_EXEC).exe
endif

# Set flags depending on compiler
ifeq ($(findstring mingw,$(CXX)),mingw)
	LDFLAGS := $(LDFLAGS) -static-libgcc -static-libstdc++
else ifeq ($(findstring clang,$(CXX)),clang)

else
	LDLIBS := $(LDLIBS) -ldl
endif

ifeq ($(findstring clang,$(CXX)),clang)
	CXXFLAGS := $(CXXFLAGS) -std=c++17
else
	CXXFLAGS := $(CXXFLAGS) -std=gnu++17
endif

C2_GITVERSION := $(shell git describe --always)

ifeq ($(C2_GITVERSION),)
	C2_GITVERSION := not set
endif

ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

$(TARGET_EXEC): c2gitversion.h $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

c2gitversion.h:
	@echo "#define C2_GITVERSION \"$(value C2_GITVERSION)\"" > gitversion.h

.PHONY: clean debug install uninstall

clean:
	$(RM) -r $(BUILD_DIR) c2gitversion.h

debug:
	@echo C2_GITVERSION=$(C2_GITVERSION)
	@echo OS=$(OS)
	@echo TARGET_EXEC=$(TARGET_EXEC)
	@echo CXX=$(CXX)
	@echo CXXFLAGS=$(CXXFLAGS)
	@echo CPPFLAGS=$(CPPFLAGS)
	@echo LDFLAGS=$(LDFLAGS)
	@echo LDLIBS=$(LDLIBS)
	@echo SRCS=$(SRCS)
	@echo PREFIX=$(PREFIX)

install: $(TARGET_EXEC)
	install -d $(PREFIX)/bin
	install $(TARGET_EXEC) $(PREFIX)/bin
	install -d $(PREFIX)/lib
	cp -r c2lib $(PREFIX)/lib/

uninstall:
	rm $(PREFIX)/bin/$(TARGET_EXEC)
	rm -rf $(PREFIX)/lib/c2lib

-include $(DEPS)

MKDIR_P ?= mkdir -p
