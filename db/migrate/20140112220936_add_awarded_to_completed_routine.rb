class AddAwardedToCompletedRoutine < ActiveRecord::Migration
  def change
    add_column :completed_routines, :awarded, :boolean
  end
end
