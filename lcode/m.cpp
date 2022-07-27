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

  ListNode* l2L(vector<int> v){
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
    if (!lists || lists.empty()) return nullptr;

    ListNode *l1, *l2;

    while (lists.size()){
      auto mergedLists = new vector<ListNode*>();

      for (int i = 0; i < lists.size(); i+=2){
        l1 = lists[i];
        l2 = (i + 1) < lists.size() ? lists[i+1] : nullptr;
        mergedLists.push_back(merge2(l1,l2));
      }
      lists = mergedLists;
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
    }

    if (l1) tail->next = l1;
    if (l2) tail->next = l2;

    return dummy->next;
}
};

int main(int argc, char *argv[]){
  Solution S;

  return 0;
}
