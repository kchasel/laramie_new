# require 'grackle'

class Tweet < ActiveRecord::Base
  MY_APPLICATION_NAME = "nlralliance"
  
  def self.get_latest
    tweets = client.statuses.user_timeline? :count => 20
    tweets.each do |t|
      created = DateTime.parse(t.created_at)
      unless Tweet.exists?(["created_at=?", created])
        Tweet.create({:text => t.text, :created_at => created})
      end
    end
  end
  
  private
  
  def self.client
    Grackle::Client.new(:auth => {
      :type => :oauth,
      :consumer_key => "1z0O2TZUQCSGSwVyPyq77g",
      :consumer_secret => "oSbDgGIeqHwJdWZAe0O4WaZ5OUPVaTj0Bz9YXKG1k",
      :token => "241061434-9ioidFfbojg7r6dRMN70xzT1Zk1yCQJ7dz3UtTH9",
      :token_secret => "Rf0leJS4pkCMwvna5YklReb5ytJBvtxCgqQmR8YE"
    })
  end
end