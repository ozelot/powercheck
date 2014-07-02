class Report < ActiveRecord::Base
  belongs_to :device
  belongs_to :user
  has_attached_file :report_file

  default_scope -> { order('created_at DESC') }
  validates :device_id, presence: true
  validates :user_id, presence: true
  validates_attachment_content_type :report_file, :content_type => ["text/xml", "text/plain"]
  validates_attachment :report_file, :presence => true,
                       :size => {:less_than => 10.megabytes}

  before_save :parse_file

  private

  def parse_file
    tempfile = report_file.queued_for_write[:original]
    doc = Nokogiri::XML(tempfile)
    parse_xml(doc)
  end

  def parse_xml(doc)
    doc.root.elements.each do |node|
      parse_element(node)
    end
  end

  def parse_element(node)
  end

end
