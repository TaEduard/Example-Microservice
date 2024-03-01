package main

import (
    "net/http"
    "log"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        // Check if the request method is GET
        if r.Method == http.MethodGet {
            w.WriteHeader(http.StatusOK) // Respond with 200 OK
            w.Write([]byte("Service B is running!")) // Optional: send a response body
        } else {
            // For non-GET requests, respond with 405 Method Not Allowed
            w.WriteHeader(http.StatusMethodNotAllowed)
            w.Write([]byte("Only GET requests are allowed"))
        }
    })

    log.Println("Service B is running on port 8081")
    // Listen on port 8081, or change the port as needed
    log.Fatal(http.ListenAndServe(":8081", nil))
}
