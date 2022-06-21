using System;
using Testing;


namespace testing
{
    class Program
    {
        static void Main(string[] args)
        {
            // foreach (string a in args){
            //     Console.WriteLine("Argument passed:Examier ");
            //     Console.WriteLine("     " + a);
            // }
            bool v;
            if (args.Length > 0 && args[0].ToUpper() == "V"){
                v = true;
                Console.WriteLine("Be verbose");
            }else{
                v = false;
                Console.WriteLine("Be quiet");
            }
            Test t = new Test(v);
            t.Add(g,"g-test");
            t.Add(f,"f-test");
            t.Add(h,"h-test");
            t.Run();
            t.ShowResults();
        }

        static void g(ref Tester t){
            t.Log("g is here");
            t.Fatal("g is bad");
        }

        static void f(ref Tester t){
            t.Log("f is here");
            t.ExpectEqual(2,2);
            t.ExpectEqual(2,3);
        }

        static void h(ref Tester t){
            t.Log("h is here");
            t.ExpectEqual("hi","hi");
            t.ExpectEqual("hi","oh");
        }
    }

}
