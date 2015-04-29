class CreateReservationsTable < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.column :origin, :string
      t.column :destination, :string
      t.column :time, :string
      t.column :date, :string
      t.column :route, :string
      t.column :user, :string
    end
  end
end
