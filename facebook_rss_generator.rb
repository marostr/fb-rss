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
        next if guest_post?(feed_entry)
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

  # Sometimes story is a note publication, cover image change like:
  # "Someone updated their cover photo." or "Someone published a note."
  # Yet sometimes it's guest post:
  # "Someone shared a photo to someone's Timeline."
  # This method should filter such posts
  def guest_post?(feed_entry)
    feed_entry.has_key?('story') && feed_entry['story'].include?('Timeline.')
  end

  def facebook_link(id)
    "https://www.facebook.com/#{id}"
  end

  def format_description(description)
    '<br />' + description.gsub("\n", '<br />') + '<br />'
  end
end
