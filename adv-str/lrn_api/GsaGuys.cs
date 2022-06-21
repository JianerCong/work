// #define MY_TEST
// #define MY_TEST2
using System;
using ComAuto = Gsa_8_6.ComAuto;
using System.IO;
using Testing;                  // dotnet add reference ..\testing3\testing3.csproj
using System.Linq;


namespace MyAnalysis{
    class BeamAnalyzer : IStructuralAnalyzable {
        BeamAnalysis analysis;
        ResultGetter resultGetter;
        int nSlicePerSide;
        public readonly string InputFilename;
        public void GetM(ref double[] M){
            resultGetter.GetM(ref M, ref analysis.gsa);
        }
        public BeamAnalyzer(string inputFilename, int n){
            // u: udl, n: nSlicePerSide
            nSlicePerSide = n;
            InputFilename = inputFilename;
            resultGetter = new ResultGetter(n);
        }
        public void SetB(in double[] B){
            clearResults();
            analysis.dataManager.sectionManager.SetB(in B);
            analysis.SendToGSA();
        }
        void clearResults() => analysis.gsa.Delete("RESULTS");
        public void Analyze(){
            clearResults();
            analysis.gsa.Analyse();
        }
        public int GetNumElemPerSide() => nSlicePerSide;
        public void Close(){
            analysis.gsa.Save();
            analysis.Dispose();
        }
        public void SetUdl(double udl){
            // SetUdl() first before you do anything
            analysis = new BeamAnalysis(InputFilename, udl, nSlicePerSide);
            analysis.SendToGSA();
        }

        public static void Test(ref Tester t){
            // string inputFilename = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\init.gwb";
            string Filename = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\test_DataAnalyzer.gwb";
            int nSlicePerSide = 2;
            BeamAnalyzer b = new BeamAnalyzer(Filename,nSlicePerSide);
            b.SetUdl(10.0);

            t.ExpectEqual(nSlicePerSide,b.GetNumElemPerSide(), "GetNumElemPerSide");
            double B_200 = 2.98666666666e13;
            double[] B = new double[] {B_200/2, B_200*2};
            double[] M = new double[nSlicePerSide];
            t.Log("Setting B");
            b.SetB(in B);
            b.Analyze();
            b.GetM(ref M);
            for (int i=0;i<nSlicePerSide;i++){
                t.Log($"M[{i}] : {M[i]}");
            }
            b.Close();
        }

    }

    class ResultGetter {
        int nSlicePerSide;
        public ResultGetter(int n) => nSlicePerSide = n;
        public void GetM(ref double[] M, ref ComAuto gsa){
#if MY_TEST2
            Console.WriteLine("Getting results for {0} elements",
                              nSlicePerSide);
#endif
            for (int i=0;i<nSlicePerSide;i++){
#if MY_TEST2
                Console.WriteLine("Getting for element {0}", i);
#endif
                M[i] = getMidMyy(ref gsa, i);
            }
        }


        static int initMyy(ref ComAuto gsa, int id){
            // Init data
            int flags,dataref,num1dpos;
            string axis, case_;
            flags = 0x20;        // calculates 1D results at interesting points
            /* number of equidistant internal positions along the 1D element, in
               addition to the automatic ones specified in flags */
            num1dpos = 1;
            axis = "default";
            case_ = "A1";
            dataref = 14002000+6;

            int r = gsa.Output_Init(flags,axis,case_,dataref,num1dpos);
            if (r != 0)
                throw new Exception("Failed to init Output with state ${r}");
#if MY_TEST
            Console.WriteLine("Data Title {0} [{1}]",gsa.Output_DataTitle(1), gsa.Output_UnitString());
#endif
            int npos = gsa.Output_NumElemPos(id + 1); // Here we used 1-based id
#if MY_TEST2
            Console.WriteLine("{0} rows of data extracted", npos);
#endif
            return npos;
        }

        public static double getMidMyy(ref ComAuto gsa, int id){
            int npos = initMyy(ref gsa, id);
            int i = npos /2;
            // double pos =  gsa.Output_1DElemPos(i); << server issue
#if MY_TEST
            Console.WriteLine("The middle position is {0}", i);
#endif
            return gsa.Output_Extract(id+1,i); // 1-based id
        }

        public static void Test(ref Tester t){
            const string filename = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\hi.gwb";
            ComAuto gsa = new ComAuto();
            int nSlicePerSide = 1;
            ResultGetter g = new ResultGetter(nSlicePerSide);
            try {
                Console.Write("Trying to open {0}: ", filename);
                if (gsa.Open(filename) == 0){
                    t.Log("OK");
                }else{
                    t.Log("Failed");
                    Environment.Exit(1);
                }
                double[] Myy = new double[1];
                g.GetM(ref Myy,ref gsa);
                t.ExpectNear(-375.0,Myy[0],"The middle Myy", 0.0001);
            } finally {
                gsa.Close();
                t.Log($"{filename}, Closed");
            }
        }

    }


    class BeamAnalysis :IDisposable{
        readonly string filename;
        const string init_filename = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\init.gwb";
        public ComAuto gsa = new ComAuto();
        public DataManager dataManager;
        public double udl_Nm {
            get => dataManager.udlManager.W;
            set => dataManager.udlManager.W = value;
        }
        int nSlicePerSide;

        public BeamAnalysis(string inputFilename,
                            double u, int n){
            Console.WriteLine("Initializing BeamAnalysis");
            filename = inputFilename;
            nSlicePerSide = n;
            dataManager = new DataManager(nSlicePerSide, u);

            // Delete if exists
            if (File.Exists(filename)){
                File.Delete(filename);
            }
            File.Copy(init_filename, filename);

            Console.Write("Trying to open {0}: ", filename);
            if (gsa.Open(filename) == 0){
                Console.WriteLine("OK");
            }else{
                Console.WriteLine("Failed");
                Environment.Exit(1);
            }
        }
        public void Save() => gsa.Save();

        public void SendToGSA(bool dryRun=false){
            /*
              Yes, BeamAnalysis needs a bunch of IGSASendable, and it itself
              has a SendToGSA method, but this one is not the same as the one
              required by the IGSASendable. How?
              */
            gsa.Delete("RESULTS");
            #if MY_TEST
            Console.WriteLine("Result Deleted");
            #endif
            dataManager.SendToGSA(ref gsa, dryRun);
        }

        public void Dispose(){
            Console.WriteLine("{0} is closed", filename);
            gsa.Close();
        }

        public static void Test(ref Tester t){
            const string filename = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\run.gwb";
            double udl = 10;    // N/mm
            int nSlicePerSide = 2;
            t.Log("Entering using block");
            using (BeamAnalysis a = new BeamAnalysis(filename, udl, nSlicePerSide)){
                t.Log("Sending to GSA...");
                a.SendToGSA(false);    // dryRun = false
                a.Save();
            }
        }
    }

    public interface IGSASendable{
        void SendToGSA(ref ComAuto gsa, bool dryRun);
    }

class NodeManager : IGSASendable {
        // The number of node to be added in the mid span.
        readonly int nNode;
        readonly double[] X;             // the x coordinates of node (m)
        /*
          X[i-1] stores the ith node. Where we say 0th node is the left
          end. X[0] should be node id 3. Since we already have node 1
          (left-end) and node 2 (right end).
        */
        readonly double L;     // the beam span length (m)
        readonly double l;
        readonly int nSlice;
        public NodeManager(int nSlicePerSide, double L_in){
            L = L_in;
            nNode = 1 + (nSlicePerSide - 1) * 2;
            nSlice = 2* nSlicePerSide;
            l = L / nSlice; // the length of slice
            X = new double[nNode];
            Console.WriteLine("Number of nodes: {0}",nNode);
            Console.WriteLine("Length of each slice: {0:G4} m",l);
            for (int i = 1; i < nNode + 1; i++){
                X[i-1] = i*l;
            }
        }

        public void SendToGSA(ref ComAuto gsa, bool dryRun){
#if MY_TEST2
            Console.Write("\tSending {0} Nodes to GSA", nNode);
#endif
            int Id, expectedId=3;
            if (!dryRun){
                foreach (double x in X){
                    Id = gsa.Gen_NodeAt(x,0,0,0.0001);
                    if (Id != expectedId){
                        string msg =
                            string.Format("Should get node {0}, but got node {1}",
                                          expectedId,Id);
                        // Console.WriteLine(msg);
                        throw new Exception(msg);
                    }
                    expectedId++;
                }
#if MY_TEST2
                Console.WriteLine(": All nodes generated: OK");
#endif
            }
        }

        public static void Test(ref Tester t){
            NodeManager m = new NodeManager(2, 8);
            t.Log("Points:");
            t.ExpectSequenceEqual(m.X, new double[] {2,4,6},"PointXCoor");
            t.ExpectEqual(m.l, 2.0, "length of slices");
            t.ExpectEqual(m.nSlice, 4, "number of slices");
            t.ExpectEqual(m.nNode, 3, "number of nodes");
        }
    }

    class SectionManager : IGSASendable {
        Section[] secs;
        const int flags = 0x1 | 0x2; // the output flags for GSA
        public SectionManager(int nSec,
                              double EI_init = 2.98666666666e13){
            secs = new Section[nSec];
            for (int i =0; i < secs.Length; i++){
                secs[i] = new Section(EI_init);
            }
        }
        public void SendToGSA(ref ComAuto gsa, bool dryRun){
#if MY_TEST2
            Console.Write("\tSending sections to GSA");
#endif
            for (int i=0; i < secs.Length; i++){
                SendThisSecToGSA(ref gsa, in secs[i], i+1, dryRun);
            }
#if MY_TEST2
            Console.WriteLine(": All sections sent : OK");
#endif
        }

        public void SendThisSecToGSA(ref ComAuto gsa,
                                     in Section s,
                                     int id, bool dryRun){
            string desc = string.Format("STD R {0:F10} {1:F10}",
                                        s.d, s.b);
            string secDesc = gsa.Gen_SectionMatchDesc(desc, flags);
#if MY_TEST
            Console.WriteLine("Section String: {0}", secDesc);
#endif
            string name = string.Format("my_section_{0}",id);
            string mat = "CONC_SHORT";
            string cmd = string.Format("SEC\t{0}\t{1}\t{2}\t{3}",
                                       id, name,mat,secDesc);
            if (!dryRun){
                var x = gsa.GwaCommand(cmd);
                if (x is int && x == 1){
#if MY_TEST
                    Console.WriteLine("Section {0}: {1} generated.",
                                      id, name);
#endif
                }else{
                    string msg = string.Format("Failed to generate section {0}, with command {1}",
                                               id, cmd);
                    throw new Exception(msg);
                }
            }
        }

        public void SetB(in double[] B){
            // Set the B of each section
            for (int i=0;i<B.Length;i++){
                secs[i].B = B[i];
            }
        }

        public static void Test(ref Tester t){
            double B = 2.98666666666e13;
            SectionManager m = new SectionManager(2,B);
            foreach (Section s in m.secs){
                t.ExpectNear(s.b, 200.0);
            }
            t.Log("Testing SetB of Section");
            m.SetB(new double[] {B/2, B*2});
            t.ExpectNear(100.0,m.secs[0].b, "Half B");
            t.ExpectNear(400.0,m.secs[1].b, "Double B");
        }
    }

    class Section {
        double _b;   // breath(width) in mm
        public  double d = 400;
        const double E = 2.8e4;       // N/mm2 (MPa)
        public double b {get => _b;}
        public double B {
            get => E * (d*d*d)*_b/12;
            set => _b = calcB(value);
        }
        double calcB(double EI) =>  EI * 12 / (E * d * d * d);
        public Section(double EI){
            // Init a section with specified B (EI) .
            // B in MNmm^2 = Nm
            _b = calcB(EI);
        }
        public static void Test(ref Tester t){
            const double EI = 2.9866666666666666667e13;
            Section s = new Section(EI);
            t.ExpectNear(s.b,200.0);
            t.Log("Doubling the EI should double the b");
            s.B = 2*EI;
            t.ExpectNear(s.b,400.0);
        }
    }

    class BeamManager :IGSASendable {
        Beam[] beams;
        public BeamManager(int nSlicePerSide){
            if (nSlicePerSide < 1)
                throw new Exception("Should have >=1 slices per side");
            beams = new Beam[nSlicePerSide*2];
            beams[0] = new Beam(1,3,1,1);
            beams[^1] = new Beam(nSlicePerSide*2+1,2,1,
                                 beams.Length); // Last element

            int beamID, beamIDAnother;
            for (int grp = 2; grp < nSlicePerSide+1; grp++){
                // grp = 2 upto nSlicePerSide
                beamID = grp;
                beamIDAnother = beams.Length - beamID;

                // Beam(nodeId1, nodeId2, secId, beamId)
                beams[beamID-1] = new Beam(grp+1, grp+2, grp,beamID);
                // if grp = 2: ^ is b[1]; below is b[^2]
                int mirrorNodeId = 2*(nSlicePerSide + 1) - grp;
                beams[beamIDAnother] = new Beam(mirrorNodeId,
                                       mirrorNodeId + 1
                                       , grp, beamIDAnother + 1);
            }
        }

        public void SendToGSA(ref ComAuto gsa, bool dryRun){
#if MY_TEST2
            Console.Write("\tSending {0} Beams to GSA", beams.Length);
#endif
            if (!dryRun){
                foreach (Beam b in beams){
                    b.SendToGSA(ref gsa, dryRun);
                }
#if MY_TEST2
                Console.WriteLine(": All beams sent: OK");
#endif
            }
        }
        public static void Test(ref Tester t){
            var m = new BeamManager(3);
            int[] s = new int[] {1,3,4,5,6,7};
            int[] e = new int[] {3,4,5,6,7,2};
            int[] g = new int[] {1,2,3,3,2,1};
            for (int i =0; i < 6; i++){
                t.Log(string.Format("For beam {0}", i));
                t.ExpectEqual(m.beams[i].startNodeId, s[i], "Node 1");
                t.ExpectEqual(m.beams[i].endNodeId, e[i], "Node 2");
                t.ExpectEqual(m.beams[i].secId, g[i], "Sec ID");
                t.ExpectEqual(m.beams[i].Id, i + 1, "Beam ID");
            }
        }
    }

    class Beam :IGSASendable {
        public int startNodeId, endNodeId, secId, Id;
        public Beam(int s, int e, int c, int i)
            => (startNodeId, endNodeId,secId, Id) = (s,e,c,i);
        public override string ToString()
            => string.Format("[{0,2}-{1,2}:{2,2}]",
                             startNodeId,
                             endNodeId,secId);
        public void SendToGSA(ref ComAuto gsa, bool dryRun){
            string cmd = string.Format("EL_BEAM\t{0}\t{1}\t{1}\t{2}\t{3}\t0\t0",
                                       Id, secId, startNodeId,endNodeId);
#if MY_TEST
            Console.WriteLine("Generating beam:");
            Console.WriteLine("Cmd to issue: {0}", cmd);
#endif
            if (!dryRun){
                var x = gsa.GwaCommand(cmd);
                if (x is int && x == 1){
#if MY_TEST
                    Console.WriteLine("Beam {0} generated at nodes ({1},{2}), with section {3}",
                                      Id, startNodeId, endNodeId, secId);
#endif
                }else{
                    throw new Exception("Failed to generate Elements.");
                }
            }
        }
    }

    class UdlManager : IGSASendable{
        public double W;
        public UdlManager(double w) => W = w;
        // w should be positive (that makes it downward)

        public void SendToGSA(ref ComAuto gsa, bool dryRun){
#if MY_TEST2
            Console.Write("\tSending UDL {0} N/m to GSA:",W);
#endif
            if (!dryRun){
                string name = "myUDL", list = "all", cas = "1",
                    axis = "GLOBAL", proj = "NO", dir = "Z";
                double val = -W; // Turn it downward in Z-direction
                string cmd = $"LOAD_BEAM_UDL.2\t{name}\t{list}\t{cas}\t{axis}\t{proj}\t{dir}\t{val}";
#if MY_TEST
                Console.WriteLine("Issueing command: {0}",cmd);
#endif
                var x = gsa.GwaCommand(cmd);
                if (x is int && x == 1){
#if MY_TEST2
                    Console.WriteLine(": UDL of size {0}N/m generated for all beams in {1}-direction", val,dir);
#endif
                }else{
                    Console.WriteLine("Failed:");
                    Console.WriteLine("Gwa say: {0}",x);
                }
            }
        }
    }

    class DataManager : IGSASendable {
        const double L = 8;
        readonly int nSlicePerSide;
        public NodeManager nodeManager;
        public BeamManager beamManager;
        public SectionManager sectionManager;
        public UdlManager udlManager;

        public DataManager(int n, double W){
            nSlicePerSide = n;
            nodeManager = new NodeManager(nSlicePerSide,L);
            beamManager = new BeamManager(nSlicePerSide);
            sectionManager = new SectionManager(nSlicePerSide,
                                    2.98666666666e13);
            udlManager = new UdlManager(W);
        }

        public void SendToGSA(ref ComAuto gsa, bool dryRun=false){
            nodeManager.SendToGSA(ref gsa, dryRun);
            beamManager.SendToGSA(ref gsa, dryRun);
            sectionManager.SendToGSA(ref gsa, dryRun);
            udlManager.SendToGSA(ref gsa, dryRun);
        }
    }
}
