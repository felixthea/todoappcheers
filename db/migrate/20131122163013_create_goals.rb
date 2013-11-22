class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id
      t.string :name
      t.boolean :completed, default: false
      t.boolean :personal, default: false
      t.timestamps
    end

    add_index :goals, :user_id
  end
end
