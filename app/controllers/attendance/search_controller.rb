# encoding : utf-8
module Attendance
class SearchController < Attendance::ApplicationController
  # protect_from_forgery
  
  def log_staff_details
    @logStaffs = LogStaff.paginate(:page=>params[:page],:per_page=>15)
  end
  
  def log_staff_zusammen
    if request.get?
      @logStaff = nil
    else
      begin
        raise( RuntimeError, "起始时间不存在。" ) if params[:sTime].blank?
        raise( RuntimeError, "终止时间不存在。" ) if params[:eTime].blank?
        raise( RuntimeError, t("errors.nonStaff") ) unless @logStaff = Staff.find_by_nr( params[:staffID].strip )
        sTime = Time.parse(params[:sTime]).to_i
        eTime = Time.parse(params[:eTime]).to_i
        @value = LogStaff.log_zusammen_range( @logStaff.nr, sTime, eTime )
        # render :json => { :flag=>true, :msg=>"success", :value=>value }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s }
      end
    end
  end
  
  def log_workunit_zusammen
    if request.get?
      @logUnit = nil
    else
      begin
        raise( RuntimeError, "起始时间不存在。" ) if params[:sTime].blank?
        raise( RuntimeError, "终止时间不存在。" ) if params[:eTime].blank?
        raise( RuntimeError, "统计状态未填写。" ) if params[:state].blank?
        raise( RuntimeError, t("errors.nonWorkunit") ) unless @logUnit = Workunit.find_by_nr( params[:workunitNr].strip )
        sTime = Time.parse(params[:sTime]).to_i
        eTime = Time.parse(params[:eTime]).to_i
        @value = LogWorkunit.log_zusammen_range_by_state( @logUnit, sTime, eTime, params[:state] )
        # render :json => { :flag=>true, :msg=>"success", :value=>value }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s }
      end
    end
  end

protected
  def rbac
    rbac_config do |user|
          case action_name
          when "log_staff_details"
            Role.privileges_check( user, "LogStaff", "X" )
          when "log_staff_zusammen"
            Role.privileges_check( user, "LogStaff", "X" )
          when "log_workunit_zusammen"
            Role.privileges_check( user, "LogWorkunit", "X" )
          end
    end
  end
  
end
end
