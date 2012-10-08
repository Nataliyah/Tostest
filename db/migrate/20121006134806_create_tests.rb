class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :title
      t.string :subtitle
      t.string :image

      t.timestamps
    end
  end
end
