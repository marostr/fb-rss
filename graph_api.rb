require 'koala'

class GraphAPI
  attr_reader :graph_api_client

  def initialize
    @graph_api_client = Koala::Facebook::API.new(ENV['FB_ACCESS_TOKEN'])
  end

  def details(page)
    graph_api_client.get_object(page)
  end

  def feed(page_id)
    graph_api_client.get_connections(page_id, 'feed')
      .reject { |feed_entry| feed_entry['message'].nil? }
  end
end
