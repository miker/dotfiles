#!/usr/bin/env ruby
%w{rubygems irb/completion irb/ext/save-history wirble open-uri color etc extensions/all hpricot what_methods find}.each { |lib| require lib }

Wirble.init
Wirble.colorize

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']
