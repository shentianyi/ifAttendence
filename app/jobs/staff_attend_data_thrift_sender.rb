#encoding: utf-8
class StaffAttendDataThriftSender
  @queue='staff_attend_data_thrift_queue'
  def self.perform(workunit_nr,log_time,log_state,staffNrs)
    puts "----------#{log_time},#{workunit_nr},#{log_state},#{staffNrs.join(',')}"
    begin
      lstate = (log_state=="true")
      log_type= lstate ? "1" : "-1"
      # staffNrs.each do |nr|
        # if (staff= Staff.find_by_nr(nr)) && (staff.state==lstate)
        # staffNrs.delete(nr)
        # end
      # end
      $thrift.addAttendances($thrift_access_key,{"entityId"=>workunit_nr.split(' ')[0],"attendTime"=>log_time.to_s,"type"=>log_type,"staffIds"=>staffNrs.join(',')})
    rescue Exception=>e
      puts e.backtrace
      system( "cd #{Rails.root}/log && echo Thrift_time: $(date) >> thrift_error.log && echo '"+e.to_s+"' >> thrift_error.log" )
    end
  end
end
