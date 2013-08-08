module Lounge::ProfileHelper
  # sort them alphabetically.
  def sorted_timezones
    ActiveSupport::TimeZone::MAPPING.sort_by { |k,v| k }
  end
end
