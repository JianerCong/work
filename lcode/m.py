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
            while j < k:        # for each k
                jmin = 1
                while j < k:    # find j for this k
                    if keys[j] + keys[k] == -keys[0]:
                        # once found, update jmin
                        jmin = j
                        o = [keys[0],keys[j],keys[k]]
                        r.append(o)
                        print(f'Found {o}')
                        break
                    else:
                        j+=1
                k -= 1
                # check and j++, k--
            keys = keys[1:]
        return r

    def make_hash(self,nums: List[int]) -> Dict[int,int]:
        d: Dict[int,int] = dict()
        for n in nums:
            d[n] = d.get(n,0) + 1
        return d

    def make_sets(self,nums: List[int]):
        s = set()
        s2 = set()
        n0 = 0                  # number of 0
        for n in nums:
            if n == 0:
                n0 += 1
            if n in s:
                s2.add(n)
            else:
                s.add(n)
        return n0,s,s2
