# encoding : utf-8
class Permission < ActiveRecord::Base
  attr_accessible :res, :ope, :desc
  
  has_many :role_permission_maps
  has_many :roles, :through=>:role_permission_maps
end
