from typing import Dict, List
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        d = dict()
        for i in range(len(nums)):
            n = target - nums[i]
            if n in d:
                return [i,d[n]]
            else:
                d[n] = i
