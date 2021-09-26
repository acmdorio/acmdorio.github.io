---
title: "Formally#"
excerpt: "An online tool for formal language (syntax) design"
last_modified_at: 2021-10-20
header:
  teaser: https://user-images.githubusercontent.com/27034173/129140042-eeba5460-0aa3-4b1c-9a58-8b948beccafe.png
tags:
  - algorithms
  - Programming Languages
---

[Formally#](https://github.com/baioc/FormallySharp) is an online formal language designer.<br>
**You can check it out at [www.formallysharp.codes](http://www.formallysharp.codes)**


Features
----

This is a full-stack functional-style web application built using F# and the [SAFE Stack](https://safe-stack.github.io/docs/overview/).
Source code is available on [GitHub](https://github.com/baioc/FormallySharp).

Notable features include:
* Full separation between lexical and syntactical definitions
* Conversion of regular expressions to DFAs
* Compilation of LL(1) grammars to table-based parsers
* Automatic detection of LL(1) conflicts
* Test acceptance of input strings on the fly
* Project persistency across (unauthenticated) sessions

To-do list:
* Translate the UI from portuguese to english
* Implement a better regex parser, as the current one is very non-standard and doesn't have escape characters
* Improve on-the-fly parsing perfomance
* Automatic generation of random syntactically correct strings, which could be useful for testing purposes
* Enforce referential integrity across rules in the UI
* Visualize lexer FSMs and syntax diagrams


Screenshots
----

![poly](https://user-images.githubusercontent.com/27034173/129140042-eeba5460-0aa3-4b1c-9a58-8b948beccafe.png)

![calc](https://user-images.githubusercontent.com/27034173/133954409-d50c6a9b-7f58-48c5-a507-dcabaeba5b95.png)

![lexer](https://user-images.githubusercontent.com/42824191/129277689-ab361e8a-a31b-4e9a-8e8b-0c57c34bc8bd.png)

![first_first](https://user-images.githubusercontent.com/27034173/133955408-82eb1c73-5ec2-434a-a313-643ea4a94ec4.png)

![first_follow](https://user-images.githubusercontent.com/27034173/133955412-432359d7-0968-4ca4-860a-a2ebb85310f8.png)
