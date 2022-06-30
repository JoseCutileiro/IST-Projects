// Primitive types - Intro

package main

import "fmt"

func main() {

	// Boolean (true or false)
	var b bool = true
	var b1 bool = 1 == 2
	var b2 bool = 2 == 2
	fmt.Printf("Value: %v || Type: %T\n", b, b)
	fmt.Printf("Value: %v || Type: %T\n", b1, b1)
	fmt.Printf("Value: %v || Type: %T\n", b2, b2)

	// Numeric types

	// int, int8, int16, int32, int64
	// uint, uint8, uint16, uint32, uint64
	// uint8 == byte
	// float32, float64
	// complex64, complex128

	// Note: Operations
	// +,-,*,/,% (decimal)
	// SHR: >> and SHL: <<
	// & and
	// | or
	// ^ or exclusive
	// ^& contratrio de ou

	// Note: You can use exponencial notation on type float
	var f0 float32 = 3.14
	var f1 float32 = 13.7e10
	var f2 float32 = 2.1e19
	fmt.Printf("Value: %v || Type: %T\n", f0, f0)
	fmt.Printf("Value: %v || Type: %T\n", f1, f1)
	fmt.Printf("Value: %v || Type: %T\n", f2, f2)

	// Note: Work with complex numbers
	var c0 complex64 = 1 + 2i

	fmt.Printf("Value: %v || Type: %T\n", c0, c0)
	fmt.Printf("Value: %v || Type: %T\n", imag(c0), imag(c0))
	fmt.Printf("Value: %v || Type: %T\n", real(c0), real(c0))

	// Text types (strings and rune)

	// Strings

	s0 := "This is a string"
	s1 := "Strings are imutable"
	s2 := "CONCATENAÇÃO 1"
	s3 := "CONCATENAÇÃO 2"

	fmt.Printf("Value: %v || Type: %T\n", s0, s0)
	// s1[2] = "u" -> Error: strings are imutable

	fmt.Printf("Value: %v || Type: %T\n", s1[2], s1[2])
	fmt.Printf("%v + %v\n", s2, s3)

	// Convert string to byte stream
	s := "isto é uma frase :)"
	bt := []byte(s)
	fmt.Println(bt)

	// Note rune == int32 (check documentation)
	r0 := 'a'
	var r1 rune = 'a'

	fmt.Printf("Value: %v || Type: %T\n", r0, r0)
	fmt.Printf("Value: %v || Type: %T\n", r1, r1)

	// Final note: if you initialize any var, this var will start with a standard value 0
}
