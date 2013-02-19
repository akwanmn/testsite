# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
up = UserProfile.new(first_name: 'Andy', last_name: 'Holman',
  address_street: '601 Hewitt Street', address_city: 'Howell', address_state: 'MI',
  address_zip: '48843', address_country: 'US')
User.create!(email: 'andy@conspyre.com', is_admin: true, password: 'Andy1212!',
  password_confirmation: 'Andy1212!', user_profile: up, nickname: 'zenom')