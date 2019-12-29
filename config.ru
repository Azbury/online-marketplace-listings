require './config/environment'


use Rack::MethodOverride
#use ListingsController
#use UsersController
run ApplicationController
