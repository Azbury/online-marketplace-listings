require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if session[:user_id] != nil
      redirect '/items'
    else
      erb :signup
    end
  end

  post '/signup' do
    if params["username"] == "" || params["email"] == "" || params["password"] == ""
      redirect '/signup'
    else
      @user = User.new(username: params["username"], email: params["email"], password: params["password"])
      @user.save
      session[:user_id] = @user.id
      redirect '/items'
    end
  end

  get '/login' do
    if session[:user_id] != nil
      redirect '/items'
    else
      erb :login
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/items"
    else
      redirect "/login"
    end
  end

  get '/logout' do
    if session[:user_id] == nil
      redirect '/'
    else
      session.clear
      redirect '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect '/login'
  end
end
