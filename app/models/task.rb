class Task < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true
  
  default_scope -> { order(:created_at) }
  scope :done,  -> { where(done: true) }
  scope :todo,  -> { where(done: false) }

  def change_status
    self.done ? update_attribute(:done, false) : update_attribute(:done, true)
  end
end
