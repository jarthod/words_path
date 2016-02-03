#!/usr/bin/env ruby

require "set"

from, to = ARGV
$words = Set.new(File.read_lines("/usr/share/dict/words").select {|w| w.size == from.size+1}.map(&.chomp).map(&.downcase))

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