# encoding : utf-8
module Attendance
  class GlobalController < Attendance::ApplicationController
    # protect_from_forgery
    # [功能：] 新建小组长，和组长的默认组"Default Group", 并将自己加入自己的组。
    # 参数：
    # - params[:nr]：组长员工号
    # - params[:name]：组长姓名
    # 返回值：
    # - 页面
    def create_captain
      roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
      if request.get?
        else
        nr = params[:nr]
        name = params[:name]
        cap = Staff.new( :nr=>nr, :name=>name, :password=>nr, :password_confirmation=>nr )
        if cap.save
          roleCap.staffs << cap
          grp = Group.new_squad( cap, "Default Group" )
          grp.add_members( cap )
          flash.now[:notice] = t("alert.success")
        else
          flash.now[:notice] = t("alert.fail")
        end
      end
      @caps = roleCap.staffs
    end

    # [功能：] 如果params.key?("search")为true，则查询显示组长的所有员工；否则新建组员。
    # 参数：
    # - params[:capNr]：组长员工号
    # - params[:nr]：组员员工号
    # - params[:name]：组员姓名
    # 返回值：
    # - 页面
    def create_mem
      @members = []
      roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
      if request.get?

        if !params[:cap].nil? && @currentUser.nr=='admin'
          if cap=Staff.find_by_id(params[:cap])
            @capNr=cap.nr
            session[:create_mem_cap_nr]=cap.nr
          else
            raise(RuntimeError, "组长不存在。")
          end
        else
          @capNr=@currentUser.nr
        end
        raise(RuntimeError, "不是组长。") unless cap = roleCap.staffs.where( :nr=>@capNr).first
      else
        @capNr=session[:create_mem_cap_nr] ||@currentUser.nr
        nr = params[:nr]
        name = params[:name]
        begin
          raise(RuntimeError, "不是组长。") unless cap = roleCap.staffs.where( :nr=>@capNr).first
          grp = Group.new_squad(@currentUser , "Default Group" ) unless grp = cap.squads.where( :name=>"Default Group" ).first
          raise(RuntimeError, "组员员工号不能为空。") if nr.blank?
          mem = Staff.new( :nr=>nr, :name=>name, :password=>nr, :password_confirmation=>nr )
          raise(RuntimeError, t("alert.fail")) unless mem.save
          grp.add_members( mem )
          flash.now[:notice] = t("alert.success")
        rescue Exception => e
          flash.now[:notice] = e.to_s
        end
      end

      @members = cap.allmems.paginate(:page=>params[:page],:per_page=>15)
    end

    # [功能：] 删除人员。
    # 参数：
    # - params[:memNr]：员工号
    # 返回值：
    # - json对象
    def delete_mem
      memNr = params[:memNr]
      roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
      begin
        if cap = roleCap.staffs.where( :nr=>memNr).first
          raise(RuntimeError, "所选人员为组长，且组员不为空，请先将组员转至其他组别。") if cap.allmems.size > 1
        cap.destroy
        elsif mem = Staff.find_by_nr(memNr)
        mem.destroy
        else
          raise(RuntimeError, "员工不存在。")
        end
        render :json=>{flag:true,msg:"删除成功."}
      rescue Exception => e
        render :json=>{flag:false,msg:e.to_s}
      end
    end

    def upload_members
      files=params[:files]
      result = true
      info = ""
      total = 0
      begin
        raise( RuntimeError, "文件数量不符合！" )  unless files.size==1
        roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first

        @capNr=session[:create_mem_cap_nr] ||@currentUser.nr

        raise(RuntimeError, "员工不是组长。") unless cap = roleCap.staffs.where( :nr=>@capNr).first
        raise(RuntimeError, "默认组Default Group不存在，请重新建立默认组。") unless grp = cap.squads.where( :name=>"Default Group" ).first
        f = files.first
        fTemp = TempFile.new( f.original_filename, f)
        hfile = fTemp.path
        @excel = ::Roo::Spreadsheet.open(hfile)
        @excel.default_sheet = @excel.sheets.first
        raise( RuntimeError, "缺少员工号(StaffNr)！") unless @excel.cell(1,"A")=="StaffNr"
        raise( RuntimeError, "缺少员工姓名(StaffName)！") unless @excel.cell(1,"B")=="StaffName"
        2.upto(@excel.last_row) do |line|
          nr =  @excel.cell( line, "A" ).to_s
          nr = nr.split(".").first if $Exp =~ nr
          name = @excel.cell( line, "B" )
          if mem = Staff.find_by_nr( nr )
            else
            mem = Staff.new( :nr=>nr, :name=>name, :password=>nr, :password_confirmation=>nr )
            unless mem.save
              info<<"第#{line}行添加失败！"
            next
            end
          end
          grp.add_members( mem )
          total+=1
        end
        # TODO #收集2行到最后一行的员工号，构成数组 arrTemp
        # TODO #cap.allmems.map{|m| m.nr}.delete( arrTemp ) 剩下的员工需要删除出小组，但不要彻底删除，只需要删除小组的外键。
        info << "导入#{total}条。"
        # File.delete(hfile)
      rescue Exception => e
      result = false
      info = e.to_s
      end

      if result
        render :json=>{flag:true,msg:"新建成功！"+info }
      #render :json=>{flag:true,msg:"新建成功！"+info, :txt=>render_to_string(:partial=>"dort")}
      else
        render :json=>{flag:false,msg:"失败！"+info }
      end
    end

    def create_workunit
      @units = []
      if request.get?
        else
        begin
          if params.key?("search")
            else
            raise(RuntimeError, "工作台号不能为空。") if params[:unit][:nr].blank?
            workunit = Workunit.new( params[:unit] )
            raise(RuntimeError, t("alert.fail")) unless workunit.save
            flash.now[:notice] = t("alert.success")
          end
          @units = Workunit.all
        rescue Exception => e
          flash.now[:notice] = e.to_s
        end
      end
    end

    def delete_workunit
      unitNr = params[:unitNr]
      begin
        raise(RuntimeError, "工作台不存在。") unless unit = Workunit.find_by_nr(unitNr)
        raise(RuntimeError, "所选工作台目前有员工登入，请先将所有员工登出。") if unit.staffs.size > 0
        unit.destroy
        render :json=>{flag:true,msg:"删除成功."}
      rescue Exception => e
        render :json=>{flag:false,msg:e.to_s}
      end
    end

    def upload_workunit
      files=params[:files]
      result = true
      info = ""
      total = 0
      begin
        raise( RuntimeError, "文件数量不符合！" )  unless files.size==1
        roleCap = Role.where( :nr=>"captain", :name=>"captain" ).first
        raise(RuntimeError, "当前用户不是组长。") unless cap = roleCap.staffs.where( :nr=>@currentUser.nr).first
        f = files.first
        fTemp = TempFile.new( f.original_filename, f)
        hfile = fTemp.path
        @excel = ::Roo::Spreadsheet.open(hfile)
        @excel.default_sheet = @excel.sheets.first
        raise( RuntimeError, "缺少工作台号(WorkunitNr)！") unless @excel.cell(1,"A")=="WorkunitNr"
        2.upto(@excel.last_row) do |line|
          nr =  @excel.cell( line, "A" ).to_s
          nr = nr.split(".").first if $Exp =~ nr
          if unit = Workunit.find_by_nr( nr )
            if unit.owners.where(:nr=>cap.nr).first
              info<<"第#{line}行已存在！"
            next
            end
          else
            unit = Workunit.new( :nr=>nr )
            unless unit.save
              info<<"第#{line}行添加失败！"
            next
            end
          end
          unit.owners << cap
          total+=1
        end
        info << "导入#{total}条。"
        File.delete(hfile)
      rescue Exception => e
      result = false
      info = e.to_s
      end

      if result
        render :json=>{flag:true,msg:"分配成功！请刷新页面。"+info }
      else
        render :json=>{flag:false,msg:"失败！"+info }
      end
    end

    protected

    def rbac
      rbac_config do |user|
        case action_name
        when "create_captain"
          Role.privileges_check( user, "CreateCap", "W" )
        when "create_mem"
          Role.privileges_check( user, "Staff", "W" )
        when "create_workunit"
          Role.privileges_check( user, "Workunit", "W" )
        end
      end
    end

  end
end
