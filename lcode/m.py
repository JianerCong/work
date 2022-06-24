from typing import Dict, List
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        r = []
        d = make_hash(nums)

        if d.get(0,0) >= 3:     # if there are more than 3 zeros
            r.append([0,0,0])

        keys = list(d.keys()).sort()

        while len(keys)>=3 and keys[0] < 0:
            # for all negative k
            j, k = 1, len(keys)-1
            # check all keys[0], keys[j], keys[k]
            while j < k:
                # check and j++, k--
            keys = keys[1:]

        return r

    def make_hash(self,nums: List[int]) -> Dict[int,int]:
        d: Dict[int,int] = dict()

        for n in nums:
            d[n] = d.get(n,0) + 1

        return d
