#Controller for the item routes. Can view, create, edit, and delete all items
class ItemsController < ApplicationController

  get '/items' do #item index route
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      @items = Item.all
      erb :'/items/items'
    end
  end

  get '/items/new' do #create action
    if !logged_in?
      redirect '/login'
    else
      erb :'/items/new'
    end
  end

  post '/items' do #create action
    if params[:title] == "" || params[:description] == "" || params[:price] == ""
      redirect '/items/new'
    else
      current_user.items.create(title: params[:title], description: params[:description], price: params[:price])
      redirect '/items'
    end
  end

  get '/items/:id' do #show action
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      @item = Item.find_by_id(params[:id])
      erb :'/items/show'
    end
  end

  get '/items/:id/edit' do #edit action
    if !logged_in?
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
      if auth_for_control?(@item)
        @item.title = params[:title]
        @item.description = params[:description]
        @item.price = params[:price]
        @item.save
        redirect "/items/#{@item.id}"
      else
        redirect "/items/#{@item.id}/edit"
      end
    end
  end

  delete '/items/:id' do #delete action
    @item = Item.find_by_id(params[:id])
    if auth_for_control?(@item)
      @item.delete
      redirect '/items'
    else
      redirect '/items'
    end
  end

end
