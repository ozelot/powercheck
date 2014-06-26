class Report < ActiveRecord::Base
  belongs_to :user
  has_attached_file :report_file

  default_scope -> { order('created_at DESC') }
  validates :summary, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true
  validates_attachment_content_type :report_file, :content_type => ["text/xml", "text/plain"]
  validates_attachment :report_file, :presence => true,
                       :size => {:less_than => 10.megabytes}

end
