WebEPM::Application.routes.draw do
  mount Resque::Server.new, :at=>"/admin/resque"
  scope '(:locale)' do

    root :to => 'attendance::operation#login'

    namespace :attendance do
      controller :global do
        match 'create_captain' => :create_captain
        match 'create_mem' => :create_mem
        post 'delete_mem' => :delete_mem
        post 'upload_members' => :upload_members
        match 'create_workunit' => :create_workunit
        post 'delete_workunit' => :delete_workunit
        match 'staff_workunit' => :staff_workunit
        post 'reomve_staff_workunit'=>:reomve_staff_workunit
        match 'assign_workunit'=>:assign_workunit
        post 'upload_workunit' => :upload_workunit
      end

      controller :personal do
        get 'settings' => :create_squad
        post 'create_squad' => :create_squad
        post 'delete_squad' => :delete_squad
        post 'add_members' => :add_members
        post 'get_members' => :get_members
      end

      controller :operation do
        match 'login' => :login
        get 'logout' => :logout
        match 'operation' => :registration
        post 'control_workunit_state' => :control_workunit_state
      end

      controller :search do
        match 'log_staff_details' => :log_staff_details
        match 'log_staff_zusammen' => :log_staff_zusammen
        match 'log_workunit_zusammen' => :log_workunit_zusammen
      end
    end

  end

end
