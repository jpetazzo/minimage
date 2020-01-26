package main

import "io/ioutil"
import "log"
import "net/http"
import "os"

func main () {
  resp, err := http.Get("https://canihazip.com/s")
  if err != nil {
    log.Fatal(err)
  }
  body, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    log.Fatal(err)
  }
  os.Stdout.Write(body)
  os.Stdout.Write([]byte{'\n'})
}
