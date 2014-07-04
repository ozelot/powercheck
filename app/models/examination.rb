class Examination < ActiveRecord::Base
  belongs_to :device
  belongs_to :user

  validates :device_id, presence: true

end
