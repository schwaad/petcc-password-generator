#!/bin/bash

# Função para exibir a ajuda
show_help() {
  echo -e "Bem vindo ao password-generator!
  Versão 1.0, (c) 2025, schwaad
  Uso: ./password-generator.sh [OPÇÕES]
  Opções:
  -l [COMPRIMENTO] : comprimento da senha
  -u               : incluir letras maiúsculas
  -d               : incluir números
  -s               : incluir símbolos
  -g [ARQUIVO]     : armazena a senha no arquivo 
  -n [NOME]        : nomeia a senha que está sendo criada
  -p [ARQUIVO]     : lista as senhas armazenadas no arquivo
  -h               : exibir essa mensagem de ajuda"
}

# Definir conjuntos de caracteres
LOWERCASE="abcdefghijklmnopqrstuvwxyz"
UPPERCASE="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGITS="0123456789"
SYMBOLS="!@#$%^&*()-_=+[]{}|;:,.<>?/~"

# Construir a lista de caracteres permitidos
# { Implementação vem aqui }

# Gerar a senha:
# o /dev/urandom gera bytes aleatórios, para conseguir
# uma senha precisamos limpar esses bytes de alguma forma

INCLUDE_IN_PASSWORD="$LOWERCASE"
DEFAULT_LENGTH=8

# Parsear argumentos
if [ "$#" = 0 ]; then
  show_help
fi

while getopts "l:udsg:n:p:h" OPTION; do
  case $OPTION in
  u)
    echo "Incluindo letras maiúsculas"
    INCLUDE_IN_PASSWORD="$INCLUDE_IN_PASSWORD$UPPERCASE"
    PASSWORD=$(cat /dev/urandom | tr -dc "$INCLUDE_IN_PASSWORD" | fold -w $DEFAULT_LENGTH | head -n 1)
    ;;
  d)
    echo "Incluindo números"
    INCLUDE_IN_PASSWORD="$INCLUDE_IN_PASSWORD$DIGITS"
    PASSWORD=$(cat /dev/urandom | tr -dc "$INCLUDE_IN_PASSWORD" | fold -w $DEFAULT_LENGTH | head -n 1)

    ;;
  s)
    echo "Incluindo símbolos"
    INCLUDE_IN_PASSWORD="$INCLUDE_IN_PASSWORD$SYMBOLS"
    PASSWORD=$(cat /dev/urandom | tr -dc "$INCLUDE_IN_PASSWORD" | fold -w $DEFAULT_LENGTH | head -n 1)

    ;;
  n)
    PASSWORD_NAME="$OPTARG"
    echo "Nome da senha: $OPTARG"
    ;;
  l)
    echo "Tamanho escolhido: $OPTARG"
    PASSWORD=$(cat /dev/urandom | tr -dc "$INCLUDE_IN_PASSWORD" | fold -w $OPTARG | head -n 1)
    ;;
  g)
    # Checa se o arquivo criptografado existe
    if [ -e "$OPTARG.enc" ]; then
      # Descriptografando o arquivo para um arquivo temporário
      echo "Digite a senha do arquivo $OPTARG:"
      read -s FILE_PASSWORD
      openssl aes-256-cbc -d -in "$OPTARG.enc" -out "$OPTARG.decrypted" -pass pass:$FILE_PASSWORD
      rm "$OPTARG.enc"

      # Adicionando a senha ao arquivo descriptografado
      if [ "X" != "X$PASSWORD_NAME" ]; then
        echo "$PASSWORD_NAME: $PASSWORD" >>"$OPTARG.decrypted"
      else
        echo "Senha sem nome: $PASSWORD" >>"$OPTARG.decrypted"
      fi

      # Re-criptografando o arquivo e movendo para substituir o original
      echo "Digite a senha do arquivo $OPTARG:"
      read -s FILE_PASSWORD
      openssl aes-256-cbc -salt -in "$OPTARG.decrypted" -out "$OPTARG.enc" -pass pass:$FILE_PASSWORD
      rm "$OPTARG.decrypted"
    else
      # Se o arquivo não existe, cria-o
      touch "$OPTARG"
      echo "Arquivo $OPTARG criado"

      # Adicionando a senha ao arquivo
      if [ "X" != "X$PASSWORD_NAME" ]; then
        echo "$PASSWORD_NAME: $PASSWORD" >>"$OPTARG"
      else
        echo "Senha sem nome: $PASSWORD" >>"$OPTARG"
      fi

      # Criptografando o arquivo e movendo para o arquivo final
      echo "Digite a senha do arquivo $OPTARG:"
      read -s FILE_PASSWORD
      openssl aes-256-cbc -salt -in "$OPTARG" -out "$OPTARG.enc" -pass pass:$FILE_PASSWORD
      rm "$OPTARG"
    fi

    # Verificando o sucesso do comando
    if [ "$?" = 0 ]; then
      echo "Senha salva com sucesso no arquivo $OPTARG"
    else
      echo "Ocorreu um erro na opção -g, tente novamente (OBS.: O nome precisa ser sem espaços)"
    fi
    ;;

  p)
    # Verifica se o arquivo criptografado existe
    if [ -e "$OPTARG.enc" ]; then
      # Descriptografando o arquivo criptografado
      echo "Digite a senha do arquivo $OPTARG:"
      read -s FILE_PASSWORD
      openssl aes-256-cbc -d -in "$OPTARG.enc" -out "$OPTARG.decrypted" -pass pass:$FILE_PASSWORD
      echo "$_"

      # Exibindo o conteúdo do arquivo descriptografado
      cat "$OPTARG.decrypted"

      # Re-criptografando o arquivo e movendo para o arquivo final
      openssl aes-256-cbc -salt -in "$OPTARG.decrypted" -out "$OPTARG.enc" -pass pass:$FILE_PASSWORD
      rm "$OPTARG.decrypted"
    else
      echo "Erro: arquivo $OPTARG.enc não existe."
    fi
    ;;

  h)
    show_help
    ;;
  *)
    echo "Erro: flag inválida"
    ;;
  esac
done

# Exibir a senha gerada
if [ "X" != "X$PASSWORD" ]; then
  echo "Senha gerada: $PASSWORD"
fi

# Opcional: salvar a senha em um arquivo criptografado
# Implemente como essa senha será criptografada com o openssl
# echo $PASSWORD >>password.txt.enc
