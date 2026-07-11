CC       := gcc
CFLAGS   := -std=c23 -Wall -Wextra -Iinclude -DLocal -O2

CXX      := g++
CXXFLAGS := -std=c++23 -Wall -Wextra -Iinclude -DLocal -O2

CCACHE := $(shell command -v ccache 2>/dev/null)
ifdef CCACHE
  CC  := $(CCACHE) $(CC)
  CXX := $(CCACHE) $(CXX)
endif

SRC    ?= main.cpp
TARGET ?= bin/$(basename $(SRC))

.PHONY: all build run clean compile_json

all: build

build: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p $(dir $@)
ifeq ($(suffix $(SRC)),.c)
	@$(CC) $(CFLAGS) -o $@ $<
else
	@$(CXX) $(CXXFLAGS) -o $@ $<
endif

run: build
	@./$(TARGET)

clean:
	@rm -rf $(TARGET)

# Requires `bear` to be installed first, then run `make compile_json`.
compile_json:
	@bear -- make
