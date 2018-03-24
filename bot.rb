#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gemoji'
require 'pry'
load    'twitter_client.rb'
load    'dark_sky.rb'
load    'locations.rb'

emojis_by_icon = {
  'clear-day'           => 'sunny',
  'clear-night'         => 'milky_way',
  'rain'                => 'umbrella',
  'snow'                => 'snowflake',
  'sleet'               => 'snowman',
  'wind'                => 'cyclone',
  'fog'                 => 'foggy',
  'cloudy'              => 'cloud',
  'partly-cloudy-day'   => 'partly_sunny',
  'partly-cloudy-night' => 'partly_sunny',
  'hail'                => 'cat',
  'thunderstorm'        => 'zap',
  'tornado'             => 'bangbang',
}

Locations.bay_area.each do |loc, lat_long|
  location           = ForecastIO.forecast(lat_long[0], lat_long[1])
  alert              = location.alerts&.first
  current_weather    = location.currently
  emoji_alias        = emojis_by_icon.fetch(current_weather.icon, 'sunny')
  icon               = Emoji.find_by_alias(emoji_alias).raw

  tweet = format("Currently in #{loc} it's %{temperature}° & %{summary} %{icon}",
                 temperature: current_weather.temperature.round,
                 summary: current_weather.summary.downcase,
                 icon: icon)

  TwitterClient.client.update(tweet)

  if alert
    alert = format("%{alert_title} in #{loc} %{icon} - Expires %{expires}",
                   alert_title: alert&.title,
                   expires: Time.at(alert&.expires),
                   icon: Emoji.find_by_alias('scream_cat').raw)
    TwitterClient.client.update(alert)
  end
end
