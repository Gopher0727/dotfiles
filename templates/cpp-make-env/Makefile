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
TARGET ?= $(basename $(SRC))

.PHONY: all build run clean

all: build

build: $(TARGET)

$(TARGET): $(SRC)
ifeq ($(suffix $(SRC)),.c)
	$(CC) $(CFLAGS) -o $@ $<
else
	$(CXX) $(CXXFLAGS) -o $@ $<
endif

run: build
	@./$(TARGET)

clean:
	@rm -rf $(TARGET)