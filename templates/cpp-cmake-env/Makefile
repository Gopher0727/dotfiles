.PHONY: all build run clean

all: build

build:
	cmake -B build -S .
	ln -sf build/compile_commands.json .
	cmake --build build

run:
	@./build/main

clean:
	rm -rf build compile_commands.json
