class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :ang
      t.string :pol1
      t.string :pol2
      t.string :pol3
      t.text :opis_ang
      t.text :opis_pol

      t.timestamps
    end
  end
end
