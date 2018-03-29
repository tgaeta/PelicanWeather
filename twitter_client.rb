# frozen_string_literal: true

require 'twitter'
require 'yaml'

class TwitterClient
  CONFIG = YAML.load_file('config.yaml')

  def self.client
    Twitter::REST::Client.new do |c|
      c.consumer_key        = CONFIG['twitter_consumer_key']
      c.consumer_secret     = CONFIG['twitter_consumer_secret']
      c.access_token        = CONFIG['twitter_access_token']
      c.access_token_secret = CONFIG['twitter_access_token_secret']
    end
  end
end
