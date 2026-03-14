FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    provider { "google_oauth2" }
    sequence(:uid) { |n| "uid_#{n}" }
    name { "テストユーザー" }
  end
end
