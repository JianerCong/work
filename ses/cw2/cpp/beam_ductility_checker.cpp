void beam_ductility_checker::Do(){
  double A_s_mm2(1225), b_mm(300), d_mm(460),
    rho;
  rho = A_s_mm2 / (b_mm * d_mm);
  s.show_write(rho,"ρ","","rho", "%.3g");
}
