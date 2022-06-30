// Collection types -> Arrays & Slices

package main

import (
	"fmt"
)

func main() {

	// ARRAYS //

	grades := [3]int{90, 100, 22}
	names := [3]string{"Pedro", "Jose", "Gui"}
	fmt.Println("Grades: %v || Names: %v", grades, names)

	// Note
	grades2 := [...]int{90, 100, 22}
	fmt.Println("Grades: %v", grades2)

	// Acess specific index (init with 0)
	var nums [4]int
	nums[0] = 1
	fmt.Println("Nums ->", nums)
	fmt.Println("Size of nums ->", len(nums))

	// Not pointers -> Copia integral
	a := [...]int{1, 2, 3}
	b := a
	b[1] = 5
	fmt.Println(a)
	fmt.Println(b)

	// With pointers -> Same copy
	a2 := [...]int{1, 2, 3}
	b2 := &a2
	b2[1] = 5
	fmt.Println(a2)
	fmt.Println(b2)

	// SLICES //

	a := []int{1, 2, 3}
	b := a
	b[1] = 5
	fmt.Println(a)
	fmt.Println(b)
	fmt.Println(cap(a))
	fmt.Println(len(a))

}
