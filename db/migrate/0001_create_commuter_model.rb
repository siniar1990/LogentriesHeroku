class CreateCommuterModel < ActiveRecord::Migration

  def self.up
    create_table :commuters do |t|
      t.column :username, :string
      t.column :email, :string
      t.column :mobile, :string
      t.column :password_hash, :string
      t.column :password_salt, :string
      t.column :missed, :integer ,:default => 0
      t.column :suspended, :boolean , :default => false
      t.column :is_admin, :boolean , :default => false
      t.column :is_driver, :boolean , :default => false
    end

    create_table :reservations do |t|
      t.column :origin, :string
      t.column :destination, :string
      t.column :time, :string
      t.column :date, :string
      t.column :user, :string
    end

  end



  def self.down
    drop_table :commuters
  end
end
