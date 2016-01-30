require 'sinatra/base'
require 'sinatra/contrib'
require 'slim'
require 'yaml'

class RankingServer < Sinatra::Base
  register Sinatra::Contrib

  get '/' do
    slim :index
  end

  post '/' do
    connect_opt = YAML.load_file("./config/config.yml")
    DB = Sequel.postgres('ggjsap2016-t3', connect_opt)

    result_json = params[:result]
    result = JSON.parse(result_json)
    unless DB.table_exists?(:results)
      DB.create_table :results do
        String :user, primary_key: true
        Integer :stage
        Integer :left
      end
    end
    results = DB[:results]
    results.insert(user: result[:user], stage: result[:stage], left: result[:left])
  end

  helpers do
    def page_title(title = nil)
      @title = title if title
      @title ? "#{@title} - GGJ Sapporo 2016 Team3" : "GGJ Sapporo 2016 Team3"
    end
  end
end
