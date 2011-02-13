Factory.sequence(:email) { |n| "person#{n}@example.com" }

Factory.define :user do |u|
  u.email                 { |_| Factory.next(:email) }
  u.username              'myusername'
  u.password              'my password'
  u.password_confirmation 'my password'
end