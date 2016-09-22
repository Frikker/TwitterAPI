
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'twitter'
require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: twitter.rb'

  opt.on('-h', 'Вывод помощи по настройкам') do
    puts opt
    exit
  end

  opt.on('--twit "TWIT"','Затвитить "Твит"') {|o| options[tweet] = o}
  opt.on('--timeline USER_NAME', 'Показать последние твиты') {|o| options[:timeline] = o}
end.parse!

client = Twitter::REST::Client.new do |config|
  config.consumer_key = 'L6HQUYRKC60bkLoVZ3i41sH2T'
  config.consumer_secret = '1o7dJ1kEbkNkpcgaWUuLGZ9urujy7CtihW96cFscW9Lc9opBYV'
  config.access_token = '737306948954169344-qjQZBgIjj69N6PZRQke1acuFIAxxk76'
  config.access_token_secret = '2uSuldEnCDXnIs1ekLGbqDRhEwmhjrto1NCWOJlAnARkw'
end

if options.key?(:twit)
  puts "Постим твит #{options[:twit]}"
  client.update(options[:twit]).encode('UTF-8')
  puts 'Твит отправлен'
end

if options.key?(:timeline)
  puts "Лента пользователя: #{options[:timeline]}"
  opts = {count: 7, include_rts: true}
  twits = client.user_timeline(options[:timeline], opts)
  twits.each do |twit|
    puts twit.text
    puts "by @#{twit.user.screen_name}, #{twit.created_at}"
    puts "-"*40
  end
else
  puts "Моя лента:"
  twits = client.home_timeline(count: 5)
  twits.each do |twit|
    puts twit.text
    puts "by @#{twit.user.screen_name}, #{twit.created_at}"
    puts "-"*40
  end
end