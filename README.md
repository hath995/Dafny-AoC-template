# Dafny Advent-of-Code template
For those participating in Advent of Code this template provides a convenient structure and runner for completing the challenges in Dafny, the software verification programming language. Dafny is still under development and File IO is a bit challenging because it relies on foreign function calls to do IO. Luckily, the Dafny community has provided a libary for Dafny 4.0 that includes simple IO capabilities. 


### Installation
Clone the repository into a new folder per year. 

`git clone git@github.com:hath995/Dafny-AoC-template.git dafny-aoc-2025`

In the command line you should ensure that Dafny is in your path. Download the latest stable release and unzip [here](https://github.com/dafny-lang/dafny/releases). 

Note: On Mac using the Dafny tools has become a bit trickier. I recommend the following otherwise you will need to allow a dozen dlls in the mac security tab. 
```
xattr -r -d com.apple.quarantine /path/to/Dafny/Folder
```

Dafny also requires the .NET runtime which you can download [here](https://dotnet.microsoft.com/en-us/download).

Install the Dafny VS-Code plugin [here](https://marketplace.visualstudio.com/items?itemName=dafny-lang.ide-vscode).

### How to Use
Advent of Code has 25 problems, (12 problems as of 2025) and each problem has two parts. Traditionally, the first part is building up to the more complex second part. 

Steps:
1. Copy the example input into the problems/\<number\>/example.txt
2. Download the problem input into problems/\<number\>/input.txt
3. Depending on your os, run `aoc.ps1` or `aoc.sh` appending the problem number (0-25) and part number (1-2) and -t or --test for using the test input.

### Example
```
./aoc.sh 0 1 --test
./aoc.sh 0 2
.\aoc.ps1 0 1 -t
```

### Additional resources for learning Dafny
* [Dafny VSCode Extension](https://marketplace.visualstudio.com/items?itemName=dafny-lang.ide-vscode)
* [Dafny Getting Started Guide](https://dafny.org/dafny/OnlineTutorial/guide)
* [Dafny Language Reference](https://dafny.org/dafny/DafnyRef/DafnyRef.html)
* [Dafny Power User Reference](http://leino.science/dafny-power-user/)
* [Dafny Standard Library](https://github.com/dafny-lang/dafny/tree/master/Source/DafnyStandardLibraries)
* [Program Proofs book by Rustan Leino](https://a.co/d/9hNp5yX)
* [Dafny Zulip](https://dafny.zulipchat.com)
* [Berlin Software Verification Discord](https://discord.gg/m5sMHc6G)
* [Dafny Blog](https://dafny.org/blog/)
* [My Dafny Blog](https://dev.to/hath995/dafny-programming-language-and-software-verification-system-2afi)
* [My Dafny Repo with some old verified examples](https://github.com/hath995/dafny)
* [My Dafny Repo with more recent verified examples](https://github.com/hath995/dafny4.4)
* [Dafny Stackoverflow](https://stackoverflow.com/questions/tagged/dafny)

