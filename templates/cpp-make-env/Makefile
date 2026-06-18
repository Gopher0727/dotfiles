CXX      := g++
CXXFLAGS := -std=c++23 -Wall -Wextra -Iinclude -DLocal -O2
LDFLAGS  :=
CCACHE   := $(shell command -v ccache 2>/dev/null)

SRC      := main.cpp
OBJ      := $(SRC:.cpp=.o)
TARGET   := main

.PHONY: all build run clean

all: build

build: $(TARGET)

ifdef CCACHE
  CXX := $(CCACHE) $(CXX)
endif

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

run: build
	@./$(TARGET)

clean:
	@rm -rf $(OBJ) $(TARGET) compile_commands.json

# for clangd LSP
compile_commands.json: Makefile
	@printf '[\n' > $@
	@first=true; \
	for src in $(SRC); do \
		if $$first; then first=false; else printf ',\n' >> $@; fi; \
		printf '  {\n' >> $@; \
		printf '    "directory": "%s",\n' "$(CURDIR)" >> $@; \
		printf '    "command": "%s %s -c -o %s %s",\n' "$(CXX)" "$(CXXFLAGS)" "$${src%.cpp}.o" "$$src" >> $@; \
		printf '    "file": "%s"\n' "$$src" >> $@; \
		printf '  }' >> $@; \
	done; \
	printf '\n]\n' >> $@
