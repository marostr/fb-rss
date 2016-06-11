require 'rack'
require_relative 'facebook_rss'

class App
  def self.call(env)
    request = Rack::Request.new(env)
    fb_id = request.params['fb-id']
    if !fb_id.nil?
      [
        '200',
        { 'Content-Type' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' },
        [FacebookRSS.new(fb_id).call]
      ]
    else
      [
        '400',
        { 'Content-Type' => 'text/html' },
        ['Give me fb-id in url params!']
      ]
    end
  end
end

run App
