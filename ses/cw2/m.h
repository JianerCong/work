#pragma once

#include <iostream>
#include <string>
#include <iomanip>
#include <float.h>              // for DBL_MAX
#include <algorithm>            // for std::transform
#include "mylib2.h"
#include <tuple>
#include <vector>

using std::vector;
using std::cout;
using std::endl;
using std::string;
using std::setw;
using std::transform;
using std::tuple;
using mylib2::my_test::tester;

class shower{
private:
  FILE* fp;
public:
  shower(string fn = "data.tex");
  ~shower();

  template<typename T> // the type T will be "cout << v"
  void show(T v, string n,string unit="");

  void show(double v, string n,
            string unit="");

  template<int N>
  void show(array<double,N> v, string n,
            string unit="");

  void show_write(double v, string n,
            string unit="",string lab="",
            const char* fmt="%.3g");

  void check_smaller(double x1, double x2,
                     string n1, string n2); // check that x1 < x2
  static void Test(tester &t);
};

class beam_flex_designer{
private:
  double d_mm, f_yk_N_mm2, M_Ed_Nmm, f_ck_N_mm2;
  double find_x(double A, double B, double E,
                double f_cd, double f_yd,double co,
                double ep_cu);
public:
  beam_flex_designer(double d, double f,double f2,double m):
    d_mm(d), f_yk_N_mm2(f), M_Ed_Nmm(m), f_ck_N_mm2(f2){};
  void Do();
};

class beam_ductility_checker{
public:
  void Do();
};

// global data
shower s;

