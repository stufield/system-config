# add an alias to the Git plugin
alias gau='git add -u'
alias gpo='git stash pop --index'
alias gta='git tag -n'
alias gac='git commit --amend --no-edit'
alias gpr='git pull --rebase --autostash -v'


# git-soma related functions
git_commit_cur() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
  echo "\033[31mFetching latest commit SHA from master branch:\033[0m"
  printf "\033[32m%-25s\033[33m Commit\033[0m\n" 'Package'
  pkgs=(
    palantir
    SomaModelAssessment
    SomaClassify
    SomaGlobals
    SomaMixedEffects
    SomaNormalization
    SomaPCA
    SomaPlot
    SomaPlyr
    SomaReadr
    SomaStabilitySelection
    SomaSurvival
    somaverse
  )
  for i in ${pkgs[@]}; do 
    cd $i
    printf "\033[34m%-25s\033[0m $(git rev-parse master | cut -c -11)\n" $i
    cd ..
  done
  cd $CURPWD
}

git_tag_diff() {
  CURPWD=$PWD
  cd $R_SOMA_DEV
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
      echo "\033[33m>\033[0m \033[31m$DIR\033[0m ... \033[33mNot a Git repo ...\033[0m"
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
  for i in {Soma*,somaverse,palantir}; do
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
