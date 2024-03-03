package main

import (
	"fmt"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
	"time"
	"github.com/tidwall/gjson"
)

// Global variables to store prices and mutex for safe access
var (
	prices      []float64
	pricesMutex sync.Mutex
)

func fetchCurrentBitcoinPrice() (float64, error) {
    resp, err := http.Get("https://api.coindesk.com/v1/bpi/currentprice/USD.json")
    if err != nil {
        return 0, err
    }
    defer resp.Body.Close()

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return 0, err
    }
	bodyString := string(body)

    // Convert the body to a string
	rateFloat := gjson.Get(bodyString, "bpi.USD.rate_float").Float()

    return rateFloat, nil
}

// updatePrices updates the global slice of prices with the latest price
func updatePrices() {
	for {
		price, err := fetchCurrentBitcoinPrice()
		if err != nil {
			log.Printf("Error fetching Bitcoin price: %v", err)
			continue
		}

		pricesMutex.Lock()
		prices = append(prices, price)
		// Keep only the last 60 prices (10 minutes at 10-second intervals)
		if len(prices) > 60 {
			prices = prices[1:]
		}
		pricesMutex.Unlock()

		time.Sleep(10 * time.Second)
	}
}

// calculateAveragePrice calculates the average price of Bitcoin over the last 10 minutes
func calculateAveragePrice() float64 {
	pricesMutex.Lock()
	defer pricesMutex.Unlock()

	var sum float64
	for _, price := range prices {
		sum += price
	}

	if len(prices) == 0 {
		return 0
	}

	return sum / float64(len(prices))
}

// startWebServer starts a simple web server that responds with the current and average Bitcoin price
func startWebServer() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		currentPrice, err := fetchCurrentBitcoinPrice()
		if err != nil {
			http.Error(w, "Failed to fetch current Bitcoin price", http.StatusInternalServerError)
			return
		}
		response := map[string]float64{
			"currentPrice": currentPrice,
		}

		responseJSON, err := json.Marshal(response)
		if err != nil {
			http.Error(w, "Failed to marshal response", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(responseJSON)
	})

	http.HandleFunc("/average", func(w http.ResponseWriter, r *http.Request) {
		averagePrice := calculateAveragePrice()

		response := map[string]float64{
			"currentPrice": averagePrice,
		}

		responseJSON, err := json.Marshal(response)
		if err != nil {
			http.Error(w, "Failed to marshal response", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(responseJSON)
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	fmt.Printf("Starting Service...")
	go updatePrices()
	startWebServer()
}
