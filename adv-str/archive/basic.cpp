// {{{ headers

#include <iostream>
#include <vector>
#include <tuple>
#ifdef _WIN32
#include "C:\Users\congj\AppData\Roaming\Templates\mylib2.hpp"
#else
#include "/home/me/Templates/mylib2.hpp"
#endif

// The feet to inch ratio
#define US 12

using std::cout;
using std::endl;
using std::vector;
using std::tuple;
using std::get;
using std::make_tuple;
using std::ostream;

// }}}
typedef tuple<double,double> vec;
// {{{ operator<< for vec

ostream& operator<<(ostream & os, const vec &v){
  os << "[" << get<0>(v) << " , " << get<1>(v) << "]";
  return os;
}

// }}}
// {{{ void expect_equal<T>

template<typename T>
void expect_equal(T a, T b, const char * msg = "Item"){
  cout << '\t' << msg << " Tested: ";
  if (a == b){
    cout << S_GREEN "OK\n" S_NOR;
  }else{
    cout << S_RED "not Okay" << a << " == " << b << " is not true." << S_NOR;
  }
}

// }}}

// {{{ vec get_inital_prestress_load(double A_ps, vec f_pi_pe)

/**
 * @brief Calculate the prestress load in N.
 * Return [P_i, P_e] : the inital and final prestress force.
 * @param A_ps the cross section area of tendon.
 * @param f_pi_pe the pair [f_pi f_pe]
 */
vec get_inital_prestress_load(double A_ps, vec f_pi_pe){
  return make_tuple(get<0>(f_pi_pe) * A_ps,
                    get<1>(f_pi_pe) * A_ps);
}

void test_get_inital_prestress_load(){
  report("get_inital_prestress_load");
  vec p = get_inital_prestress_load(10, make_tuple(1,2));
  expect_equal<vec>(p, make_tuple(10,20), "value of P");
  // expect_equal<double>(10, get<0>(p), "element 0 of P");
  // expect_equal<double>(20, get<1>(p), "element 1 of P");
}
// }}}
// {{{ double get_mid_span_moment(double w, double l)

double get_mid_span_moment(double w, double l){
  return US * w * l * l / 8;
}

void test_get_mid_span_moment(){
  report("test_get_mid_span_moment");
  expect_equal<double>(get_mid_span_moment(2,3), 2.25, "T1");
  expect_equal<double>(get_mid_span_moment(4,8), 32, "T2");
}

// }}}
// {{{ struct geom{A_c, r2, e}

struct geom{
  double A_c;                   // the concrete section
  double r2;                    // the radius of gyration r^2
  double e;                     // the eccentricity
};

// }}}
// {{{double get_stress(bool is_top, geom g, double P, double M, double S, double c)

double get_stress(bool is_top, geom g, double P, double M, double S, double c){
  double sign = is_top ? -1 : 1;
  double A,B,C;
  A = P / g.A_c;
  B = 1 + sign * g.e * c  / g.r2;
  C = M / S;

#ifdef VERBOSE
  cout << "A : " << A << endl;
  cout << "B : " << B << endl;
  cout << "C : " << C << endl;
#endif
  return -(A * B) + sign * C;
}

void test_get_stress(){
  report("get_stress");
  double a = get_stress(true,
                        {2, 7, 9},
                        4, 240, 2, 7);
  expect_equal<double>(a, 100);

  a = get_stress(false,
                        {2, 7, 9},
                        4, 240, 2, 7);
  expect_equal<double>(a, -104);
  }

// }}}

// {{{ expect_less_than<T>(a, b, nam_a, nam_b)

// {{{ SHOW_LESS_THAN_RESULT(o,s,f)

#define SHOW_LESS_THAN_RESULT(o,s,f) cout << nam_a  \
  << " " s " ";                                 \
  cout.width(15);                               \
  cout << nam_b                                 \
  << f "  " o " : " S_NOR;                      \
  cout << a << " " s " " << b

// }}}

template<typename T>
void expect_less_than(T a, T b, const char * nam_a, const char * nam_b){

  cout.width(13);
  cout.setf(std::ios_base::left);
  if (a <= b){
    SHOW_LESS_THAN_RESULT("OK","<=",S_GREEN);
  }else{
    SHOW_LESS_THAN_RESULT("NOT OK",">",S_RED);
  }
  cout << endl;
}

// }}}
// {{{ void work()

// {{{ void by_basic_principle(args)

void by_basic_principle(tuple<double, double, double, double,
                        geom,double, double,double, vec, double> args){
  auto [S_t, S_b, c_t, c_b, g, w, l, w_s ,f_i_e, A_ps] = args;

  // {{{ 1. get_inital_prestress in thread.

  vec p_i_e = get_inital_prestress_load(A_ps,f_i_e);
  cout << "[P_i, P_e] is " << p_i_e << "lb " << endl;;

  // }}}
  // {{{ 2. get the mid-span moment
  double M = get_mid_span_moment(w, l);
  cout << "The mid-pan moment : " << M << "in lb\n";

  // }}}
  // {{{ 3. calculate f_top and f_bottom for init (i.e. uses P_i)

  double f_top, f_bottom;

  f_top = get_stress(true, g, get<0>(p_i_e), M, S_t, c_t);
  f_bottom = get_stress(false, g, get<0>(p_i_e), M, S_b, c_b);

  cout << "[f_top f_bottom] :" << make_tuple(f_top, f_bottom) << "  psi " << endl;

  double f_ct = 2880;
  auto abs = [](double x){return x > 0 ? x : -x;};
  expect_less_than<double>(abs(f_top), f_ct, "f_top", "f_ct");
  expect_less_than<double>(abs(f_bottom), f_ct, "|f_bottom|", "f_ct");

  // }}}
  // {{{ 4. calculate the f_top and f_bottom for final
  // {{{ 4.1 get the M for service load

  double M_new = get_mid_span_moment(w_s,l);
  M += M_new;
  cout << "The mid-pan moment M_new caused by service load : " << M_new << " in lb\n";
  cout << "The new mid-pan moment M : " << M << "in lb\n";

  // }}}
  // {{{ 4.2 get the new f

  f_top = get_stress(true, g, get<1>(p_i_e), M, S_t, c_t);
  f_bottom = get_stress(false, g, get<1>(p_i_e), M, S_b, c_b);
  cout << " the new [f_top f_bottom] :" << make_tuple(f_top, f_bottom) << "  psi " << endl;

  expect_less_than<double>(f_top, 0.45 * 6000, "f_top", "f_c");
  expect_less_than<double>(abs(f_bottom), 930, "|f_bottom|", "12√f_c'");

  // }}}
  // }}}
}

// }}}

void work(){
  cout.precision(4);

  // {{{ 0. Data

  double S_t = 3607, S_b = 1264,
    c_t = 6.23, c_b = 17.77;
  geom g = {449, 50.04, 14.77};
  double w, l, w_s;
  w = 359;                      // the inital load
  w_s = 420;                    // the service load
  l = 64;                       // the span
  vec f_i_e =  make_tuple(189e3, 150e3);
  double A_ps = 1.53;           // the area of tendon (in2)

  // }}}
  by_basic_principle(make_tuple(S_t, S_b, c_t, c_b, g, w, l, w_s ,f_i_e, A_ps));
}

// }}}
// {{{ void test()

void test(){
  // test_get_inital_prestress_load();
  test_get_mid_span_moment();
  test_get_stress();
}

// }}}

// {{{ main

int main(int argc, char *argv[]){
  work();
  return 0;
}

// }}}
