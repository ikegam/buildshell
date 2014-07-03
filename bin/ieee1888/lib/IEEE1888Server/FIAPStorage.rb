#!/usr/bin/env ruby
require 'FIAPServant.rb'
require 'FIAPMappingRegistry.rb'
require 'soap/rpc/standaloneServer'

class FIAPServiceSoap
  Methods = [
    [ "http://soap.fiap.org/query",
      "query",
      [ [:in, "parameters", ["::SOAP::SOAPElement", "http://soap.fiap.org/", "queryRQ"]],
        [:out, "parameters", ["::SOAP::SOAPElement", "http://soap.fiap.org/", "queryRS"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ],
    [ "http://soap.fiap.org/data",
      "data",
      [ [:in, "parameters", ["::SOAP::SOAPElement", "http://soap.fiap.org/", "dataRQ"]],
        [:out, "parameters", ["::SOAP::SOAPElement", "http://soap.fiap.org/", "dataRS"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ]
  ]
end

class FIAPServiceSoapApp < ::SOAP::RPC::StandaloneServer
  def initialize(*arg)
    super(*arg)
    servant = FIAPServiceSoap.new
    FIAPServiceSoap::Methods.each do |definitions|
      opt = definitions.last
      if opt[:request_style] == :document
        @router.add_document_operation(servant, *definitions)
      else
        @router.add_rpc_operation(servant, *definitions)
      end
    end
    self.mapping_registry = DefaultMappingRegistry::EncodedRegistry
    self.literal_mapping_registry = DefaultMappingRegistry::LiteralRegistry
  end
end

if $0 == __FILE__
  # Change listen port.
  server = FIAPServiceSoapApp.new('app', nil, '0.0.0.0', 10080)
  trap(:INT) do
    server.shutdown
  end
  server.start
end
