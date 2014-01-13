class Goal < ActiveRecord::Base
  belongs_to :person
  has_many :routines, inverse_of: :goal
  has_many :completed_routines, through: :routines
  
=begin rdoc
Return the number of clean routines for this goal,
minus the number of routines already rewarded, and divide that difference
by the target,
=end
  def pending(ignore_cache = false)
    pending_routines(ignore_cache).count / target
  end
  
=begin rdoc
Return the clean routines for this goal that haven't been
awarded yet.
=end
  def pending_routines(ignore_cache = false)
    clean_routines(ignore_cache).where(awarded: false)
  end
  
  def clean_routines(ignore_cache = false)
#    completed_routines(ignore_cache).select { |cr| cr.is_clean? }
    completed_routines.where(
      "not exists (" + 
        "select * from completed_expectations ce " + 
          "where (ce.observation = 'N' or ce.observation is null) and " +
            "completed_routine_id = completed_routines.id)"
    )
  end
  
  def awarded(ignore_cache = false)
    completed_routines(ignore_cache).count { |cr| cr.awarded }
  end
  
  def award(n = 1)
    return if pending < n
    pending_routines.sort_by { |cr| cr.created_at } .first(n * target).each do |give|
      give.awarded = true
      give.save!
    end
  end
  
  def can_be_completed_by?(user)
    user.primary_identity != self.person && # User can give self awards
      user.people.any? { |x| x == self.person } # Goal is for a user in the user's contact list
  end
end
