# == Schema Information
#
# Table name: logs
#
#  id                  :integer(4)      not null, primary key
#  loggable_id         :integer(4)      indexed => [loggable_type]
#  loggable_type       :string(255)     indexed => [loggable_id]
#  user_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  loggable_attributes :text
#  team_id             :integer(4)      indexed
#

class Log < ActiveRecord::Base
  serialize :loggable_attributes
  
  belongs_to :user
  belongs_to :team
  belongs_to :loggable, :polymorphic => true
  
  before_create :assign_team  
  
  def self.per_page
    per_page = Settings.dashboard.logs_per_page
  end
  
  private
    def assign_team
      self.team = user.team
    end
end
