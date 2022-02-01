


def retornar_nome 
    cadastro = [ {name: 'Matheus', age:20}, {name:'Gabriel', age:19}, {name: 'Eduardo', age:56}]
    cadastro.map do |item|
        {
              nome_do_aluno: item[:name]
          }
      end
end

puts retornar_nome()