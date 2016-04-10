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
    cards = data.keys.select{|x| x.include? $1}
    if data[$1]
      client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "<#{url}#{data[$1]}|#{$1}>"
    else
      if cards.count > 20
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "#{cards.count}장의 검색결과가 있습니다."
      elsif cards.count > 0
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: cards.map{|k| "<#{url}#{data[k]}|#{k}>"}.join(", "), unfurl_media: cards.count == 1
      end
    end
  end
end

client.start!
