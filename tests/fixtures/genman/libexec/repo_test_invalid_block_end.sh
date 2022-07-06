#!/bin/sh

#
# repo_test.sh is a test library with functions.

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

######################################
#   repo_test_invalid block end
#######################################
repo_test_invalid_block_end()(
  :
)
