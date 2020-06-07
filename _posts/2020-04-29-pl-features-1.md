---
title: "An opinionated guide to programming language features - Part 1"
excerpt: "What are some core features to look forward to on a programming language"
header:
  teaser: /assets/images/code.png
categories:
  - blog
tags:
  - Programming Languages
toc: true
toc_icon: "bars"
toc_label: "Contents"
toc_sticky: yes
---

## New programming languages

The number of programming languages grows at a slow, yet somewhat constant rate: the [Wikipedia page on programming language history](https://en.wikipedia.org/wiki/History_of_programming_languages) lists approximately 10 "notable" languages released in each decade since the 50s.
Only a few of these, however, make it to [the top](https://www.tiobe.com/tiobe-index/); and we're not even considering the hundreds of "toy" programming languages which are never used by people other than the ones who made them.

This is understandable.
After all, why should thousands of developers around the world start using some new programming language when the one they are fluent in already has a robust set of tools, works for their daily job and is invariably what they need to use when maintaining some legacy codebase?
The adoption of new programming languages is really slowed down by this inertia.

Sometimes, even people that would really like to use some new language don't do it, because no one they know uses it, there are no answered questions to their problems on Stack Overflow, no online tutorials and not this or that library, etc.
Meanwhile, the people that could be adding useful libraries, answering questions and making online tutorials don't want to waste their time doing so for this new language, as nobody uses it.
This creates a chicken-and-egg sort of problem that can kill the popularity of most new programming languages.

## Why would I care

When someone decides to develop a serious programming language, they are aware it will take tremendous ammount of effort: they must design the language's syntax and semantics, implement an efficient compiler and/or interpreter, create development tools and gather a community around the language.
There must be a good reason to go through all this.

What usually leads a programmer to move from one language to another is their unhapiness with the current state of affairs.
Maybe they quit after trying to find a bug caused by an implicit pointer cast in some C data structure implementation.
They may have got tired of reading Java's excessive class verbosity or Haskell's esoteric functional operators.
Perhaps the headache caused by programming in C++ grew too large after getting an error while using templates.
It could even have been triggered by having to change a bunch of Scheme code because parts of the script depended on functionality that was incompatible between different implementations.

What caused the discomfort doesn't matter, but this programmer is now tempted to change languages to get away from it.
He has two options: 1. finding an already-existing programming language that fullfils his needs or 2. making his own.
Path number 2 was chosen by people like Rich Hickey (Clojure), Jonathan Blow (Jai) and Andrew Kelley (Zig) and even some big software companies such as Google (Go, Dart), Facebook (Hack), Mozilla (Rust) and JetBrains (Kotlin).
Who knows, maybe some day you'll also be on that list.

Since I'm lazy, I would want to be absolutely sure there is no currently-existing (or in-development) language with a certain set of desired features before deciding to make my own.
So I'm going to use this post to list features I would appreciate having (and features I would NOT like to have to deal with) in my programming languages.
I will try to provide examples and some rationale for these decisions, but [this is mostly subjective](https://www.youtube.com/watch?v=mZyvIHYn2zk).

## Core **language** features

Of course I won't be listing basic things like expressions, statements, functions, constants, arithmetic operations... these will be taken for granted.
Below are some other core features I would consider necessary in a modern programming language.

### Sane scoping

Scoping defines the rules for name resolution.

Static scoping (also called lexical scoping) states names should only be refered to in the lexical context (that is, some piece of source code) where they have been defined.
This is the default in most languages.

The other option is dynamic scoping, in which name resolution depends on the execution context (the program's state while it runs).

**example**

```
var x = 1;

fun foo() {
    x = x * x;
    print x;
}

fun bar() {
    var x = 2;
    foo();
}
```

In the example above, `foo` is the key function, because it is using a variable name `x` which is not bound anywhere in its body.
On a language with static scoping, a call to `foo` will always print `1` (supposing the global `var x` isn't changed elsewhere), since the `x` in `foo` will be refering to the global that if ommited would cause an "usage of undefined variable..." error.
This is also called an "early binding" of `x`.

If we had dynamic scoping, `foo` will print something different depending on each situation: if we added the call `foo()` right at the end of this snippet, it would print `1`; if we instead called `bar()`, then it would print `4`; if we had something like `{var x = 3; foo();}` then it would print `9`; if we did `{var x = 4; foo(); foo();}` it would first print `16` and then `256`.
This is because the language is doing a "late binding" of `x`: choosing its value by looking for the nearest (in execution time) definition of that name.

Dynamic scoping makes it dramatically harder for humans and analysis tools (such as a compiler) to reason about code and I have **never** been presented with a reason to prefer it.
Thankfully, most programming languages prefer lexical scoping (exceptions are ***Perl***, ***Emacs Lisp*** and ***Common Lisp***).

### First-Class Parameterization

> A big part of programming is about re-using existing code and making existing code re-usable.

For instance, instead of writing procedures `pow2` and `pow3` to compute the square and cube of a number, it is probably a better idea to write a single `pow` procedure which is *parameterized* on the power one wishes to raise a number by.
This can be done via function arguments, where `pow(x, n)` could raise the value `x` to the n-th power.
Now `pow2(x)` and `pow3(x)` can reuse the code in the more generic function, since they are equivalent to `pow(x, 2)` and `pow(x, 3)`, where this *data-parameterization* of `pow` is possible because `n` is a number that can be passed to the algorithm.

Having first-class functions means that behaviour-things (functions) have the same rights as data-things (numbers, strings, etc), namely to be passed around in the code.
This gives us the capacity to write more generic code that can be easily reused through *parameterization*.
Let us imagine some language that does not have a multiplication operator: we can only add and subtract numbers.
In that case we may like to implement multiplication as a function, and it will look a lot like the `pow` implementation:

**example**

```
fun times(x, n) { // returns x * n
    var y = 0;
    repeat n times {
        y = y + x;
    }
    return y;
}

fun pow(x, n) { // returns x ^ n
    var y = 1;
    repeat n times {
        y = times(y, x);
    }
    return y;
}
```

This is code repetition, so one way to implement it with better reuse would be with a generic `empower` function which is *behaviour-parameterized*.
Since one of the arguments is a function that can be passed in just like any data argument, and the returned value is a function (which happens to be a [closure](https://en.wikipedia.org/wiki/Closure_(computer_programming))) in the same way it could be returning a number, we may now say the language has first-class functions.

```
fun empower(operation, base) {
    return fun (x, n) {
        var y = base;
        repeat n times {
            y = operation(y, x);
        }
        return y;
    }
}

fun add(a, b) { return a + b; }
const var times = empower(add, 0);

const var pow = empower(times, 1);
```

While first-class functions are pretty much mandatory in functional languages because the paradigm makes heavy use of them, they are also supported in most object-oriented languages because objects are first-class citizens and can easily wrap a function inside them.
One language that does not *fully* support this is ***C***: there are function pointers, which can be passed in as arguments but can't be used as closures, they also require strange syntax and are usually used in generic code that casts away type information and is thus considered unsafe; the same holds for macros, which are another way to achieve this idea of *behaviour parameterization*.

### Side-effects

> A computer running programs with no side-effects is an electric ambient heater.

Some programmers like to classify code into "pure" and "non-pure", where the latter means there are no side-effects caused by that code's execution.
Side effects include writing to a file, playing a sound, printing something to the terminal, displaying graphics on a screen and sending data over the web; that is, the effects caused by the program that are actually meaningful to human beings and other real-world systems.

While **hidden, undesirable side-effects** tend to be the cause of most bugs, programmers should be able to produce their **desired effects** without cumbersomeness, as producing side-effects in a controlled fashion and with a specific format is the goal of most real programs.
This means that, even though we usually want purely functional constructs available, we also want to be able to debug programs through `print`s or modify some database without having to wrap all that into ["monoids in the category of endofunctors"](https://blog.merovius.de/2018/01/08/monads-are-just-monoids.html).

The only times I would say a completely pure language is desirable is when it is being used in specific contexts to describe something declaratively while being processed by another program.
For instance, ***HTML & CSS*** (without JavaScript) to define the content of web pages, ***XML*** or ***JSON*** for configuration files, ***Elm*** (again for web pages), the ***Markdown*** that I use to write this blog, etc.

### Metaprogramming

We should be able to talk about the language itself.

Pretty much all ***Lisp*** programmers will tell you the main advantage of it over any other programming language are the metaprogramming capabilities it provides, namely macros.
Macros allow you to write code that writes code, through which it is possible to adapt ***Lisp*** and add to it pretty much any feature you would like to have.
> "If you give someone Fortran, he has Fortran. If you give someone Lisp, he has any language he pleases."

Metaprogramming is a very powerful tool, and even when a language does not have it at first, it may have it bolted onto it later on when people realise how useful it is (eg: [***Java***'s Annotation Processing](https://en.wikipedia.org/wiki/Java_annotation)).
When metaprogramming is *possible but impractical*, the language's "best practices" will discourage it and then some people will avoid it at all costs by saying it is unsafe or unidiomatic.

While user-defined macros are the usual, more general example of metaprogramming, languages may provide other tools, eg:
- Conditional compilation: for instance through ***C***'s `#if`.
- Compile-time testing and assertions: ***Zig*** has `test {...}`, ***C++*** has `static_assert` and `if constexpr`.
- Parameterized code generation: ***C++*** has `template`s, ***Jai*** has `#body_text`, ***Terra*** is a whole language dedicated to this.
- Code introspection: ***Python*** is a good example with its `__special_methods__`. ***Java*** supports this as well.
- Custom static analysis tools: ***Java*** annotations and ***Jai***'s compiler API.
- Toggling language features on and off at different parts of the program: ***Odin*** has `#no_bounds_check` to make some arrays faster.

For more information on this topic, there's a recently published [Survey of Metaprogramming Languages](https://doi.org/10.1145/3354584).
{: .notice}

### Portable data

> No man is an island entire of itself, and most programs aren't as well.

Real programs communicate, either with human beings, with the environment, with other programs that share the same machine, or with programs on the other side of the internet.
This means there are some characteristics we want the data representation in our language to have: 1. able to represent a great variety of things; 2. being serializable and easy to send back and forth and 3. efficiency when applying common transformations.
The problem is that these are all conflicting goals.

Strings make the perfect example of this: in ***C*** they are null-terminated sequence of bytes, which means they are memory efficient and can be arbitrarily big but we can't even ask what their length is without going looping through every character; some languages use the first N bytes in the string as its size, but then you may be stuck with an arbitrary maximum length such as 255; others use Unicode encoding, meaning it supports all characters from every existing language and other important communication means such as 💩 ("pile of poo" emoji, U+1F4A9), but then either wastes a lot of space when storing the more frequently used ASCII digits or makes it very difficult to get to single characters because their size varies from 1 to 4 bytes.

The chosen format needs to support common data types and structures (these could be a hint to the language's built-in types):
- Numbers
- Text
- Bytes (for binary blobs)
- **Maybe**: a "missing content" value such as `null`
- "ordered data" (eg. Sequences)
- "named data" (eg. Dictionaries)
- "unordered data" (eg. Sets)

***JSON*** and ***XML*** seem like good references as they are well structured and widely accepted; ***EDN*** may be a nice alternative that's as lightweight as ***JSON*** and as feature-complete as ***XML***.
It would also be nice if there were some directives in the language to allow programmers to query and change the representation of these common data types (or, equivalently, to have different built-in types for the different representations).

**PS:** since I'm talking about text, I'll just point it out here that multiline strings are nice to have.

### Concurrency awareness

It has been stated time after time that computing systems have evolved past the single-threaded mentality and that programming languages should keep up with the technological advances by providing mechanisms to deal with concurrency.
From operating systems to web pages: asynchronous events and high performance should be taken into consideration.

When general-purpose programming languages don't provide support for concurrency, these mechanisms are strapped to the language through external libraries and/or by interfacing with other languages.
These solutions are never as efficient or user-friendly as they would have been with proper support from the language's semantics and built-in tools, so most modern languages strive for concurrent support from the get-go.
One must be careful, however, to avoid creating usability issues in the language when mixing non-concurrent with concurrent code (eg. not to [color their functions](http://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)).

***Go***, ***Lua*** and ***Java*** are examples with nice built-in concurrency mechanisms.

## Core **tools** and **implementation**

I have been listing features which would need to be built into a language's "ideology" and semantics.
There's another aspect of programming languages that is just as important and can mean the difference between it reaching public acceptance or not: the quality of its documentation, tools and implementations.

### Friendly documentation

Official documentation of the language's standard functions, unique syntax and special features should be easy to look up online and offline.
It should include intuitive examples for begginers and perhaps links to more advanced content for veterans.

Having a standardised way to document code is also nice, since people can build documentation generators (maybe it could even be packaged together with the main compiler/interpreter), issue trackers and other such tools.
Languages that I know that do this nicely are ***Java***, ***Python***, ***Haskell*** and ***Racket***, but there are probably others.

### Intuitive debugging

Debugging should be quick and intuitive, as that will be the activity some programmers will be spending most of their time on.
It's probably not a good idea to rely too much on IDEs for this, as some people (like me) don't like using them.

The first aspect of debugging is actually reading any error messages emitted by the code analysis tools: they should be concise and clear about what the error is and where it's located.
***C++***'s templates are famous for causing compiler errors with hundreds of useless lines.

### Easy packaging

I see software packaging as having two aspects: 1. the packaging of libraries to other programmers and 2. the distribution of executable files to end users.
Ideally, both of these would be as easy as typing a single command into the terminal, but that's far from reality for most languages.

***Python*** has `pip`, ***Java*** has maven and gradle, ***Ruby*** has gems, ***Scheme*** has `akku` (also Snow and some others), ***Common Lisp*** has quicklisp, ***Racket*** has `raco`, ***Lua*** has `luarocks`, ***C*** & ***C++*** have... headers and object files.
Each one of those methods has its pros & cons, but most of them require a bunch of build configuration files (which need to be written in an entirely new language), and some external tool that may have portability issues among different operating systems; or are a pain to set up and maintain without an IDE.
My bet would be on having a standard, built-in way to develop, package, distribute, find and download libraries.

Something I have recently used that has really pleased me was ***Lua***'s LÖVE framework which can build standalone executables as easily as

```shell
$ cat Love_Windows.exe ProjectSource.zip > Executable.exe
```

Another aspect of executable distribution that I would like to see addressed in programming languages is native support for making both command line tools and graphical applications.
***Racket*** does this pretty nicely with command argument parsing and a graphic toolkit built into the standard library, ***Java*** is another example with SWT, Swing and JavaFX.

### Development tools

I believe a language shouldn't be oblivious to the most common practices adopted by software developers.
This means documentation generators, test runners, debuggers and interactive development tools such as REPLs and hot-reloading should be considered by implementations (some of these aspects could even be standardised in the language itself).

### Performance optimizations

Evidently, users of a programming language will want their implementation to be as performatic as possible while maintaining the semantics of their programs.
This means that mechanisms in the language should have at least *some* guarantees of optimization.
An example of this is ***Scheme***, which requires implementations to be properly tail recursive and thus allows users to write tail-calls without the need to worry about stack overflows; meanwhile in ***C*** or ***C++*** there is no portable way to make sure small functions are inlined and that causes people to write macros, which can be problematic in those languages.

Another aspect to think about is how hard it is to make existing programs faster.
Ideally, performant code would not look too much different from what is "idiomatic" code in the language.
I believe ***Jai*** has some nice features regarding this aspect with Array of Structs (AoS) to Struct of Arrays (SoA) transformations that pretty much maintain syntax and directives to command inlining / non-inlining of procedures at each call site.
***C++*** has move semantics and RVO.
Other examples are ***Octave*** and ***Julia***, in which most functions will work exactly the same for single numbers or vectors, and optimize accordingly.

Some optimizations I'd say should be common (if not enforced by the high-level language's semantics) are:
- Dead code elimination
- Common subexpression elimination
- Constant propagation
- Procedure inlining
- Loop invariant extraction
- Caching of "pure" results
- Tail-call optimization
- Loop fusing (as in [***Julia***'s dot call expressions](https://docs.julialang.org/en/v1/manual/mathematical-operations/#man-dot-operators-1))

### Extensibility

A programming language, specially a new one, shouldn't ignore the existence of other languages and the fact that, when it's released, every single line of existing code will have been written in those.
In practice, this means we want **Foreign-Function Interfaces** (FFIs) to be able to reuse existing codebases, exporting their APIs with perhaps better adaptation to the new language.
This extensibility property also allows high-level, dynamically typed, interpreted languages to reach performance levels comparable to those of statically typed, compiled languages in specific applications.
One such example is ***Python*** with high performance numeric libraries such as NumPy, that call into ***C*** or ***C++*** code; another is ***Zig*** which claims full ABI compatiblity with ***C*** libraries; and ***Julia***, that plays well with both ***C*** and ***Python***.

Unfortunately, mandating compatibility with other languages can 1. limit portabillity and/or 2. import issues that wouldn't exist in the language otherwise.
Suppose the language specifies it should be able to utilize routines from ***Java*** (like in ***Clojure***), then, there will be some specific cases where the JVM is unavailable (or incomplete due to some missing set of features) and using the full spec of the language becomes impossible.

Another aspect that could be taken into consideration is the ability to embed the new language in existing applications, as is proposed by ***Lua***, ***Squirrel***, ***Python***, ***Tcl*** and some ***Lisp***s.
I definitely don't consider this feature as important as extensibility ([there is only one correct decision](https://twistedmatrix.com/users/glyph/rant/extendit.html)), but scripting languages will normally want this capability as well.

## What else

All features listed here have to do with programming language semantics, standard library, tools and implementation; syntactic aspects weren't considered and will be left to a second part of this (extensive) rant.

At some point I may try to assemble a table of which languages have which features, with the intention on comparing them and helping other people choose what's best for them, be it either an existing language or what set of characteristics they'll want their new language to have.

I would also like to know what languages people think have all the mentioned features, as well as which others they can say that definitely don't accomplish them.
