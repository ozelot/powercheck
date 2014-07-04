class AddColumnsToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :inventory_no, :integer
    add_column :devices, :serial_no, :string
    add_column :devices, :location, :string
    add_column :devices, :kind, :string
    add_column :devices, :type, :string
    add_column :devices, :vendor, :string
  end
end
