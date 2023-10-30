include "../../parser/split.dfy"
include "../../parser/parseInt.dfy"
include "../../libraries/src/dafny/Collections/Seqs.dfy"
module Problem1 {
    import opened Split
    import opened ParseInt
    import opened Dafny.Collections.Seq

    method parseInput(input: string) returns (result: seq<seq<int>>) {
        var lineEnding := if Contains(input, "\r\n") then "\r\n" else "\n";
        var data := split(input, lineEnding+lineEnding);
        result := Map(s => Map(xs => Integer(xs), Filter(xs => xs != "", split(s, lineEnding))), data);
    }

    method problem1_1(input: string) returns (x: int)
    {
        var data := parseInput(input);
        var sums: seq<int> := MergeSortBy(Map((items) => FoldLeft((x,y) => x+y, 0, items), data), (x,y) => x >= y);
        //assume |sums| > 0;
        if |sums| > 0 {

            return sums[0];
        } 
        return -1;
    }

    method problem1_2(input: string) returns (x: int)
    {
        var data := parseInput(input);
        var sums: seq<int> := MergeSortBy(Map((items) => FoldLeft((x,y) => x+y, 0, items), data), (x,y) => x >= y);
        //assume |sums| > 0;
        if |sums| > 2 {
            return sums[0]+ sums[1]+ sums[2];
        } 
        return -1;
    }
}