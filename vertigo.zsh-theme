KUBE_PS1_CTX_COLOR=212
KUBE_PS1_NS_COLOR=103
KUBE_PS1_SYMBOL_COLOR=110
KUBE_PS1_SEPARATOR=" "
KUBE_PS1_DIVIDER=" "
KUBE_PS1_SYMBOL_DEFAULT="\Uf10fe"

PROMPT='
%{$FG[033]%}%n%{$fg[white]%}/%{$FG[103]%}%m %{$FG[111]%}%c%{$reset_color%} $(git_prompt_info)$(kube_ps1)
%(?:%{$FG[085]%}❯ %{$reset_color%}:%{$FG[197]%}❯ %{$reset_color%})'
#PROMPT+='%{$FG[111]%}%c%{$reset_color%} $(git_prompt_info)'

#PROMPT='$(kube_ps1)'$PROMPT
#RPROMPT='$(kube_ps1)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[231]%}(%{$FG[098]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}) "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[223]%} %{$FG[231]%} %{$FG[198]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[223]%} %{$FG[231]%}"

# icons ➜        ✘ ➥  ❯
# k8s icons ☸ ⎈ 󱃾

