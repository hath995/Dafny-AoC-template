include "../libraries/src/Wrappers.dfy"

module Parser {
    import opened Wrappers
    datatype ParserState<T> = State(index: nat, targetString: string, result: Option<T>, isError: bool, error: string)
    type Parser<!T> = (ParserState<T>) --> ParserState<T>
    function Str(s: string): Parser<string> {
        (state: ParserState<string>) requires state.index <= |state.targetString| => if s <= state.targetString[state.index..] then 
            State(state.index+|s|, state.targetString, Some(s), false, "") 
        else 
            State(state.index+|s|, state.targetString, Some(s), true, "Tried to match \""+s+"\", but got \""+state.targetString[state.index..(if state.index+|s| <= |state.targetString| then  state.index+|s| else |state.targetString|)]+"\"")
    }

    function Run<T(!new)>(parser: Parser<T>, targetString: string): ParserState<T>
        reads parser.reads
        // requires forall x :: parser.requires(x)
    {
        var state:=State(0, targetString, None, false, "");
        assert state.index <= |state.targetString|;
        parser(state)
    }

    method Main() {
        var hello := Str("hello");

    }
}