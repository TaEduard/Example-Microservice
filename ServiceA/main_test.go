package main

import (
	"sync"
	"testing"
)

// TestCalculateAveragePrice tests the calculateAveragePrice function.
func TestCalculateAveragePrice(t *testing.T) {
	// Setup test cases
	tests := []struct {
		prices []float64 // input prices for testing
		want   float64   // expected average price
	}{
		{[]float64{1, 2, 3, 4, 5}, 3},         // simple sequential numbers
		{[]float64{10, 20, 30, 40, 50}, 30},   // larger numbers
		{[]float64{5}, 5},                     // single value
		{[]float64{}, 0},                      // empty slice
	}

	for _, tc := range tests {
		// Reset global variables before each test case
		prices = tc.prices
		pricesMutex = sync.Mutex{}

		got := calculateAveragePrice()
		if got != tc.want {
			t.Errorf("calculateAveragePrice() with prices %v = %v; want %v", tc.prices, got, tc.want)
		}
	}
}
