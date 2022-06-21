using System;
using ComAuto = Gsa_8_6.ComAuto;

namespace gsa_api_v2
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello GSA!");
            Gsa.testShowNode();
        }
    }

    public class Gsa : IDisposable{
        ComAuto gsa = new ComAuto();
        bool has_result = false;

        // {{{public Gsa(in string filename);

        public Gsa(in string filename){
            Console.WriteLine("Trying to open {0}", filename);
            if (gsa.Open(filename) == 0){
                Console.WriteLine("OK");
            }else{
                Console.WriteLine("Failed");
                Environment.Exit(1);
            }
        }

        // }}}
        // {{{public void Dispose();

        public void Dispose(){
            Console.WriteLine("File closed");
            gsa.Close();
        }

        // }}}
        // {{{public void ShowVersion(); 

        public void ShowVersion(){
            string s = gsa.VersionString().Split('\n',2)[0];
            s = s.Substring(s.IndexOf(' ')).Trim();
            Console.WriteLine("The GSA {0} is used", s);
        }

        // }}}
        // {{{void DeleteResult(); 

        void DeleteResult(){
            Console.Write("Removing results: ");
            int r = gsa.Delete("RESULTS");
            string s = r switch {
                0 => "OK",
                1 => "No GSA file is open",
                3 => "No data here.",
                _ => throw "Failed"
            };
            Console.WriteLine(s);
        }

        // }}}
        // {{{public void Analyse();

        public void Analyse(){
            DeleteResult();
            Console.Write("Try to analyse :");
            int r = gsa.Analyse(0);
            if (r == 0){
                Console.WriteLine("Done");
                has_result = true;
            }else{
                Console.WriteLine("Failed");
                Environment.Exit(1);
            }
        }

        // }}}
        // {{{private void _initOutput(string s);

        private void _initOutput(string s, int npos = 1){
            int flags,dataref,num1dpos;
            static bool niceToMeetYou = true;

            string axis, case_;
            flags = 0x20;        // calculates 1D results at interesting points

            /* number of equidistant internal positions along the 1D element, in
               addition to the automatic ones specified in flags */
            num1dpos = npos;


            axis = "default";
            case_ = "L1";
            dataref = s switch {
                "NODE NAME" => 1002000+1, // the node Name
                _ => throw "Unknown data ref"
            }
            int r = gsa.Output_Init(flag,axis,case_,dataref,num1dpos);
            if (r != 0)
                throw "Failed to init Output with state ${r}";

            if (gsa.Output_DataExist(data_ref) == 0){
                Console.WriteLine("No data for ${s}");
            }else{
                if (niceToMeetYou){
                    showHeading();
                    niceToMeetYou = false;
                }
            }
        }

        private void _showHeading(){
            string t, u;
            t = gsa.Output_DataTitle(1); // 1 for full title (not short title)
            u = gsa.Output_UnitString();
            Console.WriteLine("The output title is: {0} Unit: {1}" , t, u);
        }


        private bool _isForMember(){
            return gsa.Output_IsDataRef( 0x8 || 0x10); // is for element or member
            /*
              Enum Output_IsDataRef_Flags
              OP_IS_AND = &H1             ' otherwise OR
              OP_IS_PER_REC = &H2
              OP_IS_PER_NODE = &H4
              OP_IS_PER_ELEM = &H8
              OP_IS_PER_MEMB = &H10
              OP_IS_PER_1D_DISP = &H20
              OP_IS_PER_1D_FRC = &H40
              OP_IS_PER_TOPO = &H80
              OP_IS_AT_CENTRE = &H100
              End Enum
            */
        }

        // }}}
        // {{{public void showNodes(); 

        public void showNodes(int n){
            for (int i = 1; i < n; i++){
                _showNodes(i);
            }
        }

        // }}}

        void _showNode(int i){
            string n;           // name
            Console.Write("Getting the ${i}th node: ",n);
            _initOutput("NODE NAME");
            long elems[];
            int r = gsa.NodeConnectedEnt(
                GsaEntity.ELEMENT,
                i,              // which node?
                out elems
            );

            if (r != 0){throw "Error getting node entity";}
            else{
                int e = elems[0];
                n = gsa.Output_Extract(i,e);
            }

            Console.WriteLine(" name: ",n);

        }

        public static testShowNode(ref Tester t){
            t.Log("Show_Node");
            const string filename = @"C:\Users\congj\work\adv-str\gsa_api_v2\hi.gwb";
            using (Gsa g = new Gsa(filename)){
                // g.ShowVersion();
                // g.Analyse();
                g.ShowNodes(3); // there are 3 nodes
            }
        }
    }
}
