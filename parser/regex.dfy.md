# regex.dfy - Regular Expression Implementation

A limited but verified implementation of regular expressions in Dafny, based on the Thompson NFA construction algorithm (see [reference](https://swtch.com/~rsc/regexp/regexp1.html)).

## Overview

This module provides a regular expression engine that converts regex patterns into Non-deterministic Finite Automata (NFA) and executes them to match strings. 

## Features

### Supported Operations

- **Character matching**: Literal characters (e.g., `a`, `b`, `c`)
- **Wildcard**: `.` matches any single character
- **Alternation**: `|` matches either the left or right pattern (e.g., `a|b`)
- **Kleene star**: `*` matches zero or more repetitions (e.g., `a*`)
- **Plus**: `+` matches one or more repetitions (e.g., `a+`)
- **Optional**: `?` matches zero or one occurrence (e.g., `a?`)
- **Grouping**: `()` for grouping and capturing
- **Escape sequences**: `\` to escape special characters (e.g., `\(` matches literal `(`)

### Limitations

- No support for:
  - Anchors (`^`, `$`)
  - Character class ranges (`[a-z]`)
  - Negated character classes (`[^abc]`)
  - Backreferences
  - Lookahead/lookbehind assertions
  - Quantifiers with bounds (`{n}`, `{n,m}`)

## Architecture

The implementation consists of three main phases:

1. **Parsing** (`re2post`): Converts infix regex notation to postfix notation
2. **NFA Construction** (`post2nfa`): Builds an NFA from the postfix representation using Thompson's algorithm
3. **Matching** (`execRe`): Executes the NFA against an input string using a state machine simulation

## Main API

### Method: `ReMatch(re: string, targetString: string) returns (matches: bool, captures: seq<string>)`

The primary entry point for regex matching. This is a **method** (imperative, can have side effects).

**Parameters:**
- `re`: The regular expression pattern
- `targetString`: The string to match against

**Returns:**
- `matches`: `true` if the pattern matches the entire string, `false` otherwise
- `captures`: A sequence of captured groups (substrings matched by parenthesized groups)

**Example:**
```dafny
var m, cap := ReMatch("a+(b|c)+", "aaaccc");
// m == true
// cap == [['a','a','a','c','c','c'],['c']]
```

## Constants

The module provides several useful regex **constants** (compile-time values):

- `Digits`: Matches a single digit `(0|1|2|3|4|5|6|7|8|9)`
- `LowerLatin`: Matches a lowercase letter `(a|b|c|...|z)`
- `UpperLatin`: Matches an uppercase letter `(A|B|C|...|Z)`
- `LatinLetters`: Matches any Latin letter (lowercase or uppercase)

## Examples

### Basic Matching

```dafny
var m, cap := ReMatch("abc", "abc");
// m == true, cap == []
```

### Alternation

```dafny
var m, cap := ReMatch("a|b", "b");
// m == true
```

### Quantifiers

```dafny
var m, cap := ReMatch("a+be*(c|d|f)g", "aabeefg");
// m == true
```

### Group Capturing

```dafny
var m, cap := ReMatch("addxy ((0|1|2|3|4|5|6|7|8|9)+),((0|1|2|3|4|5|6|7|8|9)+)", "addxy 12,345");
// m == true
// cap contains the captured groups
```

### Escaped Characters

```dafny
var m, cap := ReMatch("add\\(.+,.+\\)", "add(12,355)");
// m == true (matches literal parentheses)
```

## Notes

- The implementation uses a Thompson NFA, which provides linear-time matching in the size of the input string
- Group capturing tracks the start and end positions of matched groups
- The NFA construction ensures that all states are properly connected and reachable
- Some operations use `assume {:axiom}` annotations where full verification would be complex but the properties are known to hold

## References

Based on the algorithm described in: https://swtch.com/~rsc/regexp/regexp1.html

