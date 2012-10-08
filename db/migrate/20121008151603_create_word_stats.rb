class CreateWordStats < ActiveRecord::Migration
  def change
    create_table :word_stats do |t|
      t.integer :count
      t.integer :correct
      t.references :word

      t.timestamps
    end
    add_index :word_stats, :word_id
  end
end
