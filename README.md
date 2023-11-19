# Dafny Advent-of-Code template
For those participating in Advent of Code this template provides a convenient structure and runner for completing the challenges in Dafny, the software verification programming language. Dafny is still under development and File IO is a bit challenging because it relies on foreign function calls to do IO. Luckily, the Dafny community has provided a libary for Dafny 4.0 that includes simple IO capabilities. 


### Installation
Clone the repository into a new folder per year. 

`git clone --recurse-submodules git@github.com:hath995/Dafny-AoC-template.git dafny-aoc-2023`

In the command line you should ensure that Dafny is in your path. Download the latest stable release [here](https://github.com/dafny-lang/dafny/releases). 

Dafny also requires the .NET runtime which you can download [here](https://dotnet.microsoft.com/en-us/download).

Install the Dafny VS-Code plugin [here](https://marketplace.visualstudio.com/items?itemName=dafny-lang.ide-vscode).

### How to Use
Advent of Code has 25 problems and each problem has two parts. Traditionally, the first part is building up to the more complex second part. 

Steps:
1. Copy the example input into the problems/\<number\>/example.txt
2. Download the problem input into problems/\<number\>/input.txt
3. Depending on your os, run `aoc.ps1` or `aoc.sh` appending the problem number (0-25) and part number (1-2) and -t or --test for using the test input.

### Example
```
./aoc.sh 0 1 --test
./aoc.sh 0 2
```

