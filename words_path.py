#!/usr/bin/env python3

import sys
import time
from string import ascii_lowercase
from collections import deque

if len(sys.argv) <3 :
  print('you loose')
else:
  fromage = sys.argv[1]
  to = sys.argv[2]

print("words path:", fromage, "->", to)
a = time.time()

words = set()
with open('/usr/share/dict/words', "r") as dictionary:
  for line in dictionary:
    if len(line) == len(fromage)+1:
      words.add(line.rstrip().lower())

def siblings (fromage):
  out = []
  for i in range(0, len(fromage)):
    w = list(fromage)
    for l in ascii_lowercase:
      w[i] = l
      str = "".join(w)
      if str in words:
        out.append(str)
        words.remove(str)
  return(out)

def bfs (fromage, to):
  parent = {}
  queue = deque([fromage])

  while to not in parent and len(queue) > 0:
    n = queue.popleft()
    for child in siblings(n):
      parent[child] = n
      queue.append(child)

  path = [to]
  while to in parent:
    path = [parent[to]] + path
    to = parent[to]
  return(path)

b = time.time()
print(" -> ".join(bfs(fromage, to)))
print("load:", (b - a), "search:", (time.time() - b))