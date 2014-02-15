class AddRoutineCategoryToCompletedRoutine < ActiveRecord::Migration
  def change
    add_reference :completed_routines, :routine_category, index: true
  end
end
