#include <cstdio>
#include <vector>
#include <string>
#include <stack>


#include <algorithm>    // std::sort


using std::string;
using std::vector;



int main(int argc, char *argv[]){
  Solution S;

  auto v = vector<int>{1,0,-1,0,-2,2};
  auto o = S.fourSum(v, 0);
  for (auto x : o){
    for (auto i : x)
      printf("%d ",i);
    puts("");
  }
  //   for (auto i : "0123456789"){
  //     printf("code for %c is %d\n", i, i);
  // }
  return 0;
}
