package main

import (
	"bufio"
	"fmt"
	"os"
)

var (
	in  = bufio.NewReader(os.Stdin)
	out = bufio.NewWriter(os.Stdout)
)

func solve() {
	fmt.Fprintln(out, "Hello")
}

func main() {
	defer out.Flush()

	solve()
}
