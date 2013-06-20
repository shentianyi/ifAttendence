# encoding : utf-8
class Group < ActiveRecord::Base
  attr_accessible :nr, :name
  
  belongs_to :captain, :class_name=>"Staff"
  has_many :members, :class_name=>"Staff", :foreign_key=>"group_id"
  
  def add_members( *mems )
    self.members << mems
  end
  
  class << self
    def new_squad( captain, name )
      group = captain.squads.build( :nr=>UUID.generate, :name=>name )
      group.save ? group : nil
    end
  end
end
