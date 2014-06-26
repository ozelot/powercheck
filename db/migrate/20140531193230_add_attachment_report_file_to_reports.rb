class AddAttachmentReportFileToReports < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.attachment :report_file
    end
  end

  def self.down
    drop_attached_file :reports, :report_file
  end
end
