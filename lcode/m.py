from typing import Dict, List
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        return [[]]

    def make_hash(self,nums: List[int]) -> Dict[int,int]:
        d: Dict[int,int] = dict()

        for n in nums:
            if n not in d.keys():
                d[n] = 0
            else:
                d[n] += 1
