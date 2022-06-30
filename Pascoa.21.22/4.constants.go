// Constants in a nutshell - Typed, untyped, enumerated constants, enumeration expressions

package main

import "fmt"

// Enumerated consts

const (
	a = iota // 0
	b        // 1
	c        // 2
)

const (
	a2 = iota // 0
	b2 = iota // 1
	c2 = iota // 2
)

const (
	_ = iota // '_' -> Write only const
	a3
	b3
	c3
)

const (
	a4 = iota + 4 // 4
	b4            // 5
	c4            // 6
)

const (
	_  = iota
	KB = 1 << (10 * iota)
	MB
	GB
	TB
)

func main() {

	// To declare consts in other langs, we usally use upper case like this
	const CONST int = 1

	// However in go, upper case on the first letter means export the variable, and we dont want that
	const MyConst int = 10 // Exportation
	const myConst int = 11 // No exportation

	// You cannot change the value of a const -> compile error
	// You need to set your const before compile the program
	// const c1 int = func(2) -> compile error

	// You can shadow a const :) {local > global}

	fmt.Println(a, b, c, a2)
}
