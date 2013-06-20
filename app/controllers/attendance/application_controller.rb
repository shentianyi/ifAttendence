# encoding : utf-8
module Attendance
class ApplicationController < ActionController::Base
  # protect_from_forgery
  before_filter :set_i18n_locale_from_params
  before_filter :authorize
  before_filter :rbac
  

  layout "attendance"


protected
  def authorize
    unless @currentUser = Staff.find_by_id( session[:userID] )
      respond_to do |format|
        format.html { redirect_to attendance_login_url }
        format.json { render :json=>{:flag=>false, :msg=>"请重新登录。"} }
      end
    end
  end

  def rbac_config
    unless staff = Staff.find_by_id( session[:userID] )
      reset_session
      redirect_to attendance_login_url
    else
      begin
          yield staff
      rescue Exception => e
          @permissionErrorMsg=e.to_s
          respond_to do |format|
            format.html { render "share/permission", :layout=>'attendance' }
            format.json { render :json=>{:flag=>false, :msg=>@permissionErrorMsg} }
          end
      end
    end
  end
  
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    (I18n.locale == I18n.default_locale) ? {} : { locale: I18n.locale }
  end

end
end
