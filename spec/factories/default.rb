#encoding: utf-8

require 'faker'

FactoryGirl.define do
  factory :user do
    email                 { "#{SecureRandom.uuid}-#{Faker::Internet.email}" }
    password              'secret'
    password_confirmation 'secret'

    factory :global_admin do
      admin true
    end

    factory :admin do
      rights {|rights| [rights.association(:right, role: 'admin')] }
    end
    factory :developer do
      rights {|rights| [rights.association(:right, role: 'developer')] }
    end
    factory :auditor do
      rights {|rights| [rights.association(:right, role: 'auditor')] }
    end
  end

  factory :right do
    project
    user
    role { ['auditor', 'developer', 'admin'].sample }
  end

  factory :project do
    name        { Faker::Company.name }
    branch      'master'
    folder_path { "/tmp/bennett/#{SecureRandom.uuid}/" }
  end

  factory :build do
    project
  end

  factory :command do
    project
    name { %w(bundle dbmigrate rspec cucumber units controllers).sample }
  end

  factory :invitation do
    project
    association :issuer, factory: :user
    role  { ['auditor', 'developer', 'admin'].sample }
    email { "#{SecureRandom.uuid}-#{Faker::Internet.email}" }
  end

  factory :result do
    build
    command
  end
end
