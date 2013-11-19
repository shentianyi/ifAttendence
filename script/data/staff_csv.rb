#encoding: utf-8
require 'csv'

dir = Rails.root.join('script','data')

File.open(File.join(dir,'staff.csv'),'wb') do |f|
  f.puts "StaffNr;Name;Title;Email;Contact;DOUPDATE"
  Staff.all.each do |s|
    puts s.nr
    f.puts [s.nr,s.name,"","","",0].join(';')
  end
end