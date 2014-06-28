class RemoveSummaryFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :summary, :String
  end
end
