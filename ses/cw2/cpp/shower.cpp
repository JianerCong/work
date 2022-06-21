// to be included in m.cpp

shower::shower(string fn){
  fp = fopen(fn.c_str(), "a+");
  if(fp != NULL){
    printf("🐸 open file: ok\n");
  }else{
    printf("failed to open file.\n");
    exit(1);
  }
}

shower::~shower(){
  fclose(fp);
  printf("🐸 file closed\n");
}

template<typename T>
void shower::show(T v, string n, string unit){
  cout.precision(4);
  cout
    // << std::setiosflags (std::ios::left)
       << setw(15) << n
       << setw(10) << unit << ":"
       << std::setiosflags (std::ios::right)
       << setw(20)
       << v
       << endl;
}

void shower::show(double v, string n, string unit){
  printf("%15s %10s %15.4g\n",
         n.c_str(),
         unit.c_str(),
         v);
}

template<int N>
void shower::show(array<double,N> v, string n,
                  string unit){
  printf("%15s %10s ",n.c_str(),unit.c_str());
  for (auto i : v){
    printf("%10.2g", i);
  }
  puts("");
}

void shower::show_write(double v, string n,
                string unit,string lab,
                const char* fmt){
  if (lab == "") lab = n;
  printf("[%-10s] ",lab.c_str());
  show(v, n, unit);

  // Write the data here:
  string val = mylib2::Sprintf(fmt,v);
  fprintf(fp,"\\MySet{%s}{%s}\n",
          lab.c_str(), val.c_str());
}

void shower::check_smaller(double x1, double x2,
                           string n1, string n2){
  bool ok = (x1 < x2);
  printf("%s [%6.4g] should be smaller than %s [%6.4g]:\t",
         n1.c_str(),x1,
         n2.c_str(),x2);
  if (ok){
    cout << S_GREEN "OK" S_NOR;
  }else{
    cout << S_RED "NOT OK" S_NOR;
  }
  puts("");
}

void shower::Test(tester &t){
  t.log("Testing shower.\n");
  shower s;
  s.show(2.2, "a_double","cm");
  s.show(true, "a_bool");
  s.show(string("hi"), "a string");
}

