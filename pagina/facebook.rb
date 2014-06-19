require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'
require "haml"
#TODO require 'omniauth-att'

class SinatraApp < Sinatra::Base


  configure do
    set :sessions, true
    set :inline_templates, true
  end
  use OmniAuth::Builder do
    provider :facebook, '475837809228613','f76490e12fd6972ae282591b82bbaced'
    #provider :att, 'client_id', 'client_secret', :callback_url => (ENV['BASE_DOMAIN']

  end
  
  get '/' do
    haml :index
  end
  
  get '/auth/:provider/callback' do
    usuario = request.env['omniauth.auth']
    nombre = usuario["info"]["name"]
    email = usuario["info"]["email"]
    arch = File.open('res.txt', 'w')
    arch.write(nombre+email)
    arch.close()
    session[:authenticated] = true
    redirect "/inicio"
  end

  get "/inicio" do
    erb "holis"

  end
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end
  
  get '/logout' do
    session[:authenticated] = false
    redirect '/'
  end

end

SinatraApp.run! if __FILE__ == $0