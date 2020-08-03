# --------------------- #
# Stu's Bash Functions
# --------------------- #

VIMgrep() {
  PATTERN=$1
  ret=$(grep -r --color=always --include='*.R' $PATTERN ./)
  if [ -z "$2" ]; then
    echo $ret
  elif [ $2 = "open" ]; then
    echo "Opening VIM"
    vim $(grep -lr --include='*.R' $PATTERN ./)
  else
    echo "Options for $2 are: 'open' or ''"
  fi
}


git_tag_diff() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in `ls -d */`; do
    cd $i
    if [ -d ".git" ]; then
      TAG1=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=0 --max-count=1)` > /dev/null 2>&1
      TAG0=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=1 --max-count=1)` > /dev/null 2>&1
      if [ -z "$TAG0" ]; then
        echo "\033[33m>\033[0m \033[31m$i\033[0m ... \033[33mNo Tags ...\033[0m"
      else
        echo "\033[33m>\033[0m \033[31m$i\033[0m ... \033[33m$TAG0 -> $TAG1\033[0m"
        COMMITS=`git rev-list $TAG1 ^$TAG0 --count`
        STAT=`git diff --shortstat $TAG1 ^$TAG0 ':(exclude)*.html'`
        echo "$i, $COMMITS commits,$STAT"
      fi
    else
      echo "\033[33m>\033[0m \033[31m$i\033[0m ... \033[33mNot a Git repo ...\033[0m"
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

git_tags_cur() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in `ls -d */`; do
    cd $i
    if [ -d ".git" ]; then
      TAG=`git describe --abbrev=0 --tags` > /dev/null 2>&1
      if [ -z "$TAG" ]; then
        echo "\033[33m>\033[0m \033[32m$i\033[0m ... \033[33mNo tags\033[0m"
      else
        COMMIT=$(git rev-list -n 1 $TAG)
        COMMIT=$(git rev-parse --short $COMMIT)
        echo "\033[33m>\033[0m \033[32m$i\033[0m ... \033[33m$TAG\033[0m ... \033[034m$COMMIT\033[0m"
      fi
    else
      echo "\033[33m>\033[0m \033[31mSkipping $i\033[0m ... not a Git repo"
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

git_branch_cur() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in {Soma*,somaverse,SMA,palantir}; do
    cd $i
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    if [[ $BRANCH == 'master' ]]; then
      UNPUSHED=`git log @{upstream}.. --oneline | wc -l | xargs`
      echo "\033[33m>\033[0m \033[31m$i\033[0m: \033[32m$BRANCH\033[0m \033[34m(ahead upstream: \033[33m$UNPUSHED\033[34m)\033[0m"
    else 
      BEHIND_MASTER=`git rev-list --left-only --count master...$BRANCH`
      AHEAD_MASTER=`git rev-list --right-only --count master...$BRANCH`
      echo "\033[33m>\033[0m \033[31m$i\033[0m: \033[32m$BRANCH\033[0m \033[34m(behind master: \033[33m$BEHIND_MASTER\033[34m - ahead master: \033[33m$AHEAD_MASTER\033[34m)\033[0m"
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}


nuke_docker() {
  while true; do
  read -q "yn?* Are you sure you want to nuke all Docker containers? (Y/n) "
    case $yn in
      [Yy] ) break;;
      [Nn] ) echo "\n* Aborting."; return 1;;
      * ) echo "* Please answer y (yes) or n (no):";;
    esac
  done
  echo "\n* Stopping, removing, and nuking all SLIDE docker containers & images"
  for i in `docker ps -aq`; do 
    docker stop $i
    docker rm -f $i
  done
  docker rmi $(docker images -q)
  echo "It is done ..."
}

render_README() {
  echo "Rendering README.Rmd"
  Rscript --vanilla -e "Sys.setenv(RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/MacOS/pandoc'); rmarkdown::render('README.Rmd', quiet = TRUE)"
}

update_READMEs() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in {Soma*,somaverse}; do
    echo "$i:"
    cd $i && render_README && cd $R_SOMA_DEV
  done
  cd $CURPWD
}

git_check_status() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in `ls -d */`; do
    cd $i
    if [ -d ".git" ]; then
      if [[ -z $(git status --porcelain) ]]; then
        echo -e "* \033[33m$i\033[0m ... \033[32mClean\033[0m"
      else 
        BRANCH=`git rev-parse --abbrev-ref HEAD`
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "\033[31m* $i\033[0m ... \033[34m$BRANCH\033[0m"
        git status -s $1
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
      fi
    else
      echo -e "* \033[33m$i\033[0m ... \033[32mNot a Git repo\033[0m"
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

runRerrors(){  # runs the output Rcheck R script
  R --vanilla < $1 > out.txt
}

zip_deliv(){

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


openpng(){
  okular $1 &>/dev/null &
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


vmail() {
# vmail $mike -u Subject Here -a file.R
# alias email2="sendemail -s pine -f 'Stu Field <sfield@somalogic.com>' -bcc sfield@somalogic.com -t "
  if [ -e /tmp/vmail.tmp ]; then
    rm -f /tmp/vmail.tmp
  fi
  if [ -e /tmp/vmail.tmp2 ]; then
    rm -f /tmp/vmail.tmp2
  fi

  #vim -c "setlocal spell" /tmp/vmail.tmp
  vim -u /home/sfield/.vim/empty --noplugin -c "setlocal spell" /tmp/vmail.tmp

  if [ -e /tmp/vmail.tmp ]; then
    echo "<html>" > /tmp/vmail.tmp2
    sed "s/ /\&nbsp/g" /tmp/vmail.tmp | sed "s/$/<br\/>/g" | sed "s/<code>.*$/<font face='monospace'>/g" | sed "s/<\/code>.*$/<\/font>/g" >> /tmp/vmail.tmp2
    echo "</html>" >> /tmp/vmail.tmp2
  fi

  if [ -e /tmp/vmail.tmp2 ]; then
    sendemail -s pine -f 'Stu Field <sfield@somalogic.com>' -bcc sfield@somalogic.com -t $@ -o message-file=/tmp/vmail.tmp2
    if [ $? -ne 0 ]; then
      cat /tmp/vmail.tmp
    fi
    mkdir -p /tmp/saved_vmail;
    \cp -f /tmp/vmail.tmp /tmp/saved_vmail/vmail_message.txt
    rm -f /tmp/vmail.tmp /tmp/vmail.tmp2
  fi
}


untar(){
  if [ ! -d ./$2 ]; then
    mkdir ./$2
  fi
  tar -xvf $1 -C $2
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

