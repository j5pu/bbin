#!/bin/sh
# shellcheck disable=SC2154
# bashsupport disable=BP3001
set -u

#
#   repo_test.sh is a test library with functions.

#######################################
#  function with() space and {
#######################################
repo_test_function_sh_a() {
  :
}

#######################################
#  function with() and ()
#######################################
repo_test_function_sh_b() (
  :
)

#######################################
#  function with() if true; then true; fi.
#######################################
repo_test_function_sh_c() if true; then true; fi

#######################################
#    function with(){
#######################################
repo_test_function_sh_d(){
  :
}

#######################################
#  function with()(.
#######################################
repo_test_function_sh_e()(
  :
)

#######################################
#   function f with spaces at the beginning and at the end and ::
#######################################
repo_test::function_sh_f()(
  :
)
