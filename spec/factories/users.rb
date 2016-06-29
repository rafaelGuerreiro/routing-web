require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email('Guerreiro') }
    f.password { Faker::Internet.password }
    f.password_confirmation { password }

    ## Rememberable
    f.remember_created_at { DateTime.now - 7.days }
  end
end
