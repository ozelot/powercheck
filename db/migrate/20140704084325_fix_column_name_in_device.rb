class FixColumnNameInDevice < ActiveRecord::Migration
  def change
    rename_column :devices, :type, :type_no
  end
end
