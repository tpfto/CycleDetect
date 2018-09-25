
(* :Title: Cycle Detection *)

(* :Author: J. M. *)

(* :Summary:

     This package implements cycle detection algorithms.

 *)

(* :Copyright:

     © 2017-2018 by J. M. (pleasureoffiguring(AT)gmail(DOT)com)
     This work is free. It comes without any warranty, to the extent permitted by applicable law.
     You can redistribute and/or modify it under the terms of the WTFPL (http://www.wtfpl.net/).

 *)

(* :Package Version: 1.0 *)

(* :Mathematica Version: 5.0 *)

(* :History:

     1.0 - initial release

*)

(* :References:

     Brent, R.P. BIT 20: 176 (1980). https://doi.org/10.1007/BF01933190

     Gray, T.W. and Glynn, J. Exploring Mathematics With Mathematica. Addison-Wesley, 1991

     Knuth, D.E. The Art of Computer Programming, vol. II: Seminumerical Algorithms. Addison-Wesley, 1969

*)

(* :Keywords:
     Brent, cycle detection, Floyd *)

BeginPackage["CycleFixedPoint`"];
Unprotect[CycleFixedPoint, CycleTest, FuzzySameQ, IterationCount];

(* usage messages *)

CycleFixedPoint::usage="CycleFixedPoint[f, expr] starts with expr, and tries to find the limit cycle from applying f repeatedly."

CycleTest::usage="CycleTest is an option for CycleFixedPoint that specifies the comparison function to be used for cycle detection."

FuzzySameQ::usage="FuzzySameQ[n][x, y] returns True if x and y are the same to at least n decimal places, and False otherwise."

IterationCount::usage="IterationCount is an option for CycleFixedPoint that, when set to True, return the limit cycle and the number of iterations needed to get the limit cycle."

(* error/warning messages *)

CycleFixedPoint::bdmtd="Value of option Method -> `1` is not Automatic, \"Brent\", or \"Floyd\"."

Begin["`Private`"]

FuzzySameQ[tol_][x_, y_] := (Abs[x - y] < 10^(-tol))

Options[CycleFixedPoint] = {CycleTest -> SameQ, IterationCount -> False, Method -> Automatic, SameTest -> SameQ};

CycleFixedPoint[f_, start_, maxIterations : (_Integer | Infinity), OptionsPattern[]] :=
        Module[{cycleTest = OptionValue[CycleTest], sameTest = OptionValue[SameTest], counter = 1,
		      fast, mon, pow, result, slow, value},

                    Switch[OptionValue[Method],
                               "Brent" | Automatic,
                               slow = start; fast = f[start]; pow = 1; mon = counter;
                               If[maxIterations =!= Infinity,
                                   While[(! sameTest[slow, fast]) && (counter < maxIterations),
                                            If[pow == mon, slow = fast; pow *= 2; mon = 0];
                                            fast = f[fast]; ++counter; mon = counter],
                                   While[! sameTest[slow, fast],
                                            If[pow == mon, slow = fast; pow *= 2; mon = 0];
                                            fast = f[fast]; ++counter; mon = counter]],
                               "Floyd",
                               slow = f[start]; fast = f[slow];
                               If[maxIterations =!= Infinity,
                                   While[(! sameTest[slow, fast]) && (counter < maxIterations),
                                            slow = f[slow]; fast = f[f[fast]]; ++counter;],
                                   While[! sameTest[slow, fast],
                                            slow = f[slow]; fast = f[f[fast]]; ++counter;]],
                                _,
		                Message[CycleFixedPoint::bdmtd, OptionValue[Method]]; Return[$Failed, Module]];

                    result = If[counter == maxIterations, slow,
                                    NestWhileList[f, slow, (! cycleTest[#, slow]) &, {2, 1}, maxIterations, -1]];

                    If[TrueQ[OptionValue[IterationCount]], {result, counter}, result]]

CycleFixedPoint[f_, start_, opts : OptionsPattern[]] := CycleFixedPoint[f, start, $IterationLimit, opts];

End[];

SetAttributes[{CycleFixedPoint, CycleTest, FuzzySameQ, IterationCount}, ReadProtected];
Protect[CycleFixedPoint, CycleTest, FuzzySameQ, IterationCount];

EndPackage[];