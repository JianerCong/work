#include <cstdio>
#include <vector>
#include <string>
#include <stack>


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

    kSum(4,0,target);
    return res;
  }

  void kSum(int k, int start, int target){
    printf("kSum called with k=%d, start=%d, target=%d\n", k, start, target);
    if (k != 2){
      for (int i =start;i < n.size()-k+1;i++){
        printf("\t i =%d\n",i);
        if (i > start && n[i] == n[i-1])
          continue;
        quad.push_back(n[i]);
        kSum(k-1, i+1, target - n[i]);
        quad.pop_back();
      }
      return ;
    }
    // base case two sum II
    int l = start, r = n.size() - 1;
    while (l < r){
      if (n[l] + n[r] < target)
        l++;
      else if (n[l] + n[r] > target)
        r--;
      else{
        quad.push_back(n[l]);
        quad.push_back(n[r]);
        res.push_back(vector<int>(quad.begin(), quad.end())); // copy
        quad.pop_back();
        quad.pop_back();

        l+=1;
        while (l<r && n[l] == n[l-1]) l++;
      }
    }
  }
};

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
