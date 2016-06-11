require 'rack'
require_relative 'facebook_rss'

use Rack::Static,
  urls: ['/images', '/css'],
  root: 'public'

class App
  def self.call(env)
    request = Rack::Request.new(env)
    fb_id = request.params['fb-id']
    if !fb_id.nil?
      [
        '200',
        {
          'Content-Type' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Cache-Control' => 'public, max-age=3000'
        },
        [FacebookRSS.new(fb_id).call]
      ]
    else
      [
        '200',
        {
          'Content-Type' => 'text/html',
          'Cache-Control' => 'public, max-age=86400'
        },
        File.open('public/index.html', File::RDONLY)
      ]
    end
  end
end

run App
