class Goal < ActiveRecord::Base
  belongs_to :person
  has_many :routines, inverse_of: :goal
  has_many :completed_routines, through: :routines
  
=begin rdoc
Return the number of clean routines for this reward definition,
minus the number of routines already reward, and divide that difference
by the target,
=end
  def pending
    clean_routines.count / target
  end
  
  def clean_routines
    completed_routines.select { |cr| cr.is_clean? }
  end
  
  def awarded
    
  end
end
