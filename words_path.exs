#!/usr/bin/env elixir

# defmodule DictServer do
#   use GenServer

#   def handle_call({:siblings, from}, _, words) do
#     res = for i <- 0..length(from)-1, c <- ?a..?z do
#       List.replace_at from, i, c
#     end |> Enum.filter(&MapSet.member?(words, &1))
#     {:reply, res, words}
#   end
# end

# defmodule DictServerPool do
#   use GenServer

#   def start(from) do
#     GenServer.start(__MODULE__, from, name: :dict_server_pool)
#   end

#   def siblings(from) do
#     choose_worker(from) |> GenServer.call({:siblings, from})
#   end

#   def init(from) do
#     {:ok, start_workers(load_dict(from))}
#   end


#   defp load_dict(from) do
#     size = length(from)
#     File.read!("/usr/share/dict/words")
#     |> String.splitter("\n", trim: true)
#     |> Stream.filter(&byte_size(&1) == size)
#     |> Stream.map(&String.to_char_list(String.downcase(&1)))
#     |> Enum.into(MapSet.new)
#   end

#   defp start_workers(words) do
#     for index <- 1..5, into: %{} do
#       {:ok, pid} = DistServer.start(words)
#       {index - 1, pid}
#     end
#   end
# end

defmodule Parallel do
  def map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def flat_map(collection, func) do
    map(collection, func) |> List.flatten
  end
end

defmodule WordsPath do

  def get_words from do
    size = length(from)
    File.read!("/usr/share/dict/words")
    |> String.splitter("\n", trim: true)
    |> Stream.filter(&byte_size(&1) == size)
    |> Stream.map(&String.to_char_list(String.downcase(&1)))
    |> Enum.into(MapSet.new)
  end

  def get_siblings from, words do
    for i <- 0..length(from)-1, c <- ?a..?z do
      # <<left :: binary - size(i), _, right :: binary>> = from
      # left <> <<c>> <> right
      List.replace_at from, i, c
    end
    |> Enum.filter(&MapSet.member?(words, &1))
  end

  def get_path froms, to, words, visited do
    if MapSet.member?(froms, to) do
      [to]
    else
      v = MapSet.union(visited, froms)
      origins = Map.new(for from <- froms, n <- get_siblings(from, words), !MapSet.member?(visited, n) do
        {n, from}
      end)
      # origins = Enum.flat_map(froms, fn(from) ->
      #   get_siblings(from, words)
      #   |> Enum.filter(&!MapSet.member?(visited, &1))
      #   |> Enum.map(&{&1, from})
      # end) |> Map.new
      edge = Map.keys(origins) |> Enum.into(MapSet.new)
      [next | path] = get_path(edge, to, words, v)
      [origins[next] | [next | path]]
    end
  end

  def bfs from, to do
    {time, words} = :timer.tc(fn -> WordsPath.get_words(from) end)
    # {:ok, pid} = GenServer.start_link(DictServer, words)
    IO.puts "load time: #{time / 1000}ms"
    {time, path} = :timer.tc(fn ->
      # IO.inspect(get_siblings(from, words))
      # IO.inspect(GenServer.call(pid, {:siblings, from}))
      get_path(Enum.into([from], MapSet.new), to, words, MapSet.new)
    end)
    IO.puts "BFS time: #{time / 1000}ms"
    path
  end

end

[from, to] = System.argv |> Enum.map(fn(word) -> String.to_char_list(word) end)
IO.puts WordsPath.bfs(from, to) |> Enum.join(" -> ")