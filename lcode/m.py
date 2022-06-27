from typing import Dict, List
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        if len(nums) < 3: return []

        r2 = []
        n0, s, s2 = self.make_sets(nums)

        #print(f'Checking 000:')
        if n0 >= 3:
            r2.append([0,0,0])

        #print(f'Checking abc')
        r = []
        l = list(s)
        L = len(s)
        for i in range(L):      # 0,..,L-1
            for j in range(i+1,L):  # i+1,..,L-1
                n1,n2 = l[i],l[j]
                # take these two out
                s.remove(n1);s.remove(n2)

                # See if there difference is in the set
                n3 = -(n1 + n2)

                if {n1,n2,n3} not in r and n3 in s:
                    r.append({n1,n2,n3})
                    #print(f'Adding {n1},{n2},{n3}')

                # push back the two
                s.add(n1);s.add(n2)

        #print(f'Checking aab')
        for n in s2:
            n0 = - 2*n
            if n0 in s:
                r2.append([n,n,n0])
                #print(f'Adding {n},{n},{n0}')

        r1=[]
        for l in r:
            i = list(l)
            #i.sort()
            r1.append(i)

        return r1 + r2

    def make_sets(self,nums: List[int]):
        s = set()
        s2 = set()
        n0 = 0                  # number of 0
        for n in nums:
            if n == 0:
                n0 += 1
            if n in s and n != 0:  # 0 shouldn't be in s2
                s2.add(n)
            else:
                s.add(n)
        return n0,s,s2
