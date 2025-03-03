# skondrashov oh-my-zsh-theme

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

function get_current_dir {
    echo "%{$green_bold%}${${PWD/#$HOME/~}##*/}%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} *"

function get_git_prompt {
    [[ -z $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] && return

    local git_status="$(git_prompt_status)"
    if [[ -n $git_status ]]; then
        git_status="[$git_status%{$reset_color%}]"
    fi

    local git_prompt="%{$magenta_bold%}  $(git_prompt_info)$git_status%{$reset_color%}"
    echo $git_prompt
}

function get_aws_prompt {
    [[ -z $AWS_PROFILE ]] && return

    local aws_prompt="%{$yellow_bold%} ☁️ $AWS_PROFILE%{$reset_color%}"
    echo $aws_prompt
}

function get_k8s_prompt {
    local kube_current_context=$(kubectl config current-context 2>/dev/null)
    [[ -z $kube_current_context ]] && return

    local k8s_prompt="%{$blue_bold%} ☸️ $kube_current_context %{$reset_color%}"
    echo $k8s_prompt
}

function get_prompt_title {
    local prompt_title="\
$(get_current_dir)\
$(get_git_prompt)\
$(get_k8s_prompt)\
$(get_aws_prompt) "

    print ""
    print -rP "$prompt_title"
}

function get_cursor_color {
    local cursor='➜'
    if [[ $? -eq 0 ]]; then
        echo "%{$green_bold%}$cursor %{$reset_color%}"
    else
        echo "%{$red_bold%}$cursor %{$reset_color%}"
    fi
}


autoload -U add-zsh-hook
add-zsh-hook precmd get_prompt_title
setopt prompt_subst

RPROMPT=''
PROMPT='$(get_cursor_color)'
