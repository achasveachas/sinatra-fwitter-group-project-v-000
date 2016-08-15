class UsersController < ApplicationController
  enable :sessions
  set :session_secret, 'fwitter'
  set :public_folder, 'public'
  set :views, 'app/views'

# Displayse the "Sign Up" form and creates a new user
  get '/signup' do
    redirect '/tweets' if logged_in?
    erb :'users/create'
  end

  post '/signup' do
    redirect '/signup' if params['username'] == "" || params['email'] == "" || params['password'] == ""
    user = User.create
    user.username = params['username']
    user.password = params['password']
    user.email = params['email']
    user.save
    session[:user] = user.username
    redirect '/tweets'
  end

# Displayse the "Log In" form and logs in user
  get '/login' do
    redirect '/tweets' if logged_in?
    erb :'users/login'
  end

  post '/login' do
    redirect '/login' if params['username'] == "" || params['password'] == ""
    login(params['username'], params['password'])
    redirect '/tweets'
  end

# Logs out user
  get '/logout' do
    logout!
    redirect '/login'
  end

# Displays individual user's tweets
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @tweets = Tweet.collect { |tweet| tweet.user_id == @user.id }
    erb :'/tweets/tweets'
  end
end
