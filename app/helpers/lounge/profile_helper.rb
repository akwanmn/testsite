module Lounge::ProfileHelper
  def sorted_timezones
    ActiveSupport::TimeZone::MAPPING.sort_by { |k,v| k }
  end
end
