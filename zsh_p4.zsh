# Attempt at making a prompt which automatically gives p4 branch, status etc.
# Idea:
#   Use p4 info to figure out if we are in a p4 client
#   Get 'branch' from p4 client -o: By convention the branch is the third 'level' //<depot>/<product>/<branch>
#   Get status from p4 opened
#   Get Remote from p4 sync -n
#   Use $ZSH_THEME_GIT* settings for a consistent look and feel
function p4_prompt_info() {
  # If we are not in a p4 client get out
  if ! p4 client -o; then
    return 0
  fi
  # Get 'Branch' info
  local ref
  ref=$(p4 client -o | grep // | tail -n 1 | cut -d / -f 5 2> /dev/null) || return 0

  local upstream

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_p4_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
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
