
include "../libraries/src/Wrappers.dfy"
module RegEx {
    import opened Wrappers
    datatype RegexPiece = Char(value: char) | GroupStart(id: int) | GroupEnd(id: int) | Plus | Star | Optional | Alt | Concat
    datatype Paren = Paren(natom: int, nalt: int)
    function RegToChar(re: RegexPiece): char {
        match re {
            case Char(value) => value
            case GroupStart(id) => '('
            case GroupEnd(id) => ')'
            case Alt => '|'
            case Optional => '?'
            case Plus => '+'
            case Star => '*'
            case Concat => '.'
        }
    }

    method re2post(re: string) returns (res: Result<seq<RegexPiece>, string>) {
        var buf := [];
        var nalt := 0;
        var natom := 0;
        var groupid := 1;
        var groups: seq<int> := [];
        var parens: seq<Paren> :=[];
        for i := 0 to |re| 

        {
            match re[i] {
                case '(' => {
                    if natom > 1 {
                        natom := natom -1;
                        buf := buf + [Concat];
                    }
                    parens := parens + [Paren(nalt, natom)];
                    buf := buf + [GroupStart(groupid)];
                    groups := groups + [groupid];
                    groupid := groupid + 1;
                    nalt := 0;
                    natom := 0;
                }
                case '|' => {
                    if natom == 0 {
                        return Failure("Missing atom");
                    }
                    while natom > 0 {
                        buf := buf + [Concat];
                        natom := natom - 1;
                    }
                    nalt := nalt + 1;
                }
                case ')' => {
                    if |parens| == 0 || |groups| == 0 || natom == 0 {
                        return Failure("missing atom or paren");
                    }
                    while natom > 0 {
                        buf := buf + [Concat];
                        natom := natom - 1;
                    }
                    while nalt > 0 {
                        buf := buf + [Alt];
                        nalt := nalt - 1;
                    }
                    var next := parens[|parens|-1];
                    nalt := next.nalt;
                    natom := next.natom;
                    parens := parens[0..|parens|-1];
                    natom := natom + 1;
                    buf := buf + [GroupEnd(groups[|groups|-1])];
                    groups := groups[0..|groups|-1];
                }
                case '*' => {
                    if natom == 0 {
                        return Failure("Missing atom");
                    }
                    buf := buf + [Star];
                }
                case '+' => {
                    if natom == 0 {
                        return Failure("Missing atom");
                    }
                    buf := buf + [Plus];
                }
                case '?' => {
                    if natom == 0 {
                        return Failure("Missing atom");
                    }
                    buf := buf + [Optional];
                }
                case _ => {
                    if natom > 1 {
                        natom := natom -1;
                        buf := buf + [Concat];
                    }
                    buf := buf + [Char(re[i])];
                    natom := natom + 1;
                }
            }
        }
        if |parens| != 0 {
            return Failure("Missing )");
        }
        while natom > 0 {
            buf := buf + [Concat];
            natom := natom - 1;
        }
        while nalt > 0 {
            buf := buf + [Alt];
            nalt := nalt - 1;
        }
        return Success(buf);
    }

    method Main() {
        var test := re2post("a(a+be*)(c|(d)|f)g");
        // var test := re2post("ac+de?(fg)*");
        print test;
        print "\n";
        match test {
            case Success(value) => print seq(|value|, i requires 0 <= i < |value| => RegToChar(value[i]));
            case Failure(err) => print err;
        }
        
    }
}