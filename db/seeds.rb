# encoding : utf-8

Permission.create([
  { res:"Role", ope:"W", desc:"新建或更改角色。" },
  { res:"Role", ope:"X", desc:"将角色赋予用户。" },
  { res:"Role", ope:"D", desc:"删除角色。" },
  { res:"Staff", ope:"W", desc:"新建或更改用户。" },
  { res:"Staff", ope:"D", desc:"删除用户。" },
  { res:"Workunit", ope:"W", desc:"新建或更改生产线。" },
  { res:"Workunit", ope:"X", desc:"控制生产线状态。" },
  { res:"Workunit", ope:"D", desc:"删除生产线。" },
  { res:"Group", ope:"W", desc:"新建或更改工作组。" },
  { res:"Group", ope:"X", desc:"读取或控制工作组。" },
  { res:"Group", ope:"D", desc:"删除工作组。" },
  { res:"LogStaff", ope:"X", desc:"查询员工出勤记录。" },
  { res:"LogWorkunit", ope:"X", desc:"查询生产线记录。" }
  # { res:"", ope:"", desc:"" },
  
])
puts "-"*20

role = Role.create( :nr=>"root", :name=>"root" )
puts "-"*20
role.permissions << Permission.all
puts "-"*20

roleCap = Role.create( :nr=>"captain", :name=>"captain" )
roleCap.permissions << Permission.where( :res=>"Group" )
roleCap.permissions << Permission.where( res:"Workunit")
roleCap.permissions << Permission.where( res:"Staff")

roleVCap = Role.create( :nr=>"vice_captain", :name=>"vice_captain" )
roleVCap.permissions << Permission.where( :res=>"Group" )

creator = Staff.create( :nr=>"admin", :name=>"admin", :password=>"admin", :password_confirmation=>"admin" )
puts "-"*20

role.staffs << creator


WorkunitState.create([
  { state:"开始" },
  { state:"停止" }
  # { state:"stop" },
  # { state:"abnormal" }
])
