// SPDX-FileCopyrightText: 2024 Kartoza <info@kartoza.com>
// SPDX-License-Identifier: MIT

// Package main is the entry point for LearningGo.
// This is your sandbox for learning Go - experiment freely!
package main

import (
	"fmt"
)

// Version is set during build using ldflags.
var Version = "dev"

func main() {
	fmt.Println("🐹 Welcome to LearningGo!")
	fmt.Printf("Version: %s\n\n", Version)

	// Start your Go learning journey here!
	// Try modifying this code and running: make run
	//
	// Quick tips:
	// - Variables: var name string = "Go"
	// - Short declaration: name := "Go"
	// - Functions: func add(a, b int) int { return a + b }
	// - Structs: type Person struct { Name string; Age int }
	// - Slices: numbers := []int{1, 2, 3}
	// - Maps: ages := map[string]int{"Alice": 30}
	// - Goroutines: go someFunction()
	// - Channels: ch := make(chan int)

	greeting := sayHello("Gopher")
	fmt.Println(greeting)

	// Example: Working with slices
	numbers := []int{1, 2, 3, 4, 5}
	fmt.Printf("Sum of %v = %d\n", numbers, sum(numbers))

	fmt.Println("\nMade with 💗 by Kartoza | https://kartoza.com")
}

// sayHello returns a greeting for the given name.
func sayHello(name string) string {
	return fmt.Sprintf("Hello, %s! Happy coding!", name)
}

// sum calculates the sum of a slice of integers.
func sum(numbers []int) int {
	total := 0
	for _, n := range numbers {
		total += n
	}
	return total
}
