# --------------------------------- #
# Stu's Bash Functions:
# - a collection of BASH utilities
#   for use at the command line
#   for user specific common operations
# --------------------------------- #

# VIM split
vims() {
  # [-o | --open] flag for opening files
  USAGE="Usage: $0 [file1] [file2]"
  if [[ "$#" -ne 2 ]]; then
    echo "$USAGE"
    return 1
  fi
  echo "Opening \033[34m$1\033[0m and \033[34m$2\033[0m:"
  vim -O $1 $2
}

vigrep() {
  # [-o | --open] flag for opening files
  USAGE="Usage: $0 [-o | --open] [pattern] [files]"
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


render_markdown() {
  FILE=$1
  echo "Rendering $FILE"
  BASEFILE="${FILE%.*}"
  Rscript --vanilla \
    -e "Sys.setenv(RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools')" \
    -e "options(cli.width = 80L)" \
    -e "rmarkdown::render('$FILE', quiet = TRUE)"
  rm -f $BASEFILE.html
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


# list contents of a zip file
lszip(){
  for i in $@; do unzip -l $i; done
}

# list files beginning with '.'
lsdot(){
  if [ $# -ne 1 ]; then
    ls -A | grep ^\\.
  else
    ls -A $1 | grep ^\\.
  fi
}


# list number of files in directory
lsn(){
  if [ $# -ne 1 ]; then
    ls | wc -l
  else
    ls $1 | wc -l
  fi
}


# list the last modified file/directory
lslast(){
  if [ $# -ne 1 ]; then
    ls -At | head -n 1
  else
    ls -At $1 | head -n 1
  fi
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


# print an HTML file to PDF via headless Chrome; keeps the page CSS
#   (branding, fonts, tables), unlike pandoc/LaTeX PDF output.
#   outfile defaults to the input name with .pdf
#   bash + zsh portable: this file is sourced by both
html2pdf(){
  USAGE="Usage: html2pdf [file.html] [outfile.pdf]"
  chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  if [[ "$#" -lt 1 || "$#" -gt 2 || $1 == "-h" || $1 == "--help" ]]; then
    echo "$USAGE"
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "html2pdf: no such file: $1"
    return 1
  fi
  if [[ ! -x "$chrome" ]]; then
    echo "html2pdf: Google Chrome not found at $chrome"
    return 1
  fi
  # absolute paths: Chrome needs a file:// URL; subshell keeps cwd
  in="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
  out="${2:-${1%.*}.pdf}"
  out="$(cd "$(dirname "$out")" && pwd)/$(basename "$out")"
  # stderr hidden: harmless macOS 'task_policy_set' noise from Chrome
  "$chrome" --headless=new --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="$out" "file://$in" 2>/dev/null
  if [[ -s "$out" ]]; then
    echo "* Created $out"
  else
    echo "html2pdf: failed to write $out"
    return 1
  fi
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

