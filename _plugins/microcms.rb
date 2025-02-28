require 'json'
require 'open-uri'

begin
  # 環境変数取得
  api_key = ENV.fetch('MICROCMS_API_KEY', nil)
  raise '!!! ERROR: MICROCMS_API_KEY is not set in .env' if api_key.nil? || api_key.empty?

  # ニュースを取得
  response = URI.open('https://64pub3ju4u.microcms.io/api/v1/news?limit=100', 'X-MICROCMS-API-KEY' => api_key).read
  news_data = JSON.parse(response)
  File.write('_data/news.json', JSON.pretty_generate(news_data['contents']))
rescue StandardError => e
  puts "!!! MicroCMS Plugin Error: #{e.message}"
  puts e.backtrace
  exit 1
end
