class Arrendario
	protected
	def initialize(nombre,correo,telefono,ids,favoritos) 
		@nombre = nombre
		@correo = correo
		@telefono = telefono
		@ids_asociados = ids # ids es una lista con los ids de diferentes apartamentos para mas orden
		@favoritos = favoritos
	end

	public
	def quita_favorito(id)
		largo_lista = @favoritos.length
		while i < largo_lista
			if @favoritos[i] == id
				@favoritos[i] = nil
				return "Borrado con exito!"
			end
		end
	end

	def agrega_favorito(id)
		@favoritos = @favoritos + [id]
	end

	def agrega_id(id)
		@ids_asociados = @ids_asociados + [id]
	end
end

$lista_apartamentos = []
class Apartamento < Arrendario

	def initialize(titulo,descripcion,ubicacion,precio,id)
		@titulo = titulo
		@descripcion = descripcion
		@facilidades = []
		@caracteristicas = []
		@ubicacion = ubicacion
		@precio = precio
		@id = id
		puts "Exito al crear apartamento"
	end

	def agrega_facilidad(facilidad)
		@facilidades[@facilidades.length] = facilidad
		puts "Facilidad Agregada"
	end

	def agrega_caracteristica(caracteristica)
		@caracteristicas[@caracteristicas.length] = caracteristica
		puts "Caracteristica Agregada"
	end

	def self.agregar_a_lista(apartamento)
		$lista_apartamentos[$lista_apartamentos.length] = apartamento
		puts "Se agrego #{apartamento} a la lista principal"
	end

	def buscar_caracteristica(caracteristica) #recibe lista de caracteisticas
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
end

class Buscador < Apartamento
	def self.buscar_en_lista(obj) # Busca apartamentos ya sea por facilidades o caracteristicas (recibe lista)
		lista_res = "No hay apartamentos disponibles"
		est = true
		for i in $lista_apartamentos
			if i.buscar_caracteristica(obj) or i.buscar_facilidad(obj)
				if est
					est = false
					lista_res = [i]
				else
					lista_res = lista_res + [i]
				end
			end
		end
		puts lista_res
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




apartamento = Apartamento.new("La Posada","Excelente lugar para pasar tu semestre","23G 00 N 08G 00 E",75000,"Fdz","fa.fdz@me.com",83791648)
apartamento.agrega_caracteristica("Cama individual incluida")
apartamento.agrega_caracteristica("Cerca del TEC")
apartamento.agrega_caracteristica("Vista a Cartago")
apartamento.agrega_facilidad("TV")
apartamento.agrega_facilidad("Internet")
apartamento.agrega_facilidad("Luz")
Apartamento.agregar_a_lista(apartamento)

apartamento1 = Apartamento.new("La Pension","Excelente lugar para pasar tu semestre","32G 00 N 08G 00 E",75000,"Fdz","fa.fdz@me.com",83791648)
apartamento1.agrega_caracteristica("Cama individual incluida")
apartamento1.agrega_caracteristica("Vista a Cartago")
apartamento1.agrega_facilidad("TV")
apartamento1.agrega_facilidad("Internet")
apartamento1.agrega_facilidad("Luz")
Apartamento.agregar_a_lista(apartamento1)

apartamento2 = Apartamento.new("Moe's","Excelente lugar para pasar tu semestre","21G 00 N 08G 00 E",75000,"Fdz","fa.fdz@me.com",83791648)
apartamento2.agrega_caracteristica("Vista a Cartago")
apartamento2.agrega_facilidad("TV")
apartamento2.agrega_facilidad("Internet")
apartamento2.agrega_facilidad("Luz")
Apartamento.agregar_a_lista(apartamento2)

Buscador.buscar_en_lista(["Vista a Cartago","TV"])