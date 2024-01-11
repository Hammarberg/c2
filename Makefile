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

ifndef C2_PLATFORM
	ifneq ($(ProgramFiles),)
		C2_PLATFORM := Windows
	else ifeq ($(OS),Cygwin)
		C2_PLATFORM := Cygwin
	else
		C2_PLATFORM := Unix
	endif
endif

# Fix some special cases.
ifeq ($(C2_PLATFORM),Unix)
	LDLIBS := $(LDLIBS) -ldl
else ifeq ($(C2_PLATFORM),Windows)
	TARGET_EXEC := $(TARGET_EXEC).exe
endif

# Prefer clang++ if available, but not on Cygwin
ifeq ($(C2_PLATFORM),Cygwin)
else
	ifneq ($(shell which clang++),)
		CXX := clang++
	endif
endif

# Set flags depending on compiler
ifeq ($(strip $(CXX)),g++)
CXXFLAGS := $(CXXFLAGS) -std=gnu++17
else
CXXFLAGS := $(CXXFLAGS) -std=c++17
endif

$(TARGET_EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

debug:
	@echo OS=$(OS)
	@echo TARGET_EXEC=$(TARGET_EXEC)
	@echo C2_PLATFORM=$(C2_PLATFORM)
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
