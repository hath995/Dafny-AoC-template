# Parser Module Documentation

This directory contains verified parsing utilities for use in Dafny programs. Each module provides functions and methods for common text processing tasks.

## Modules

### [regex.dfy](regex.dfy.md) - Regular Expression Implementation

A limited but verified implementation of regular expressions based on the Thompson NFA construction algorithm. Supports character matching, wildcards, alternation, quantifiers (star, plus, optional), grouping with capture, and escape sequences.

**Main API:**
- **Method:** `ReMatch(re: string, targetString: string)` - Match a regex pattern against a string
- **Constants:** `Digits`, `LowerLatin`, `UpperLatin`, `LatinLetters` - Common regex patterns

See [regex.dfy.md](regex.dfy.md) for complete documentation.

### [split.dfy](split.dfy.md) - String Splitting Utilities

Verified string splitting and joining operations with support for common line break handling patterns.

**Main API:**
- **Function:** `split(s: string, separator: string)` - Split a string by separator
- **Function:** `sumSeq(ss: seq<string>, separator: string)` - Join strings with separator
- **Predicate:** `Contains(haystack: string, needle: string)` - Check substring membership
- **Function:** `splitOnBreak(s: string)` - Split on line breaks (handles `\r\n` and `\n`)
- **Function:** `splitOnDoubleBreak(s: string)` - Split on double line breaks

See [split.dfy.md](split.dfy.md) for complete documentation.

### [parseInt.dfy](parseInt.dfy.md) - Integer Parsing and Conversion

⚠️ **DEPRECATED** - This module is deprecated. Use the standard library functions from `Std.Strings` instead:

- **Use `Std.Strings.OfNat(n: nat): string`** instead of `toStr` for converting natural numbers to strings
- **Use `Std.Strings.OfInt(i: int): string`** instead of `toStr` for converting integers to strings
- **Use `Std.Strings.ToNat(s: string): nat`** instead of `Integer` or `toInt` for parsing natural numbers
- **Use `Std.Strings.ToInt(s: string): int`** instead of `Integer` or `toInt` for parsing integers

The standard library functions are more robust, better maintained, and integrate seamlessly with Dafny's type system.

**Legacy API (for reference only):**
- **Function:** `Integer(ns: string)` - Extract digits from string (lenient parsing)
- **Method:** `toInt(ns: string)` - Convert valid number string to integer (strict parsing)
- **Method:** `toStr(num: int)` - Convert integer to string
- **Predicate:** `isNumString(s: string)` - Validate number string format

See [parseInt.dfy.md](parseInt.dfy.md) for complete documentation (for reference only).

## Quick Reference

### Recommended Usage

```dafny
import Std.Strings

// String to integer conversion
var num := Std.Strings.ToInt("123");  // Returns int
var nat := Std.Strings.ToNat("456");  // Returns nat

// Integer to string conversion
var str1 := Std.Strings.OfInt(-42);   // Returns "-42"
var str2 := Std.Strings.OfNat(99);    // Returns "99"

// String splitting
import Split
var parts := Split.split("a,b,c", ",");
var lines := Split.splitOnBreak(fileContents);

// Regular expressions
import RegEx
var matches, captures := RegEx.ReMatch("a+", "aaa");
```

## Notes

- All functions are pure and can be used in specifications unless marked as methods
- Methods may have side effects and require imperative contexts
- Predicates are pure boolean functions usable in specifications

