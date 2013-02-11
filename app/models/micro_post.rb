class MicroPost < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :user_id
  validates :content, presence: true, length: { minimum: 5, maximum: 140}
  validates :user_id, presence: true
end
