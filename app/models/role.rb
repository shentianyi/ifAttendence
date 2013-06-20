# encoding : utf-8
class Role < ActiveRecord::Base
  attr_accessible :nr, :name
  
  has_many :staff_role_maps
  has_many :staffs, :through=>:staff_role_maps
  has_many :role_permission_maps
  has_many :permissions, :through=>:role_permission_maps
  
  validates :nr, :presence => true, :uniqueness => true
  
  def save
    self.nr ||= UUID.generate
    super
  end
  
  class << self
    # def new_role( captain, name )
      # group = captain.squads.build( :nr=>UUID.generate, :name=>name )
      # group.save ? group : nil
    # end
    
    def privileges_check( staff, resource, operate )
      staff.roles.each do |r|
        return true if r.permissions.where( :res=>resource, :ope=>operate ).first
      end
      if perm = Permission.where( :res=>resource, :ope=>operate ).first
        raise( RuntimeError, "无法#{perm.desc} 权限不足。" )
      else
        raise( RuntimeError, "无效操作。" )
      end
    end
  end
  
end
