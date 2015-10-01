#!/usr/bin/env ruby

require "set"

from, to = ARGV
words = Set.new(File.read_lines("/usr/share/dict/words").map(&.chomp).select {|w| w.size == from.size}.map(&.downcase))

# (slower) iterate on words + measure & filter by changes
# $siblings = Hash(String, Array(String)).new do |h, k|
#   h[k] = words.select {|w| (k.bytes.zip(w.bytes).inject(0) {|c, chars| c += 1 if chars[0] != chars[1]; c } == 1) }
# end

# (faster) iterate on possible manipulation + test inclusing
$siblings = Hash(String, Array(String)).new do |h, k|
  h[k] = [] of String
  k.size.times do |i|
    ('a'..'z').each do |l|
      w = k[0...i] + l + k[(i+1)..-1]
      h[k] << w if w != k && words.includes?(w)
    end
  end
  h[k]
end

def bfs from, to
  dist = {from => 0}
  parent = {} of String => String
  queue = [from]

  while queue.size > 0
    n = queue.shift
    $siblings[n].each do |child|
      if dist[child]? == nil
        dist[child] = dist[n] + 1
        parent[child] = n
        queue.push(child)
      end
    end
    break if dist[to]? != nil
  end

  path = [to]
  while parent[to]?
    path.unshift(parent[to])
    to = parent[to]?
  end
  path
end

puts bfs(from, to).join(" -> ")