class Checkin < ApplicationRecord
  belongs_to :trip
  after_create :notify_pusher

  def notify_pusher
    Pusher.trigger('location', 'new', self.trip.as_json)
  end
end
