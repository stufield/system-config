# --------------------- #
# Stu's Bash Functions
#   - a collection of BASH utilities
#     for use at the command line
#     for user specific common operations
# --------------------- #

vigrep() {
  # [-o | --open] flag for opening files
  USAGE="Usage: $0 [-o | --open] pattern files"
  if [[ "$#" -lt 2 || $1 == "-open" ]]; then
    echo "$USAGE"
    return 1
  fi
  if [[ $1 == "-o" || $1 == "--open" ]]; then
    shift
    PATTERN=$1; shift;
    echo "Running $0 with '$PATTERN':"
    vim $(grep -lr $PATTERN $@)
  else
    PATTERN=$1; shift;
    echo "Running $0 with '$PATTERN':"
    grep --color=always $PATTERN $@
  fi
}


nuke_docker() {
  docker stop edge_shiny_1 edge_jupyter_1
  docker rm -f edge_shiny_1 edge_jupyter_1
  docker image prune -a
}


render_README() {
  echo "Rendering README.Rmd"
  Rscript --vanilla \
    -e "Sys.setenv(RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/MacOS/pandoc')" \
    -e "rmarkdown::render('README.Rmd', quiet = TRUE)"
  rm -f README.html
}


runRerrors(){  # runs the output Rcheck R script
  R --vanilla < $1 > out.txt
}


zip_deliver(){

  length=`ls *.pdf | wc -l`

  if [ "$length" -ne 1 ] && [ -z "$1" ]; then
    echo
    echo Error: there are $length PDF files in the directory ... please pass which one you want.
    echo
    return 1
  elif [ -z "$1" ]; then
    token=`ls *.pdf | awk '{ gsub("SQS_|\\.pdf$","",$1); print }'`
  else
    token=`echo "$1" | awk '{ gsub("SQS_|\\.pdf$","",$1); print }'`
  fi

  echo "* zipping and prepping this file:" $token
 
  prefix=`echo $token | awk '{ gsub("[A-Z]_[0-9][0-9]-.*","",$1); print }'`
  pw=SL$Date$prefix
  zip -r -P $pw $token.zip *.csv *.pdf *.adat *.txt
  echo $pw > $token.pwd.txt
  echo "* Finished zipping:" $token.zip
  return 0
}

mount_drive(){
  usage() {
    echo "Usage:"
    echo "   mount_drive [option]"
     echo
     echo "Options:"
     echo "  -r, -R    mount the 'R' drive: //aspen/res_dev/"
     echo "  -s, -S    mount the 'S' drive: //aspen/shared/"
     echo "  -h, -H    mount the 'H' drive: //aspen/home/sfield"
     echo "  -d        debug mode; return internal variables & settings"
     echo
     echo "Examples:"
     echo "   mount_drive -r"
     echo "   mount_drive -s"
     echo "   mount_drive -d"
     echo
   }

  if [ $# -eq 0 ]; then
    echo "Must pass a drive option:"
    usage
    return 1
  fi

  usr=$(grep username /home/sfield/user | awk '{ gsub("username=","",$1); print }')
  mypwd=$(grep password /home/sfield/user | awk '{ gsub("password=","",$1); print }')

  case $1 in
    -d|-D)   usage; echo $usr; echo $mypwd; shift;;
    -s|-S)   logic=$(mount | grep -c media\/sfield\/S\ )
             #echo $logic
             if [[ $logic == 0 ]]; then
                echo "* Mounting S: drive ..."
                sudo mount -t cifs -o "username=$usr,password=$mypwd,uid=$usr,gid=$usr" //aspen/shared /media/sfield/S;
             else 
                echo "* S: drive already mounted ..."
                unset usr
                unset mypwd
                unset logic
                return 1
             fi; shift;;
    -r|-R)   logic=$(mount | grep -c media\/sfield\/R\ )
             if [[ $logic == 0 ]]; then
                echo "* Mounting R: drive ..."
                sudo mount -t cifs -o "username=$usr,password=$mypwd,uid=$usr,gid=$usr,dir_mode=0755,file_mode=0644" //aspen/res_dev/ /media/sfield/R;
             else
                echo "* R: drive already mounted ..."
                unset usr
                unset mypwd
                unset logic
                return 1
             fi; shift;;
    -h|-H)   sudo mount -t cifs -o "username=$usr,password=$mypwd,uid=$usr,gid=$usr" //aspen/home/sfield /media/sfield/H; shift;;
    *)       usage; return 1;;
  esac
  unset usr
  unset mypwd
  return 0
}

unmount_drive(){
  case $1 in
    -s)   sudo fusermount -u /media/sfield/S; shift;;
    -r)   sudo fusermount -u /media/sfield/R; shift;;
    -h)   sudo fusermount -u /media/sfield/H; shift;;
    *)      echo 'Invalid Arg: -s, -r, -h'; return 1;;
  esac
  return 0
}


lszip(){
  for i in $@; do unzip -l $i; done
}

lsdot(){
  ls -A | grep ^\\.
}


lsn(){
  if [ $# -ne 1 ]; then
    ls | wc -l
  else
    arg=$1
    ls $arg | wc -l
  fi
}


lslast(){
  if [ $# -ne 1 ]; then
    path='.'
  else
    path=$1
  fi
  ls -t $path | head -n 1
}


splitpdf(){
  file=$1
  outfile=$2
  shift;
  if [ ! -d ./pdf_files ]; then
    mkdir ./pdf_files
  fi
  pdftk $file burst output pdf_files/${outfile}_%02d.pdf
  rm -rf doc_data.txt
  echo "Creating $outfile"
}


joinpdf(){
  outfile=$1
  shift;
  echo $@
  pdftk $@ cat output $outfile
}


convertpng(){
  if [ ! -d ./png ]; then
    mkdir ./png
 fi
  echo "* Creating png file(s) in png/"
  for i in $@; do
    echo "* Converting ... $i";
    convert -density 300 $i png/`basename $i ${i##*.}`png;
  done
  echo "* Done"
}


cleantex() {
  filename=`basename $1 tex`
  echo $filename
  mv -f "${filename}log" "${filename}aux" "${filename}out" "${filename}blg" "${filename}bbl" "${filename}toc" /tmp
}


slidy() {
  case $1 in
    -v|-V) echo "*  Rendering $2 (--vanilla)";
           Rscript --vanilla -e "rmarkdown::render(\"$2\", quiet=TRUE)"; shift;;
    *)     echo "*  Rendering $1";
           R -e "rmarkdown::render(\"$1\", quiet=TRUE)";;
  esac
  echo "*  DONE"
}


setup_slidy() {
  if [ -d $1 ]; then
    echo "Directory already exists!"
    return 0
  else
    mkdir $1
    root=~/Documents/templates/slidy
    cp -r $root/css $root/js $root/include $1
    cp $root/SlidyTemplate.Rmd $1/slidy_$1.Rmd
    echo "* Done creating $1 directory"
  fi
}


format_R_style() {
  for j in $@; do
    sed -i 's/\t/   /g' $j          # tabs -> spaces
    sed -i 's/){/) {/' $j           # space after {
    sed -i 's/else{/else {/' $j     # spaces after 'else'
    sed -i 's/}else/} else/' $j     # space before 'else'
    sed -i 's/if(/if (/' $j         # space after 'if'
    echo "Updating R format for ... $j"
  done
}

