#include "my_test.h"

using namespace my_test;

#ifdef TEST
int main(int argc, char *argv[]){
  tester::Test();
  test::Test();
  return 0;
  }
#endif
