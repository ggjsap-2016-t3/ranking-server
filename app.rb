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

  end

  helpers do
    def page_title(title = nil)
      @title = title if title
      @title ? "#{@title} - GGJ Sapporo 2016 Team3" : "GGJ Sapporo 2016 Team3"
    end
  end
end
