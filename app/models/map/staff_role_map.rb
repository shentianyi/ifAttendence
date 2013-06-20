# encoding : utf-8
class StaffRoleMap < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :staff
  belongs_to :role
end
