#include <cstdio>
#include <string>
#include <stack>

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

using std::string;


void show(std::stack<char> c){  // pass by value
  while (!c.empty()){
    printf(" %c",c.top());c.pop();
}
  printf("\n");
}

class Solution {
public:
  bool isValid(string s) {
    std::stack<char> stk;
    const char* m ="{}[]()";

    for (char c : s){
      int index = m.find(c);
      printf("For char %c, index = %d\n",c, index);
      if (index % 2 == 1){
        printf("top is %c, m[index-1] is %c\n", stk.top(), m[index-1]);
        if (!stk.empty() && stk.top() == m[index-1]){
          printf("\tPop %c\n", stk.top());
          stk.pop();
}
        else
          return false;
      }else{
        printf("\tPush\n");
        stk.push(c);
}
      printf("Now stack: ");
      show(stk);
    }

    return stk.empty() ? true : false;
  }
};


int main(int argc, char *argv[]){
  Solution S;

  puts(S.isValid("[]()") ? "True" : "False");
  return 0;
}
