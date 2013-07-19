# encoding : utf-8
#
# 20130620
# 本脚本是为莱尼
#

perm=Permission.create({ res:"CreateCap", ope:"W", desc:"新建组长" }) unless perm=Permission.where(:res=>'CreateCap').first
puts perm.desc
if role = Role.find_by_nr("root")
  if role.permissions.find_by_id(perm)
    puts "permssion is in role : root"
  else
    role.permissions << perm 
    puts 'add to root success'
  end
end

# add admin to captain
if admin=Staff.find_by_nr('admin')
 unless admin.captain?
     puts "admin is not captain"
     admin.roles<< Role.find_by_nr("captain")
   else
     puts "admin is captain"
 end
end
