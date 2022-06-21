// to be included in m.cpp

double get_M_Rd(double A_s_mm2, double f_yd_N_mm2, double d_mm,
                double x_mm, double E_s_N_mm2, double ep_cu,
                double c_mm);
void check_ep_s(double ep_cu, double x, double c, double d);
double get_real_A_s_mm2(double A_sreq_mm2);
void beam_flex_designer::Do(){
  double x_a_mm = 0.25 * d_mm;
  double f_yd_N_mm2 = f_yk_N_mm2 / 1.15;
  double f_cd_N_mm2 = 0.85 * f_ck_N_mm2 / 1.5;
  double A_sreq_mm2 = M_Ed_Nmm / (f_yd_N_mm2 * 0.9 * d_mm);

  // data
  double ep_s(0.0021),ep_cu(0.0035),
    E_s_N_mm2(f_yd_N_mm2 / ep_s),c_mm(40),B_mm(300);
  s.show_write(d_mm,"d","mm");
  s.show_write(x_a_mm,"Assumed x", "mm","x_a");
  s.show_write(M_Ed_Nmm,"M_Ed","Nmm","M_Ed");
  s.show_write(A_sreq_mm2,"A_sreq","mm2","A_sreq");

  double A_s_mm2 = get_real_A_s_mm2(A_sreq_mm2);
  s.show(A_s_mm2,"A_s","mm2");  // cout << [array] is implemented in mylib2.h
  double x_mm = find_x(A_s_mm2,B_mm,E_s_N_mm2,
                       f_cd_N_mm2,f_yd_N_mm2,c_mm,
                       ep_cu);
  s.show(x_mm,"Calculated x","mm");
  check_ep_s(ep_cu, x_mm, c_mm, d_mm);

  double M_Rd_N_mm = get_M_Rd(A_s_mm2, f_yd_N_mm2, d_mm,
                         x_mm, E_s_N_mm2, ep_cu, c_mm);
  s.check_smaller(M_Ed_Nmm * 1e-6, M_Rd_N_mm * 1e-6, "M_Ed (kNm)", "M_Rd (kNm)");
}

double get_M_Rd(double A_s_mm2, double f_yd_N_mm2, double d_mm,
                double x_mm, double E_s_N_mm2, double ep_cu,
                double c_mm){
  double a1 = f_yd_N_mm2 * (d_mm - 0.4 * x_mm);
  double a2 = (E_s_N_mm2 * ep_cu * (x_mm - c_mm) / x_mm)
    * (0.4 * x_mm - c_mm);
  return A_s_mm2 * (a1 + a2);
}

void check_ep_s(double ep_cu, double x,
                            double c, double d){
  double ep_sy = 0.0021;
  double ep_s = (d - x) * ep_cu / x;
  double ep_s_prm = (x - c) * ep_cu / x;

  s.check_smaller(ep_sy,ep_s,"ɛ_sy", "ɛ_s");
  s.check_smaller(ep_s_prm,ep_sy,"ɛ_s'", "ɛ_sy");
}

double beam_flex_designer::find_x(double A, double B, double E,double f_cd,
                                  double f_yd,double co, double ep_cu){
  mylib2::Rule("Finding x");
  s.show(A,"Steel Area A_s","mm2");
  s.show(B,"Section Width","mm");
  s.show(E,"Es","N/mm2");
  s.show(f_cd,"f_cd","N/mm2");
  s.show(f_yd,"f_yd","N/mm2");
  s.show(co,"cover c","mm");
  s.show(ep_cu,"ep_cu","");

  double a = 0.8 * B * f_cd;
  double b = (A * E * ep_cu - A * f_yd);
  double c = - A * E * ep_cu * co;
  mylib2::Rule("For the quadratic eqn",1); // subheading 1

  s.show(a,"a","");
  s.show(b,"b","");
  s.show(c,"c","");
  auto [r1, r2] = mylib2::math::SolveQuadratic(a,b,c);
  return r1;
}


#define Tf(A,O,F) transform(A.begin(), A.end(),O.begin(),F);
#define Tf2(a,b,o,f) transform(A.begin(), A.end(),B.begin(), O.begin(),F);
double get_real_A_s_mm2(double A_sreq_mm2){
  array<double,2> d = {18,14};
  auto get_area = [](double d){return M_PI * d * d / 4;};
  array<double,2> a;
  Tf(d,a,get_area);

  s.show(a,"Area","mm2");
  mylib2::Rule("Getting realistic steel area: ");

  // Grid-search all the combinations to find the minimized steel area that
  // suffices the A_sreq
  array<int,2> N;               // N = ceil(A_sreq_mm2/a)
  Tf(a,N,[&A_sreq_mm2] (double a)->int{return int(ceil(A_sreq_mm2 / a));});
  s.show(N,"Looping N","");
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
        printf("\tUpdating a_c, now it's %5.4g,"
               "found at i=%d,j=%d\n",
               a_c, i,j);
      }
    }

  mylib2::Rule("Grid Search of A_s 🐸 done.");
  printf("Use %d [%.0fmm] bar and %d [%.0fmm] bar\n", n[0],d[0],n[1],d[1]);
  return a_c;
}
