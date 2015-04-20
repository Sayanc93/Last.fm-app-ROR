class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :user_id
      t.string :history

      t.timestamps
    end
    add_index :histories, :user_id
  end
end
