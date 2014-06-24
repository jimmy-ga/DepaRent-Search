class Arrendario
	def initialize(nombre,correo,telefono,id) 
		@nombre = nombre
		@correo = correo
		@telefono = telefono
		@id = id
		@favoritos = []
	end

	def getNombre()
		@nombre
	end

	def getCorreo()
		@correo
	end

	def getTelefono()
		@telefono
	end

	def getID()
		@id
	end

	def getFavoritos()
		@favoritos
	end

	def quita_favorito(nombre)
		largo_lista = @favoritos.length
		while i < largo_lista
			if @favoritos[i].getTitulo == nombre.upcase
				@favoritos[i] = nil
				return "Borrado con exito!"
			end
		end
	end

	def agrega_favorito(apartamento)
		@favoritos = @favoritos + [apartamento]
	end
end

$lista_apartamentos = []

class Buscador
	def self.buscar_en_lista(obj)
		if obj == []
			return "No hay resultados para su busqueda"
		end
		obj = Buscador.lista_downcase(obj)
		faci = []
		ind = 0
		ind2 = 0
		while @@facilidades_globales.length > ind #Separa en listas de facilidades y de caracteristicas
			while obj.length > ind2
				if @@facilidades_globales[ind] == obj[ind2]
					faci[faci.length] = obj[ind2]
					obj[ind2] = nil
					break
				end
				ind2 = ind2 + 1
			end
			ind2 = 0
			ind = ind + 1
		end
		obj = Buscador.quita_nil(obj)
		Buscador.buscar_facilidad(faci,obj)
	end

	def self.buscar_facilidad(faci,car) #recibe lista
		lista_res = "No hay resultados para su busqueda"
		est = true
		for i in $lista_apartamentos
			if i.buscar_facilidad(faci)
				if est
					est = false
					lista_res = [i]
				else
					lista_res = lista_res + [i]
				end
			end
		end
		if car != nil
			Buscador.buscar_caracteristica(car,lista_res)
		else
			return lista_res
		end
	end

	def self.buscar_caracteristica(obj,lista) #recibe lista
		if lista[0] == "N"
			return lista
		end
		lista_res = "No hay resultados para su busqueda"
		est = true
		for i in lista
			if i.buscar_caracteristica(obj)
				if est
					est = false
					lista_res = [i]
				else
					lista_res = lista_res + [i]
				end
			end
		end
		return lista_res
	end

	def buscar_caracteristica(caracteristica) #recibe lista de caracteristicas y lista donde desea buscar
		lista_res = []
		lista_temp = []
		ind = 0
		ind2 = 0
		while caracteristica.length > ind2
			while @caracteristicas.length > ind
				caracteristica_de_lista = @caracteristicas[ind]
				if caracteristica[ind2] == caracteristica_de_lista
					lista_temp = lista_temp + [true]
					break
				elsif @caracteristicas.length == ind + 2 and caracteristica[ind2] != @caracteristicas[ind+1]
					lista_temp = lista_temp + [false]
					break
				end
				ind = ind + 1
			end
			lista_res = lista_res + [Apartamento.disyuncion(lista_temp)]
			ind2 = ind2 + 1
		end
		Apartamento.conjuncion(lista_res)
	end

	def buscar_facilidad(facilidad)
		lista_res = []
		lista_temp = []
		ind = 0
		ind2 = 0
		while facilidad.length > ind2
			while @facilidades.length > ind
				facilidad_de_lista = @facilidades[ind]
				if facilidad[ind2] == facilidad_de_lista
					lista_temp = lista_temp + [true]
					break
				elsif @facilidades.length == ind + 2 and facilidad[ind2] != @facilidades[ind+1]
					lista_temp = lista_temp + [false]
					break
				end
				ind = ind + 1
			end
			lista_res = lista_res + [Apartamento.disyuncion(lista_temp)]
			ind2 = ind2 + 1
		end
		Apartamento.conjuncion(lista_res)
	end

	def self.esta(lista,obj)
		for i in lista
			if i == obj
				return true
			end
		end
		false
	end

	def self.conjuncion(lista)
		for i in lista
			if not i
				return false
			end
		end
		true
	end

	def self.disyuncion(lista)
		for i in lista
			if i
				return true
			end
		end
		false
	end

	def self.lista_downcase(obj) #vuelve cada elemento de la lista en minusculas
		largo_lista = obj.length
		ind = 0
		while largo_lista > ind
			obj[ind] = obj[ind].downcase
			ind = ind + 1
		end
		obj
	end

	def self.quita_nil(obj) #vuelve cada elemento de la lista en minusculas
		largo_lista = obj.length
		ind = 0
		while largo_lista > ind
			if obj[ind] == nil and obj[ind+1] != nil
				obj[ind] = obj[ind+1]
				obj[ind+1] = nil
			end
			ind = ind + 1
		end
		ind = 0
		if obj[0] == nil
			return nil
		end
		while obj.length > ind
			if obj[ind] == nil
				obj = obj.slice(0..(ind-1))
				break
			end
			ind = ind + 1
		end
		obj
	end

	def self.ordenaPrecio(lista)
		lista_res = []
		if lista.length == 1
			return lista[0]
		else
			while i < lista.length
				
			end
		end
	end
end

class Apartamento < Buscador
	@@facilidades_globales =[]

	def initialize(titulo,descripcion,ubicacion,precio,id)
		@titulo = titulo.downcase
		@descripcion = descripcion.downcase
		@facilidades = []
		@caracteristicas = []
		@ubicacion = ubicacion.downcase
		@precio = precio
		@id = id
	end

	def agrega_facilidad(facilidad)
		@facilidades[@facilidades.length] = facilidad.downcase
		if not Apartamento.esta(@@facilidades_globales,facilidad.downcase)
			@@facilidades_globales = @@facilidades_globales + [facilidad.downcase]
		end
	end

	def agrega_caracteristica(caracteristica)
		@caracteristicas[@caracteristicas.length] = caracteristica.downcase
	end

	def self.agregar_a_lista(apartamento)
		$lista_apartamentos[$lista_apartamentos.length] = apartamento
		return "Se agrego #{apartamento.getTitulo} a la lista principal"
	end

	def getTitulo()
		@titulo.upcase
	end

	def getDescripcion()
		@descripcion.capitalize
	end

	def getPrecio()
		@precio
	end

	def getCaracteristicas()
		@caracteristicas
	end

	def getFacilidades()
		@facilidades
	end

	def getUbicacion()
		@ubicacion
	end

	def getID()
		@id
	end

	def self.Sort_Menor_a_Mayor(vector) #Primero el precio mas bajo hasta el precio mas alto
    	i=1
      	while i < vector.length
        	aux = vector[i]
        	j=i-1
        	while j >= 0 and vector[j].getPrecio > aux.getPrecio
            	vector[j+1] = vector[j]
            	j = j - 1
        	end
        	vector[j+1] = aux
        	i = i + 1
      	end
      	return vector;
    end

    def self.Sort_Mayor_a_Menor(vector) #Primero el precio mas alto hasta el precio mas bajo
    	i=1
      	while i < vector.length
        	aux = vector[i].getPrecio
        	j=i-1
        	while j >= 0 and vector[j].getPrecio < aux
            	vector[j+1] = vector[j]
            	j = j - 1
        	end
        	vector[j+1] = aux
        	i = i + 1
      	end
      	return vector;
    end
end

apartamento = Apartamento.new("La Posada","Excelente lugar para pasar tu semestre","23G 00 N 08G 00 E",72000,83791648) #Orden 1
apartamento.agrega_caracteristica("Cama individual incluida")
apartamento.agrega_caracteristica("Cerca del TEC")
apartamento.agrega_caracteristica("Vista a Cartago")
apartamento.agrega_facilidad("TV")
apartamento.agrega_facilidad("Internet")
apartamento.agrega_facilidad("Luz")
puts Apartamento.agregar_a_lista(apartamento)

apartamento1 = Apartamento.new("La Pension","Excelente lugar para pasar tu semestre","32G 00 N 08G 00 E",85000,83791648) #Orden 3
apartamento1.agrega_caracteristica("Cama individual incluida")
apartamento1.agrega_caracteristica("Vista a Cartago")
apartamento1.agrega_facilidad("TV")
apartamento1.agrega_facilidad("Internet")
apartamento1.agrega_facilidad("Luz")
puts Apartamento.agregar_a_lista(apartamento1)

apartamento2 = Apartamento.new("Moe's","Excelente lugar para pasar tu semestre","21G 00 N 08G 00 E",75000,83791648) #Orden 2
apartamento2.agrega_caracteristica("Vista a Cartago")
apartamento2.agrega_facilidad("TV")
apartamento2.agrega_facilidad("Internet")
apartamento2.agrega_facilidad("Luz")
puts Apartamento.agregar_a_lista(apartamento2)

#Buscador.buscar_en_lista([])
puts Apartamento.Sort_Menor_a_Mayor([apartamento,apartamento1,apartamento2])
