#!/usr/bin/env ruby
require 'slack-ruby-client'
require 'oj'
require 'async'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

data = Oj.load_file 'all.json'
client = Slack::RealTime::Client.new

def card_link card
  "<http://gatherer.wizards.com/Handlers/Image.ashx?type=card&multiverseid=#{card["card_id"]}|[#{card["name"]}]>"
end

client.on :message do |msg|
  if msg.channel == "C0U7FHW66" && msg.text =~ /\[\[([^:]+)(?::(\w{2}))?\]\]/
    key = $1.downcase.delete(" ,’'")
    cards = data.select{|x| x.include? key}

    if data[key] || cards.count == 1
      exact = data[key] || cards.values.first
      exact = data[exact["key_#{$2}"]] if $2
      if data[exact["key_en"]]["back"]
        back = data[data[data[exact["key_en"]]["back"]]["key_#{exact["lang"]}"]]
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "#{card_link(exact)} <=> #{card_link(back)}"
      else
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: card_link(exact)
      end
    else
      if cards.count > 20
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: "#{cards.count}장의 검색결과가 있습니다."
      elsif cards.count > 0
        client.web_client.chat_postMessage username: "매직봇", channel: msg.channel, text: cards.map{|k, v| card_link(v)}.join(" "), unfurl_media: false
      end
    end
  end
end

client.start!