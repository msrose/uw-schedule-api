require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'net/http'
require 'uri'
require 'nokogiri'

require_relative './schedule-generator/generator'

global_config = JSON.parse(File.open('./config.json').read)

configure do
  enable :cross_origin
end

options '/' do
  'OK'
end

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

options '/search' do
  'OK'
end

get '/search' do
  search_params = {
    'level' => 'under',
    'subject' => (params['subject'] || '').upcase,
    'cournum' => params['cournum'],
    'sess' => params['term']
  }
  uri = URI('http://www.adm.uwaterloo.ca/cgi-bin/cgiwrap/infocour/salook.pl')
  res = Net::HTTP.post_form(uri, search_params)
  table = Nokogiri::HTML(res.body).at('table')
  body = nil
  if table
    body = table.to_html.gsub('&amp;nbsp', '&nbsp')
  else
    body = 'No results'
  end
  [res.code.to_i, body]
end
