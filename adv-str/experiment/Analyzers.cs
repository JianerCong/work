using System;
using System.Threading;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Testing;
using MathNet.Numerics.Interpolation;
// #define RUN_THIS


namespace MyAnalysis
{

#if RUN_THIS
    class Program
    {
        static void Main(string[] args)
        {
            bool verbose = true;
            Test t = new Test(verbose);
            // t.Add(BMData.Test, "BMData");
            // t.Add(BMSection.Test, "BMSection");
            // t.Add(AnalysisSet.Test, "AnalysisSet");
            t.Add(AnalysisTask.Test, "AnalysisTask");
            t.Run();
        }
    }
#endif

    record BMPoint {
        public BMPoint(double b, double m, string l)
            => (B,M,Lab) = (b,m,l);
        double _B, _M;
        string _Lab;
        public static readonly string[] AllowedLabs
            = {"s11", "s12","s13","s2","s31","s32","s33"};
        public string Lab {
            get => _Lab;
            init {
                if (!AllowedLabs.Contains(value))
                    throw new ArgumentException($"{value} is not a valid label");
                _Lab = value;
            }
        }
        public double B {
            get => _B;
            init {
                _B = Util.EnsurePositive(value, "M");
            }
        }
        public double M {
            get => _M;
            init {
                _M = Util.EnsurePositive(value, "M");
            }
        }
    };

    static class Util{
        public static double EnsurePositive(double x, string n){
            if (x < 0)
                throw new ArgumentException(string.Format(
                                                "{1} should be > 0, but got {0}", x, n));
            return x;
        }
    }

    public class BMData :IBMgettable {
        BMPoint[] rows;
        string[] headings;
        public BMData(string filename){
            Console.WriteLine("Reading file: {0}", filename);
            if (!File.Exists(filename))
                throw new ArgumentException("path: [{0}] dosn't exist",filename);
            using(StreamReader sr = File.OpenText(filename)){
                // Get headings
                getHeadings(sr, out headings);

                // Get the text of rows
                List<string> rowsTxt;
                getTextOfRows(sr, out rowsTxt);
                getRowsFromText(in rowsTxt);
            }
        }
        void getRowsFromText(in List<string> rowsTxt){
            int n = rowsTxt.Count;
            Console.WriteLine("Parsing {0} Rows", n);
            rows = new BMPoint[n];
            double B,M;
            string lab;
            for (int i=0;i<n;i++){
                getBMLabFromThisRow(rowsTxt[i], out B, out M, out lab);
                rows[i] = new BMPoint(B,M,lab);
            }
        }
        void getBMLabFromThisRow(string r, out double B,
                                 out double M,
                                 out string lab){
            string[] s = r.Split(',');
            B = double.Parse(s[0]);
            M = double.Parse(s[1]);
            lab = s[2];
        }
        void getHeadings(StreamReader sr, out string[] h){
            Console.WriteLine("Getting headings");
            h = sr.ReadLine().Split(',');
            for (int i =0; i< h.Length; i++){
                h[i] = h[i].Trim();
            }
        }
        void getTextOfRows(StreamReader sr, out List<string> rowsTxt){
            Console.WriteLine("Getting rows in text");
            rowsTxt = new List<string>();
            string r;
            while ((r = sr.ReadLine())!= null){
                rowsTxt.Add(r);
            }
        }

        public string GetHeadingString()
            => string.Join("|",headings);

        public void getTheBM(string lab, out double[] B, out double[] M){
            Console.Write("\tRetriving B-M for section-{0}", lab);
            if (!BMPoint.AllowedLabs.Contains(lab))
                throw new ArgumentException("Invalid section label:{0}", lab);
            IEnumerable<BMPoint> selected = rows.Where(n => (n.Lab == lab));
            B = selected.Select(n => n.B).ToArray();
            M = selected.Select(n => n.M).ToArray();
            Console.WriteLine(":  {0} rows retrieved\n",B.Length);
        }

        public static void Test(ref Tester t){
            BMData b = new BMData("test.csv");
            t.Log("Data read:");
            t.Log(b.GetHeadingString());
            foreach (BMPoint r in b.rows)
                t.Log(r.ToString());
            t.ExpectEqual(2.0,b.rows[5].B,"B of 6th row");
            t.ExpectEqual(0.0,b.rows[0].M,"M of first row");

            t.Log("Try getTheBM:");
            double[] B,M;
            b.getTheBM("s11",out B,out M);
            t.ExpectSequenceEqual(new double[] {0,1,2}, M, "M");
            t.ExpectSequenceEqual(new double[] {0,1,0}, B, "B");
        }
    }

    public interface IBMgettable {
        public void getTheBM(string lab, out double[] B, out double[] M);
    }

    public class BMSection{
        LinearSpline l;
        public double MaxM;
        public double MinM;
        public readonly string Name;
        // If the MaxM is exceeded by more than the tolerance (tol), than the
        // moment is considered too high (worth throwing an exception).

        double tol {get => (MaxM-MinM)*0.4;}
        public BMSection(IBMgettable b, string c){
            Console.Write("Getting BMSection [{0}]: ",c);
            Name = c;

            double[] B,M;
            b.getTheBM(c, out B, out M);

            MaxM = M.Max(n=>n);
            MinM = M.Min(n=>n);
            l = LinearSpline.Interpolate(M,B);
            Console.WriteLine("\t Got M in range [{0:G4},{1:G4}]",
                              MinM,MaxM);
        }
        public double GetBFromM(double M){
            if (M > MaxM + tol){
                throw new ArgumentException($"M={M} is too high than the limits {MaxM + tol}");
            }else if (M > MaxM){
                return l.Interpolate(MaxM);
            }else if (M < MinM){
                return l.Interpolate(MinM);
            }else{
                return l.Interpolate(M);
            }
        }

        public static void Test(ref Tester t){
            DummyIBMgettable b = new DummyIBMgettable();
            BMSection s = new BMSection(b, "s11");
            t.ExpectEqual(1.0,s.GetBFromM(0),"Interpolate at 0 < Min = 1");
            t.ExpectEqual(1.0,s.GetBFromM(1),"Interpolate at 1 = Min");
            t.ExpectEqual(1.1,s.GetBFromM(1.1),"Interpolate at 1.1");
            t.ExpectEqual(2.0,s.GetBFromM(2),"Interpolate at 2");
            t.ExpectEqual(2.0,s.GetBFromM(2.5),"Interpolate at 2.5");
            t.ExpectEqual(1.5,s.GetBFromM(3.5),"Interpolate at 3.5");
            t.ExpectEqual(1.0,s.GetBFromM(4),"Interpolate at 4");
            t.ExpectEqual(1.0,s.GetBFromM(4.2),"Interpolate at 4.2 (> Max, but Acceptable)");
            Action f = () => s.GetBFromM(9);
            t.ExpectException(f, typeof(ArgumentException));
        }

    }

    class DummyIBMgettable: IBMgettable{
        public void getTheBM(string s, out double[] B, out double[] M){
            Console.WriteLine("Getting the BM for {0} from the dummy provider",
                              s);
            if (s == "s11"){
                M = new double[]{1,2,3,4};
                B = new double[]{1,2,2,1};
            }else{
                // the B = 2M
                M = new double[]{1,5};
                B = new double[]{2,10};
            }
        }
    }

    public class AnalysisSet{
        public readonly BMSection HoggingBM;
        public readonly BMSection SaggingBM;
        public readonly string Name;
        public static readonly string OutputFileName = @"C:\Users\congj\work\adv-str\data\AnalysisOutput.csv";

        public AnalysisSet(IBMgettable b, string sag, string hog, string n){
            Console.WriteLine($"Initializing AnalysisSet [{n}] with sag: {sag}, hog: {hog}");
            Name = n;
            HoggingBM = new BMSection(b, hog);
            SaggingBM = new BMSection(b, sag);
        }

        public void FindBAndCapRatioForThisM(in double M, out double B, out double capacityRatio){
            // the capacityRatio = [0,1]. 1 means at this moment M, the slice has failed.
            if (M < 0){
                double m = Math.Abs(M);
                B = HoggingBM.GetBFromM(m);
                capacityRatio = m / HoggingBM.MaxM;
            }else{
                B = SaggingBM.GetBFromM(M);
                capacityRatio = M / SaggingBM.MaxM;
            }
        }

        public static void Test(ref Tester t){
            DummyIBMgettable d = new DummyIBMgettable();
            string n = "MySet";
            AnalysisSet a = new AnalysisSet(d,"s11","s2",n);
            double B, r;
            a.FindBAndCapRatioForThisM(2.5, out B, out r);
            t.ExpectEqual(2.0,B,"B");
            t.ExpectNear(2.5/4, r, "ratio of capacity");

            a.FindBAndCapRatioForThisM(4, out B, out r);
            t.ExpectEqual(1.0,B,"B@M=4");
            t.ExpectNear(1, r, "ratio of capacity @M=4");

            a.FindBAndCapRatioForThisM(-2.5, out B, out r);
            t.ExpectEqual(5.0,B,"hog B");
            t.ExpectNear(2.5/5, r, "hog ratio of capacity");

            a.FindBAndCapRatioForThisM(-5.0, out B, out r);
            t.ExpectEqual(10.0,B,"hog B@M=-5");
            t.ExpectNear(1, r, "hog ratio of capacity@M=-5");
        }

    }

    public interface IStructuralAnalyzable {
        void SetB(in double[] B);
        void SetUdl(double udl_Nm_1);
        void Analyze();
        void GetM(ref double[] M);
        int GetNumElemPerSide();
        void Close();
    }

    public class AnalysisTask {
        AnalysisSet boss;
        double udl_Nm_1;
        public readonly string Name;
        IStructuralAnalyzable analyst;
        public double AllowedResidual; // =0.3 ⇒ 30% off ⇒ OK

        public AnalysisTask(AnalysisSet b,
                            double u,
                            string n,
                            IStructuralAnalyzable a,
                            double r = 0.3){
            Console.WriteLine("\tInitializing AnalysisTask {0} [res = {1}]", n,r);
            Name = n; udl_Nm_1 = u; boss = b; AllowedResidual = r;
            analyst = a;
        }

        public override string ToString(){
            return $"AnalysisTask: [Name: {Name},AnalysisSet:{boss.Name}, load: {udl_Nm_1}N/m]";
        }

        public void Run(){
            Console.WriteLine("Running {0}", this);
            double[] B, capacityRatio, M, B_expected, R;
            init(out B, out capacityRatio, out M, out B_expected, out R);
            writeHeader();
            using (StreamWriter sw = new StreamWriter(AnalysisSet.OutputFileName, true)){ // append=true
                int nRun = 0;
                double r = runOnce(ref B, ref B_expected,
                            ref M, ref capacityRatio, ref R);
                writeOutput(sw, in B,in B_expected, in M, in R, in capacityRatio, nRun);
                while (checkResidual(r,nRun)){
                    B_expected.CopyTo(B,0); // Copy all, start with index 0
                    nRun++;
                    r = runOnce(ref B, ref B_expected,
                                ref M, ref capacityRatio, ref R);
                    writeOutput(sw, in B,in B_expected, in M, in R, in capacityRatio, nRun);
                }
                Console.WriteLine("Analysis {0}: Finished [capacity ratio: {1:P}]",
                                  Name,
                                  capacityRatio.Max(n=>n));
                analyst.Close();
            }
        }

        bool checkResidual(double r, int nRun){
            Console.Write($"Residual for iteration {nRun,2}: R={r:G4}: Allowed={AllowedResidual:G4}: ");
            // Thread.Sleep(500);
            return (nRun<10) ? true :false;
            // Console.Write("Continue? [y/n]:");
            // string s = Console.ReadLine();
            // if (s[0] == 'n')
            //     return false;
            // return true;
        }

        double runOnce(ref double[] B, ref double[] B_expected,
                     ref double[] M, ref double[] capacityRatio,
                     ref double[] R){
            try {
                analyst.SetB(in B);
                analyst.Analyze();
                analyst.GetM(ref M);
                M = M.Select(n=> n*1e3).ToArray(); // Transform to Nmm
                getExpectedB(ref M, ref B_expected, ref capacityRatio);
            }catch (Exception e) {
                analyst.Close();
                Console.WriteLine("Something wrong, gwb file closed.");
                throw;
            }
            // Get the unitless residual. 0.3 means Max 30% off
            return getResidual(ref B, ref B_expected, ref R);
        }

        void writeHeader(){
            string f = AnalysisSet.OutputFileName;
            if (!File.Exists(f)){
                using (StreamWriter sw = new StreamWriter(f, true)){
                    sw.WriteLine("B,B_exp,M,R,nRun,udl,cap_r,nam,nam_set,hog,sag");
                }
            }
        }

        void writeOutput(StreamWriter sw,
                         in double[] B, in double[] B_expected,
                         in double[] M, in double[] R, in double[] capacityRatio,
                         int nRun){
            string s = "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}";
            for (int i=0;i<B.Length;i++){
                sw.WriteLine(s,
                             B[i],B_expected[i],M[i],
                             // 0,1            ,2
                             R[i],nRun,udl_Nm_1,capacityRatio[i],
                             // 3,4   ,5       ,6
                             Name,boss.Name, boss.HoggingBM.Name, boss.SaggingBM.Name);
                //           7   ,8        ,9                   ,10
            }
            Console.WriteLine("Output of iteration {0} written",nRun);
        }

        double getResidual(ref double[] V, ref double[] W, ref double[] R){
            // Calculate the Maximum residual between two vectors
            for (int i = 0; i < V.Length; i++){
                R[i] = Math.Abs(V[i] - W[i]) / V[i];
            }
            return R.Max(n=>n);
        }

        void getExpectedB(ref double[] M,ref double [] B_expected, ref double[] capacityRatio){
            double b,m,s;
            for (int i=0;i<M.Length;i++){
                m = M[i];
                boss.FindBAndCapRatioForThisM(in m, out b,out s);
                B_expected[i] = b;
                capacityRatio[i] = s;
            }
        }

        void init(out double[] B, out double[] capacityRatio,
                  out double[] M, out double[] B_expected,
                  out double[] R){
            analyst.SetUdl(udl_Nm_1);
            int n = analyst.GetNumElemPerSide();
            B = new double[n];
            M = new double[n];
            R = new double[n];
            B_expected = new double[n];
            capacityRatio = new double[n];
            double b, c, m=0;
            for (int i =0; i < n; i++){
                boss.FindBAndCapRatioForThisM(in m, out b, out c);
                capacityRatio[i] = c;
                B[i] = b;
            }
            Console.WriteLine($"\tNumber of Element per side: {n}");
            Console.WriteLine("\tB and capacityRatio initialized.");
        }

        public static void Test(ref Tester t){
            IBMgettable g = new Test_BMgetter();
            IStructuralAnalyzable sa = new Test_StructualAnalyzer();
            AnalysisSet a = new AnalysisSet(g,"s11","s2","C1");
            double udl = 10;
            string n = $"{a.Name}_{udl}";
            AnalysisTask at = new AnalysisTask(a,udl,n,sa);
            at.Run();
        }
    }

    class Test_BMgetter : IBMgettable{
        // The trapizium B-M plot
        public void getTheBM(string s, out double[] B, out double[] M){
#if MY_TEST
            Console.WriteLine($"Getting the Trapizium BM for {s}");
#endif
            M = new double[] {0,1,2};
            B = new double[] {1,1,0};
        }
    }

    class Test_StructualAnalyzer : IStructuralAnalyzable {
        private const int N = 2;
        private double[] B_;
        public  Test_StructualAnalyzer(){
            B_ = new double[N];
        }
        public void Close() => Console.WriteLine("Test_StructualAnalyzer closed...");
        public void Analyze() => Console.WriteLine("Analyze.....");
        public void SetUdl(double u)
            => Console.WriteLine($"Setting udl to {u} N/m");
        public void SetB(in double[] B){
            Console.Write("Setting B to: ");
            for (int i=0;i<N;i++){
                Console.Write("{0} |",B[i]);
                B_[i] = B[i];
            }
            Console.WriteLine();
        }
        public int GetNumElemPerSide() => N;
        public void GetM(ref double[] M){
            Console.Write("Get M as: ");
            double M_real = 1.5, B_real = 0.5;
            double m;
            for (int i=0;i<N;i++){
                m = M_real - (B_[i] - B_real)*0.5;
                Console.Write("{0} |",m);
                M[i] = m;
            }
            Console.WriteLine();
        }
    }}
