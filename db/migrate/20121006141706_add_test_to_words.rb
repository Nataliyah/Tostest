class AddTestToWords < ActiveRecord::Migration
  def change
    add_column :words, :test_id, :integer
  end
end
