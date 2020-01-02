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

  post '/items' do
    if params[:title] == "" || params[:description] == "" || params[:price] == ""
      redirect '/items/new'
    else
      Item.create(title: params[:title], description: params[:description], price: params[:price], user_id: session[:user_id])
      redirect '/items'
    end
  end

  get '/items/:id' do
    if session[:user_id] == nil
      redirect '/login'
    else
      @item = Item.find_by_id(params[:id])
      erb :'/items/show'
    end
  end

end
