#!/usr/bin/env ruby

require 'rubygems'
require 'color'
require 'irb/completion'
require 'irb/ext/save-history'
require 'hirb'
require 'what_methods'
require 'wirble'
require 'bond'
require 'interactive_editor'

Wirble.init
Wirble.colorize

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

begin
  require "ap"
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError => e
  puts "ap gem not found.  Try typing 'gem install awesome_print' to get super-fancy output."
end

# Prompt behavior
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

# http://blog.evanweaver.com/articles/2006/12/13/benchmark/
def benchmark(times = 1000, samples = 20)
  times *= samples
  cur = Time.now
  result = times.times { yield }
  print "#{cur = (Time.now - cur) / samples.to_f } seconds"
  puts " (#{(cur / $last_benchmark * 100).to_i - 100}% change)" rescue puts ""
  $last_benchmark = cur
  result
end

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']
