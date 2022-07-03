from typing import List
from numpy import array

class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        nums = array(nums)
        nums.sort()
        result = nums[0] + nums[1] + nums[-1]

        L = len(nums)
        for i in range(L-2):
            if i > 0 and nums[i-1] == nums[i]:
                continue
            pa = i + 1
            pb = L - 1

            while pa < pb:
                current_sum = nums[i] + nums[pa] + nums[pb]

                if current_sum == target:
                    return current_sum
                elif current_sum > target:
                    # decrement to next nums[pb]
                    pb -= 1
                else:
                    # increment to next nums[pa]
                    pa += 1

                if abs(current_sum - target) < abs(result - target):
                    result = current_sum

        return result
