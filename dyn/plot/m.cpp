#include <iostream>
#include <vector>
#define _USE_MATH_DEFINES
#include <cmath>

using std::cout;
using std::endl;
using std::vector;


typedef double dbl;
const int N = 500;
const dbl pi = M_PI;


#include <Rcpp.h>
using namespace Rcpp;


dbl u0{1.0}, v0{2.0};

// [[Rcpp::export]]
List go(){
  cout << "Let's go\n";
  dbl T,om,A,B;
  T = 0.5; om = 2*pi/T; A = u0; B = v0/om;

  vector<dbl> t(N), u(N);

  const dbl max = 5;
  cout << "ω is " << om
       << "\nA is " << A
       << "\nB is " << B << endl;

  for (int i =0; i < N; i++){
    t[i] = i * max / N;
    u[i] = A*om*cos(om * t[i]) + B*om*sin(om * t[i]);
  };

  return List::create(
                      _["t"] = t,
                      _["u"] = u
                      );
}

// int main(int argc, char *argv[]){
//   go();
//   return 0;
//   }
