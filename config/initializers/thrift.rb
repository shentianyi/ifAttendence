require 'thrift/epm_service_types'
require 'thrift/epm_service_constants'
require 'thrift/datahouse'

# transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new('192.168.0.233', '9001'))
# protocol=::Thrift::BinaryProtocol.new(transport,false)

# $thrift = CZ::Epm::Thrift::Datahouse::Client.new(protocol)
# transport.open
# @options={:protocol => ::Thrift::BinaryProtocol, :transport => ::Thrift::FramedTransport,:retries => 5}
@options={:retries => 5}
$thrift=ThriftClient.new(CZ::Epm::Thrift::Datahouse::Client, "localhost:9001", @options)
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # transport.close
      # transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new('192.168.0.233', '9001'))
      # protocol=::Thrift::BinaryProtocol.new(transport,false)
      # $thrift = CZ::Epm::Thrift::Datahouse::Client.new(protocol)
      $thrift=ThriftClient.new(CZ::Epm::Thrift::Datahouse::Client, "localhost:9001", @options)
      # transport.open
    end
  end
end
class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
end
