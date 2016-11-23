# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
#Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

require 'csv'

csv_path = Rails.public_path+'kenya_location_data.csv'
country = Spree::Country.find_by_name('Kenya')

csv_text = File.read(csv_path)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|

  break if row[0] == ''

  p '==============='
  county = row[0].titleize
  consti = row[1].titleize
  locat = row[2].titleize

  p 'Started Processing... '
  p county
  p consti
  p locat

  state = country.states.find_or_create_by(name: county, abbr: county)
  constituency = state.constituencies.find_or_create_by(name: consti)
  constituency.locations.find_or_create_by(name: locat)

end