#!/usr/bin/env ruby
require 'FIAPDriver.rb'

endpoint_url = ARGV.shift
obj = FIAPServiceSoap.new(endpoint_url)

# run ruby with -d to see SOAP wiredumps.
obj.wiredump_dev = STDERR if $DEBUG

# SYNOPSIS
#   query(parameters)
#
# ARGS
#   parameters      QueryRQ - {http://soap.fiap.org/}queryRQ
#
# RETURNS
#   parameters      QueryRS - {http://soap.fiap.org/}queryRS
#
parameters = nil
puts obj.query(parameters)

# SYNOPSIS
#   data(parameters)
#
# ARGS
#   parameters      DataRQ - {http://soap.fiap.org/}dataRQ
#
# RETURNS
#   parameters      DataRS - {http://soap.fiap.org/}dataRS
#
parameters = nil
puts obj.data(parameters)


