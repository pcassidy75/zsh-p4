#!/bin/zsh
# Attempt at making a prompt which automatically gives p4 branch, status etc.
# Idea:
#   Get 'branch' from p4 client -o: By convention the branch is the third 'level' //<depot>/<product>/<branch>
#   Get status from p4 opened
#   Todo: Get Remote from p4 sync -N | grep 0/0/0
#   Use $ZSH_THEME_GIT* settings for a consistent look and feel
function p4_prompt_info() {

# Get 'Branch' info (fifth field from //<depot>/<product>/<branch>)
  local branch
  # weird redirects need to preserve exit status from p4 client (better way?)
  branch=$(grep '//' < <(p4 client -o 2> /dev/null) > >(tail -n 1 | cut -d / -f 5)) || return 0

  # Todo: Integrate p4 sync info into upstream
  local upstream

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch:gs/%/%%}${upstream:gs/%/%%}$(parse_p4_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function parse_p4_dirty() {
  local STATUS
  STATUS=$(p4 opened 2> /dev/null | tail -n 1)
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}
