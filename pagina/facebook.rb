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
require "./mysql.rb"
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
    haml :error

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
    apartamento.agrega_facilidad("tiene #{numCuartos} cuartos")
    apartamento.agrega_facilidad("#{tieneInternet} incluye internet")
    apartamento.agrega_facilidad("#{esCompartido} es compatido")
    linea=inserta_depa(titulo,desc,telefono,precio,numCuartos,tieneInternet,esCompartido)
		puts linea

    Apartamento.agregar_a_lista(apartamento)
    puts apartamento
    redirect "/apartaAgregado"
  end

#busqueda por precio
get "/buscarPrecio" do
  precio = params[:precio]
  lista = Apartamento.Sort_Menor_a_Mayor()
  #función que busca los apartas de cierto precio o menores
  contador = 0

  listaMenores = []
  while contador < lista.length
    if lista[contador].getPrecio.to_i < precio.to_i
      listaMenores=listaMenores + [lista[contador]]
    end
    contador = contador+1
  end

    haml :resultados,:locals => {:resultados => listaMenores}

end

#busqueda por numero de cuartos

get "/resultados" do
 haml :resultados, :locals => {:resultados => $lista_apartamentos}
end


get "/buscarNumCuartos" do
  cuartos = params[:cuartos]
  lista = Buscador.buscar_en_lista(["tiene #{cuartos} cuartos"])

  if lista == []
    haml :resultados, :locals => {:resultados => lista}
  end
  #función que busca apartas con cierto numero de cuartos
  haml :resultados, :locals => {:resultados => lista}
end

get "/buscarInternet" do
  internet = params[:internetCuarto]
  lista =Buscador.buscar_en_lista(["#{internet} incluye internet"])
  haml :resultados, :locals => {:resultados => lista}
 
end

get "/buscarCompartido" do
  compartido = params[:CuartoCompartido]
  lista = Buscador.buscar_en_lista(["#{compartido} es compatido"])
  haml :resultados, :locals => {:resultados => lista}
end




end

SinatraApp.run! if __FILE__ == $0
