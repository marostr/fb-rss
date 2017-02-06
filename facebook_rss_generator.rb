require 'rss'

class FacebookRSSGenerator
  attr_reader :details, :feed

  def initialize(details, feed)
    @details = details
    @feed = feed
  end

  def call
    RSS::Maker.make('atom') do |maker|
      maker.channel.author = details['name']
      maker.channel.updated = feed.first['created_time']
      maker.channel.about = facebook_link(details['id'])
      maker.channel.title = details['name']

      feed.each do |feed_entry|
        maker.items.new_item do |item|
          item.id = feed_entry['id']
          item.link = facebook_link(feed_entry['id'])
          item.title = feed_entry['message'][0..100]
          item.updated = feed_entry['created_time']
          item.description = format_description(feed_entry['message'])
        end
      end
    end
  end

  private

  def facebook_link(id)
    "https://www.facebook.com/#{id}"
  end

  def format_description(description)
    '<br />' + description.gsub("\n", '<br />') + '<br />'
  end
end
