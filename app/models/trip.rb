class Trip < ApplicationRecord
  before_create :set_uuid
  has_many :checkins

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def as_json(options={})
    super(
      only: [:id, :name, :uuid],
      include: { checkins: { only: [:lat, :lng, :trip_id] } }
    )
  end
end
