# encoding : utf-8
class Workunit < ActiveRecord::Base
  attr_accessible :nr, :state

  has_many :staffs
  has_many :staff_workunit_maps, :dependent=>:destroy
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

    # for batch
    def add_delete_staffs(workunit_id,workunit_nr,staffNrs,log_state)
      Staff.where(:nr=>staffNrs,:state=>!log_state).update_all(:state=>log_state,:workunit_id=> (log_state ? workunit_id : nil))
      Resque.enqueue(StaffAttendDataThriftSender,workunit_nr,Time.now.to_ms.to_s,log_state.to_s,staffNrs)
      Resque.enqueue(StaffLogCreator,staffNrs,workunit_nr,log_state.to_s,Time.now.to_i.to_s)
    end

    # def delete_staffs(workunit_id,workunit_nr,staffNrs)
      # Resque.enqueue(StaffAttendDataThriftSender,workunit_nr,Time.now.to_ms,"-1",staffNrs)
      # Resque.enqueue(StaffLogCreator,staffNrs,workunit_id,false,Time.now.to_i)
      # Staff.where(:nr=>staffNrs,:state=>true).update_all(:state=>false,:workunit_id=>workunit_id)
    # end
  end

end
