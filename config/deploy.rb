set :application, "webEPM"
set :repository,  "set your repository location here"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "root@192.168.0.21"                          # This may be the same as your `Web` server
role :localtest, "localhost"
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
desc "Echo the server's hostname"
task :dp_pull, :roles => :app do
  # run "ls -x1 /usr/lib | grep -i xml"
  run "cd /webApps/webepm && git pull && nginx -s reload"
end

desc "Echo the server's hostname"
task :testuser, :roles => :localhost do
  if `hostname`.chomp=="General"
    # puts execv(" hostname ")
    puts "可以执行"
  else
    puts "Permission denied !"
  end
  
end