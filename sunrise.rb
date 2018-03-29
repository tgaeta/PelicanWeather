#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'gemoji'
require 'pry'
load    'twitter_client.rb'
load    'dark_sky.rb'
load    'locations.rb'

rise = Emoji.find_by_alias('sunrise').raw
set  = Emoji.find_by_alias('city_sunset').raw

Locations.bay_area.each do |loc, lat_long|
  location    = ForecastIO.forecast(lat_long[0], lat_long[1])
  data        = location.daily.data.first
  outlook     = data.summary
  sunrise     = Time.at(data.sunriseTime)
  sunset      = Time.at(data.sunsetTime)

  if sunrise.strftime('%H:%M') == Time.now.strftime('%H:%M')
    event = "sunrise #{rise}"
  elsif sunset.strftime('%H:%M') == Time.now.strftime('%H:%M')
    event = "sunset #{set}"
  end

  if event.nil?
    puts 'Not sunrise or sunset time yet'
    exit
  else
    time_of_day = event.include?('rise') ? 'morning' : 'evening'
    tweet = "Good #{time_of_day}, #{loc}. It's #{event}. Outlook: #{outlook}"
    TwitterClient.client.update(tweet)
  end
end
