---
title: "UGLy - An Unsafe Generic LibrarY"
excerpt: "A C11 library with generic data structures, custom allocators and more"
header:
  teaser: /assets/images/code.png
tags:
  - Generic Programming
---

UGLy is a C(11) library used to apply the DRY principle and avoid re-implementing the same common data structures, procedures and macros everywhere.

It is Open-Sourced on [GitLab](https://gitlab.com/baioc/UGLy).
{: .notice--info}


Unsafe?
------

It uses "unsafe" generics (`void *`) in the sense that all data types are seen as a sequence of bytes and the user is responsible for making sure they are properly interpreted (and memory aligned).
It should be noted that the library's containers always use copy semantics and never "take ownership" of given elements, meaning the user is still expected to manage the lifetimes of dynamically allocated objects ("you allocate it, you free it").

The suggested use of UGLy would be as internal implementation for libraries which wrap it in a more "type-and-memory safe" API.


Features
------

### Common data structures

Currently implemented generic data structures:
- `list_t`: dynamically sized sequence of fixed-size elements which are contiguously allocated and indexed in O(1) time. Insertions and remotions have amortized O(1) complexity when done at the end of the list and O(n) otherwise.
- `map_t`: dynamically sized mapping between fixed-size keys and values. All operations have an amortized average constant complexity when using a proper hashing function.
- `stack_t`: dynamic LIFO structure for fixed-size elements. All operations have O(1) complexity (amortized in the case of insertions and deletions).

### Custom memory allocator support

Whenever memory allocations are needed, the user can choose to provide his own custom allocator or use one of the generic built-in ones (most of which allocate on a user-provided buffer):
- `STDLIB_ALLOCATOR`: simply calls `malloc`, `realloc` and `free` from stdlib.
- `pool_allocator_t`: fixed maximum allocation size, zero overhead and no external fragmentation while supporting deallocations in any order.
- `stack_allocator_t`: variable allocation size, can free and do in-place reallocations but only in Last-In-First-Out fashion.
- `arena_allocator_t`: variable allocation size, almost no memory overhead, never frees.

### Descriptive type definitions

Instead of using primitives for everything, UGLy defines some core types which should elucidate their intended semantics in procedure signatures.

### Useful macros

We also include some macros which tend to be needed every now and then when programming in C.
