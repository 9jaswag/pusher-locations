class Trip < ApplicationRecord
  # validates :long, :lat, :name, :uuid presence: true
  # before_validation :set_uuid, on: :create
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
