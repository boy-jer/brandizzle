# == Schema Information
#
# Table name: brand_results
#
#  id                :integer(4)      not null, primary key
#  brand_id          :integer(4)      indexed, indexed => [result_id]
#  result_id         :integer(4)      indexed, indexed => [brand_id]
#  created_at        :datetime
#  updated_at        :datetime
#  state             :string(255)     indexed
#  comments_count    :integer(4)      default(0)
#  temperature       :integer(4)      indexed
#  read              :boolean(1)      default(FALSE), indexed
#  team_id           :integer(4)      indexed
#  result_created_at :datetime        indexed
#

class BrandResult < ActiveRecord::Base
  belongs_to :brand
  belongs_to :result
  belongs_to :team
  has_many :comments, :dependent => :delete_all
    
  class << self
    def per_page
      per_page = Settings.pagination.results_per_page
    end
    
    def cleanup_for_brand(brand_id)
      find_in_batches(:batch_size => 200, :conditions => { :brand_id => brand_id }) do |batch|
        batch.each(&:destroy)
      end
    end
  end

  named_scope :between_date, lambda { |date_range|
    from = date_range.split(" to ").first.to_time.beginning_of_day
    to = date_range.split(" to ").last.to_time.end_of_day
    
    {:joins => :result,
    :conditions => ["#{Result.table_name}.created_at >= ? AND #{Result.table_name}.created_at <= ?", from, to]}
  }

  [ 'normal', 'follow_up', 'done' ].each do |state|
    named_scope state, :conditions => {:state => state}
  end
  
  named_scope :unread_before, lambda { |before| 
    {:joins => :result,
    :conditions => ["#{BrandResult.table_name}.read = ? AND #{Result.table_name}.created_at <= ?", false, before.to_time]}
  }
  
  named_scope :read, :conditions => { :read => true }
  named_scope :unread, :conditions => { :read => false }
  
  named_scope :read_state, lambda { |state|
    {:conditions => ["#{BrandResult.table_name}.read = ?", state]}
  }
  
  named_scope :latest_follow_up, 
    :include => [:brand, :result],
    :conditions => { :state => "follow_up" }, 
    :order => "#{BrandResult.table_name}.updated_at DESC", 
    :limit => Settings.dashboard.follow_up_results_number
  
  include AASM
  aasm_column :state
  
  aasm_initial_state :normal
  aasm_state :normal
  aasm_state :follow_up
  aasm_state :done
  
  aasm_event :follow_up do
    transitions :to => :follow_up, :from => [:normal]
  end
  
  aasm_event :finish do
    transitions :to => :done, :from => [:follow_up]
  end
  
  aasm_event :reject do
    transitions :to => :normal, :from => [:follow_up]
  end
  
  def warm_up!
    self.temperature = 1
    save!
  end
  
  def temperate!
    self.temperature = 0
    save!
  end
  
  def chill!
    self.temperature = -1
    save!
  end
  
  def positive?
    temperature == 1
  end
  
  def neutral?
    temperature == 0
  end
  
  def negative?
    temperature == -1
  end
  
  def mark_as_read!
    self.read = true
    save!
  end
  
  def logged_attributes(options = {})
    options.merge({
      "body" => result.body,
      "url"  => result.url
    })
  end
end
