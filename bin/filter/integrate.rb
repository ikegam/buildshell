#!/usr/bin/ruby

require 'time'
require 'optparse'

class String
  def number?
    self =~ /\A-?\d+(.\d+)?\Z/
  end
end

STDOUT.sync = true
params = ARGV.getopts('f:p:')
params["f"] ||= "3600"
params["p"] ||= "http://example.org/integrated"
frequency = params["f"].to_i

buf = []

STDIN.each{|line|
  cols = line.chomp.split(/\t/)
  cols[0] = Time.parse(cols[0])
  if cols[2].number?
    cols[2] = cols[2].to_f
    if buf[0] != nil
      if (cols[0] - buf[0][0] >= frequency)
        puts "#{cols[0].iso8601}\t#{params["p"]}\t#{buf.inject(0){|s, x| s+=x[2]}}"
        buf = []
      end
    end
    buf.push(cols)
  else
    STDERR.puts("Impossible to integrate")
    exit -1;
  end
}
