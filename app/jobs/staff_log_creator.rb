#encoding: utf-8
class StaffLogCreator
  @queue='staff_log_creator_queue'
  def self.perform(staffNrs,workunit_nr,log_state,log_time)
    # puts '--------------'
    # puts staffNrs
    # puts workunit_nr
    # puts log_state
    # puts log_time
    # puts '--------------'
    lstate = (log_state=="true")
    staffNrs.each do |nr|
      begin
        # if (staff= Staff.find_by_nr(nr)) && staff.state!=lstate
          LogStaff.new(:staffNr=>nr,
          :workunitNr=>workunit_nr,
          :oldState=>!lstate,
          :newState=>lstate,
          :time=>log_time).save
        # end
      rescue Exception=>e
        puts e.message
        puts e.backtrace
      end
    end
  end
end
