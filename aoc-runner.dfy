include "libraries/src/dafny/FileIO/FileIO.dfy"
include "libraries/src/Wrappers.dfy"
include "problems/0/Problem0.dfy"
include "problems/1/Problem1.dfy"
include "problems/2/Problem2.dfy"
include "problems/3/Problem3.dfy"
include "problems/4/Problem4.dfy"
include "problems/5/Problem5.dfy"
include "problems/6/Problem6.dfy"
include "problems/7/Problem7.dfy"
include "problems/8/Problem8.dfy"
include "problems/9/Problem9.dfy"
include "problems/10/Problem10.dfy"
include "problems/11/Problem11.dfy"
include "problems/12/Problem12.dfy"
include "problems/13/Problem13.dfy"
include "problems/14/Problem14.dfy"
include "problems/15/Problem15.dfy"
include "problems/16/Problem16.dfy"
include "problems/17/Problem17.dfy"
include "problems/18/Problem18.dfy"
include "problems/19/Problem19.dfy"
include "problems/20/Problem20.dfy"
include "problems/21/Problem21.dfy"
include "problems/22/Problem22.dfy"
include "problems/23/Problem23.dfy"
include "problems/24/Problem24.dfy"
include "problems/25/Problem25.dfy"
//run --no-verify --unicode-char:false --target:cs "aoc-runner.dfy" --input "libraries/src/FileIO/FileIO.cs" -- "1" "1" "System.ArgumentException:"

module AocRunner {
    import opened Dafny.FileIO
    import opened Problem0
    import opened Problem1
    import opened Problem2
    import opened Problem3
    import opened Problem4
    import opened Problem5
    import opened Problem6
    import opened Problem7
    import opened Problem8
    import opened Problem9
    import opened Problem10
    import opened Problem11
    import opened Problem12
    import opened Problem13
    import opened Problem14
    import opened Problem15
    import opened Problem16
    import opened Problem17
    import opened Problem18
    import opened Problem19
    import opened Problem20
    import opened Problem21
    import opened Problem22
    import opened Problem23
    import opened Problem24
    import opened Problem25

    function toStr(iores: FileIO.Wrappers.Result<seq<bv8>, string> ): string {
        match iores {
            case Success(value) => seq(|value|, i requires 0 <= i < |value| => value[i] as char)
            case Failure(e) => e
        }
    }

    method Main(args: seq<string>) 
        decreases * 
    {
        expect |args| > 2;
        var problem := args[1];
        var part := args[2];
        var test := |args| > 3 && args[3] == "-t";
        var file := "problems/"+problem+"/"+ if test then "example.txt" else "input.txt";
        var input := FileIO.ReadBytesFromFile(file);
        match input {
            case Failure(e) => print e;
            case Success(value) => print "\n";
        }

        print "Problem " + problem + " part " + part + (if test then " test" else " official") + " input Result: \n";
        match problem {
            case "0" => {
                match part {
                    case "1" => {
                        var res := problem0_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem0_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "1" => {
                match part {
                    case "1" => {
                        var res := problem1_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem1_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "2" => {
                match part {
                    case "1" => {
                        var res := problem2_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem2_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "3" => {
                match part {
                    case "1" => {
                        var res := problem3_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem3_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "4" => {
                match part {
                    case "1" => {
                        var res := problem4_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem4_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "5" => {
                match part {
                    case "1" => {
                        var res := problem5_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem5_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "6" => {
                match part {
                    case "1" => {
                        var res := problem6_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem6_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "7" => {
                match part {
                    case "1" => {
                        var res := problem7_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem7_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "8" => {
                match part {
                    case "1" => {
                        var res := problem8_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem8_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "9" => {
                match part {
                    case "1" => {
                        var res := problem9_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem9_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "10" => {
                match part {
                    case "1" => {
                        var res := problem10_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem10_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "11" => {
                match part {
                    case "1" => {
                        var res := problem11_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem11_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "12" => {
                match part {
                    case "1" => {
                        var res := problem12_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem12_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "13" => {
                match part {
                    case "1" => {
                        var res := problem13_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem13_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "14" => {
                match part {
                    case "1" => {
                        var res := problem14_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem14_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "15" => {
                match part {
                    case "1" => {
                        var res := problem15_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem15_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "16" => {
                match part {
                    case "1" => {
                        var res := problem16_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem16_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "17" => {
                match part {
                    case "1" => {
                        var res := problem17_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem17_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "18" => {
                match part {
                    case "1" => {
                        var res := problem18_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem18_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "19" => {
                match part {
                    case "1" => {
                        var res := problem19_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem19_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "20" => {
                match part {
                    case "1" => {
                        var res := problem20_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem20_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "21" => {
                match part {
                    case "1" => {
                        var res := problem21_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem21_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "22" => {
                match part {
                    case "1" => {
                        var res := problem22_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem22_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "23" => {
                match part {
                    case "1" => {
                        var res := problem23_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem23_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "24" => {
                match part {
                    case "1" => {
                        var res := problem24_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem24_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case "25" => {
                match part {
                    case "1" => {
                        var res := problem25_1(toStr(input));
                        print res;
                    }
                    case "2" => {
                        var res := problem25_2(toStr(input));
                        print res;
                    }
                    case _ => print "problem part not found";
                }
            }
            case _ => print "Problem Not found";
        } 
        print "\n";
    }
}
