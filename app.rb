require 'sinatra/base'
require 'sinatra/contrib'
require 'slim'
require 'yaml'
require 'sequel'
require 'json'

class RankingServer < Sinatra::Base
  register Sinatra::Contrib

  get '/' do
    slim :index
  end

  post '/' do
    connect_opt = YAML.load_file("./config/config.yml")
    DB = Sequel.postgres('ggjsap2016-t3', connect_opt)

    result = JSON.parse(params[:result])

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

  helpers do
    def page_title(title = nil)
      @title = title if title
      @title ? "#{@title} - GGJ Sapporo 2016 Team3" : "GGJ Sapporo 2016 Team3"
    end
  end
end
