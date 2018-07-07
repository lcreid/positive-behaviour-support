# frozen_string_literal: true

class CompletedRoutine < ActiveRecord::Base
  belongs_to :person
  belongs_to :routine
  belongs_to :recorded_by, class_name: "User", optional: true
  belongs_to :updated_by, class_name: "User", optional: true
  belongs_to :routine_category, optional: true
  has_many :completed_expectations, dependent: :destroy
  accepts_nested_attributes_for :completed_expectations, allow_destroy: true
  scope :most_recent, ->(n = 10_000) { reorder(routine_done_at: :desc).limit(n) } # TODO: either remove the limit or get rid of this scope altogether
  scope :clean, -> { where_not_exists(:completed_expectations, "observation = 'N' or observation is null") }
  scope :dirty, -> { where_exists(:completed_expectations, "observation = 'N' or observation is null") }
  scope :unawarded, -> { clean.where(awarded: false) }

  before_create :set_routine_done_at

  validates_datetime :routine_done_at, allow_blank: true

  # rdoc
  # By default, the routine is given a date and time of when the person began
  # recording the observations. This field is editable in the form.
  def set_routine_done_at
    self.routine_done_at ||= Time.zone.now
  end

  # rdoc
  # Override == when the other object is a Routine, to test only the attributes
  # that make sense to compare.
  def ==(other)
    #    puts "Self is a #{self.class}. Other is a #{other.class}"
    return super unless other.is_a? Routine
    comparable_attributes == other.comparable_attributes
  end

  # rdoc
  # Return a hash of attributes that make sense to compare to a routine.
  def comparable_attributes
    attributes.slice("routine_id", "name", "person_id").merge(
      "completed_expectations_attributes" => completed_expectations.collect(&:comparable_attributes)
    )
  end

  # rdoc
  # Return true if all expectations in the routine were completed successfully,
  # or weren't able to be completed through no fault of the patient.
  def is_clean?
    completed_expectations.all?(&:is_clean?)
  end

  # rdoc
  # Return all the expectations that have ever existed for the routine associated
  # with this comopleted routine.
  def expectations
    Expectation.distinct.where(routine_id: routine_id)
  end

  # FROM http://railscasts.com/episodes/102-auto-complete-association-revised
  # rdoc
  # Return the category name for the completed routine.
  def category_name
    routine_category.try(:name)
  end

  # rdoc
  # Set the category based on the name.
  def category_name=(name)
    self.routine_category = RoutineCategory.find_or_create_by(name: name, person_id: person_id) if name.present?
  end
end

# A more general way to change keys in a hash is this
# (http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby):
#
# ages = { "Bruce" => 32, "Clark" => 28 }
# mappings = {"Bruce" => "Bruce Wayne", "Clark" => "Clark Kent"}
#
# Hash[ages.map {|k, v| [mappings[k], v] }]
