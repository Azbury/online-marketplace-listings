class UsersController < ApplicationController
  get '/users/:slug' do #user profile pages
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end
