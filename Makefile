TARGET_EXEC ?= c2

BUILD_DIR := build
SRC_DIR := source

SRCS := $(shell find $(SRC_DIR) -name *.cpp)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(SRC_DIR) ./
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP
CXXFLAGS ?= -O2 -Wno-unused-result -g

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

$(TARGET_EXEC): c2gitversion.h $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

c2gitversion.h:
	@echo "#define C2_GITVERSION \"$(value C2_GITVERSION)\"" > c2gitversion.h

.PHONY: clean

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

install: $(TARGET_EXEC)
	install -d /usr/local/bin
	install $(TARGET_EXEC) /usr/local/bin
	install -d /usr/local/lib
	cp -r c2lib /usr/local/lib/

uninstall:
	rm /usr/local/bin/$(TARGET_EXEC)
	rm -rf /usr/local/lib/c2lib

-include $(DEPS)

MKDIR_P ?= mkdir -p
