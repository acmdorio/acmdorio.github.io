---
title: "Matemática Funcional em Scheme"
excerpt: "Minicurso ministrado durante a SECCOM 2019"
header:
  teaser: /assets/images/wizard.png
---

Tive a experiência de ministrar um minicurso na [SECCOM](https://seccom-ufsc.github.io/) - a Semana Acadêmica de Ciência da Computação e Sistemas de Informação da UFSC - sobre programação matemática funcional na linguagem Scheme.

Todo o conteúdo está disponível online na [webpage oficial](https://baioc.github.io/scheme) e também no [GitHub](https://github.com/baioc/seccom-scheme).
{: .notice--info}


Resumo
----

Scheme é um dos principais "dialetos" de [Lisp](https://en.wikipedia.org/wiki/Lisp_programming_language), que adere ao paradigma funcional e é a **segunda linguagem de programação mais antiga ainda amplamente utilizada**.
Devido à sua flexibilidade e simplicidade, Scheme é usada para extender o comportamento de outros softwares e foi adotada como [a linguagem de scripting oficial do GNU Project](https://www.gnu.org/software/guile/).


Conteúdo
----

O oficina abordou algumas **técnicas de programação funcional** em Scheme para algoritmos matemáticos e métodos numéricos, incluindo:

- Tipos de recursão
  - ***Tail Call Optimization***
- Abstração com funções de alta ordem e *closures*
  - **Algoritmo de Exponenciação Rápida (*Successive Squaring*)**
  - **Método de Newton e outros Pontos Fixos**
- Processamento simbólico e metalinguagem
  - **Diferenciação Analítica de Polinômios**
- Paradigma de fluxo de dados: *streams* e *lazy evaluation*
  - **Séries infinitas e *Memoization***


Bibliografia
----

- [**Structure and Interpretation of Computer Programs <br/> (SICP, a.k.a. "The Wizard Book")** <br/> - Abelson H., Sussman G. J.](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html)
- [**MIT OpenCourseWare 6.001 SICP lectures** <br/> - Abelson H., Sussman G. J.](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/)
- [**The Scheme Programming Language** <br/> - Dybvig R. K.](https://www.scheme.com/tspl4/)
- [**Teach Yourself Scheme in Fixnum Days** <br/> - Sitaram D.](https://ds26gte.github.io/tyscheme/)
