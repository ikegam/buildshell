require 'FIAP.rb'
require 'pp'

class FIAPServiceSoap
  # SYNOPSIS
  #   query(parameters)
  #
  # ARGS
  #   parameters      QueryRQ - {http://soap.fiap.org/}queryRQ
  #
  # RETURNS
  #   parameters      QueryRS - {http://soap.fiap.org/}queryRS
  #
  def query(parameters)
    p [parameters]
    raise NotImplementedError.new
  end

  # SYNOPSIS
  #   data(parameters)
  #
  # ARGS
  #   parameters      DataRQ - {http://soap.fiap.org/}dataRQ
  #
  # RETURNS
  #   parameters      DataRS - {http://soap.fiap.org/}dataRS
  #
  def data(parameters)
    parameters.transport.body.point.each{|point|
      puts "#{point.value[0].xmlattr_time.to_s}\t#{point.xmlattr_id}\t#{point.value[0]}"
    }
    header=Header.new()
    header.oK = true
    body = Body.new()
    transport = Transport.new(header, body)
    datars = DataRS.new(transport)

    return datars
  end
end

