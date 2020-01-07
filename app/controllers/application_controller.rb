require './config/environment'
#Main controller, can view initial route, allows users to sign up, sign in, and sign out.
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do #initial route
    erb :index
  end

  get '/signup' do #sign up action
    if session[:user_id] != nil
      redirect '/items'
    else
      erb :signup
    end
  end

  post '/signup' do #sign up action
    if params["username"] == "" || params["email"] == "" || params["password"] == ""
      redirect '/signup'
    else
      #does not allow user to make an account with the same username as another account
      if User.find_by(username: params["username"])
        redirect '/signup'
      else
        @user = User.new(username: params["username"], email: params["email"], password: params["password"])
        @user.save
        session[:user_id] = @user.id
        redirect '/items'
      end
    end
  end

  get '/login' do #login action
    if session[:user_id] != nil
      redirect '/items'
    else
      erb :login
    end
  end

  post '/login' do #login action
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/items"
    else
      redirect "/login"
    end
  end

  get '/logout' do #logout action
    if session[:user_id] == nil
      redirect '/'
    else
      session.clear
      redirect '/login'
    end
  end

  post '/logout' do #logout action
    session.clear
    redirect '/login'
  end
end
