# encoding : utf-8
class StaffWorkunitMap < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :staff
  belongs_to :workunit
end
