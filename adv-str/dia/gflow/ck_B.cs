bool Okay = true;
foreach (slice in span){
    theoratical_B = getBFromM(slice.M);
    if (isCloseTo(slice.B,theoratical_B)){
        // this slice is Okay
    }else{
        // change the stiffness B of the slice
        slice.B = theoratical_B;
        Okay = false;
    }

    if (Okay){
        // Analysis Done
    }else{
        // Run analysis again with the updated B distribution
    }
}
