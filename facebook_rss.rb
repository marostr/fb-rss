require_relative 'graph_api'
require_relative 'facebook_rss_generator'

class FacebookRSS
  attr_reader :fb_page

  def initialize(fb_page)
    @fb_page = fb_page
  end

  def call
    api = GraphAPI.new
    details = api.details(fb_page)
    feed = api.feed(details['id'])

    generate_rss(details, feed)
  end

  private

  def generate_rss(details, feed)
    FacebookRSSGenerator.new(details, feed).call.to_s
  end
end
