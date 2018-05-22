class Trip < ApplicationRecord
  before_create :set_uuid
  has_many :checkins

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
