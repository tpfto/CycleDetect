# Cycle Detection

CycleFixedPoint.m implements the function `CycleFixedPoint`, which can be used to detect cycling in an iterative process.

The function implements both the algorithms of Floyd and Brent to detect cycles.

Some examples:

    CycleFixedPoint[Mod[7 # + 3, 11] &, 2, Method -> "Brent"]
       {4, 9, 0, 3, 2, 6, 1, 10, 7, 8}

    CycleFixedPoint[Mod[7 # + 3, 11] &, 2, Method -> "Floyd"]
       {2, 6, 1, 10, 7, 8, 4, 9, 0, 3}

    CycleFixedPoint[3.5 # (1 - #) &, 0.2, Method -> "Brent"]
       {0.826941, 0.500884, 0.874997, 0.38282}

    CycleFixedPoint[3.5 # (1 - #) &, 0.2, Method -> "Floyd"]
       {0.826941, 0.500884, 0.874997, 0.38282}

See the package for more details.