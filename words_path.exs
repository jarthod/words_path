#!/usr/bin/env elixir

[from, to] = System.argv |> Enum.map(fn(word) -> String.to_char_list(word) end)
IO.puts WordsPath.bfs(from, to) |> Enum.join(" -> ")