# Script para otimização de imagens

Otimização diminui tamanho de imagens buscando manter a qualidade.

## Objetivos:

-Diminuir tempo de carregamento de imagens (Ex: HTTP Requests);

-Diminuir espaço utilizado para armazenamento;

## OBS

-A imagem original será substituída pela processada;

-Pode ser agendada no crontab. Ex - Execução diária 2AM:
```
0 2 * * * ~/optimage.sh <dir>
```

## Ações e utilização:

#### -optimage.sh

Uso:

```./optimage.sh <dir> --all``` - Realizará a otimização recursivamente (Substituir ```<dir>``` pelo caminho do diretório)

```./optimage.sh <dir>``` - Realizará a otimização recursivamente de imagens modificadas a menos de 3 dias


## Requisitos e dependencias:

Ferramentas utilizadas: imgopt pngquant pngout imagemagick jfifremove

Instalação de dependencias:
```
#################### Installing dependencies - Debian9 (as root): #######################
apt-get update && apt-get -y install gcc libc6-dev libjpeg-progs trimage imagemagick pngquant
git clone https://github.com/kormoc/imgopt.git
cd imgopt
chmod +x imgopt
cp imgopt /usr/local/bin/
gcc -o jfifremove jfifremove.c
mv jfifremove /usr/local/bin/
wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz
tar -zxf pngout-20150319-linux.tar.gz
cd pngout-20150319-linux/x86_64
mv pngout /usr/local/bin/
#########################################################################################
```

