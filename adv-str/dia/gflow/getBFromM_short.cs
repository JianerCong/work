double getBFromM(double M){
    // Determine the stiffness at moment M
    double B;
    if (M > 0){
        B = readFromSaggingBMPlot(M);
    }else{
        B = readFromHoggingBMPlot(Abs(M));
    }
    return B;
}
