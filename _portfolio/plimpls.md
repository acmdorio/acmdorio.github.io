---
title: "My private PL Zoo"
excerpt: "Showcase of compilers and interpreters that implement toy Programming Languages"
header:
  teaser: /assets/images/basic.png
tags:
  - Programming Languages
toc: true
toc_icon: "bars"
toc_label: "Contents"
toc_sticky: yes
---

After reading [The Wizard Book](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html) and going through [The SICP lectures](https://www.youtube.com/playlist?list=PLE18841CABEA24090), I found myself deeply interested in PL design and implementation.
That naturally led me to further reading on the subject, as well as to the development of compilers and interpreters for toy programming languages.

With those projects, I got to learn about and implement:
- Compilers for stack-based and register-based target architectures.
- Interpreters for dynamically-typed languages.
- Garbage collection algorithms.
- Virtual Tables for OOP inheritance and dynamic dispatch.
- Static typechecking.
- Hand-written and tool-generated parsers.
- First-class functions, closures and their low-level implementation.
- Optimizations such as tail-call elimination, string interning and constant folding.
- Different evaluation strategies (nondeterminism, lazyness).
- Pattern-matching and unification.


Yet another Scheme Metacircular Evaluator
------

This is where the magic began: a Scheme interpreter written in Scheme following [Chapter 4 of The Wizard Book](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-25.html#%_chap_4).
Differently than what most people do, however, I kept extending the first evaluator with the variations that followed in the next sections (instead of building them upon a minimal, scratch version).

[The result](https://gitlab.com/baioc/paradigms/-/blob/master/Scheme/sicp/lisp.scm) turned up as a macro-less R5RS(-ish) implementation that separates syntactic analysis from the actual interpreter execution and additionally provides built-in `amb` and `try-catch` special forms for nondeterministic computing, as well as a `retry` command in the REPL that backtracks to the most recent nondeterministic fork and tries a different path.

| ![](/assets/images/scheme.png) |
|:--:|
| *Using the nondeterministic Scheme evaluator to solve the SEND+MORE=MONEY puzzle (source not shown).* |

<!--scheme
(define (require pred)
  (if (not pred) (amb)))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (send+more=money)
  (let ((d (amb 0 1 2 3 4 5 6 7 8 9))
        (e (amb 0 1 2 3 4 5 6 7 8 9))
        (m (amb 0 1 2 3 4 5 6 7 8 9))
        (n (amb 0 1 2 3 4 5 6 7 8 9))
        (o (amb 0 1 2 3 4 5 6 7 8 9))
        (r (amb 0 1 2 3 4 5 6 7 8 9))
        (s (amb 0 1 2 3 4 5 6 7 8 9))
        (y (amb 0 1 2 3 4 5 6 7 8 9)))
    (require (distinct? (list d e m n o r s y)))
    (require (not (= s 0)))
    (require (not (= m 0)))
    (let ((send  (+             (* 1000 s) (* 100 e) (* 10 n) (* 1 d)))
          (more  (+             (* 1000 m) (* 100 o) (* 10 r) (* 1 e)))
          (money (+ (* 10000 m) (* 1000 o) (* 100 n) (* 10 e) (* 1 y))))
      (require (= (+ send more) money))
      (list (cons 'd d)
            (cons 'e e)
            (cons 'm m)
            (cons 'n n)
            (cons 'o o)
            (cons 'r r)
            (cons 's s)
            (cons 'y y)))))
-->


Bytecode compiler and VM for Lox
------

[This](https://github.com/baioc/clox) was my implementation of Robert Nystrom's [Crafting Interpreters](https://www.craftinginterpreters.com/) single-pass compiler and bytecode virtual machine for the Lox programming language, coming from what is probably the best (also free) beginner-friendly resource (definitely much better than [The Dragon Book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools)) for learning about how programming languages are implemented.
Most of it is written in standard C99, making use of features such as Flexible Array Members (FAMs), designated struct initializers and Variable-Length Arrays (VLAs, just once).

Notably, Lox is an efficient, dynamically-typed, object-oriented, garbage-collected scripting language with some runtime introspection and support for closures and first-class functions.
The implemented clox version uses a hand-written recursive descent parser (a.k.a. Pratt parser) and compiles down to bytecode targetting a stack-based VM that encompasses a Mark & Sweep GC and includes many useful optimizations such as string interning, NaN boxing and computed `goto`s for efficient instruction dispatch (requires [GCC's labels-as-values extension](https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html)).


A minimal BASIC simulator
------

Wanting to improve my french before going abroad on an exchange program, I decided to acquire some programming-related vocabulary by skimming through the original, untranslated version of [Developing Applications With Objective Caml (DAWOC)](http://caml.inria.fr/pub/docs/oreilly-book/) while learning F# instead of OCaml.
One example application in Chapter 6 caught my attention: it was a very minimal BASIC interpreter which I extended by implementing system directives (using as reference whatever I could find online about the old Microsoft BASIC) and by adding support for subroutines.
The [entire simulator](https://gitlab.com/baioc/paradigms/-/tree/master/F%23/basic) is quite short given that BASIC is a very ~~basic~~ simple non-structured imperative language with dynamic types and no notion of scopes or even functions.
In fact, a considerable part of its development time was dedicated to the hand-written shift-reduce parser, which was much harder to grasp than the top-down parsers I had coded until then.

| ![](/assets/images/basic.png) |
|:--:|
| *Fizz buzz in BASIC. Hopefully the last thing I'll ever program in this language.* |


Deca - A compiled subset of Java
------

I've been told all Ensimag students have at least one project in common: the *Projet Génie Logiciel* (french for "Software Engineering Project").
In this project, students have to work in groups of five to develop, in less than a month and using Agile practices, a full-blown compiler for Deca: a statically-typed, object-oriented language that resembles a subset of Java and is further specified in a 231-page long document that is given to students in the beginning of the project.
It compiles down to a register-based architecture -- inspired by the [68000](https://en.wikipedia.org/wiki/Motorola_68000) -- that is used in Ensimag's closed-source abstract machine.

The compiler uses [ANTLR](https://www.antlr.org/) to generate a lexer and a parser from a description of the accepted tokens and grammar.
Those are employed to build the AST that is then processed during the multiple verification and code generation passes that follow.
Unfortunately, the project needed to be coded in Java and the initial skeleton used an Interpreter pattern for everything, meaning we had to deal with a ton of trivial files and the usual OOP inheritance abuse (worsened by the fact that the original codebase programmers had apparently never heard of interfaces, only abstract classes).
In the end though, I was happy with the test suite we set up -- allowing expected output to be written with regular expressions inside comments in the Deca test sources -- and the fact that we got to implement virtual method tables and some basic constant folding optimization.

We also had the opportunity to extend the base language with anonymous functions, closures and functional object interfaces.
In doing so, I finally scratched the itch to design something better than what Java has for functional types (how it forces users/libraries to define a different interface for every possible function arity, plus specific interfaces for primitive types), using something that looks like `Lambda<ArgTypes*,ReturnType>`.

| ![](/assets/images/deca.png) |
|:--:|
| *Lazy (even) Streams library in Deca-λ (Deca + our functional extension), side by side with the generated assembly code.* |


Honorable Mentions
------

### Logic programming in lisp

Another one from the venerable Wizard Book: a (lispy) [logic programming language interpreter](https://gitlab.com/baioc/paradigms/-/blob/master/Scheme/sicp/prolisp.scm) with built-in pattern-matching and unification.

### Automatum-compiling macros

[Here](https://gitlab.com/baioc/paradigms/-/blob/master/Scheme/misc/automata.scm) I simply implement the interpreter and the macro-time compiler for the FSM DSL as presented in Shriram Krishnamurthi's excelent [macro tutorial](https://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/).

### Assembling Forth

In order to test [my custom CPU](https://baioc.github.io/portfolio/s4pu/), I wrote a [simple assembler script](https://gitlab.com/baioc/s4pu/-/tree/master/forth) in Python to translate a Forth-like assembly language into executable machine code.

### Java-embedded Scheme

On [another project](https://github.com/baioc/ArchwizardDuel), I added a tree-walking interpreter to a distributed Java application in order to use Scheme as an embedded scripting language.
