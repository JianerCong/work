#include <cstdio>
#include <string>
#include <stack>
#include <vector>



using std::string;
using std::vector;



// Definition for singly-linked list.
struct ListNode {
  int val;
  ListNode *next;
  ListNode() : val(0), next(nullptr) {}
  ListNode(int x) : val(x), next(nullptr) {}
  ListNode(int x, ListNode *next) : val(x), next(next) {}
  void show(){
    printf("%d",this->val);
    if (this->next){
      printf(" ");this->next->show();
    }
    else
      puts("");
  }
};

ListNode* l2L(vector<int> v){
  ListNode *n = nullptr;
  while (!v.empty()){
    // printf("pushing %d\n",v.back());
    n =  new ListNode(v.back(),n);
    v.pop_back();
  }
  return n;
}


class Solution {
public:
  ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
    ListNode* dummy = new ListNode();
    ListNode* tail = dummy;

    while (l1 && l2){
      if (l1->val < l2->val){
        tail->next = l1;
        l1 = l1->next;
      }else{
        tail->next = l2;
        l2 = l2->next;
      }
      tail = tail->next;
    }

    if (l1){
      tail->next = l1;
    }else if(l2)
      tail->next = l2;

    return dummy->next;
  }
};

int main(int argc, char *argv[]){
  Solution S;

  auto l1 = vector<int>{1,2,4};
  auto l2 = vector<int>{1,3,4};
  ListNode* h1 = l2L(l1);
  ListNode* h2 = l2L(l2);
  // printf("Ready to show, h[0]=%d\n",h->val);
  auto h = S.mergeTwoLists(h1,h2);
  h->show();

  return 0;
}
