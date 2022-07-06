#!/bin/sh

#
# repo_test.sh is a test library with one function repo_test_function

#######################################
#  bash library function a with spaces and .
#######################################
repo_test_function_bash_a() {
  :
}

#######################################
#  this is the description of function b with spaces and .
#######################################
repo_test_function_b() (
  :
)

#######################################
#  this is the description of function c with spaces and .
#######################################
repo_test_function_c() if true; then true; fi
