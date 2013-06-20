# encoding : utf-8
module Attendance
class PersonalController < Attendance::ApplicationController
  # protect_from_forgery
  
  def create_squad
    if request.get?
      @mySquads = @currentUser.squads
    else
      begin
        raise( RuntimeError, t("alert.fail") ) unless grp = Group.new_squad( @currentUser, params[:name].strip )
        @newSquad = grp
        render :json => {:flag=>true, :msg=>t("alert.success"), :txt=>render_to_string(:partial=>"new_squad") }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s }
      end
    end
  end
  
  def delete_squad
      begin
        raise( RuntimeError, t("errors.nonGroup") ) unless grp = Group.find_by_nr( params[:group].strip )
        raise( RuntimeError, t("errors.nonblankGroup") ) if grp.members.size!=0
        grp.destroy
        render :json => {:flag=>true, :msg=>t("alert.success") }
      rescue Exception => e
        render :json => { :flag=>false, :msg=>e.to_s }
      end
  end

  def add_members
    begin
      raise( RuntimeError, t("errors.nonGroup") ) unless grp = Group.find_by_nr( params[:group].strip )
      raise( RuntimeError, t("errors.nonStaff") ) unless mem = Staff.find_by_nr( params[:mem].strip )
      grp.add_members( mem )
      render :json => {:flag=>true, :msg=>t("alert.success")}
    rescue Exception => e
      render :json => { :flag=>false, :msg=>e.to_s }
    end
  end
  
  def get_members
    begin
      raise( RuntimeError, t("errors.nonGroup") ) unless grp = Group.find_by_nr( params[:group] )
      @groupMembers = grp.members
      render :json => {:flag=>true, :msg=>t("alert.success"), :txt=>render_to_string(:partial=>"squad_members") }
    rescue Exception => e
      render :json => { :flag=>false, :msg=>e.to_s }
    end
  end

protected
  def rbac
    rbac_config do |user|
          case action_name
          when "create_squad", "add_members"
            Role.privileges_check( user, "Group", "W" )
          when "get_members"
            Role.privileges_check( user, "Group", "X" )
          when "delete_squad"
            Role.privileges_check( user, "Group", "D" )
          end
    end
  end

end
end
