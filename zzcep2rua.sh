#!/bin/bash

source /usr/bin/funcoeszz   # inclui o ambiente ZZ
ZZPATH=$PWD/chaves.sh       # o PATH desse script

# ----------------------------------------------------------------------------
# Procura o CEP pelo nome da rua, cidade e UF informados
# -h (exibe ajuda, cabeçalho da função)
# -e (exibe o endereço completo)
# Obs.: As opções (parâmetro: -h ou --help ; -e ou --endereco)
#       , se forem utilizadas, o -h não recebe complementp.
#				e o -e ou --endereco , deve ser utilizado antes de 
#				digitar o endereço.
#
# Usos:	zzcep2rua [rua cidade uf]
#			 	zzcep2rua [-e] [rua cidade uf]
#			 	zzcep2rua [--endereco] [rua cidade uf]
#			 	zzcep2rua [-h]
#			 	zzcep2rua [--help]
#
# Exs.: zzcep2rua rua santana salvador ba
#				zzcep2rua -e rua rio da ilha salvador ba
#      	zzcep2rua rua cambui londrina pr
#			 	zzcep2rua rua silverio lelis sao paulo sp
#				zzcep2rua -e jobim rio de janeiro rj
#      
# Autor:Marcos da B. M. Oliveira , http://amigosdopinguim.blogspot.com.br/
# Desde: 2013-12-28
# Versão: 1
# Licença: GPL
# Requisitos: zztool
# ----------------------------------------------------------------------------
zzcep2rua(){

		zzzz -h cep2rua "$1" && return

		if [ "$*" ]; then
			echo -n
		else
			echo "Sem parâmetros, digite o endereço."
			exit 0
		fi

		# variavel do que for digitado
		local endereco="$*"

		# troca os espaços em branco por '+' para efetuar pesquisa
		local endereco="$(echo $endereco | sed -e 's/ /+/g')"

		# endereço para pesquisa
		local urlendereco="http://maps.google.com/maps/api/geocode/json?address=$*&sensor=false"

		# baixa o código fonte do arquivo pesquisado
		local endcom="$(lynx -source "$urlendereco" |

		# imprime só a linha que contém a palavra 'formatted_address'
		sed -n '/formatted_address/p' |

		# divide a linha anterior em duas, após o sinal de ': '
		sed 's/: /: \n/' |

		# deleta a linha que contém a string 'formatted_address'
		sed '/formatted_address/d' |

		# troca todas as ocorrências de \"(aspas duplas) e de ,(vírgula) por nada, e imprime o endereço.
		sed 's/\"\|\,//g')"

			case $1 in

				-h | --help)
					echo " Usos:	zzcep2rua [rua cidade uf]
			 	zzcep2rua [-e] [rua cidade uf]
			 	zzcep2rua [--endereco] [rua cidade uf]
			 	zzcep2rua [-h]
			 	zzcep2rua [--help]

 Exs.: zzcep2rua rua santana salvador ba
				zzcep2rua -e rua rio da ilha salvador ba
      	zzcep2rua rua cambui londrina pr
			 	zzcep2rua rua silverio lelis sao paulo sp
				zzcep2rua -e jobim rio de janeiro rj"
					shift
					exit 0
					;;
				-e | endereco)
					echo "$endcom";
					shift
					;;
				*)
					local cep=$(echo $endcom | tr -d -c 0123456789)
					if [ "$cep" = "" ]; then
						echo "Cep não encontrado";
					else
						echo "$(echo $cep | cut -c1-5)-$(echo $cep | cut -c6-8)"; 
					fi
					exit 0
					;;
			esac
	
		exit 0
}
