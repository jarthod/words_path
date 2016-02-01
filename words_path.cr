#!/usr/bin/env ruby

require "set"

from, to = ARGV
$words = Set.new(File.read_lines("/usr/share/dict/words").select {|w| w.size == from.size+1}.map(&.chomp).map(&.downcase))

# (slower) iterate on words + measure & filter by changes
# $siblings = Hash(String, Array(String)).new do |h, k|
#   h[k] = words.select {|w| (k.bytes.zip(w.bytes).inject(0) {|c, chars| c += 1 if chars[0] != chars[1]; c } == 1) }
# end

# (faster) iterate on possible manipulation + test inclusing
def siblings(from)
  out = [] of String
  ptr = Pointer.malloc(from.size) { |i| from[i].ord.to_u8 }
  from.size.times do |i|
    prev = ptr[i]
    ('a'..'z').each do |l|
      ptr[i] = l.ord.to_u8
      w = String.new(ptr, from.size)
      if $words.includes?(w)
        out << w
        $words.delete(w)
      end
    end
    ptr[i] = prev
  end
  out
end

def bfs(from, to)
  parent = {} of String => String
  queue = [from]

  while !parent[to]? && (n = queue.shift)
    siblings(n).each do |child|
      parent[child] = n
      queue.push(child)
    end
  end

  path = [to]
  while parent[to]?
    path.unshift(parent[to])
    to = parent[to]?
  end
  path
end

puts bfs(from, to).join(" -> ")