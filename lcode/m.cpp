#include <cstdio>
#include <vector>
#include <string>

#include <algorithm>    // std::sort


using std::string;
using std::vector;

class Solution {
public:
  vector<int> n;                // global data
  vector<vector<int>> res;
  vector<int> quad;

  vector<vector<int>> fourSum(vector<int>& nums, int target) {
    n = nums;
    std::sort(n.begin(), n.end());
  }

  void kSum(int k, int start, int target){
    if (k != 2){
      for (int i =start;i < n.size()-k+1;i++)
}
}
};

int main(int argc, char *argv[]){
  Solution S;

  string s = "23";
  for (auto x : S.letterCombinations(s))
    printf("%s ",x.c_str());

  puts("");
  //   for (auto i : "0123456789"){
  //     printf("code for %c is %d\n", i, i);
  // }
  return 0;
}
