require 'mysql2'

desc "One line task description"
task :name_of_task do
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "2d4l", :password => "")
  users = client.query("SELECT * FROM auth_user")
  users.each do |u|
    p u
  end
  # Your code goes here
end