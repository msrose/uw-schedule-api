require 'sinatra'
require 'json'

require_relative './schedule-generator/generator'

global_config = JSON.parse(File.open('./config.json').read)

post '/' do
  body = {}
  begin
    body = JSON.parse(request.body.read)
  rescue
    return [400, 'Invalid JSON']
  end
  config = {
    'api_key' => global_config['api_key'],
  }
  attrs = ['title', 'colors', 'course_numbers', 'term']
  attrs.each do |attr|
    return [400, "No #{attr} provided"] unless body[attr]
    config[attr] = body[attr]
  end
  begin
    Generator.create_schedule(config)
  rescue Exception => e
    [400, "Error generating schedule: #{e.message}"]
  end
end
