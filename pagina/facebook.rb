require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'
require "haml"
require "./Geokit.rb"
require "./Logica.rb"

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
  
  #la pagina que se utiliza para autenticar con facebook
  get '/auth/:provider/callback' do
    usuario = request.env['omniauth.auth'] #información que devuelve la API de facebook
    $nombre = usuario["info"]["name"] 
    $email = usuario["info"]["email"]
    $IDusuario = usuario["uid"]
    $imgPerfil = usuario["info"]["image"]
    arch = File.open('res.txt', 'w')
    session[:authenticated] = true
    redirect "/inicio"
  end
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"

  end
  

  #pagina de inicio cuando uno inicia sesión
  get '/inicio' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    haml :inicioSesion, :locals => {:nombre => "  "+$nombre, :imagen => $imgPerfil}
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

  get '/apartaAgregado' do
    haml :apartaAgregado, :locals => {:nombre => "  "+$nombre, :imagen => $imgPerfil}

  end

  post '/geocode' do
		a=buscar_ubicacion('Instituto tecnologico de costa rica')
		haml :results, :locals => {:resultados => a}
  end



##Aquí se recogen los datos del formulario y agrega el apartamento.
  post "/agregarAparta" do
    titulo = params[:titulo]
    desc = params[:descripcion]
    correo = params[:correo]
    telefono = params[:numeroTelefono]
    precio = params[:precioAparta]
    numCuartos = params[:cuartosAparta]
    tieneInternet = params[:internet]
    esCompartido = params[:comparte]

    apartamento = Apartamento.new(titulo,desc,"23G 00 N 08G 00 E",precio,telefono)
    apartamento.agrega_caracteristica("tiene #{numCuartos} cuartos")
    apartamento.agrega_caracteristica(" #{tieneInternet} incluye internet")
    apartamento.agrega_caracteristica(" #{esCompartido} es compatido")

    Apartamento.agregar_a_lista(apartamento)
    puts apartamento
    redirect "/apartaAgregado"
  end

#busqueda por precio
get "/buscarPrecio" do
  precio = params[:precio]
  #función que busca los apartas de cierto precio o menores
  "precio = #{precio}" #prueba recolección de datos
end

#busqueda por numero de cuartos

get "/buscarNumCuartos" do
  cuartos = params[:cuartos]
  #función que busca apartas con cierto numero de cuartos
  "cuartos = #{cuartos}"
end

get "/buscarInternet" do
  internet = params[:internetCuarto]

  "internet = #{internet}" #prueba recolección de datos
 
end

get "/buscarCompartido" do
  compartido = params[:CuartoCompartido]

  "compartido= #{compartido}" #prueba recolección de datos
end




end

SinatraApp.run! if __FILE__ == $0
