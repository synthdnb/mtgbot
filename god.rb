God.watch do |w|
    w.name = "mtgbot"
    w.start = "bundle exec ruby /home/devenv/mtgbot/mtgbot.rb"
    w.log = "/home/devenv/mtgbot/stdout.log"
    w.dir = "/home/devenv/mtgbot"
    w.keepalive

end

