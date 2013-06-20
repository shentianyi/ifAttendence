# encoding : utf-8
require 'digest/sha2'

class Staff < ActiveRecord::Base
      attr_accessible :nr, :name, :password, :password_confirmation, :state
      attr_accessible :pwd, :salt
      attr_accessible :workunit_id, :group_id
      
      has_many :staff_role_maps
      has_many :roles, :through=>:staff_role_maps
      
      belongs_to :workunit
      belongs_to :group
      has_many :squads, :class_name=>"Group", :foreign_key=>"captain_id", :dependent=>:delete_all
      has_many :allmems, :through=>:squads, :source=>:members, :uniq=>true
      
      has_many :staff_workunit_maps
      has_many :units, :through=>:staff_workunit_maps, :source=>:workunit
      
      
      validates :nr, :presence => true, :uniqueness => true
      validates :password, :confirmation => true
      validate   :password_must_be_present
      
      def password
           @password
      end

      def password=(password)
            @password = password
            if password.present?
                  generate_salt
                  self.pwd = self.class.encrypt_password(password, salt)
            end
      end
      
      class << self
            def authenticate( nr, password)
                  if staff = find_by_nr(nr)
                        if staff.pwd == encrypt_password(password, staff.salt)
                             staff
                        end
                  end
            end
            def encrypt_password(password, salt)
                  Digest::SHA2.hexdigest(password + "webepm" + salt)
            end
      end
  
    
  private
      
      def password_must_be_present
           errors.add(:password, "Missing password !" ) unless pwd.present?
      end
      
      def generate_salt
            self.salt = self.object_id.to_s + rand.to_s
      end

  
end
