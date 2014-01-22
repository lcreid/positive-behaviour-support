class AddExpectationToCompletedExpectation < ActiveRecord::Migration
  def change
    add_reference :completed_expectations, :expectation, index: true
  end
end
