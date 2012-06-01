require 'json'
require 'geoloqi'
require 'highline/import'
require 'optparse'

# Put in your client ID and secret from
# https://developers.geoloqi.com
LQ_CLIENT_ID = nil
LQ_CLIENT_SECRET = nil 

options = {
  client_id: LQ_CLIENT_ID,
  client_secret: LQ_CLIENT_SECRET
}

OptionParser.new do |opts|
  opts.banner = "Usage: location-update.rb --file=history.json --rate=10 --start=0 --verbose"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-t", "--token=[TOKEN]", "Access token") do |t|
    options[:access_token] = t
  end

  opts.on("-w", "--wait=[WAIT]", "Maxium amount of time to wait between updates") do |w|
    options[:wait] = w.to_i || 300
  end

  opts.on("-s", "--start=[START]", Integer, "Start index") do |s|
    options[:start] = s
  end

  opts.on("-r", "--rate=[RATE]", Integer, "Playback rate") do |r|
    options[:playback_rate] = r
  end

  opts.on("-f", "--file=FILE", "History file") do |f|
    options[:file] = f
  end

  opts.on("-I", "--client_id=[ID]", "Application client_id") do |i|
    options[:client_id] = i
  end

  opts.on("-S", "--client_secret=[SECRET]", "Application client_secret") do |s|
    options[:client_secret] = s
  end

end.parse!

if options[:file].nil?
  puts "Usage: location-update.rb --file=filename.json"
  exit!
end

if options[:wait].nil?
  options[:wait] = 300
end

if !FileTest.exist?(options[:file])
  puts "File not found: #{options[:file]}"
  exit!
end

playback_rate = options[:playback_rate] || 5

if options[:client_id].nil?
  options[:client_id] = ask("Enter your applicaitons client_id:  ") { |q| q.echo = true }
end

if options[:client_secret].nil?
  options[:client_secret] = ask("Enter your applicaitons client_secret:  ") { |q| q.echo = true }
end

if options[:access_token].nil?
  username = ask("Enter your username:  ") { |q| q.echo = true }
  password = ask("Enter your password:  ") { |q| q.echo = "*" }
  geoloqi = Geoloqi::Session.new :access_token => nil, :config => {
    :client_id => options[:client_id],
    :client_secret =>  options[:client_secret]
  }
  geoloqi.establish :grant_type => 'password', :username => username, :password => password
else
  geoloqi = Geoloqi::Session.new :access_token => options[:access_token], :config => {
    :client_id => options[:client_id],
    :client_secret =>  options[:client_secret]
  }
end

profile = geoloqi.get 'account/profile'
puts 
puts "Logged in as #{profile[:username]}"
puts "Access token: #{geoloqi.access_token}"
puts

history = JSON.parse File.read(File.join(options[:file]))

start_index = options[:start]

while true do
  last_point = nil
  history['points'].each_with_index do |point,i|
    if last_point.nil? || (start_index && i < start_index)
      last_point = point
      next
    end

    last_time = Time.at last_point['date_ts']
    this_time = Time.at point['date_ts']

    diff = this_time - last_time
    
    diff = options[:wait] if diff > options[:wait]
    puts ""
    puts "Waiting #{diff} seconds..."

    sleep diff / playback_rate

    puts "Current point [#{i}] #{point['date_ts']} #{point['location']['position']['latitude']} #{point['location']['position']['longitude']}"

    last_point = point.clone
    new_point = point.clone

    new_point.delete 'uuid'
    new_point['date'] = Time.now
    new_point.delete 'date_ts'

    puts new_point.to_json if options[:verbose]
    puts ""
    response = geoloqi.post 'location/update', [new_point]
    puts response if options[:verbose]

  end
  start_index = 0
end

