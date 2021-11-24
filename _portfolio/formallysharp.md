---
title: "Formally#"
excerpt: "An online tool for formal language (syntax) design"
last_modified_at: 2021-11-24
header:
  teaser: https://user-images.githubusercontent.com/27034173/129140042-eeba5460-0aa3-4b1c-9a58-8b948beccafe.png
tags:
  - algorithms
  - Programming Languages
---

[Formally#](https://github.com/baioc/FormallySharp) is an online formal language designer.<br>
**You can check it out at [formallysharp.azurewebsites.net](https://formallysharp.azurewebsites.net/)**


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
* Automatic generation of random syntactically correct strings, which could be useful for testing purposes
* Enforce referential integrity across rules in the UI
* Visualize lexer FSMs and syntax diagrams


Screenshots
----

![tablet_blue_theme](https://user-images.githubusercontent.com/27034173/143199891-f7999ce6-454b-4a91-b54b-f6cd1ea2be47.png)

![poly](https://user-images.githubusercontent.com/27034173/129140042-eeba5460-0aa3-4b1c-9a58-8b948beccafe.png)

![calc](https://user-images.githubusercontent.com/27034173/133954409-d50c6a9b-7f58-48c5-a507-dcabaeba5b95.png)

![first_first](https://user-images.githubusercontent.com/27034173/133955408-82eb1c73-5ec2-434a-a313-643ea4a94ec4.png)

![first_follow](https://user-images.githubusercontent.com/27034173/133955412-432359d7-0968-4ca4-860a-a2ebb85310f8.png)
