namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationship

  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "bat11@club.fr",
                       :password => "tototo",
                       :password_confirmation => "tototo")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationship
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |followed| followed.follow!(user) }
end