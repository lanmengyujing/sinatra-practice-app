require 'sinatra'
require 'slim'

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'
  set :static, true
  set :public_dir, File.dirname(__FILE__) + '/public/views'

  get '/show-task' do
    #'Hello world!'
    slim :index
  end

  get '/:task' do
    @task = params[:task].split('-').join(' ').capitalize
    slim :task
  end

  post '/show-task' do
    @task =  params[:task]
    slim :task
  end


end


