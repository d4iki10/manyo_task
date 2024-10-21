FactoryBot.define do
  factory :user do
    name { '一般ユーザ' }
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end

  factory :admin_user, class: User do
    name { '管理者ユーザ' }
    email { 'admin@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end
end
