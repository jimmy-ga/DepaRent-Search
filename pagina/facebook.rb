require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'
require "haml"
require "./Geokit.rb"
#TODO require 'omniauth-att'

class SinatraApp < Sinatra::Base

	set :bind, '0.0.0.0'
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
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/inicio' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    haml :inicioSesion
  end
  
  get '/logout' do
    session[:authenticated] = false
    redirect '/'
  end

	get '/mapaL' do
		#"Hello World"
		@a=buscar_ubicacion('Instituto tecnologico de costa rica')
    haml :mapa, :locals => {:resultados => @a}
  end

  post '/geocode' do
		a=buscar_ubicacion('Instituto tecnologico de costa rica')
		haml :results, :locals => {:resultados => a}
  end



##Aquí se recogen los datos del formulario y se devuelven en una página que todavía no está, es una prueba!
  post "/agregarAparta" do
    titulo = params[:titulo]
    desc = params[:descripcion]
    correo = params[:correo]
    telefono = params[:numeroTelefono]
    precio = params[:precioAparta]


    "nombre = #{titulo}, descripcion = #{desc}, correo = #{correo}, telefono = #{telefono}, precio = #{precio}"

  end

end

SinatraApp.run! if __FILE__ == $0
