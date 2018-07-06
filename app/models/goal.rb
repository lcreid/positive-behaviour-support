# frozen_string_literal: true

class Goal < ActiveRecord::Base
  belongs_to :person
  has_many :routines, inverse_of: :goal
  has_many :completed_routines, through: :routines

  validates :target, numericality: { only_integer: true }, allow_blank: true
  validates :name, presence: true

  # rdoc
  # Return the number of clean routines for this goal,
  # minus the number of routines already rewarded, and divide that difference
  # by the target,
  def pending(ignore_cache = false)
    pending_routines(ignore_cache).count / target
  end

  # rdoc
  # Return the clean routines for this goal that haven't been
  # awarded yet.
  def pending_routines(ignore_cache = false)
    clean_routines(ignore_cache).where(awarded: false)
  end

  def clean_routines(_ignore_cache = false)
    #    completed_routines(ignore_cache).select { |cr| cr.is_clean? }
    completed_routines.clean
  end

  def awarded(ignore_cache = false)
    completed_routines(ignore_cache).count(&:awarded)
  end

  def award(n = 1)
    begin
      n = Integer(n) if n.is_a? String
    rescue ArgumentError
      errors.add(:number_of_rewards, "is not an integer")
      return
    end

    if pending < n
      errors.add(:number_of_awards, "must be less than or equal to #{pending}")
      return
    end

    pending_routines.sort_by(&:routine_done_at) .first(n * target).each do |give|
      give.awarded = true
      give.save!
    end
  end

  def can_be_completed_by?(user)
    user.primary_identity != person && # User can give self awards
      user.people.any? { |x| x == person } # Goal is for a user in the user's contact list
  end
end
