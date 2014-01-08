module PersonHelper
  def users
    people.select { |person| ! person.user_id.nil? }
  end
  
  def patients
    people.select { |person| person.user_id.nil? }
  end
end
