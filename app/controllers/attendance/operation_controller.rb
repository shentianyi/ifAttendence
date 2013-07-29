# encoding : utf-8
module Attendance
class OperationController < Attendance::ApplicationController
  
  skip_before_filter :authorize, :only=>:login
  skip_before_filter :rbac, :only=>:login
  
  def login
    if request.get?
      render :layout=>false
    else
      if staff = Staff.authenticate( params[:staffNr], params[:staffNr] )
      # if staff = Staff.authenticate( params[:staffNr], params[:password] )
        session[:userID] = staff.id
        redirect_to attendance_operation_url
      else
        reset_session
        flash[:notice] = t("errors.wrUserPwd")
        redirect_to attendance_login_url
      end
    end
  end
  
  def logout
    reset_session
    flash[:notice] = t("alert.logout")
    redirect_to attendance_login_url
  end
  
  def registration
    if request.get?
      if params[:set_locale]
        redirect_to attendance_operation_url(locale: params[:set_locale])
      else
        staff = Staff.find_by_id( session[:userID] )
        @workunits = staff.units
        @unitStates = WorkunitState.all
        @mySquads = staff.squads
      end
    else
      begin
        type = params[:logType].strip
        raise( RuntimeError, t("errors.nonWorkunit") ) unless unit = Workunit.find_by_id( params[:entityID].strip )
        raise( RuntimeError, t("errors.nonStaff") ) unless staff = Staff.find_by_nr( params[:staffID].strip )
        if type == "in"
          Workunit.add_staff( unit, staff )
        else
          Workunit.delete_staff( unit, staff )
        end
        msg = t("alert.success")
        render :json => { :flag=>true, :msg=>msg, :type=>type, :unit=>unit.nr, :staffnr=>staff.nr, :staffname=>staff.name }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s }
      end
    end
  end
  
  def control_workunit_state
      begin
        raise( RuntimeError, t("errors.nonWorkunit") ) unless workunit = Workunit.find_by_id( params[:entityID].strip )
        chstate = params[:state]
        ched = workunit.set_state( chstate, params[:desc] )
        render :json => { :flag=>true, :msg=>t("alert.chWorkunitState", state:chstate ), :changed=>ched, :unit=>workunit.nr }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s}
      end
  end


protected
  def rbac
    rbac_config do |user|
          case action_name
          when "registration"
            Role.privileges_check( user, "Group", "X" )
          when "control_workunit_state"
            Role.privileges_check( user, "Workunit", "X" )
          end
    end
  end

end
end
