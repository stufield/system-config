# --------------------- #
# Stu's Bash Functions
# --------------------- #

git_tag_diff() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in {Soma*,somaverse}; do
    cd $i
    TAG1=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=0 --max-count=1)`
    TAG0=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=1 --max-count=1)`
    echo "\033[33m>\033[0m \033[31m$i\033[0m ... \033[33m$TAG0 -> $TAG1\033[0m"
    COMMITS=`git rev-list $TAG1 ^$TAG0 --count`
    STAT=`git diff --shortstat $TAG1 ^$TAG0 ':(exclude)*.html'`
    echo "$i, $COMMITS commits,$STAT"
    cd $OLDPWD
  done
  cd $CURPWD
}

git_tags_cur() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in {Soma*,somaverse}; do
    cd $i
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    TAG=`git describe --abbrev=0 --tags`
    echo "\033[33m>\033[0m \033[31m$i\033[0m ... \033[33m$TAG\033[0m"
    cd $OLDPWD
  done
  cd $CURPWD
}

git_branch_cur() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  for i in {Soma*,somaverse}; do
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
  echo "\n* Stopping, removing, and nuking all SLIDE docker containers"
  CURPWD=$PWD
  cd ~/slide-cli
  for i in `docker ps -aq`; do 
    docker stop $i
    docker rm -f $i
  done
  docker rmi $(docker images -q)
  cd $CURPWD
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
  for i in {Soma*,somaverse}; do
    cd $i
    if [[ -z $(git status --porcelain) ]]; then
      echo -e "* \033[33m$i\033[0m ... \033[32mClean\033[0m"
    else 
      BRANCH=`git rev-parse --abbrev-ref HEAD`
      echo "~~~~~~~~~~~~~~~~~~~~~~~"
      echo -e "\033[31m* $i\033[0m ... \033[34m$BRANCH\033[0m"
      git status -s $1
      echo "~~~~~~~~~~~~~~~~~~~~~~~"
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



create_ss_header() {
  pkgver=$(grep "Version: " ~/SomaPackages/SomaGlobals/DESCRIPTION | sed -e 's/Version: //')
  Rver=$(Rscript --vanilla -e "R.version.string" | sed -e 's/\[1\] //')
  Rver=$(echo $Rver | sed -e 's/\"//g')
  nick=$(Rscript --vanilla -e "R.version[['nickname']]" | sed -e 's/\[1\] //')
  nick=$(echo $nick | sed -e 's/\"//g')
  system=$(uname -a)
  echo "#############################################" > tmp.txt
  echo "#  Run on SomaR-$pkgver" >> tmp.txt
  echo "#  $Rver ($nick)" >> tmp.txt
  echo "#  $system" >> tmp.txt
  echo "#############################################" >> tmp.txt
}

make_ss_folder(){
  if [ -d $1 ]; then
    echo "Directory already exists!"
    return 1
  fi

  mkdir -p $1/{data/meta,tables,plots,reports}
  create.ss.header
  cat tmp.txt ~/soma_sciences/func.R > $1/func.R
  rm tmp.txt
  #cp ~/soma_sciences/func.R $1
  touch $1/analysis.driver.R
  echo "* Done creating: $1"
}


sqs_template() {
  if [ $# == 1 ]; then
    svn co $SVN_PATH/BioInformatics/Latex/SomaSciences/SQS/trunk $1
  else
    svn co $SVN_PATH/BioInformatics/Latex/SomaSciences/SQS/trunk .
  fi
}


phone(){
  grep -i "$1" ~/Documents/HR/phone_list.txt
}


format_phone_file() {
  sed 's/ //g' $1 > $2
  sed -i '/^[^0-9A-Za-z\\-]*$/d' $2
  sed -i 's/[ \t\r]*$//' $2      # rm tabs, spaces, \r at end of lines
  sed -i 's/\r//' $2
  sed -i '/^[CI]$/d' $2
  sed -i '/^Name$/d' $2
  sed -i '/^Extension$/d' $2
  sed -i '/^SomaLogic/d' $2
  sed -i '/^Boulder/d' $2
  sed -i 's/^\([A-Za-z]*\)\(C\)\([0-9]\{3\}\)/\1: \3/' $2   # zap long-distance using "C" string
  sed -i '/^[A-Za-z\\-]*$/ N; /^[A-Za-z\\-]*\n[0-9\\-]*/ s/\n/: /' $2
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



check_pkg() {
  $R_SOMA_DEV/utils/check_pkg.sh $1
}


test_pkg() {
  $R_SOMA_DEV/utils/test_pkg.sh $1
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


setup_slidy(){
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






###########################
#  deprecated old stuff
###########################
add_git_keywords() {
   for j in $@; do
      sed -i 's/\$Revision\$/$Id$/' $j
      sed -i 's/LastChanged//' $j
      sed -i '/URL/d' $j
      sed -i 's/saved/created/' $j
   done
}










#####
###########################
#  Mike's old stuff
###########################
#####

#find_exp() {
#   ~/tools/scripts/database/recent_experiments.py -n 2000 | grep $1
#}
#
#kill_suspended() {
#   kill -9 `jobs -l | awk '{print $2}'`
#}
#
#findRall() {
#   grep -n "$1" ~/scripts/R/*.R
#}
#
#my_email() {
#   sendemail -s elm.sladmin.com -bcc sfield@somalogic.com -f sfield@somalogic.com -t ${1}@somalogic.com
#}
#
#move_plots() {
#   rm /media/H/dump/plots/*
#   cp $1* /media/H/dump/plots
#}
#
#img_view() {
#   gwenview $1 2> /dev/null &
#}
#
#convert_todo() {
# grep class1 $1 |  sed "s/'//g" | sed "s/:/=/g" | sed "s/, variable.*/)/g" | sed "s/{/create.training.data(, /" | sed "s/\[\[/list(c(/g" | sed "s/\]\]/))/g" | sed "s/\],\[/),c(/g"
#}
#
#garmin.file() {
#   gpsbabel -t -i garmin -f usb: -o gtrnctr -F $i
#}
#
#file_counts() {
#   for dir in `find $1 -type d`; do
#      lines=`find $dir -type f | wc -l`
#      if [ $dir == $1 ]; then
#         echo "$lines $dir"
#      else
#         file_counts $dir
#      fi
#   done
#}
#
#
#
#contains () {
#   if [ $# -ne 2 ]; then
#      echo "Returns all files that contain a particular string"
#      echo "USAGE: contains 'str' 'files' "
#      echo "EX: contains blah '*.txt'    "#
#      return
#   fi
#   str=$1
#   files=$2
#
#   for file in `ls $files`; do
#      lines=`grep $str $file | wc -l`
#      if [ $lines -gt 0 ]; then
#         echo $file
#      fi
#   done
#
#
#}
#
#size_less () {
#   if [ $# -ne 2 ]; then
#      echo "USAGE: size_less 'files' value"
#      echo "EX: size_less '*.txt' 2   # returns all txt files with <2 size"
#      return
#   fi
#   files=$1
#   val=$2
#
#
#   for file in `ls $files`; do
#      size=`ls -s $file | awk '{print $1}'`
#      if [ $size -lt $val ]; then
#         echo $file
#      fi
#   done
#}
#
#lines_less () {
#   if [ $# -ne 2 ]; then
#      echo "USAGE: lines_less 'files' value"
#      echo "EX: lines_less '*.txt' 2   # returns all txt files with <2 lines"
#      return
#   fi
#   files=$1
#   val=$2
#
#
#   for file in `ls $files`; do
#      lines=`cat $file | wc -l`
#      if [ $lines -lt $val ]; then
#         echo $file
#      fi
#   done
#
#}
#
#lines_greater () {
#   if [ $# -ne 2 ]; then
#      echo "USAGE: lines_greater 'files' value"
#      echo "EX: lines_greater '*.txt' 2   # returns all txt files with >2 lines"
#      return
#   fi
#   files=$1
#   val=$2
#
#
#   for file in `ls $files`; do
#      lines=`cat $file | wc -l`
#      if [ $lines -gt $val ]; then
#         echo $file
#      fi
#   done
#
#}
#
#edge_count() {
#   file=$1
#   args=$@
#   count=-1
#   for arg in $args; do
#      if [ $count -ge 0 ]; then
#         genes[$count]=$arg
#      fi
#      count=$[ $count+1 ]
#   done
#   num_genes=$[ $# - 1 ]
#   total=0
#   for i in `seq 0 $[$num_genes-1]`; do
#      for j in `seq 0 $[$num_genes-1]`; do
#      #for j in `seq $[ $i+1 ] $[ $num_genes -1 ]`; do
#         lines=`grep -E "^${genes[$i]}   ${genes[$j]}   " $file | wc -l`
#         if [ $lines -gt 0 ]; then
#            echo "${genes[$i]}   ${genes[$j]}: $lines"
#         fi
#      done
#   done
#
#
#
#}
#
#
#density () {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: density filename gene_list"
#      return
#   fi
#   file=$1
#   args=$@
#   count=-1
#   for arg in $args; do
#      if [ $count -ge 0 ]; then
#         genes[$count]=$arg
#      fi
#      count=$[ $count+1 ]
#   done
#   num_genes=$[ $# - 1 ]
#   total=0
#   for i in `seq 0 $[$num_genes-1]`; do
#      for j in `seq 0 $[$num_genes-1]`; do
#      #for j in `seq $[ $i+1 ] $[ $num_genes -1 ]`; do
#         lines=`grep -E "^${genes[$i]}   ${genes[$j]}   " $file | wc -l`
#         if [ $lines == 1 ]; then
#            total=`expr $total + 1`
#            #grep -E "^${genes[$i]}   ${genes[$j]}   " $file
#         else
#            if [ $lines -gt 1 ]; then
#               echo "Multiple edges found"
#               grep -E "^${genes[$i]}   ${genes[$j]}   " $file
#               return
#            fi
#         fi
#      done
#   done
#   total_edges=`calc ${num_genes}*$[ ${num_genes}-1 ]/2`
#   val=`calc ${total}/${total_edges}`
#   echo -e "$file\t$val"
#}
#
#send_temp() {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: send_temp filename"
#      return
#   fi
#   cp $@ ~/temp
#}
#
#
#file_split() {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: ./file_split filename pieces"
#      return
#   fi
#   filename=$1
#   pieces=$2
#   total_lines=`cat $filename | wc -l`
#   lines=$[ $total_lines/$pieces+1 ]
#   split -l $lines $filename ${filename}_
#}
#
#count_lines() {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: count_lines grep_str filename "
#      return
#   fi
#   grep $1 $2 | wc -l
#}
#
#
#
#
#
#graph_links() {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: ./graph_links dataset_list dataset_path"
#      return
#   fi
#   list=$1
#   path=$2
#   lines=`cat $list | wc -l`
#   for  i in `seq 1 $lines`; do ln -s $path`gl $i $list`.p01.sig.top2 dataset$i.sig.top2; done
#}
#dataset_links() {
#   if [ $# -eq 0 ]; then
#      echo "USAGE: ./dataset_links dataset_list dataset_path"
#      return
#   fi
#   list=$1
#   path=$2
#   name=$3
#   lines=`cat $list | wc -l`
#   for  i in `seq 1 $lines`; do ln -s $path`gl $i $list`.exp4 ${name}dataset$i; done
#}
#
#
#
#move_output() {
#   mkdir ~/outputs/`date -Idate`/
#   mv ~/*.pbs.o* ~/outputs/`date -Idate`/
#}
#
#
#
#count_jobs () {
#   qstat | grep $1 | wc -l;
#}
#
#qstat_look () {
#   qstat | grep cmb | vi -
#}
#
#
#gl () {
##   lines=`cat $2 | wc -l`
#   if [ `head -n $1 $2 | wc -l` -lt $1 ]; then
#      echo "Out of bounds on gl"
#   else
#      head -n $1 $2 | tail -1
#   fi
#}
#
#comp_run () {
#   make.py $1; if [ $? == 0 ]; then $@; fi
#}
#
#flt () {
#   LHS=`echo $1 | sed 's/0*$//g'`
#   RHS=`echo $2 | sed 's/0*$//g'`
#
#   max=`(echo $LHS ; echo $RHS) | sort -rn | head -1`
#   if [ "$max" != "$LHS" ]; then
#      echo TRUE
#   else
#      echo FALSE
#   fi
#}
#
#fgt () {
#   flt $2 $1
#}
#
#fle () {
#   if [ $1 == $2 ]; then
#      echo TRUE
#   else
#      flt $1 $2
#   fi
#}
#fge () {
#   if [ $1 == $2 ]; then
#      echo TRUE
#   else
#      fgt $1 $2
#   fi
#}
#
#
#wait_for_jobs () {
#   if [ $1 ]; then
#      file=$1
#      jobs=`sed "s/.hpc-pbs.usc.edu//g" $1`
#   else
#      jobs=""
#      while read data; do
#         jobs="$jobs `echo $data | sed 's/.hpc-pbs.usc.edu//g'`"
#      done
#   fi
#
#   found="yes"
#   while [ $found == "yes" ]; do
#      found="no"
#      qstat=`qstat -u $USER`
#      for job in $jobs; do
#         if [ `echo $qstat | grep $job | wc -l` -gt 0 ]; then
#            found="yes"
#            break
#         fi
#      done
#      sleep 40
#      date
#   done
#}
#
#qj () {
#    n=`qstat cmb | grep $USER |  awk '{print $5}' | grep -c ^Q`
#    echo $n jobs queued on cmb
#}
#
#rj () {
#    n=`qstat cmb | grep $USER |  awk '{print $5}' | grep -c ^R`
#    echo $n jobs running on cmb
#}
#
#qju () {
#    n=`qstat cmb | grep $1 |  awk '{print $5}' | grep -c ^Q`
#    echo $n jobs queued on cmb
#}
#
#rju () {
#    n=`qstat cmb | grep $1 |  awk '{print $5}' | grep -c ^R`
#    echo $n jobs running on cmb
#}
#
#qs () {
#    qstat -a cmb | grep $USER
#}
#
#qarj() {
#    qj
#    rj
#}
#
#qarju() {
#    qju $1
#    rju $1
#}
#
#qlist() {
#    for x in `qstat | grep cmb |  awk '{print $3}' | sort | uniq`; do
#      queued=`qstat cmb | grep $x |  awk '{print $5}' | grep -c ^Q`
#      running=`qstat cmb | grep $x |  awk '{print $5}' | grep -c ^R`
#      echo -e "$x:\t$running ($queued)"
#   done
#}
#
#
#chigh() {
#    OVLPSDIR=$HOME/Research/om/data/cluster/Z.mays/SwaI/2.1million
#    last=`ls $OVLPSDIR | awk -F . '{print $2}' | sort -n | tail -1`
#    echo $last
#}
#
#clow() {
#    OVLPSDIR=$HOME/Research/om/data/cluster/Z.mays/SwaI/2.1million
#    last=`ls $OVLPSDIR | awk -F . '{print $2}' | sort -n | head -1`
#    echo $last
#}
#
#ccount() {
#    OVLPSDIR=$HOME/Research/om/data/cluster/Z.mays/SwaI/2.1million
#    echo `ls $OVLPSDIR | wc -l`
#}
#
#
#countseq() {
#    grep -c "^>" $1
#}
#
