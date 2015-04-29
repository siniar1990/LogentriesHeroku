class DropReservationsTable < ActiveRecord::Migration
  def up
    drop_table :reservations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end