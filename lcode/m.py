from typing import Dict, List
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums.sort()

        out = []

        L = len(nums)
        for i in range(L-2):
            if i == 0 or (i > 0 and nums[i] != nums[i-1]):
                # for each unique first entry
                # solve a two sum
                pa = i + 1
                pb = L - 1

                s = -nums[i]    # sum

                while pa < pb:
                    r =  nums[pa] + nums[pb] + s
                    if r == 0:
                        # add the triplet
                        out.append([nums[i], nums[pa], nums[pb]])
                        # skip duplicate second entries and third entries
                        # by moving to the last duplicate
                        while pa < pb and nums[pa+1] == nums[pa]: pa+=1
                        while pa < pb and nums[pa-1] == nums[pb]: pa-=1

                        # step to the first non-duplicate entry
                        pa+=1
                        pb-=1
                    elif r > 0:
                        pb-=1
                    else:
                        pa+=1
        return out
