class AddCategoryToTests < ActiveRecord::Migration
  def change
    add_column :tests, :category_id, :integer
  end
end
