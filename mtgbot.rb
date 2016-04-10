require 'slack-ruby-client'
require 'oj'
require 'pry'
require 'dotenv'

Dotenv.load

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

data = Oj.load_file 'korean.json'
client = Slack::RealTime::Client.new
url = "http://gatherer.wizards.com/Handlers/Image.ashx?type=card&multiverseid="
client.on :message do |msg|
  if msg.channel == "C0U7FHW66" && msg.text =~ /\[\[(.+)\]\]/
    if data[$1]
      client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "<#{url}#{data[$1]}|#{$1}>"
    end
  end
end

client.start!
