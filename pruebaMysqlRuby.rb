require 'mysql'

#queryUsr="CALL `DepaRent&Search`.`inserta_usr`(0,"default","def@def.com");"
queryDepa="CALL `DepaRent&Search`.`inserta_depa`(";
#"0", <{IN titulo TEXT}>, <{IN descr TEXT}>, <{IN correo TEXT}>, <{IN tel TEXT}>, <{IN precio TEXT}>, <{IN num_cuartos TEXT}>, <{IN internet TEXT}>, <{IN compatido TEXT}>);

con = Mysql.new('127.0.0.1', 'depars', '123', 'DepaRent&Search')  
rs = con.query('select * from Usuarios')  

#for i in rs
#	puts i
#end
#rs.each_hash {|h| puts h["*"]}  
n_rows=rs.num_rows
n_rows.times do
	puts rs.fetch_row.join("\s")
end
con.close 
