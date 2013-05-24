require 'mysql2'

# Migration Details
SEARCH_HASH = {
  11 => 'Religion',
  10 => 'Politics',
  9 =>'Education',
  8 =>'Animals',
  12 => 'Career',
  13 => 'Nightlife',
  14 => 'Social Life',
  15 => 'Health & Fitness',
  16 => 'Travel',
  17 => 'Books & Reading',
  18 => 'Family',
  19 => 'Outdoors'
}


desc "Migrate the users."
task :migrate_users => :environment do
  countries = {}
  Carmen::Country.all.each do |c|
    countries[c.alpha_3_code] = c.alpha_2_code
  end
  Timezone::Configure.begin do |c|
    c.username = 'ajholman'
  end

  client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "2d4l", :password => "")
  User.skip_callback(:update, :after, :geocode)
  User.skip_callback(:create, :after, :send_welcome_email)
  users = client.query("SELECT * FROM auth_user")
  missing_profiles = []
  users.each do |u|
    user = User.find_or_initialize_by(nickname: u['username'])
    user.nickname             = u['username']
    user.created_at           = u['date_joined']
    user.last_sign_in_at      = u['last_login']
    user.encrypted_password   = u['password']
    user.current_state = u['is_active'] == 1 ? 'charter' : 'suspended'
    user.import_user_id       = u['id']

    user_profile = client.query("SELECT * FROM core_userprofile WHERE user_id = #{u['id']} LIMIT 1").first

    # now profile
    prof = UserProfile.new
    prof.first_name       = u['first_name']
    prof.last_name        = u['last_name']
    missing_profiles << user.nickname if user_profile.nil?
    unless user_profile.nil?
      prof.birthday         = user_profile['birthday']
      prof.min_age          = user_profile['min_age']
      prof.max_age          = user_profile['max_age']
      prof.address_street   = user_profile['street']
      prof.address_city     = user_profile['city']
      prof.address_state    = user_profile['state']
      prof.address_zip      = user_profile['zip']
      prof.biography        = user_profile['biography']
      prof.ethnicity        = user_profile['ethnicity']
      prof.religion         = user_profile['religion']
      prof.education        = user_profile['education']
      prof.occupation       = user_profile['occupation']
      prof.address_country  = countries[user_profile['country'].upcase.strip]
      prof.search_radius    = user_profile['radius']
      prof.gender           = user_profile['gender'] == 1 ? 'Male' : 'Female'
      prof.seeking          = user_profile['seeking'] == 1 ? 'Male' : 'Female'
      prof.likes            = user_profile['looking_for'].split(' ').map {|k| SEARCH_HASH[k.to_i] }
      prof.total_views      = user_profile['views']

      has_coords = false
      if user_profile['lat'].present? && user_profile['lng'].present?
        has_coords = true
        user.coordinates = [user_profile['lng'].to_f, user_profile['lat'].to_f]
      end
      user.user_profile = prof
      user.save(validate: false)
      puts "Migrated #{user.nickname} - Coords: #{has_coords}"
    end
  end


  # Thread_id = communication
  # parent_id = last message
  #
  #p missing_profiles
  #p countries
  # Your code goes here
end

desc "Migrate the messages."
task :migrate_basic_messages => :environment do
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "2d4l", :password => "")
  assoc = {}
  User.all.each do |u|
    assoc[u.import_user_id] = u
  end
  messages = client.query("SELECT DISTINCT(thread_id) FROM postman_message WHERE thread_id IS NOT NULL")
  messages.each do |msg|
    #puts "FROM: #{assoc[msg['sender_id']].nickname} TO: #{assoc[msg['recipient_id']].nickname}"
    # if sender archived or deleted, do not add to mailbox?
    msgs_in_thread = client.query("SELECT * FROM postman_message WHERE thread_id = #{msg['thread_id']}")
    puts "*" * 40
    puts "Working on thread #{msg['thread_id']}"
    msgs_in_thread.each do |m|
      next if assoc[m['sender_id']].nil? || assoc[m['recipient_id']].nil?
      puts "\t FROM: #{assoc[m['sender_id']].nickname}"
    end
    # one communication for each user (unless deleted or archived)
    # message is assigned to the same communications.
  end
end