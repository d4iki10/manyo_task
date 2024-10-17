# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 管理者ユーザの作成
admin_user = User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# 一般ユーザの作成
general_user = User.create!(
  name: 'general',
  email: 'general@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

# 管理者ユーザに紐づくタスクを50件作成
50.times do |n|
  admin_user.tasks.create!(
    title: "管理者のタスク#{n + 1}",
    content: "タスクの詳細#{n + 1}",
    status: :not_started,
    priority: :medium,
    deadline_on: Date.today + n.days
  )
end

# 一般ユーザに紐づくタスクを50件作成
50.times do |n|
  general_user.tasks.create!(
    title: "一般ユーザのタスク#{n + 1}",
    content: "タスクの詳細#{n + 1}",
    status: :not_started,
    priority: :medium,
    deadline_on: Date.today + n.days
  )
end
