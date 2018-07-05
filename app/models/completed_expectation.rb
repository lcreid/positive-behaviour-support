# frozen_string_literal: true

class CompletedExpectation < ActiveRecord::Base
  belongs_to :completed_routine
  belongs_to :expectation
  scope :clean, -> { where("observation = 'Y' or observation = 'N/A'") }
  scope :not_clean, -> { where("observation = 'N' or observation is null") }

  # rdoc
  # Build a new CompletedExpectation from an Expectation.
  def initialize(params)
    params = params.copyable_attributes if params.is_a? Expectation
    super(params)
  end

  # rdoc
  # Get the Routine associated with this CompletedExpectation.
  def routine
    completed_routine.routine
  end

  # rdoc
  # Return a hash of attributes that make sense to compare to an expectation.
  def comparable_attributes
    attributes.slice("description", "expectation_id")
  end

  # rdoc
  # Override == when the other object is an Expectation, to test only the attributes
  # that make sense to compare.
  def ==(other)
    return super unless other.is_a? Expectation
    comparable_attributes == other.comparable_attributes
  end

  # rdoc
  # Return true if the expectation was completed successfully,
  # or wasn't' able to be completed through no fault of the patient.
  def is_clean?
    observation == "Y" || observation == "N/A"
  end
end
