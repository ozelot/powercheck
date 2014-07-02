class Device < ActiveRecord::Base
  belongs_to :user
  has_many :imports
  default_scope -> { order('created_at DESC') }

  validates :user_id, presence: true
end
