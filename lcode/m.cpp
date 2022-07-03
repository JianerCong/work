#include <vector>
#include <algorithm>    // std::sort
#include <cstdio>

using std::vector;

class Solution {
public:
  int threeSumClosest(vector<int>& nums, int target) {
    int result;
    std::sort(nums.begin(), nums.end());

    int L = nums.size();

    for (int i=0;i<L-2;i++){
      if (i > 0 && nums[i-1] == nums[i])
        continue;
      int pa = i + 1;
}
  }
};
