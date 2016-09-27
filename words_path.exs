#!/usr/bin/env elixir

defmodule WordsPath do

  def get_words from do
    size = length(from)
    File.read!("/usr/share/dict/words")
    |> String.splitter("\n", trim: true)
    |> Stream.filter(&byte_size(&1) == size)
    |> Stream.map(&String.to_char_list(String.downcase(&1)))
    |> Enum.into(HashSet.new)
  end

  def get_siblings from, words do
    for i <- 0..length(from)-1, c <- ?a..?z do
      # <<left :: binary - size(i), _, right :: binary>> = from
      # left <> <<c>> <> right
      List.replace_at from, i, c
    end
    |> Enum.filter(&Set.member?(words, &1))
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