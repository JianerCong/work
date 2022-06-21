#include <Rcpp.h>
#include <array>
#include <cstdio>
#include <algorithm>
#include <cmath>
#include <tuple>
#include <stdexcept>

using std::array;
using std::transform;
using std::tuple;
using std::domain_error;
using namespace Rcpp;

#define Tf(A,O,F) transform(A.begin(), A.end(),O.begin(),F);
#define Tf2(a,b,o,f) transform(A.begin(), A.end(),B.begin(), O.begin(),F);

// [[Rcpp::export]]
List get_real_A_s_mm2(double A_sreq_mm2){
  array<double,2> d = {18,14};
  auto get_area = [](double d){return M_PI * d * d / 4;};
  array<double,2> a;
  Tf(d,a,get_area);

  printf("Getting realistic steel area: \n");

  // Grid-search all the combinations to find the minimized steel area that
  // suffices the A_sreq
  array<int,2> N;               // N = ceil(A_sreq_mm2/a)
  Tf(a,N,[&A_sreq_mm2] (double a)->int{return int(ceil(A_sreq_mm2 / a));});
  array<int,2> n = {0,0};
  double a_c = DBL_MAX;        // current lowest area

  double A;                       // use in loop
  printf("\tSearching A_s\n");
  for (int i = 0; i <= N[0]; i++) // i = 0:N[1]
    for (int j = 0; j <= N[1]; j++){
      A = i * a[0] + j * a[1];
      // printf("Now it's i: %3d j: %3d\n",i,j);
      if (A > A_sreq_mm2 && A < a_c){
        a_c=A;
        n[0]=i;n[1]=j;
        printf("\tUpdating a_c, now it's %5.4g," "found at i=%d,j=%d\n", a_c, i,j);
      }
    }

  printf("Grid Search of A_s 🐸 done.\n");
  printf("Use %d [%.0fmm] bar and %d [%.0fmm] bar\n", n[0],d[0],n[1],d[1]);
  return List::create(_["A_s_mm2"] = a_c,
                      _["n18"] = n[0],
                      _["n14"] = n[1]);
}

tuple<double,double> SolveQuadratic(double a, double b, double c);
// [[Rcpp::export]]
List find_x(double A, double B, double E,double f_cd,
                                  double f_yd,double co, double ep_cu){

  double a = 0.8 * B * f_cd;
  double b = (A * E * ep_cu - A * f_yd);
  double c = - A * E * ep_cu * co;
  double r1,r2;
  std::tie(r1,r2) = SolveQuadratic(a,b,c);
  return List::create(
                      _["x"] = r1,
                      _["a"] = a,
                      _["b"] = b,
                      _["c"] = c);
}

tuple<double,double> SolveQuadratic(double a,
                                    double b,
                                    double c){
  double th = b*b - 4*a*c;
  printf("SolveQuadratic called with \n\ta =%10.4g, b =%10.4g\n\tc =%10.4g, th=%10.4g\n",
         a,b,c,th);
  if (th < 0){
    throw domain_error("b^2 - 4ac < 0");
  }else{
    double x = - b / (2*a);
    double y = sqrt(th) / (2*a);
    // Use " " to refer to the global namespace.
    return ::std::make_tuple(x+y, x-y);
  }
}

// [[Rcpp::export]]
double get_M_Rd(double A_s_mm2, double f_yd_N_mm2, double d_mm,
                double x_mm, double E_s_N_mm2, double ep_cu,
                double c_mm){
  double a1 = f_yd_N_mm2 * (d_mm - 0.4 * x_mm);
  double a2 = (E_s_N_mm2 * ep_cu * (x_mm - c_mm) / x_mm)
    * (0.4 * x_mm - c_mm);
  return A_s_mm2 * (a1 + a2);
}
