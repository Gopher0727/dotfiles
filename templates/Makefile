.PHONY: build run test fmt tidy clean

build:
	@go build -o bin/ main.go

run: build
	@./bin/main

tidy:
	@go mod tidy

# Go files should be named with `_test.go` suffix and contain `Test` or 
# `Benchmark` functions to be recognized by `go test`.
test:
	@go test --bench=. -benchmem ./..

# If you use fish, you should install goimports-reviser with 
# `go install github.com/incu6us/goimports-reviser/v2@latest` 
# and add the `set -gx PATH $HOME/go/bin $PATH` to your `config.fish`:
fmt:
	@goimports-reviser -rm-unused -set-alias -format ./...

clean:
	@rm -rf bin/
	@rm -rf .cph/
