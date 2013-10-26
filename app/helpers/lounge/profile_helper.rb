module Lounge::ProfileHelper
  # sort them alphabetically.
  def sorted_timezones
    ActiveSupport::TimeZone::MAPPING.sort_by { |k,v| k }
  end

  def show_even_options(options)
    step = 2
    options.select {|k| k[1].to_i % step == 0 }
  end

  def show_odd_options(options)
    step = 2
    options.select {|k| k[1].to_i % step == 1 }
  end

  def marital_status(user_profile)
    find_option MARITAL_STATUS, user_profile.marital_status
  end

  def fitness_status(user_profile)
    find_option HEALTH_FITNESS, user_profile.health_fitness
  end

  def children(user_profile)
    find_option CHILDREN, user_profile.children
  end

  def reading(user_profile)
    find_option BOOKS_READING, user_profile.reading
  end

  def nightlife(user_profile)
    items = []
    NIGHTLIFE.each do |nl|
      items << nl[0] if user_profile.nightlife.include?(nl[1])
    end
    items
  end

  def outdoor_activities(user_profile)
    items = []
    OUTDOOR_ACTIVITIES.each do |nl|
      items << nl[0] if user_profile.outdoor_activities.include?(nl[1])
    end
    items
  end

  def drinking(user_profile)
    find_option DRINKING, user_profile.drinking
  end

  def travel(user_profile)
    find_option TRAVEL, user_profile.travel
  end

  def career(user_profile)
    find_option CAREER, user_profile.career
  end

  def smoking(user_profile)
    find_option SMOKING, user_profile.smoking
  end

  def eating(user_profile)
    find_option EATING, user_profile.eating
  end

  def politics(user_profile)
    find_option POLITICS, user_profile.politics
  end

  # look up an option from a constant.
  def find_option(constant, value)
    constant.select {|l| l[1] == value.to_s }[0][0]
  end

end
