// include "../libraries/src/Wrappers.dfy"

module Parser {
    import opened Std.Wrappers
    datatype ParserState<T> = State(index: nat, targetString: string, result: Option<T>, isError: bool, error: string)
    type Parser<!T> = (ParserState<T>) -> ParserState<T>

    ghost predicate ValidParser<T(!new)>(parser: Parser<T>)
    {
        forall state: ParserState<T> :: 
            if parser(state).isError then 
                parser(state).result == None
            else 
                parser(state).result.Some? 
                && parser(state).index > state.index 
                && parser(state).index <= |state.targetString|
                && parser(state).targetString == state.targetString
    }

    function updateParserState<T>(state: ParserState, index: nat, result: T): ParserState {
        State(index, state.targetString, Some(result), false, "")
    }

    function updateParserResult<T, U>(state: ParserState, result: U): ParserState<U> {
        State(state.index, state.targetString, Some(result), false, "")
    }

    function updateParserError<T>(state: ParserState, errorMsg: string): ParserState {
        State(state.index, state.targetString, state.result, true, errorMsg)
    }

    function validSlice(s: string, state: ParserState): string {
        state.targetString[(if state.index <= |state.targetString| then state.index else 0)..(if state.index+|s| <= |state.targetString| then  state.index+|s| else |state.targetString|)]
    }

    function Str(s: string): Parser<string> 
        requires |s| > 0
    {
        (state: ParserState<string>)  => if s <= validSlice(s, state) then 
            updateParserState(state, state.index+|s|, s) 
        else 
            updateParserError(state, "Str: Tried to match \""+s+"\", but got \""+validSlice(s, state)+"\"")
    }

    function sequenceOfHelper<T>(parsers: seq<Parser<T>>, nextState: ParserState<T>, results: seq<T>): ParserState<seq<T>> {
        if |parsers| == 0 then updateParserResult(nextState, results) else 
        var nextState := parsers[0](nextState);
        if nextState.result.Some? then
            sequenceOfHelper(parsers[1..], nextState, results+[nextState.result.Extract()])
        else
            sequenceOfHelper(parsers[1..], nextState, results)
    }

    function SequenceOf<T>(parsers: seq<Parser<T>>) : (parserSeq: ParserState<T> -> ParserState<seq<T>>) {
        (state: ParserState<T>) => if state.isError then 
            match state.result {
                case Some(value) => State(state.index, state.targetString, Some([value]), true, state.error)
                case None => State(state.index, state.targetString, None, true, state.error)
            }
        else sequenceOfHelper(parsers, state, [])
    }

    function OneOfHelper<T>(parsers: seq<Parser<T>>, nextState: ParserState<T>): ParserState<T> {
        if |parsers| == 0 then updateParserError(nextState, "OneOf: Tried all parsers, but none matched") else 
        var nextState := parsers[0](nextState);
        if nextState.result.Some? then nextState else OneOfHelper(parsers[1..], nextState)
    }

    function OneOf<T>(parsers: seq<Parser<T>>) : (parserSeq: ParserState<T> -> ParserState<T>) {
        (state: ParserState<T>) => if state.isError then 
            match state.result {
                case Some(value) => State(state.index, state.targetString, Some(value), true, state.error)
                case None => State(state.index, state.targetString, None, true, state.error)
            }
        else
            OneOfHelper(parsers, state)
    }

    function ManyHelper<T(!new)>(parser: Parser<T>, state: ParserState<T>, results: seq<T>): ParserState<seq<T>> 
        requires ValidParser(parser)
        decreases |state.targetString| - state.index
    {
        var nextState := parser(state);
        if nextState.result.Some? then
            ManyHelper(parser, nextState, results+[nextState.result.Extract()])
        else
            updateParserResult(nextState, results)
    }

    function Many<T(!new)>(parser: Parser<T>) : (parserSeq: ParserState<T> -> ParserState<seq<T>>) 
        requires ValidParser(parser)
    {
        (state: ParserState<T>) => if state.isError then 
            match state.result {
                case Some(value) => State(state.index, state.targetString, Some([value]), true, state.error)
                case None => State(state.index, state.targetString, None, true, state.error)
            }
        else
            ManyHelper(parser, state, [])
    }

    function Run<T(!new), U(!new)>(parser: ParserState<T> -> ParserState<U>, targetString: string): ParserState<U>
    {
        var state := State(0, targetString, None, false, "");
        parser(state)
    }

    // lemma StrValidParser(s: string)
    //     requires |s| > 0
    //     ensures ValidParser(Str(s))
    // {

    // }

    method Main() {
        var hello := Str("hello!");
        var parser := SequenceOf([hello, Str("there!")]);
        var result := Run(parser, "hello!there!");
        print result, "\n";

        var parser2 := OneOf([Str("hello"), Str("there")]);
        var result2 := Run(parser2, "hello");
        print result2, "\n";
    }
}