class AddRecordedByAndUpdatedByToCompletedRoutine < ActiveRecord::Migration
  def change
    add_reference :completed_routines, :recorded_by, index: true
    add_reference :completed_routines, :updated_by, index: true
  end
end
