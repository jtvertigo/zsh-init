PROMPT="%{$fg[cyan]%}%n%{$fg[white]%}/%{$FG[103]%}%m %(?:%{$FG[112]%}➜ :%{$FG[203]%}➜ )"
PROMPT+='%{$FG[111]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="  %{$fg[blue]%} %{$fg[yellow]%}✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="   %{$fg[blue]%}"

# icons ➜        ✘