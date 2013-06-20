require 'thrift/epm_service_types'
require 'thrift/epm_service_constants'
require 'thrift/datahouse'

if  ENV["USER"]=="ding"
  transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new('192.168.0.138', '9001'))
else
  transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new('192.168.0.21', '9001'))
end
protocol=::Thrift::BinaryProtocol.new(transport,false)
$thrift = CZ::Epm::Thrift::Datahouse::Client.new(protocol)
transport.open
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
     transport.close
     $thrift = CZ::Epm::Thrift::Datahouse::Client.new(protocol)
     transport.open  
   end
  end
end


class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
end
