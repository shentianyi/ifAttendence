# encoding : utf-8
class LogStaff < ActiveRecord::Base
  attr_accessible :staffNr, :staffName, :workunitNr, :oldState, :newState, :time
  
  def time_str
    Time.at(self.time)
  end
  
  class << self
    
    def log_change_state( staff, workunit, oldState, newState, alterTime=nil )
      if alterTime.nil?
        log = self.new( :staffNr=>staff.nr, :staffName=>staff.name, :workunitNr=>workunit.nr, :oldState=>oldState, :newState=>newState, :time=>Time.now.to_i )
      else
        log = self.new( :staffNr=>staff.nr, :staffName=>staff.name, :workunitNr=>workunit.nr, :oldState=>oldState, :newState=>newState, :time=>alterTime )
      end
      log.save
      begin
        if newState
          $thrift.addAttendance($thrift_access_key,{"entityId"=>workunit.nr,"attendTime"=>(Time.now.to_ms).to_s,"staffId"=>staff.nr,"type"=>"1"})
        else
          $thrift.addAttendance($thrift_access_key,{"entityId"=>workunit.nr,"attendTime"=>(Time.now.to_ms).to_s,"staffId"=>staff.nr,"type"=>"-1"})
        end
      rescue Exception=>e
        system( "cd #{Rails.root}/log && echo Thrift_time: $(date) >> webEpm_error.log && echo '"+e.to_s+"' >> webEpm_error.log" )
        # raise I18n.t("errors.wrService")
      end
    end
    
    def log_zusammen_range( staffNr, sTime, eTime, unit=nil )
      if unit
        raw = LogStaff.where(:time=>sTime..eTime, :staffNr=>staffNr, :workunitNr=>unit.nr ).order("time ASC")
      else
        raw = LogStaff.where(:time=>sTime..eTime, :staffNr=>staffNr).order("time ASC")
      end
      if raw.size == 0
        if unit
          beforeRaw = LogStaff.where(:time=>0...sTime, :staffNr=>staffNr, :workunitNr=>unit.nr).order("time ASC")
        else
          beforeRaw = LogStaff.where(:time=>0...sTime, :staffNr=>staffNr).order("time ASC")
        end
        return 0 if beforeRaw.size == 0
        return (eTime-sTime) if beforeRaw.last.newState
        return 0
      else
        sum = 0
        record = raw.map {|r| r.time}
        record.insert( 0, sTime ) unless raw.first.newState
        record.push(eTime) unless record.size%2==0
        hash = Hash[*record]
        hash.each do |k,v|
          sum+= v.to_i - k.to_i
        end
        return sum
      end
    end
    
  end
  
  
end
