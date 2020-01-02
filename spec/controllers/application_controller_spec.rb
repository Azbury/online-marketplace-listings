require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to The Online Marketplace")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to listing index' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/items")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      #user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/items')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the items index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/items")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in and redirects to the login page" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'redirects a user to the index page if the user tries to access /logout while not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")

    end

    it 'redirects a user to the login route if a user tries to access /items route if user not logged in' do
      get '/items'
      expect(last_response.location).to include("/login")
      expect(last_response.status).to eq(302)
    end

    it 'loads /items if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/items')
    end
  end

  describe 'user show page' do
    it 'shows all a single users items' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      item1 = Item.create(:title => "bird", :description => "makes bird sounds", :price => "$100", :user_id => user.id)
      item2 = Item.create(:title => "bird cage", :description => "keep that bird locked up", :price => "$50", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("bird")
      expect(last_response.body).to include("bird cage")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the items index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        item1 = Item.create(:title => "bird", :description => "makes bird sounds", :price => "$100", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        item2 = Item.create(:title => "bird cage", :description => "keep that bird locked up", :price => "$50", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/items"
        expect(page.body).to include(item1.title)
        expect(page.body).to include(item2.title)
      end
    end

    context 'logged out' do
      it 'does not let a user view the items index if not logged in' do
        get '/items'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new item if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/items/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets a user create a new item if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/items/new'
        fill_in(:title, :with => "dog")
        fill_in(:description, :with => "goes woof woof")
        fill_in(:price, :with => "$200")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        item = Item.find_by(:title => "dog")
        expect(item).to be_instance_of(Item)
        expect(item.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a new item from another users account' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/items/new'
        fill_in(:title, :with => "dog")
        fill_in(:description, :with => "goes woof woof")
        fill_in(:price, :with => "$200")
        click_button 'submit'

        user1 = User.find_by(:id => user1.id)
        user2 = User.find_by(:id => user2.id)
        item = Item.find_by(:title => "dog")
        expect(item).to be_instance_of(Item)
        expect(item.user_id).to eq(user1.id)
        expect(item.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank item' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/items/new'

        fill_in(:title, :with => "")
        fill_in(:description, :with => "goes woof woof")
        fill_in(:price, :with => "$200")
        click_button 'submit'

        expect(Item.find_by(:title => "")).to eq(nil)
        expect(page.current_path).to eq("/items/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new item form if not logged in' do
        get '/items/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

end
