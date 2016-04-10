require 'slack-ruby-client'
require 'oj'
require 'pry'
require 'dotenv'

Dotenv.load

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

data = Oj.load_file 'all.json'
client = Slack::RealTime::Client.new
url = "http://gatherer.wizards.com/Handlers/Image.ashx?type=card&multiverseid="
client.on :message do |msg|
  if msg.channel == "C0U7FHW66" && msg.text =~ /\[\[(.+)\]\]/
    key = $1.downcase.delete(" ").delete(",")
    cards = data.select{|x| x.include? key}

    if data[key]
      client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "<#{url}#{data[key]["card_id"]}|#{data[key]["name"]}>"
    else
      if cards.count > 20
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "#{cards.count}장의 검색결과가 있습니다."
      elsif cards.count > 0
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: cards.map{|k, v| "<#{url}#{v["card_id"]}|#{v["name"]}>"}.join(", "), unfurl_media: cards.count == 1
      end
    end
  end
end

client.start!
