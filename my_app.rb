require 'sinatra'
require 'slim'

class MyApp < Sinatra::Base
  set :sessions, true
  set :static, true

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
    if settings.username && settings.password && params['username']==settings.username&&params['password']==settings.password
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
end


