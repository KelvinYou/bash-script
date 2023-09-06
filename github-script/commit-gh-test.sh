#!/usr/bin/env sh

_() {
  YEAR="1990"
  # echo "GitHub Username: "
  # read -r USERNAME
  # echo "GitHub Access token: "
  # read -r ACCESS_TOKEN
  USERNAME=KelvinYou
  ACCESS_TOKEN=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

  C_YEAR=2021
  C_MONTH=02
  C_DAY=28

  [ -z "$USERNAME" ] && exit 1
  [ -z "$ACCESS_TOKEN" ] && exit 1  
  [ ! -d $YEAR ] && mkdir $YEAR

  cd "${YEAR}" || exit
  git init
  echo "**${YEAR}** - Generated by https://github.com/KelvinYou" \
    >README.md
  git add .
  GIT_AUTHOR_DATE="${C_YEAR}-${C_MONTH}-${C_DAY}T18:00:00" \
    GIT_COMMITTER_DATE="${C_YEAR}-${C_MONTH}-${C_DAY}T18:00:00" \
    git commit -m "feat: build Kelvin You"
  git remote add origin "https://${ACCESS_TOKEN}@github.com/${USERNAME}/${YEAR}.git"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${YEAR}"

  echo
  echo "Cool, check your profile now: https://github.com/${USERNAME}"
} && _

unset -f _