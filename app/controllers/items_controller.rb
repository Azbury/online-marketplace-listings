#Controller for the item routes. Can view, create, edit, and delete all items
class ItemsController < ApplicationController

  get '/items' do #item index route
    if session[:user_id] == nil
      redirect '/login'
    else
      @user = User.find_by_id(session[:user_id])
      @items = Item.all
      erb :'/items/items'
    end
  end

  get '/items/new' do #create action
    if session[:user_id] == nil
      redirect '/login'
    else
      erb :'/items/new'
    end
  end

  post '/items' do #create action
    if params[:title] == "" || params[:description] == "" || params[:price] == ""
      redirect '/items/new'
    else
      Item.create(title: params[:title], description: params[:description], price: params[:price], user_id: session[:user_id])
      redirect '/items'
    end
  end

  get '/items/:id' do #show action
    if session[:user_id] == nil
      redirect '/login'
    else
      @user = User.find_by_id(session[:user_id])
      @item = Item.find_by_id(params[:id])
      erb :'/items/show'
    end
  end

  get '/items/:id/edit' do #edit action
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

  delete '/items/:id' do #delete action
    @item = Item.find_by_id(params[:id])
    if @item.user_id != session[:user_id]
      redirect '/items'
    else
      @item.delete
      redirect '/items'
    end
  end

end
