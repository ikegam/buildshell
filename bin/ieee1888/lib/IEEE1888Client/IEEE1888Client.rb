#!/usr/bin/ruby1.8
require 'FIAPDriver.rb'
require 'pp'

class IEEE1888Client

  def initialize(endpoint)
    @obj = FIAPServiceSoap.new(endpoint)
    @obj.wiredump_dev = STDERR if $DEBUG
  end

  def write(val, time, pointid)
    v = Value.new(val)
    v.xmlattr_time = time.iso8601
    p = Point.new([v])
    p.xmlattr_id = pointid
    self.write_query(p)
  end

  def get_recent_one(pointid)
    key = Key.new()
    key.xmlattr_id = pointid
    key.xmlattr_attrName = :time
    key.xmlattr_select = :maximum

    q = Query.new([key])
    q.xmlattr_type = :storage
    q.xmlattr_id = "%s%s%s%s%s%s%s%s-%s%s%s%s-%s%s%s%s-%s%s%s%s-%s%s%s%s%s%s%s%s%s%s%s%s" % ((0..31).to_a.map{|a|rand(16).to_s(16)})
    self.read_query(q)[0]
  end

  def get_time_series(pointid, from=nil, to=nil)
    key = Key.new()
    key.xmlattr_id = pointid
    key.xmlattr_attrName = :time

    if from != nil
      key.xmlattr_gteq = from
    end

    if to != nil
      key.xmlattr_lt = to
    end

    q = Query.new([key])
    q.xmlattr_type = :storage
    q.xmlattr_id = "%s%s%s%s%s%s%s%s-%s%s%s%s-%s%s%s%s-%s%s%s%s-%s%s%s%s%s%s%s%s%s%s%s%s" % ((0..31).to_a.map{|a|rand(16).to_s(16)})
    self.read_query(q)
  end


  def read_query(qs)
    cursor = nil
    values = []

    begin
      header = Header.new()
      body = Body.new()
      header.query = qs
      header.query.xmlattr_cursor = cursor
      header.query.xmlattr_acceptableSize = 2000
      transport = Transport.new(header, body)
      parameters = QueryRQ.new(transport)
      ret = @obj.query(parameters)
      check(ret)
      cursor=ret.transport.header.query.xmlattr_cursor
      if ret.transport.body.point[0].value == nil then
        next
      end
      values += ret.transport.body.point[0].value
    end while cursor != nil

    values

  end

  def write_query(point)
    header = Header.new()
    body = Body.new()
    body.point[0] = point
    transport = Transport.new(header, body)
    parameters = QueryRQ.new(transport)
    ret = @obj.data(parameters)
    check(ret)
    ret
  end

  def check(ret)

    if ret.transport == nil
      raise "The result does not contain a <transport>."
    end

    if ret.transport.header == nil
      raise "The result does not contain a header."
    end

    if ret.transport.header.oK == nil or ret.transport.header.error != nil
      raise "#{ret.transport.header.error}"
    end

    ret
  end

end


if $0 == __FILE__
  p "hoge"
end
