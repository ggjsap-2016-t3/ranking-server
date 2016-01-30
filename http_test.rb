require 'net/http'
require 'json'

req = Net::HTTP::Post.new '/'
params = {user: "mktakuya", stage: 1, left: 15}
req.set_form_data({result: params.to_json})
res = Net::HTTP.start('localhost', 9393) { |http| http.request req }
puts res

