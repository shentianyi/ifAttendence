# encoding : utf-8
class LogWorkunit < ActiveRecord::Base
  attr_accessible :workunitNr, :oldState, :newState, :desc, :time
  
  def time_str
    Time.at(self.time)
  end
  
  class << self
    
    def log_change_state( workunit, oldState, newState, desc )
      log = self.new( :workunitNr=>workunit.nr, :oldState=>oldState, :newState=>newState, :desc=>desc, :time=>Time.now.to_i )
      log.save
      begin
       # $thrift.addOperatingState($thrift_access_key,{"entityId"=>workunit.nr,"operateTime"=>(Time.now.to_ms).to_s,"state"=>newState})
      rescue Exception=>e
        system( "cd #{Rails.root}/log && echo Thrift_time: $(date) >> webEpm_error.log && echo '"+e.to_s+"' >> webEpm_error.log" )
        # raise I18n.t("errors.wrService")
      end
    end
    
    def log_zusammen_range_by_state( workunit, sTime, eTime, state )
      raw = LogWorkunit.where("time >= :stime AND time <= :etime AND workunitNr=:workunitNr AND (oldState=:state OR newState=:state)",
                                          :stime=>sTime, :etime=>eTime, :workunitNr=>workunit.nr, :state=>state ).order("time ASC")
      if raw.size == 0
        beforeRaw = LogWorkunit.where("time >= :stime AND time <= :etime AND workunitNr=:workunitNr AND (oldState=:state OR newState=:state)",
                                          :stime=>0, :etime=>sTime, :workunitNr=>workunit.nr, :state=>state ).order("time ASC")
        return 0 if beforeRaw.size == 0
        record = [sTime, eTime] if state == beforeRaw.last.newState
        return 0
      else
        record = raw.map {|r| r.time}
        record.insert( 0, sTime ) if state == raw.first.oldState
        record.push(eTime) unless record.size%2==0
      end
      sum = 0
      hash = Hash[*record]
      staffs = LogStaff.where(:workunitNr=>workunit.nr ).select(:staffNr).uniq
      staffs.each do |staff|
        hash.each do |k,v|
          sum += LogStaff.log_zusammen_range( staff.staffNr, k.to_i, v.to_i, workunit )
        end
      end
      return sum
    end
    
  end
  
end
