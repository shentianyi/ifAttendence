require 'resque/tasks'

task "resque:setup" => :environment  do
  ENV['QUEUE']='*'
  ENV['COUNT']='5'
  ENV['BACKGROUND']='yes' if ENV["USER"]=='server'
  # puts ENV["USER"].class
  ENV['PIDFILE']="tmp/pids/resque.pid"
end

