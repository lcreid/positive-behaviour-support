class ChangeDefaultOfAwardedColumnOnCompletedRoutines < ActiveRecord::Migration
  def change
    change_column_default :completed_routines, :awarded, false
  end
end
