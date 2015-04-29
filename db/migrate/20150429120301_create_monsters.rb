class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.text :description
      t.integer :hitpoints

      t.timestamps
    end
  end
end
