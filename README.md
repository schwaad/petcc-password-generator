# petcc-password-generator
Programa de geração de senhas fortes implementado em Shell Script para o Minicurso de Linux e Git ofertado pelo PETCC.

### Funcionalidades do programa:
- Gera senhas fortes incluindo letras minúsculas e maiúsculas, símbolos e números;
- Customização das senhas (incluir somente números ou somente símbolos, customização do tamanho da senha, etc)
- Armazena as senhas geradas de forma criptografada em arquivos `.enc`

### Rodando o programa:
```terminal 
git clone https://github.com/schwaad/petcc-password-generator
cd petcc-password-generator/
./petcc-password-generator.sh
```
Você deve receber essa mensagem de ajuda:
```terminal
Bem vindo ao password-generator!
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
  -h               : exibir essa mensagem de ajuda
  ```
