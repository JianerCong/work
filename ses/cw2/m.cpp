#include "m.h"
#include "cpp/shower.cpp"
#include "cpp/beam_flex_designer.cpp"
#include "cpp/beam_ductility_checker.cpp"

void go(){
  double d_mm(460), f_ck_N_mm2(25),f_yk_N_mm2(500), M_Ed_Nmm(216.9e6);
  beam_flex_designer b(d_mm,
                       f_yk_N_mm2,
                       f_ck_N_mm2,
                       M_Ed_Nmm);
  // b.Do();

  beam_ductility_checker b2;
  b2.Do();
}

void test(){
  bool verbose = true;
  mylib2::my_test::test t(verbose);
  t.add(shower::Test, "a simple shower test");
  t.show_tests();
  t.run();
  t.show_results();
}

int main(int argc, char *argv[]){
  // test();
  go();
  return 0;
}
