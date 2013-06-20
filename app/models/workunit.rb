# encoding : utf-8
class Workunit < ActiveRecord::Base
  attr_accessible :nr, :state
  
  has_many :staffs
  has_many :staff_workunit_maps, :dependent=>:delete_all
  has_many :owners, :through=>:staff_workunit_maps, :source=>:staff
  
  validates :nr, :presence => true, :uniqueness => true
  
  def set_state( state, desc )
    desc ||= ""
    was = self.state
    return false if was==state
    self.update_attributes( :state=>state )
    LogWorkunit.log_change_state( self, was, self.state, desc )
    return true
  end
  
  
  class << self
    def add_staff( workunit, staff )
      raise( RuntimeError, I18n.t("errors.existStaffLog", place:staff.workunit.nr) ) if staff.state
      staff.update_attributes( :workunit_id=>workunit.id, :state=>true )
      LogStaff.log_change_state( staff, workunit, false, staff.state )
    end
    
    def delete_staff( workunit, staff )
      raise( RuntimeError, I18n.t("errors.nonStaffLog") ) unless staff.state
      raise( RuntimeError, I18n.t("errors.existStaffLogOther", place:staff.workunit.nr) ) unless staff.workunit_id==workunit.id
      staff.update_attributes( :workunit_id=>nil, :state=>false )
      LogStaff.log_change_state( staff, workunit, true, staff.state )
    end
  end
    
end
