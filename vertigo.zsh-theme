PROMPT="%{$fg[cyan]%}%n%{$fg[white]%}/%{$FG[103]%}%m %(?:%{$FG[112]%}➜ :%{$FG[203]%}➜ )"
PROMPT+='%{$FG[111]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[231]%}(%{$FG[098]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}) "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[223]%} %{$FG[231]%} %{$FG[198]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[223]%} %{$FG[231]%}"

# icons ➜        ✘
