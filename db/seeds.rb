# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: "jack@todo.com",
             password: "123123",
             password_confirmation: "123123",
             activated: true)


user = User.first
10.times do |n|
  content = "#{'Lorem ipsum '*(n+1)}"
  user.tasks.create!(content: content)
end


User.create!(email: "jack-oauth@todo.com",
             password: "123123",
             password_confirmation: "123123",
             activated: true,
             provider: 'example',
             uid: '9999999')