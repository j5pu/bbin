# shellcheck shell=sh

if has tput; then
  LESS_TERMCAP_mb=$(tput -T ansi setaf 2; tput -T ansi bold) # start bold
  LESS_TERMCAP_md=$(tput -T ansi setaf 2; tput -T ansi bold) # start bold
  LESS_TERMCAP_me=$(tput -T ansi sgr0)  # turn off bold, blink and underline
  LESS_TERMCAP_so=$(tput -T ansi setaf 3; tput -T ansi smso)  # start standout (reverse video)
  LESS_TERMCAP_se=$(tput -T ansi sgr0; tput -T ansi rmso)  # stop standout
  LESS_TERMCAP_us=$(tput -T ansi setaf 1 ; tput -T ansi smul)  # start underline
  LESS_TERMCAP_ue=$(tput -T ansi sgr0; tput -T ansi rmul)  # stop underline
  export LESS_TERMCAP_mb
  export LESS_TERMCAP_md
  export LESS_TERMCAP_me
  export LESS_TERMCAP_se
  export LESS_TERMCAP_so
  export LESS_TERMCAP_ue
  export LESS_TERMCAP_us
fi

! has most || export MANPAGER=most

export PAGER=less
