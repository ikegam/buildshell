#!/usr/bin/ruby

require 'time'
require 'optparse'

class String
  def number?
    self =~ /\A-?\d+(.\d+)?\Z/
  end
end

STDOUT.sync = true
params = ARGV.getopts('f:')
params["f"] ||= "60"
frequency = params["f"].to_i

prev = nil

STDIN.each{|line|
  cols = line.chomp.split(/\t/)
  cols[0] = Time.parse(cols[0])
  if cols[2].number?
    cols[2] = cols[2].to_f
    if prev != nil
      missed = ((cols[0] - prev[0] - frequency) / frequency.to_f).to_i
      missed.times{|x|
        puts [(prev[0] + frequency * (x+1)).iso8601, cols[1], prev[2] + (cols[2] - prev[2])/missed.to_f * (x+1)].join("\t")
      }
    end
  else
    if prev != nil
      missed = ((cols[0] - prev[0] - frequency) / frequency.to_f).to_i
      missed.times{|x|
        puts [(prev[0] + frequency * (x+1)).iso8601, cols[1], x >= missed / 2 ? cols[2] : prev[2]].join("\t")
      }
    end
  end
  prev = cols.clone
  cols[0] = cols[0].iso8601
  puts cols.join("\t")
}
