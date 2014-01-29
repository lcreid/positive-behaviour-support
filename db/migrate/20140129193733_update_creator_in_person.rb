class UpdateCreatorInPerson < ActiveRecord::Migration
  def up
    # Any people so far are training patients that will only have one link,
    # and it will be the creator,
    # Or, they're the primary identity of the User, which by definition
    # should be the User
    Person.all.each do |p|
      if p.user
        p.creator = p.user
      elsif 0 < p.people.count # May be people not linked to anyone, e.g. fixtures
        p.creator = p.people.first.user
      end
      p.save
    end
  end
end
