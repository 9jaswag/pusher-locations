class Checkin < ApplicationRecord
  belongs_to :trip
  after_commit :notify_pusher, on: [:create]

  def notify_pusher
    Pusher.trigger('location', 'new', self.as_json)
  end
end
