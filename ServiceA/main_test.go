package main

import (
	"sync"
	"encoding/json"
    "io/ioutil"
    "net/http"
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

// fetchPriceFromCryptoCompare fetches the current Bitcoin price from CryptoCompare
func fetchPriceFromCryptoCompare() (float64, error) {
    resp, err := http.Get("https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD")
    if err != nil {
        return 0, err
    }
    defer resp.Body.Close()

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return 0, err
    }

    var result map[string]float64
    if err := json.Unmarshal(body, &result); err != nil {
        return 0, err
    }

    return result["USD"], nil
}

// TestFetchCurrentBitcoinPrice compares the price fetched from your function with the price from CryptoCompare
func TestFetchCurrentBitcoinPrice(t *testing.T) {
    priceFromCoindesk, err := fetchCurrentBitcoinPrice()
    if err != nil {
        t.Fatalf("fetchCurrentBitcoinPrice failed: %v", err)
    }

    priceFromCryptoCompare, err := fetchPriceFromCryptoCompare()
    if err != nil {
        t.Fatalf("fetchPriceFromCryptoCompare failed: %v", err)
    }

    // Assuming a tolerance of $1000 is acceptable for the price difference
    tolerance := 1.0
    difference := priceFromCoindesk - priceFromCryptoCompare
    if difference < 0 {
        difference = -difference // Ensure the difference is positive
    }

    if difference > tolerance {
        t.Errorf("Price difference between Coindesk and CryptoCompare is too large: %f", difference)
    }
}
