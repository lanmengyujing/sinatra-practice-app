require 'sinatra'
require 'slim'

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'
  set :static, true

  set :username, ''
  set :token, 'maketh1$longandh@rdtoremember'
  set :password, ''

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
    if params['username']==settings.username&&params['password']==settings.password
      response.set_cookie(settings.username, settings.token)
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
    settings.username = params['username']
    settings.password = params['password']
    redirect '/'
  end

#register do
#  def auth (type)
#    condition do
#      redirect "/login" unless send("is_#{type}?")
#    end
#  end
#end
#
#helpers do
#  def is_user?
#    @user != nil
#  end
#end
#
#before do
#  @user = User.get(session[:user_id])
#end
#
#get "/" do
#  "Hello, anonymous."
#end
#
#get "/protected", :auth => :user do
#  "Hello, #{@user.name}."
#end
#
#post "/login" do
#  session[:user_id] = User.authenticate(params).id
#end
#
#get "/logout" do
#  session[:user_id] = nil
#end

end


