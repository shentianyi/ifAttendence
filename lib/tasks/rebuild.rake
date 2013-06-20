namespace :db do
  
  desc "Rebuild from db"
  task :rebuild => :environment do
    ActiveRecord::Base.establish_connection('development')
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
    system("rake db:seed RAILS_ENV=development")
    # system("rails runner script/test/testdata.rb")
    system("rails runner script/real/realdata.rb")
  end
  
end