class Trip < ApplicationRecord
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
