#!/usr/bin/env ruby

require 'set'

from, to = ARGV
$words = Set.new(File.readlines('/usr/share/dict/words').select {|w| w.length == from.length+1}.map(&:chomp).map(&:downcase))

# (slower) iterate on $words + measure & filter by changes
# $siblings = Hash.new do |h, k|
#   h[k] = $words.select {|w| (k.bytes.zip(w.bytes).inject(0) {|c, (c1, c2)| c += 1 if c1 != c2; c } == 1) }
# end

# (faster) iterate on possible manipulation + test inclusing
def siblings from
  Enumerator.new do |enum|
    from.length.times do |i|
      w = from.dup
      ('a'..'z').each do |l|
        w[i] = l
        enum.yield w.dup if $words.delete?(w)
      end
    end
  end
end

def bfs from, to
  parent = {}
  queue = [from]

  while !parent[to] and n = queue.shift
    siblings(n).each do |child|
      parent[child] = n
      queue.push(child)
    end
  end

  path = [to]
  while parent[to]
    path.unshift(parent[to])
    to = parent[to]
  end
  path
end

puts bfs(from, to).join(' -> ')