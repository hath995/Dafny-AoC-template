# split.dfy - String Splitting Utilities

A verified implementation of string splitting and joining operations in Dafny, with support for common line break handling patterns.

## Overview

This module provides functions for splitting strings by separators and joining sequences of strings back together. It includes special handling for common line break patterns used in text processing.

## Exported Functions and Predicates

### Function: `split(s: string, separator: string): seq<string>`

**Type:** Function (pure, can be used in specifications)

Splits a string into a sequence of substrings separated by the given separator.

**Parameters:**
- `s`: The string to split
- `separator`: The separator string to split on

**Returns:**
- A sequence of strings resulting from splitting `s` by `separator`

**Behavior:**
- If `separator` is empty (`""`), the string is split into individual characters
- If `separator` is non-empty, the string is split at each occurrence of the separator
- The separator is not included in the resulting substrings
- The function satisfies: `sumSeq(split(s, separator), separator) == s` (joining the result with the separator reconstructs the original string)

**Examples:**
```dafny
var parts := split("a,b,c", ",");
// parts == ["a", "b", "c"]

var chars := split("abc", "");
// chars == ["a", "b", "c"]

var words := split("hello world", " ");
// words == ["hello", "world"]
```

### Function: `sumSeq(ss: seq<string>, separator: string): string`

**Type:** Function (pure, can be used in specifications)

Joins a sequence of strings together with a separator between each pair.

**Parameters:**
- `ss`: The sequence of strings to join
- `separator`: The separator string to insert between elements

**Returns:**
- A single string formed by concatenating all strings in `ss` with `separator` between them

**Behavior:**
- If the sequence is empty, returns an empty string
- If the sequence has one element, returns that element (no separator added)
- For multiple elements, inserts the separator between each adjacent pair
- This is the inverse operation of `split`: `sumSeq(split(s, sep), sep) == s`

**Examples:**
```dafny
var joined := sumSeq(["a", "b", "c"], ",");
// joined == "a,b,c"

var words := sumSeq(["hello", "world"], " ");
// words == "hello world"

var empty := sumSeq([], "-");
// empty == ""
```

### Predicate: `Contains(haystack: string, needle: string): bool`

**Type:** Predicate (pure boolean function, can be used in specifications)

Checks whether a string contains another string as a substring.

**Parameters:**
- `haystack`: The string to search in
- `needle`: The substring to search for

**Returns:**
- `true` if `needle` appears as a substring of `haystack`, `false` otherwise

**Formal Specification:**
- `Contains(haystack, needle) <==> exists i :: 0 <= i <= |haystack| && needle <= haystack[i..]`
- The predicate is true if and only if `needle` is a prefix of some suffix of `haystack`

**Examples:**
```dafny
var found := Contains("hello world", "world");
// found == true

var notFound := Contains("hello", "xyz");
// notFound == false

var emptyNeedle := Contains("abc", "");
// emptyNeedle == true (empty string is always contained)
```

### Function: `splitOnBreak(s: string): seq<string>`

**Type:** Function (pure, can be used in specifications)

Splits a string on line breaks, automatically handling both Windows (`\r\n`) and Unix (`\n`) line endings.

**Parameters:**
- `s`: The string to split

**Returns:**
- A sequence of strings, one for each line (line breaks are removed)

**Behavior:**
- First checks if the string contains `\r\n` (Windows line endings)
- If found, splits on `\r\n`
- Otherwise, splits on `\n` (Unix line endings)
- Useful for processing text files that may come from different operating systems

**Examples:**
```dafny
var lines1 := splitOnBreak("line1\nline2\nline3");
// lines1 == ["line1", "line2", "line3"]

var lines2 := splitOnBreak("line1\r\nline2\r\nline3");
// lines2 == ["line1", "line2", "line3"]
```

### Function: `splitOnDoubleBreak(s: string): seq<string>`

**Type:** Function (pure, can be used in specifications)

Splits a string on double line breaks, automatically handling both Windows and Unix line endings.

**Parameters:**
- `s`: The string to split

**Returns:**
- A sequence of strings, split at double line breaks

**Behavior:**
- First checks if the string contains `\r\n` (Windows line endings)
- If found, splits on `\r\n\r\n`
- Otherwise, splits on `\n\n` (Unix line endings)
- Useful for splitting text into paragraphs or sections separated by blank lines

**Examples:**
```dafny
var paragraphs1 := splitOnDoubleBreak("para1\n\npara2\n\npara3");
// paragraphs1 == ["para1", "para2", "para3"]

var paragraphs2 := splitOnDoubleBreak("para1\r\n\r\npara2\r\n\r\npara3");
// paragraphs2 == ["para1", "para2", "para3"]
```

## Common Use Cases

### Processing Input Files

```dafny
// Split a file into lines
var lines := splitOnBreak(fileContents);

// Split a file into paragraphs
var paragraphs := splitOnDoubleBreak(fileContents);
```

### Parsing Delimited Data

```dafny
// Split CSV-like data
var fields := split("name,age,city", ",");

// Split on multiple characters
var parts := split("key:value", ":");
```

## Verification Properties

The implementation includes formal verification to ensure:

- **Correctness**: `sumSeq(split(s, separator), separator) == s` for all strings and separators
- **Substring matching**: The `Contains` predicate has formal specifications relating it to substring operations
- **Termination**: All functions are guaranteed to terminate

## Notes

- When splitting with an empty separator, the result is a sequence of single-character strings
- The `split` function handles overlapping separators correctly (each occurrence splits the string)
- Line break detection in `splitOnBreak` and `splitOnDoubleBreak` prioritizes Windows-style line endings (`\r\n`) over Unix-style (`\n`)

