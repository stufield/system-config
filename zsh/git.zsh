# add an alias to the Git plugin
alias gau='git add -u'
alias gpo='git stash pop --index'
alias gtn='git tag -n'
alias gac='git commit --amend --no-edit'
alias gpr='git pull --rebase --autostash -v'
alias gwip='git add -u; git commit --no-verify --no-gpg-sign -m "wip"'


# git-soma related functions
git_commit_cur() {
  CURPWD=$PWD
  cd $R_SOMAVERSE
  echo "\033[31mFetching latest commit SHA from current branch:\033[0m"
  printf "  \033[32m%-25s\033[33m Commit\033[0m\n" 'Package'
  for i in `ls -d */`; do
    cd $i
    DIR=${i%/}
    if [ -d ".git" ]; then
      CUR_BRANCH=`git rev-parse --abbrev-ref HEAD`
      printf "\033[33m>\033[34m %-25s\033[0m $(git rev-parse $CUR_BRANCH | cut -c -7)\n" $DIR
    else
      printf "\033[33m> \033[31m%-25s Not a Git repo ...\033[0m\n" $DIR
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

git_tag_diff() {
  CURPWD=$PWD
  cd $R_SOMAVERSE
  for i in `ls -d */`; do
    cd $i
    DIR=${i%/}
    if [ -d ".git" ]; then
      TAG1=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=0 --max-count=1)` > /dev/null 2>&1
      TAG0=`git describe --abbrev=0 --tags $(git rev-list --tags --skip=1 --max-count=1)` > /dev/null 2>&1
      if [ -z "$TAG0" ]; then
        echo "\033[33m>\033[0m \033[31m$DIR\033[0m ... \033[33mNo Tags ...\033[0m"
      else
        COMMITS=`git rev-list $TAG1 ^$TAG0 --count`
        STAT=`git diff --shortstat $TAG1 ^$TAG0 ':(exclude)*.html'`
        echo "$DIR, $TAG0 -> $TAG1, $COMMITS commits,$STAT"
      fi
    else
      echo "\033[33m> \033[31m$DIR\033[0m ... \033[33mNot a Git repo ...\033[0m"
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

git_tags_cur() {
  CURPWD=$PWD
  cd $R_SOMAVERSE
  for i in `ls -d */`; do
    cd $i
    DIR=${i%/}
    if [ -d ".git" ]; then
      TAG=`git describe --abbrev=0 --tags` > /dev/null 2>&1
      if [ -z "$TAG" ]; then
        printf "\033[33m> \033[32m%-25s \033[33mNo tags ...\033[0m\n" $DIR
      else
        COMMIT=$(git tag -l --format='%(object)' $TAG | cut -c -7)
        printf "\033[33m>\033[032m %-25s\033[0m \033[33m$TAG\033[0m (\033[034m$COMMIT\033[0m)\n" $DIR
      fi
    else
      printf "\033[33m> \033[31m%-25s \033[33mNot a Git repo ...\033[0m\n" $DIR
    fi
    cd $OLDPWD
  done
  cd $CURPWD
}

git_branch_status2() {
  CURPWD=$PWD
  printf "  \033[32m%-25s\033[33m Branch State\033[0m\n" 'Repository'

  DIRS=""
  for i in `ls -d $R_SOMAVERSE/*/`; do
    cd $i
    if [ -d ".git" ]; then
      DIRS+=($i)
    fi
  done

  for dir in $DIRS; do
    cd $dir && git_branch_status
  done
  cd $CURPWD
}

git_branch_status() {
  BASENAME=${PWD##*/}
  CUR_BRANCH=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
  DEFAULT_BRANCH=$(git_main_branch)   # comes from ZSH git plugin
  COMMITS_AHEAD=`git rev-list --count @{upstream}..HEAD 2>/dev/null`
  COMMITS_BEHIND=`git rev-list --count HEAD..@{upstream} 2>/dev/null`
  printf "\033[33m>\033[31m %-25s \033[32m$CUR_BRANCH \033[0m(\033[34mbehind remote: \033[33m$COMMITS_BEHIND\033[34m <|> ahead remote: \033[33m$COMMITS_AHEAD\033[0m)\n" $BASENAME
  if [[ $CUR_BRANCH != $DEFAULT_BRANCH ]]; then
    COMMITS_AHEAD_DEFAULT=`git rev-list --right-only --count $DEFAULT_BRANCH...$CUR_BRANCH`
    COMMITS_BEHIND_DEFAULT=`git rev-list --left-only --count $DEFAULT_BRANCH...$CUR_BRANCH`
    printf "%-27s \033[32m$CUR_BRANCH \033[0m(\033[34mbehind $DEFAULT_BRANCH: \033[33m$COMMITS_BEHIND_DEFAULT\033[34m <|> ahead $DEFAULT_BRANCH: \033[33m$COMMITS_AHEAD_DEFAULT\033[34m)\033[0m\n"
  fi
}

git_check_status() {
  CURPWD=$PWD
  cd $R_SOMAVERSE
  for i in `ls -d */`; do
    cd $i
    if [ -d ".git" ]; then
      if [[ -z $(git status --porcelain) ]]; then
        echo -e "* \033[33m$i\033[0m ... \033[32mClean \xE2\x9C\x94\033[0m"
      else 
        CUR_BRANCH=`git rev-parse --abbrev-ref HEAD`
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "\033[31m* $i\033[0m ... \033[34m$CUR_BRANCH\033[0m"
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
