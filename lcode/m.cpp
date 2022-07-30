
#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

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
  static ListNode* l2L(vector<int> v){
    ListNode *n = nullptr;
    while (!v.empty()){
      // printf("pushing %d\n",v.back());
      n =  new ListNode(v.back(),n);
      v.pop_back();
    }
    return n;
}
};



class Solution {
public:
  ListNode* mergeKLists(vector<ListNode*>& lists) {
    //printf("Merging %ld lists\n",lists.size());
    if (lists.empty()) return nullptr;

    ListNode *l1, *l2;

    while (lists.size()>1){
      auto mergedLists = new vector<ListNode*>();

      for (int i = 0; i < lists.size(); i+=2){
        // sleep(1);
        //printf("Looping i=%d\n",i);
        l1 = lists[i];
        l2 = ((i + 1) < lists.size()) ? lists[i+1] : nullptr;

        //printf("Now l1 is: ");
        // l1->show();
        //printf("Now l2 is: ");
        // if (l2 != nullptr) l2->show(); else printf("nullptr\n");

        mergedLists->push_back(merge2(l1,l2));
      }
      lists = *mergedLists;
      //printf("Now lists size=%ld\n",lists.size());
    }

    return lists[0];
  }

  ListNode* merge2(ListNode* l1, ListNode* l2){
    auto dummy = new ListNode();
    auto tail = dummy;

    while (l1 && l2){
      if (l1->val < l2->val){
        tail->next= l1;
        l1 = l1->next;
      }else{
        tail->next= l2;
        l2 = l2->next;
      }
      tail = tail->next;
    }

    if (l1)
      tail->next = l1;
    else if (l2)
      tail->next = l2;

    return dummy->next;
  }
};

int main(int argc, char *argv[]){
  Solution S;

  vector<ListNode*> l;
  l.push_back(ListNode::l2L(vector<int>({1,4,5})));
  l.push_back(ListNode::l2L(vector<int>({1,3,4})));
  l.push_back(ListNode::l2L(vector<int>({2,6})));

  auto r = S.mergeKLists(l);
  r->show();

  return 0;
}
