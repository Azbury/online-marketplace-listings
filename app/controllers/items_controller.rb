class ItemsController < ApplicationController

  get '/items' do
    if session[:user_id] == nil
      redirect '/login'
    else
      @items = Item.all
      erb :'/items/items'
    end
  end

  get '/items/new' do
    if session[:user_id] == nil
      redirect '/login'
    else
      erb :'/items/new'
    end
  end

end
