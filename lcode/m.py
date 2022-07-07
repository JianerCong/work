from typing import List
class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        nums.sort()
        res, quad = [],[]

        def kSum(k, start, target):
            print(f"kSum called with {k}, {start}, {target}")
            if k!= 2:
                for i in range(start, len(nums) - k + 1):  # if k=4, reserve 3(=k-1)
                    print(f"\ti = {i}")
                    if i > start and nums[i] == nums[i-1]:
                        continue         # skip duplicate this nums[i]
                    quad.append(nums[i])  # push in the stack
                    kSum(k-1,i+1,target - nums[i])           # solve a k-1 sum problem
                    quad.pop()                               # done
                return
            # base case two sum II
            l, r = start, len(nums) - 1
            while l < r:
                if nums[l] + nums[r] < target:
                    l+=1
                elif nums[l] + nums[r] > target:
                    r-=1
                else:           # found
                    res.append(quad + [nums[l], nums[r]])
                    l+=1
                    while l < r and nums[l] == nums[l-1]:
                        l+=1

        kSum(4, 0, target)
        return res
