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

end
