class Invitation < ActiveRecord::Base
  belongs_to :invitor, class_name: "User"
  validates_presence_of :token
  before_validation :add_token

  private

  def add_token
    self.token = SecureRandom.uuid
  end
end
