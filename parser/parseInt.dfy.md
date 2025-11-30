# parseInt.dfy - Integer Parsing and Conversion

A verified implementation of integer parsing and string conversion in Dafny, with support for validating number strings.

## Overview

This module provides functions and methods for converting between integers and their string representations. It includes both lenient parsing (extracting digits from any string) and strict parsing (requiring valid number format).

## Exported Functions and Methods

### Function: `Integer(ns: string): int`

**Type:** Function (pure, can be used in specifications)

Extracts all digit characters from a string and converts them to an integer.

**Parameters:**
- `ns`: The string to parse (may contain non-digit characters)

**Returns:**
- An integer formed by concatenating all digit characters found in the string

**Behavior:**
- Filters the input string to keep only digit characters (0-9)
- Non-digit characters are ignored
- Does not handle negative signs (the minus sign is filtered out)
- If no digits are found, returns 0
- This is a lenient parser that works on any string

**Examples:**
```dafny
var num1 := Integer("123");
// num1 == 123

var num2 := Integer("abc123def");
// num2 == 123

var num3 := Integer("-456");
// num3 == 456 (minus sign is ignored)

var num4 := Integer("12.34");
// num4 == 1234 (decimal point is ignored)
```

### Method: `toInt(ns: string) returns (ret: int)`

**Type:** Method (imperative, can have side effects)

Converts a valid number string to an integer.

**Parameters:**
- `ns`: The string to parse (must be a valid number string)

**Returns:**
- The integer value represented by the string

**Preconditions:**
- `isNumString(ns)` must be true (the string must contain only digits and optionally a leading minus sign)

**Behavior:**
- Parses the entire string as a number
- Handles negative numbers (leading `-` sign)
- Requires the input to be a well-formed number string
- More strict than `Integer` - will fail verification if the precondition is not met

**Examples:**
```dafny
var num1, _ := toInt("123");
// num1 == 123

var num2, _ := toInt("-456");
// num2 == -456

// The following would fail verification:
// var num3, _ := toInt("12.34"); // Not a valid number string
```

### Method: `toStr(num: int) returns (ret: string)`

**Type:** Method (imperative, can have side effects)

Converts an integer to its string representation.

**Parameters:**
- `num`: The integer to convert

**Returns:**
- A string representation of the integer

**Postconditions:**
- `isNumString(ret)` is guaranteed to be true

**Behavior:**
- Converts the integer to its decimal string representation
- Includes a minus sign for negative numbers
- The result is always a valid number string that can be parsed back with `toInt`
- For zero, returns an empty string (this may be a limitation)

**Examples:**
```dafny
var str1, _ := toStr(123);
// str1 == "123"

var str2, _ := toStr(-456);
// str2 == "-456"

var str3, _ := toStr(0);
// str3 == "" (note: may need special handling)
```

### Predicate: `isNumString(s: string): bool`

**Type:** Predicate (pure boolean function, can be used in specifications)

Checks whether a string is a valid number string.

**Parameters:**
- `s`: The string to validate

**Returns:**
- `true` if the string contains only valid number characters, `false` otherwise

**Behavior:**
- Valid number strings contain only:
  - Digits: `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`
  - Minus sign: `-` (typically only at the beginning)
- Empty strings are considered valid
- Any other characters make the string invalid

**Examples:**
```dafny
var valid1 := isNumString("123");
// valid1 == true

var valid2 := isNumString("-456");
// valid2 == true

var invalid1 := isNumString("12.34");
// invalid1 == false (contains decimal point)

var invalid2 := isNumString("abc");
// invalid2 == false (contains letters)

var empty := isNumString("");
// empty == true
```

## Common Use Cases

### Parsing User Input

```dafny
// Lenient parsing - extract numbers from mixed text
var extracted := Integer("The answer is 42!");
// extracted == 42

// Strict parsing - validate format first
if isNumString(userInput) {
    var parsed, _ := toInt(userInput);
    // Use parsed value
}
```

### Converting Numbers to Strings

```dafny
// Convert integer to string for display
var num := 12345;
var display, _ := toStr(num);
// display == "12345"

// Handle negative numbers
var negative := -99;
var negStr, _ := toStr(negative);
// negStr == "-99"
```

### Round-Trip Conversion

```dafny
// Convert to string and back
var original := 123;
var asString, _ := toStr(original);
var backToInt, _ := toInt(asString);
// backToInt == original (when original != 0)
```

## Differences Between `Integer` and `toInt`

| Feature | `Integer` | `toInt` |
|---------|-----------|---------|
| Input validation | None (works on any string) | Requires `isNumString` |
| Negative numbers | Not supported (minus filtered out) | Supported |
| Non-digit handling | Ignores non-digits | Rejects invalid strings |
| Use case | Extract numbers from mixed text | Parse validated number strings |

## Verification Properties

The implementation includes formal verification to ensure:

- **Type safety**: `toStr` always produces a valid number string (`isNumString(ret)`)
- **Precondition checking**: `toInt` requires a valid number string
- **Termination**: All functions and methods are guaranteed to terminate

## Notes

- `Integer` is useful for extracting numeric values from strings that may contain other characters
- `toInt` is more appropriate when you need to validate the input format and handle negative numbers
- The `toStr` function may return an empty string for zero, which may require special handling in some use cases
- All exported functions work with base-10 integers only
- The module does not handle floating-point numbers or other number bases

