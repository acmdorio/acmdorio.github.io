---
title: "pygraphs"
excerpt: "A Python package for the study of graph discrete data structures and algorithms"
header:
  teaser: /assets/images/code.png
---

`pygraphs` is a Python package dedicated to the study of [graphs](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics)) as discrete data structures and graph algorithms.

Source code is available on [GitLab](https://gitlab.com/baioc/pygraphs), together with simple makefiles.
{: .notice--info}


Features
----

- Efficient data structures written in modern C++ 17 and wrapped into Python using [Swig](http://www.swig.org/)
  - Directed and undirected Graphs
  - Priority Queue using Binary Heap
- Classic algorithms are implemented in Python 3 with type annotations
  - Breadth-First and Depth-First iteration with generators
  - Finding Eulerian cycles through Hierholzer's algorithm
  - Computing the minimum Hamiltonian circuit using Held-Karp's method
  - Shortest paths with Bellman-Ford, Dijkstra and Floyd-Warshall algorithms
  - Minimum spanning trees through Prim
  - Topological sorting and finding strongly connected components using variants of DFS
  - Computing maximum network flow with an Edmonds-Karp implementation of the Ford-Fulkerson Algorithm
  - Maximum cardinality matching of bipartite graphs via Hopcroft-Karp-Karzanov


Usage
----

**Note:** at this point, distributed packages are compatible with **Linux only** and require a recent version of `libstdc++`.
{: .notice}

1. Install via [pip](https://test.pypi.org/project/pygraphs/){: .btn .btn--info}:

    ```bash
    pip install -i https://test.pypi.org/simple/ pygraphs --user
    ```

2. Import the package:

    ```python
    import pygraphs as pyg
    ```
