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

double readFromSaggingBMPlot(double M){
    return LinearInterpolate(saggingBMPlot,M);
}

double readFromHoggingBMPlot(double M){
    return LinearInterpolate(hoggingBMPlot,M);
}

double LinearInterpolate(BMPlot p, double M){
    if (p.OutOfLimit(M)) {
        throw $"M = {M} is out of Limit of the B-M Plot: {p.Limit}";
    }
    return p.Interpolate(M);
}

double Abs(double x) => (x>0)?x:-x;
