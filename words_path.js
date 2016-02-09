#!/usr/bin/env node

var from = process.argv[2]
var to = process.argv[3]
var words = new Set()

require('readline').createInterface({
  input: require('fs').createReadStream('/usr/share/dict/words')
}).on('line', (line) => {
  if (line.length == from.length) {
    words.add(line.trim().toLowerCase())
  }
}).on('close', () => {
  console.log(bfs(from, to).join(' → '))
});

function siblings(from) {
  var out = []
  var str = from.split('');
  for (var i = 0; i < str.length; i++) {
    var prev = str[i]
    for (var c = 'a'.charCodeAt(0); c <= 'z'.charCodeAt(0); c++) {
      str[i] = String.fromCharCode(c)
      w = str.join('')
      if (words.delete(w)) {
        out.push(w)
      }
    }
    str[i] = prev
  }
  return out;
}

function bfs(from, to) {
  var parent = new Map()
  var queue = [from]

  while (!parent.has(to) && queue.length > 0) {
    var n = queue.shift()
    for (var child of siblings(n)) {
      parent.set(child, n)
      queue.push(child)
    }
  }

  var path = [to]
  while (parent.has(to)) {
    path.unshift(parent.get(to))
    to = parent.get(to)
  }
  return path
}
