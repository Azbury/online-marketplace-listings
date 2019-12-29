require './config/environment'


use Rack::MethodOverride
use ItemsController
use UsersController
run ApplicationController
