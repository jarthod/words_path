#!/usr/bin/env ruby

require 'set'

from, to = ARGV
words = Set.new(File.readlines('/usr/share/dict/words').map(&:chomp).select {|w| w.length == from.length}.map(&:downcase))

# (slower) iterate on words + measure & filter by changes
# $siblings = Hash.new do |h, k|
#   h[k] = words.select {|w| (k.bytes.zip(w.bytes).inject(0) {|c, (c1, c2)| c += 1 if c1 != c2; c } == 1) }
# end

# (faster) iterate on possible manipulation + test inclusing
$siblings = Hash.new do |h, k|
  h[k] = []
  k.length.times do |i|
    w = k.dup
    ('a'..'z').each do |l|
      w[i] = l
      h[k] << w.dup if w != k and words.include?(w)
    end
  end
  h[k]
end

def bfs from, to
  dist = {from => 0}
  parent = {}
  queue = [from]

  while queue.size > 0
    n = queue.shift
    $siblings[n].each do |child|
      if dist[child].nil?
        dist[child] = dist[n] + 1
        parent[child] = n
        queue.push(child)
      end
    end
    break if dist[to] != nil
  end

  path = [to]
  while parent[to]
    path.unshift(parent[to])
    to = parent[to]
  end
  path
end

puts bfs(from, to).join(' -> ')