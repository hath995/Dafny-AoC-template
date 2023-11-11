
//based on https://swtch.com/~rsc/regexp/regexp1.html
include "../libraries/src/Wrappers.dfy"
module RegEx {
    import opened Wrappers
    datatype RegexPiece = Char(value: char) | GroupStart(id: nat) | GroupEnd(id: nat) | Plus | Star | Optional | Alt | Concat
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
        var groups: seq<nat> := [];
        var parens: seq<Paren> :=[];
        for i := 0 to |re| 
            invariant |groups| == |parens|
        {
            // print "char -> ";
            // print re[i];
            // print "\n";
            match re[i] {
                case '(' => {
                    if natom > 1 {
                        natom := natom -1;
                        buf := buf + [Concat];
                    }
                    parens := parens + [Paren(natom, nalt)];
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
                    natom := natom - 1;
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
                    natom := natom - 1;
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
                    assume |groups| > 0;
                    buf := buf + [GroupEnd(groups[|groups|-1])];
                    groups := groups[0..|groups|-1];
                    // print "nalt: ";
                    // print nalt;
                    // print " natom: ";
                    // print natom;
                    // print "\n";
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
        natom := natom - 1;
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
    datatype MatchKind = Split | Match | Wild | MatchChar(c: char)
    class State {
        ghost var repr : set<object>
        var id: nat
        var c: MatchKind
        var negated: bool
        var out: State?
        var out1: State?
        var lastlist: nat
        var groups: set<nat>
        var origin: RegexPiece

        constructor(id: nat, c: MatchKind, out: State?, out1: State?, negated: bool) 
            ensures this.id == id
            ensures this.c == c
            ensures this.out == out
            ensures this.out1 == out1
            ensures this.negated == negated
            ensures this.groups == {}
        {
            this.id := id;
            this.c := c;
            this.out := out;
            this.out1 := out1;
            this.negated := negated;
            this.groups := {};

        }
        
        ghost predicate Valid() 
            reads this, repr, out, out1
            decreases repr
        {
            this in repr &&
            (this.out != null ==> this !in this.out.repr && this.out.repr <= repr) &&
            (this.out1 != null ==> this !in this.out1.repr && this.out1.repr <= repr) &&
            (this.out != null && this.out1 != null ==> this.out1.repr !! this.out.repr)

        }
    }
    
    datatype StateUpdate = Out(out: State) | Out1(out: State)
    datatype FragC = FragC(start: State, out: seq<StateUpdate>)

    class Frag {
        ghost var repr: set<object>
        var start: State
        var out: array<StateUpdate>

        constructor(start: State, out: array<StateUpdate>)
            ensures this.start == start 
            ensures this.out == out 
        {
            this.start := start;
            this.out := out;
        }

        // ghost predicate Valid()
        //     reads this, repr, out
        // {
        //     this in repr &&
        //     start in repr &&
        //     forall i :: 0 <= i < out.Length ==> OutSet(out[i]) in repr
        // }
    }

    // method pop<T>(stack: seq<T>) returns (e: T)
    //     requires |stack| > 0
    // {
    //     e := stack[|stack|-1];
    //     stack:=stack[..|stack|-1];
    // }
    function OutSet(ls: StateUpdate): State {
        match ls {
            case Out(out) => out
            case Out1(out1) => out1
        }
    }

    function sout(s: State): State? 
        reads s, s.out
    {
        s.out
    }

    function lout(s: State): State? 
        reads s, s.out1
    {
        s.out1
    }


    // method patch(l: Frag, s: Frag)
    //     // requires l.Valid()
    //     modifies l.repr
    //     modifies l.out
    //     modifies set i | 0 <= i < |l.out[..]| :: OutSet(l.out[i])
    //     modifies set i | 0 <= i < l.out.Length :: OutSet(l.out[i])
    //     // modifies set i | 0 <= i < l.out.Length :: sout(OutSet(l.out[i]))
    // {
    //     var i:=0;
    //     while i < l.out.Length
    //         invariant 0 <= i <= l.out.Length
    //     {
    //         match l.out[i]
    //         {
    //             case Out(out) => {
    //                 out.out := s.start;
    //             }
    //             case Out1(out) => {
    //                 out.out1 := s.start;
    //             }
    //         }
    //         i := i+1;
    //     }
    // }

    method patch(l: FragC, s: FragC)
        modifies set i | 0 <= i < |l.out| :: OutSet(l.out[i])
    {
        var i:=0;
        while i < |l.out|
            invariant 0 <= i <= |l.out|
        {
            match l.out[i]
            {
                case Out(out) => {
                    out.out := s.start;
                }
                case Out1(out) => {
                    out.out1 := s.start;
                }
            }
            i := i+1;
        }
    }

    method post2nfa(postfix: seq<RegexPiece>) returns (start: State)
        ensures fresh(start)
    {
        expect |postfix| > 0, "postfix seq should contain an element";
        var stack: seq<FragC> := [];
        var groups: map<nat, (nat, nat)> := map[];
        var states: seq<State?> := [];
        var sid := 1;
        for i:=0 to |postfix| 
            invariant forall frag :: frag in stack ==> fresh(frag.start)
            invariant forall state :: state !=null && state in states ==> fresh(state)
            invariant |states| == i
        {
            match postfix[i] {
                case Char(c) => {
                    var s := new State(sid, MatchChar(c), null, null, false);
                    sid := sid+1;
                    s.origin := postfix[i];
                    states := states +[s];
                    stack := stack +[FragC(s,[Out(s)])];
                }
                case GroupStart(id) => {
                    groups := groups[id := (i+1,0)];
                    states := states +[null];
                }
                case GroupEnd(id) => {
                    assume id in groups;
                    expect id in groups, "Group id was not seen before group end";
                    var GroupStart := groups[id];
                    groups := groups[id := (GroupStart.0, i)];
                    states := states +[null];
                    assume GroupStart.0 < i;
                    for j := GroupStart.0 to i 
                    {
                        if(states[j] != null) {
                            assert states[j] in states;
                            states[j].groups := states[j].groups+{id};
                        }
                    }
                }
                case Concat => {
                    // var e2 := pop(stack);
                    assume |stack| > 1;
                    expect |stack| > 1, "stack length was not greater than 1";
                    var e2 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var e1 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    assume forall i :: 0 <= i < |e1.out| ==>  fresh(OutSet(e1.out[i]));
                    states := states +[null];
                    patch(e1, e2);
                    stack := stack + [FragC(e1.start, e2.out)];
                }
                case Alt => {
                    assume |stack| > 1;
                    expect |stack| > 1, "stack length was not greater than 1";
                    var e2 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var e1 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var s := new State(sid, Split, e1.start, e2.start, false);
                    s.origin := postfix[i];
                    states := states+[s];
                    sid := sid+1;
                    stack := stack+[FragC(s, e1.out+e2.out)];
                }
                case Option => {
                    assume |stack| > 0;
                    expect |stack| > 0, "stack length was not greater than 1";
                    var e1 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var s := new State(sid, Split, e1.start, null, false);
                    s.origin := postfix[i];
                    states := states+[s];
                    sid := sid+1;
                    stack := stack+[FragC(s, e1.out+[Out1(s)])];
                }
                case Star => {
                    assume |stack| > 0;
                    expect |stack| > 0, "stack length was not greater than 1";
                    var e1 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var s := new State(sid, Split, e1.start, null, false);
                    s.origin := postfix[i];
                    states := states+[s];
                    sid := sid+1;
                    patch(e1, FragC(s,[]));
                    stack := stack + [FragC(s, [Out1(s)])];
                }
                case Plus => {
                    assume |stack| > 0;
                    expect |stack| > 0, "stack length was not greater than 1";
                    var e1 := stack[|stack|-1];
                    stack:=stack[..|stack|-1];
                    var s := new State(sid, Split, e1.start, null, false);
                    s.origin := postfix[i];
                    states := states+[s];
                    sid := sid+1;
                    patch(e1, FragC(s, []));
                    stack := stack+[FragC(e1.start, [Out1(s)])];
                }
            }
        }
        assume |stack| > 0;
        expect |stack| > 0, "stack length was not greater than 1";
        var e := stack[|stack|-1];
        var matchState := new State(sid, Match, null, null, false);
        assume forall i :: 0 <= i < |e.out| ==>  fresh(OutSet(e.out[i]));
        patch(e, FragC(matchState, []));
        return e.start;
    }

    method addstate(l: seq<State>, s: State?) returns (res: Result<seq<State>, string>)
        decreases *
    {
        if s == null {
            return Failure("Added state was null");
        } else if s!=null && s.c.Split? {
            var next := addstate(l, s.out);
            if next.Success? {
                res := addstate(next.Extract(), s.out1);
            }else{
                res := next;
            }
            
        } else {
            return Success(l+[s]);
        }
    }

    method ReMatch(re: string, targetString: string) returns (matches: bool, captures: seq<string>)

    {
        var postfix := re2post(re);
        match postfix {
            case Success(post) => {
                var start := post2nfa([GroupStart(0)]+post+[GroupEnd(0)]);
                matches := true;
                captures := [];
            }
            case Failure(err) => {
                print err;
                matches := false;
                captures := [];
            }
        }
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

    method test_re2post() {

    }

    method test_post2nfa() {

    }
}