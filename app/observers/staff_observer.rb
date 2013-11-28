#encoding: utf-8
class StaffObserver<ActiveRecord::Observer
  observe :staff
  def after_create staff
    uri = URI.parse("http://localhost:8081/staffs")
    Net::HTTP.post_form(uri, {staff:{name:staff.name,staffNr:staff.nr}.to_json,access_key:$thrift_access_key})
  end
end
