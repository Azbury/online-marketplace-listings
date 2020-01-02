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

  get '/items/:id/edit' do
    if session[:user_id] == nil
      redirect '/login'
    else
      @item = Item.find_by_id(params[:id])
      erb :'items/edit'
    end
  end

  patch '/items/:id' do #edit action
    if params[:title] == "" || params[:description] == "" || params[:price] == ""
      redirect "/items/#{params[:id]}/edit"
    else
      @item = Item.find_by_id(params[:id])
      @item.title = params[:title]
      @item.description = params[:description]
      @item.price = params[:price]
      @item.save
      redirect "/items/#{@item.id}"
    end
  end

end
