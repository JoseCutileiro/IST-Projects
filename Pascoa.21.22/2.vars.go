// About variables using go -> Level 1

package main

import (
	"fmt"
	"strconv"
)

// Global Vars
var v0 string = "This is a global var"

// Global Var blocks
var (
	v1 string = "This is a global var declared inside a block"
	v2 int    = 69
	v3 string = "You can use this vars where ever you want"
)

func main() {

	// Declare and then assign
	var i1 int
	i1 = 10
	fmt.Printf("Value: %v || Type: %T\n", i1, i1)

	// Assign while declaring
	var i2 int = 20
	fmt.Printf("Value: %v || Type: %T\n", i2, i2)

	// Infered type
	i3 := 30
	fmt.Printf("Value: %v || Type: %T\n", i3, i3)

	// Use global vars
	fmt.Println(v0)
	fmt.Println(v1)

	// Casting
	var i int = 42
	var j float32
	j = float32(i)
	fmt.Printf("Value: %v || Type: %T\n", j, j)

	// Strconv example
	var thisIsAString string
	thisIsAString = strconv.Itoa(i)
	fmt.Printf("Value: %v || Type: %T", thisIsAString, thisIsAString)

}
