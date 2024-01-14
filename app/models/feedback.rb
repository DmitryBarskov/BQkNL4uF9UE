class Feedback < ApplicationRecord
  belongs_to :branch

  validates :quality, numericality: { in: 1..5 }
  validates :nps, numericality: { in: 0..10 }

  scope :with_org, ->(org) { joins(:branch).where(branches: { organization: org }) }
end
