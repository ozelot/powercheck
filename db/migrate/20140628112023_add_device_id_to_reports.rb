class AddDeviceIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :device_id, :integer
  end
end
