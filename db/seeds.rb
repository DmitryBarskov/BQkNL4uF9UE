# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
orgs = %w[Douglas FitX BMW REWE].map do |org_name|
  Organization.create(name: org_name)
end

orgs.each do |org|
  (1..10).each do |i|
    name = "Branch #{org.name} #{format('%02d', i)}"
    org.branches.create(name:)
  end
end

from = Date.new(2010, 1, 1)
to = Date.new(2018, 5, 1)

10_000.times do
  quality = rand(1..10)
  age_group = %w[01-19 20-29 30-39 40-49 50-59 60+].sample
  nps = rand(0..10)
  status = %w[valid cancelled].sample
  org = orgs.sample
  branch = org.branches.sample
  experienced_at = rand(from..to)

  Feedback.create(quality:, age_group:, nps:, status:, branch:, experienced_at:)
end
