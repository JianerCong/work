
using System;
using MyAnalysis;
using Testing;                  // dotnet add reference ..\testing3\testing3.csproj

namespace CJE {
    class Client {
        static void Main(){
            // Test();
            Run();
        }

        static void Run(){
            string DataFileName = @"C:\Users\congj\work\adv-str\data\DBData.csv";
            IBMgettable df = new BMData(DataFileName);
            AnalysisSet[] A = new AnalysisSet[6];

            AnalysisSetInfo I = new AnalysisSetInfo();
            I.SaggingSectionLabels = new string[6] {"s11", "s12", "s13", "s11","s12","s13"};
            I.HoggingSectionLabels = new string[6] {"s2", "s2", "s2", "s31","s32","s33"};
            I.AnalysisSetName = new string[6] {"C1_1", "C1_2", "C1_3", "C2_1","C2_2","C2_3"};
            Do(I, ref A, df);
        }

        public struct AnalysisSetInfo {
            public string[] SaggingSectionLabels;
            public string[] HoggingSectionLabels;
            public string[] AnalysisSetName;
        }


        static void Do(AnalysisSetInfo I, ref AnalysisSet[] A, IBMgettable df){
            // Do C1_2
            double[][] Udl = new double[][] {
                new double[] {10,20}, // C1_1
                new double[]  {3e3,5.4e3}, // C1_2
                new double[] {6e3,7e3}, // C1_3
                new double[] {10,20}, // C2_1
                new double[] {3e3, 6e3}, // C2_2
                new double[] {10,20} // C2_3
            }; // The load for each analysis

            // Task 1 (C1_2)
            RunTask(in Udl, in I, in A, df, 1, 0);
            RunTask(in Udl, in I, in A, df, 1, 1);

            // Task 2 (C1_3)
            RunTask(in Udl, in I, in A, df, 2, 0);
            RunTask(in Udl, in I, in A, df, 2, 1);

            // Run task 4 (C2_2), first udl
            RunTask(in Udl, in I, in A, df, 4, 0); // C2_2, load 0
            RunTask(in Udl, in I, in A, df, 4, 1); // C2_2, load 1
        }

        static void RunTask(in double[][] Udl, in AnalysisSetInfo I,
                            in AnalysisSet[] A,IBMgettable df,
                            int i, int j){

            // Run one analysis
            int nSlicePerSide = 100;
            double udl = Udl[i][j];
            string gwbName = @"C:\Users\congj\work\adv-str\lrn_api\gwb_files\test_run_" +
                I.AnalysisSetName[i] + "_" + udl.ToString() +".gwb";
            AnalysisSet a = A[i] = new AnalysisSet(df,
                                                   I.SaggingSectionLabels[i],
                                                   I.HoggingSectionLabels[i],
                                                   I.AnalysisSetName[i]);

            IStructuralAnalyzable sa = new BeamAnalyzer(gwbName, nSlicePerSide);
            string TaskName = $"{a.Name}_{udl}";
            AnalysisTask at = new AnalysisTask(a,udl,TaskName,sa);
            at.Run();
        }


        static void Test(){
            bool verbose = true;
            Test t = new Test(verbose);
            // t.Add(NodeManager.Test,"NodeManager");
            // t.Add(Section.Test,"Section");
            // t.Add(BeamManager.Test, "BeamManager");
            // t.Add(SectionManager.Test, "SectionManager");
            // t.Add(BeamAnalysis.Test,"BeamAnalysis");
            // t.Add(ResultGetter.Test,"ResultGetter");
            t.Add(BeamAnalyzer.Test,"BeamAnalyzer");
            t.Run();
        }
    }
}

