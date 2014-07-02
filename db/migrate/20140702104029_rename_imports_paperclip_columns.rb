class RenameImportsPaperclipColumns < ActiveRecord::Migration
  def change
    change_table :imports do |t|
      t.rename :report_file_file_name, :import_file_file_name
      t.rename :report_file_content_type, :import_file_content_type
      t.rename :report_file_file_size, :import_file_file_size
      t.rename :report_file_updated_at, :import_file_updated_at
    end
  end
end
