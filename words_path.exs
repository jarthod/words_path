#!/usr/bin/env elixir


[from, to] = System.argv |> Enum.map(fn(word) -> String.to_char_list(word) end)

words = File.stream!("/usr/share/dict/words") |> Stream.filter(fn(word) -> String.length(word) == length(from)+1 end) |> Stream.map(fn(word) -> word |> String.rstrip(?\n) |> String.downcase |> String.to_char_list end) |> Enum.into(HashSet.new)

get_siblings = fn(from, words) ->
  for i <- 0..length(from)-1, c <- ?a..?z do
    List.replace_at from, i, c
  end |> Enum.filter(fn(word) -> Set.member?(words, word) end)
end

IO.puts get_siblings.(from, words)

get_path = fn(froms, to, words, visited) ->
  v = froms ++ visited
  siblings = for from <- froms do
    {from, Enum.filter(get_siblings.(from, words), fn(n) ->
      !Enum.member?(visited, n)
    end)}
  end
  edge = for {from, sibling} <- siblings do sibling end
  IO.inspect edge
  # [next | path] = get_path.(edge, to, words, v)
end

bfs = fn(from, to, words) ->

  get_path.([from], to, words, [])
#   dist = {from => 0}
#   parent = {}
#   queue = [from]

#   while queue.size > 0
#     n = queue.shift
#     $siblings[n].each do |child|
#       if dist[child].nil?
#         dist[child] = dist[n] + 1
#         parent[child] = n
#         queue.push(child)
#       end
#     end
#     break if dist[to] != nil
#   end

#   path = [to]
#   while parent[to]
#     path.unshift(parent[to])
#     to = parent[to]
#   end
#   path
  ["1", "2", "3"]
end

IO.puts bfs.(from, to, words) |> Enum.join(" -> ")