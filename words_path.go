package main

import "log"
import "os"
import "fmt"
import "bufio"
import "strings"

func load_dict(path string, length int) map[string]bool {
  set := make(map[string]bool)
  file, err := os.Open(path)
  if err != nil {
    log.Fatal(err)
  }
  defer file.Close()

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    word := scanner.Text()
    if len(word) == length {
      set[strings.ToLower(word)] = true
    }
  }

  if err := scanner.Err(); err != nil {
    log.Fatal(err)
  }
  return set
}

func get_siblings(from string, words map[string]bool) []string {
  siblings := make([]string, 0)

  cache := []rune(from)
  for i := 0; i < len(from); i++ {
    prev := cache[i]
    for c := 'a'; c <= 'z'; c++ {
      cache[i] = c
      alter := string(cache)
      if (words[alter]) {
        siblings = append(siblings, alter)
        delete(words, alter)
      }
    }
    cache[i] = prev
  }
  return siblings
}

func bfs(from string, to string, words map[string]bool) []string {
  parent := make(map[string]string)
  queue := []string{from}

  for len(queue) > 0 {
    if _, visited := parent[to]; visited {
      break
    }
    node := queue[0]
    queue = queue[1:]
    for _, v := range get_siblings(node, words) {
      parent[v] = node
      queue = append(queue, v)
    }
  }

  path := []string{to}
  position := to
  for {
    path = append([]string{parent[position]}, path...)
    position = parent[position]
    if position == from { break }
  }
  return path
}

func main() {
  if len(os.Args) < 3 {
    log.Fatal("Usage: ./words_path_go jina pray")
  }
  from := os.Args[1]
  to := os.Args[2]
  fmt.Println("Finding path: ", from, " → ", to)
  words := load_dict("/usr/share/dict/words", len(from))
  fmt.Println(strings.Join(bfs(from, to, words), " -> "))
}