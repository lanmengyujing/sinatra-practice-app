require 'sinatra'
require 'slim'
require 'sinatra/activerecord'
require './environments'

require_relative 'app/models/user'
require_relative 'app/models/post'



class MyApp < Sinatra::Base
  use Rack::Session::Pool, :expire_after => 2592000
  set :sessions, true
  set :static, true
  set :views, File.dirname(__FILE__) + '/app/views'

  set :username, nil
  set :password, nil
  set :token, 'maketh1$longandh@rdtoremember'

  helpers do
    def admin?
      request.cookies[settings.username] == settings.token
    end

    def signed_up?
      !settings.username.nil?
    end

    def protected!
      halt [401, 'Not Authorized'] unless admin?
    end
  end

  get '/' do
    slim :index
  end

  get '/admin' do
    slim :admin
  end

  post '/login' do
    user = User.find_by(name: params['username'])
    if user && user.name == params['username']
        settings.username = params['username']
        response.set_cookie(params['username'], settings.token)
      redirect '/private'
    else
      "Username or Password incorrect"
    end
  end

  get '/logout' do
    response.set_cookie(settings.username, false)
    redirect '/'
  end

  get '/private' do
    protected!
    'For Your Eyes Only!'
  end

  get '/sign' do
    slim :sign
  end

  post '/sign' do
    @user = User.new(name: params['username'], password: params['password'])
    if @user.save
      redirect "/"
    else
      redirect "/sign"
    end
  end

  get "/post" do
    @posts = Post.order("created_at DESC")

    slim :posts
  end
end


