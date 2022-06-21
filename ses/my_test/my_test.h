#pragma once

#include <iostream>
#include <cstdio>
#include <stdexcept>
#include <list>
#include <stdarg.h>
#include "mylib2.h"

using std::runtime_error;
using std::cout;
using std::endl;
using std::string;
using std::list;

namespace my_test{
  class tester {
  public:
    tester(bool v):verbose(v){};
    virtual ~tester();
    void rule(string msg);
    void log(string msg);
    void fatal(string msg);
    void expect_near(double x, double y, string comment);
    static void Test();
  private:
    const string prefix = "\t";
    bool verbose;
    string get_comment_header(string msg);
  };

  typedef void (*to_be_test) (tester &t);

  class my_error : runtime_error{
  public:
    // Inherit base class constructor
    using runtime_error::runtime_error;
    using runtime_error::what;
  };

  class test {
    struct row{
      to_be_test func;
      string name;
      string msg;
      row(to_be_test f, string n){func = f; name = n;};
    };
    list<row> fs;
    tester *examer;
    void test_that(row &r);
  public:
    test(bool verbose);
    virtual ~test();
    void add(to_be_test f, string n);
    void run();
    void show_tests();
    void show_results();
    static void Test();
  };
}

