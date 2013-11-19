#encoding: utf-8
require 'csv'

dir = Rails.root.join('script','data')

File.open(File.join(dir,'workunit_staff.csv'),'wb') do |f|
  f.puts "StaffNr;StaffName;WorunitNr;StaffCount"
  Workunit.all.each do |w|
    w.owners.each do |s|
      f.puts "#{s.nr};#{s.name};#{w.nr};#{s.allmems.count}"
    end
  end
end