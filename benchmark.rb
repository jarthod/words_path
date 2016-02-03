#!/usr/bin/env ruby

# gem install benchmark-ips
require 'benchmark/ips'

RUN = 1

Benchmark.ips do |x|
  x.config(time: 5, warmup: 1)

  x.report("rust") { `./words_path_rs jina pray` }
  x.report("crystal")  { `./words_path_crystal jina pray` }
  x.report("go")  { `./words_path_go jina pray` }
  x.report("c++")  { `./words_path_c++ jina pray` }
  x.report("ruby")  { `./words_path.rb jina pray` }
  x.report("elixir")  { `elixir ./words_path.exs jina pray` }
  x.report("mruby")  { `./words_path_mrb` }

  x.compare!
end