#!/usr/bin/env elixir

defmodule WordsPath do

  def get_words from do
    size = length(from)+1
    File.stream!("/usr/share/dict/words") |> Stream.filter(fn(word) -> byte_size(word) == size end) |> Stream.map(fn(word) -> word |> String.rstrip(?\n) |> String.downcase |> String.to_char_list end) |> Enum.into(HashSet.new)
  end

  def get_siblings from, words do
    for i <- 0..length(from)-1, c <- ?a..?z do
      # <<left :: binary - size(i), _, right :: binary>> = from
      # left <> <<c>> <> right
      List.replace_at from, i, c
    end |> Enum.filter(fn(word) -> Set.member?(words, word) end)
  end


  def get_path froms, to, words, visited do
    if Set.member?(froms, to) do
      [to]
    else
      v = Set.union(visited, froms)
      origins = Map.new(for from <- froms, n <- get_siblings(from, words), !Set.member?(visited, n) do
        {n, from}
      end)
    edge = Map.keys(origins) |> Enum.into(HashSet.new)
      [next | path] = get_path(edge, to, words, v)
      [origins[next] | [next | path]]
    end
  end

  def bfs from, to do
    {time, words} = :timer.tc(fn -> WordsPath.get_words(from) end)
    IO.puts "load time: #{time / 1000}ms"
    {time, path} = :timer.tc(fn ->
      # IO.inspect(get_siblings(from, words))
      get_path(Enum.into([from], HashSet.new), to, words, HashSet.new)
    end)
    IO.puts "BFS time: #{time / 1000}ms"
    path
  end

end

[from, to] = System.argv |> Enum.map(fn(word) -> String.to_char_list(word) end)
IO.puts WordsPath.bfs(from, to) |> Enum.join(" -> ")