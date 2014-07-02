class RenameReportToImports < ActiveRecord::Migration
  def change
    rename_table :reports, :imports
  end
end
