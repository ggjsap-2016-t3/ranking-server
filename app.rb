require 'sinatra/base'
require 'sinatra/contrib'
require "sinatra/reloader"
require 'slim'
require 'yaml'
require 'sequel'
require 'json'

class RankingServer < Sinatra::Base
  register Sinatra::Contrib

	configure :development do
		register Sinatra::Reloader
	end

	get '/' do
		#File.read(File.join('public', 'index.html'))
	end

  post '/', provides: :json do
    connect_opt = YAML.load_file("./config/config.yml")
    DB = Sequel.postgres('ggjsap2016-t3', connect_opt)

		result = JSON.parse(request.body.read)["result"]

    unless DB.table_exists?(:results)
      DB.create_table :results do
        String :user, primary_key: true
        Integer :left
      end
    end

    DB.transaction do
      # UPSERT
      if DB[:results].where(user: result["user"]).update(left: result["left"]) == 0
        DB[:results].insert(user: result["user"], left: result["left"])
      end
    end
    "OK"
  end

  get '/ranking' do
    @results = []
    10.times do
      @results << Result.new("a" * rand(1..10), 1, rand(1..10))
    end
    slim :ranking
  end

  helpers do
    def page_title(title = nil)
      @title = title if title
      @title ? "#{@title} - GGJ Sapporo 2016 Team3" : "GGJ Sapporo 2016 Team3"
    end
  end
end

class Result
  attr_accessor :user
  attr_accessor :stage
  attr_accessor :left

  def initialize(user, stage, left)
    @user = user
    @stage = stage
    @left = left
  end
end

