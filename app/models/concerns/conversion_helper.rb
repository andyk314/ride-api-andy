module ConversionHelper
  METERS_TO_MILES = 0.000621
  SECONDS_IN_HOUR = 3600
  MINUTES_IN_HOUR = 60

  def meters_to_miles(distance_in_meters)
    distance_in_meters.to_f * METERS_TO_MILES
  end

  def seconds_to_hours(duration_in_seconds)
    (duration_in_seconds.to_f / SECONDS_IN_HOUR)
  end

  def seconds_to_minutes(duration_in_seconds)
    (duration_in_seconds.to_f / MINUTES_IN_HOUR)
  end
end