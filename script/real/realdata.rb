# encoding : utf-8

# cap = Staff.where( :nr=>"501640").first
cap = Staff.create( :nr=>"501640", :name=>"周金凤", :password=>"501640", :password_confirmation=>"501640" )

roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
roleCap.staffs << cap

unit = Workunit.create( :nr=>"MRA E-Class" )
cap.units << unit

grp = Group.new_squad( cap, "Default Group" )
grp.add_members( cap )

arr = [
["507065",  "宋金党"],
["511257",  "夏黎向"],
["511261",  "程小芹"],
["517352",  "王得印"],
["517353",  "谭军"],
["517510",  "刘娟"],
["517836",  "赵林林"],
["517838",  "刘兰"],
["518174",  "胡红芳"],
["518317",  "杜雪峰"],
["518557",  "秦丽丽"],
["518584",  "张磊"],
["518749",  "张党军"]
]

arr.each do |i,d|
  temp = Staff.create( :nr=>i, :name=>d, :password=>i, :password_confirmation=>i )
  grp.add_members( temp )
end
