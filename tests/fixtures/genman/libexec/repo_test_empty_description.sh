#!/bin/sh

#
# repo_test.sh is a test library with one function repo_test_function

#######################################
#  this is the description of function a with spaces and .
#######################################
repo_test_function_sh_a() {
  :
}

#######################################
#  this is the description of function b with spaces and .
#######################################
repo_test_function_sh_b() (
  :
)

#######################################
#  this is the description of function c with spaces and .
#######################################
repo_test_function_sh_c() if true; then true; fi

#######################################
#  this is the description of function d with spaces and .
#######################################
repo_test_function_sh_d(){
  :
}

#######################################
#  this is the description of function e with no spaces and ()
#######################################
repo_test_function_sh_e()(
  :
)

#######################################
#  this is the description of function f with no spaces and ::
#######################################
repo_test::function_sh_f()(
  :
)

repo_test_empty_description()(
  :
)
