class AddRoutineDoneAtToCompletedRoutine < ActiveRecord::Migration
  def change
    add_column :completed_routines, :routine_done_at, :datetime
    
    reversible do |dir|
      dir.up do
        CompletedRoutine.where(routine_done_at: nil).each do |cr|
          cr.routine_done_at = cr.created_at
          cr.save!
        end
      end
    end
  end
end
