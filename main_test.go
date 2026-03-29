// SPDX-FileCopyrightText: 2024 Kartoza <info@kartoza.com>
// SPDX-License-Identifier: MIT

package main

import "testing"

func TestSayHello(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "greet gopher",
			input:    "Gopher",
			expected: "Hello, Gopher! Happy coding!",
		},
		{
			name:     "greet world",
			input:    "World",
			expected: "Hello, World! Happy coding!",
		},
		{
			name:     "greet empty",
			input:    "",
			expected: "Hello, ! Happy coding!",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := sayHello(tt.input)
			if result != tt.expected {
				t.Errorf("sayHello(%q) = %q; want %q", tt.input, result, tt.expected)
			}
		})
	}
}

func TestSum(t *testing.T) {
	tests := []struct {
		name     string
		input    []int
		expected int
	}{
		{
			name:     "positive numbers",
			input:    []int{1, 2, 3, 4, 5},
			expected: 15,
		},
		{
			name:     "empty slice",
			input:    []int{},
			expected: 0,
		},
		{
			name:     "single element",
			input:    []int{42},
			expected: 42,
		},
		{
			name:     "negative numbers",
			input:    []int{-1, -2, -3},
			expected: -6,
		},
		{
			name:     "mixed numbers",
			input:    []int{-5, 10, -3, 8},
			expected: 10,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := sum(tt.input)
			if result != tt.expected {
				t.Errorf("sum(%v) = %d; want %d", tt.input, result, tt.expected)
			}
		})
	}
}

// Benchmark for sum function.
func BenchmarkSum(b *testing.B) {
	numbers := make([]int, 1000)
	for i := range numbers {
		numbers[i] = i
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		sum(numbers)
	}
}
