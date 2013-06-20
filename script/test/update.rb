# encoding : utf-8

role1 = Role.where( :nr=>"one" ).first
role2 = Role.where( :nr=>"two" ).first

ding = Staff.where( :nr=>"ding" ).first
wang = Staff.where( :nr=>"wang" ).first

perm = Permission.find 7

############################################

# role1.permissions << perm
WorkunitState.all.each do |w|
  w.destroy
end
WorkunitState.create([
  { state:"开始" },
  { state:"停止" }
  # { state:"stop" },
  # { state:"abnormal" }
])

