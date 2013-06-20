# encoding : utf-8

ding = Staff.create( :nr=>"ding", :name=>"丁浦航", :password=>"ding", :password_confirmation=>"ding" )
role1 = Role.create( nr:"one", name:"111" )
role1.staffs << ding
roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
roleCap.staffs << ding

wang = Staff.create( :nr=>"wang", :name=>"王子骁", :password=>"wang", :password_confirmation=>"wang" )
role2 = Role.create( nr:"two", name:"222" )
role2.staffs << wang

unit1 = Workunit.create( :nr=>"Workunit 1" )
unit2 = Workunit.create( :nr=>"Workunit 2" )
unit3 = Workunit.create( :nr=>"Workunit 3" )
unit4 = Workunit.create( :nr=>"Workunit 4" )
unit5 = Workunit.create( :nr=>"Workunit 5" )

ding.units << [unit1, unit2, unit3]
wang.units << [unit4, unit5, unit3]

grp1 = Group.new_squad( ding, "ding's Group" )

(1..3).each do |i|
  i=i.to_s
  temp = Staff.create( :nr=>i, :name=>i, :password=>i, :password_confirmation=>i )
  grp1.add_members( temp )
end

grp2 = Group.new_squad( wang, "wang's Group" )

(4..9).each do |i|
  i=i.to_s
  temp = Staff.create( :nr=>i, :name=>i, :password=>i, :password_confirmation=>i )
  grp2.add_members( temp )
end
