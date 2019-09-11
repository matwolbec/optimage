#!/bin/bash
## Filename: optimage.sh
## Function: Optimize images for web
## Author: Mateus WB
## Date: 2019-09-10
## Tools (dependencies): imgopt pngquant pngout imagemagick jfifremove
## Usage: optimage.sh dir-to-optimize #(recursive)

#################### Installing dependencies - Debian9 (as root): ###############################
# apt-get update && apt-get -y install gcc libc6-dev libjpeg-progs trimage imagemagick pngquant #
# git clone https://github.com/kormoc/imgopt.git					        #
# cd imgopt										        #
# chmod +x imgopt									        #
# cp imgopt /usr/local/bin/								        #
# gcc -o jfifremove jfifremove.c							        #
# mv jfifremove /usr/local/bin/								        #
# wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz		        #
# tar -zxf pngout-20150319-linux.tar.gz							        #
# cd pngout-20150319-linux/x86_64							        #
# mv pngout /usr/local/bin/								        #
#################################################################################################

#Usage evaluate
if [ "$1" == "" ] ;
   then echo -e "Argument missing\nUsage ./optimage.sh fullpath-dir-to-optimize"
   exit
fi

#Run all images with argument or 3 days without it
if [ -n "$2" ] ; then
   if [ "$2" == '--all' ] ;
      then run_all=""
   else echo "Invalid argument $2"
   fi
else
   run_all="-mtime +3"
fi

#Initialize environment
log_file="optimage.log"
dir_images="$1"
jpeg_quality="85"
start_size=`du -s $dir_images | awk -F ' ' '{print $1}'` 
start_files=$(find $dir_images -type f ${run_all} | wc -l)
echo "[START - `date`] - Starting run ${run_all} | Dir $dir_images" | tee -a $log_file
echo "[`date`] - Initial dir size: $start_size" bytes | tee -a $log_file
echo "[`date`] - Files count: $start_files" | tee -a $log_file

#Start optimize
echo -n "[`date`] - Setting jpeg to quality = ${jpeg_quality} |" | tee -a $log_file
find $dir_images -type f ${run_all} -exec jpegoptim -m${jpeg_quality} {} \;
tmp_size=`du -s $dir_images | awk -F ' ' '{print $1}'`
echo " Optimized: $(( $start_size - $tmp_size )) bytes" | tee -a $log_file

echo -n "[`date`] - Running pngquant |" | tee -a $log_file
find $dir_images -type f ${run_all} -exec bash -c 'img_ext=".${1##*.}" ; if [ "$img_ext" != ".png" ] ; then img_ext="" ; fi ; pngquant -f --ext "$img_ext" "$1"' bash {} \;
tmp_size2=`du -s $dir_images | awk -F ' ' '{print $1}'`
echo " Optimized: $(( $tmp_size - $tmp_size2 )) bytes" | tee -a $log_file

echo -n "[`date`] - Running imgopt |" | tee -a $log_file
find $dir_images -type f ${run_all} -exec imgopt {} \;
tmp_size3=`du -s $dir_images | awk -F ' ' '{print $1}'`
echo " Optimized: $(( $tmp_size2 - $tmp_size3 )) bytes" | tee -a $log_file

echo -n "[`date`] - Running progressive |" | tee -a $log_file
find $dir_images -type f ${run_all} -exec jpegtran -copy none -progressive -outfile {} {} \;
tmp_size4=`du -s $dir_images | awk -F ' ' '{print $1}'`
echo " Optimized: $(( $tmp_size3 - $tmp_size4 )) bytes" | tee -a $log_file

finish_size=`du -s $dir_images | awk -F ' ' '{print $1}'`
finish_files=$(find $dir_images -type f ${run_all} | wc -l)

#Finished
echo -n "[`date`] - Final dir size: $finish_size bytes | Optimized: $(( $start_size - $finish_size )) bytes ( " | tee -a $log_file
echo "$(( $(( $start_size - $finish_size )) / $(( $start_size / 100 )) )) % )" | tee -a $log_file
echo "[`date`] - End files count: $finish_files" | tee -a $log_file
echo "[FINISH - `date`] - Run finished " | tee -a $log_file
if [ "$(( $start_size - $finish_size ))" -gt "0" ] ;
   then exit 0;
else exit 1
fi
