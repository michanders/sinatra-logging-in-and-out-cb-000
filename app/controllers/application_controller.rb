require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    if @user = User.find_by(username: params["username"], password: params["password"])
      session[:user_id] = @user.id
      redirect to '/account'
    end
    erb :error
  end

  get '/account' do
    @user = User.find_by_id(session[:user_id])
    if Helpers.is_logged_in?(session) == true
      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end


end
