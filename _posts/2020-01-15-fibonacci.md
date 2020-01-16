---
title: "Fibonacci numbers: from zero to hero"
excerpt: "Includes recipes easy enough for beginners to follow and spicy enough to please veterans"
categories:
  - blog
tags:
  - algorithms
---

Fibonacci numbers appear unexpectedly often in Mathematics and in Computer Science.
They are related to the [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio) and just like the magical number, have a very extensive [Wikipedia entry](https://en.wikipedia.org/wiki/Fibonacci_number).
The Fibonacci sequence is defined by a [recurrence relation](https://en.wikipedia.org/wiki/Recurrence_relation) and is used as a canonical example of recursion in introductory programming and/or discrete math courses for computer science.
This means that pretty much every programmer has implemented an algorithm to find Fibonacci numbers.
Here we explore some possible approaches.

For a TLDR, jump to the bottom of the page.
{: .notice--info}


A golden sequence
-----

The Fibonacci numbers can be defined as

$$F_0 = 0, F_1 = 1$$ and

$$F_n = F_{n-1} + F_{n-2}$$ for $$n > 1$$

Most programmers think of a function when reading the previous definition, where the subscript number is its single argument.
Others see it as some data structure being indexed; this idea will be useful later.
The naive approach then translates math directly into some programming language, for instance C.

```c
int fib(int n)
{
	if (n == 0) return 0;
	else if (n == 1) return 1;
	else return fib(n - 1) + fib(n - 2);
}
```

That definition has some obvious practical issues.
For any negative input, the procedure launches into an infinite loop and eventually crashes the program.
Secondly, it is extremely inefficient: on my machine it takes around 15 seconds to compute and print `fib(47)` (gcc 9.2.0 with `-O3`).
At last, we will quickly run into [undefined behaviour as we overflow](https://wiki.sei.cmu.edu/confluence/display/c/INT32-C.+Ensure+that+operations+on+signed+integers+do+not+result+in+overflow) through the limits of our signed integer representation.
In fact, with 32-bit signed ints we can only correctly calculate the sequence for values of `n` from zero to 46.
That limit goes up to 93 when using longer 64-bit numbers and making them `unsigned` allows us to find a single extra number of the sequence.

There are two easy ways to remove the danger of an infinite loop: we can assert against negative values and crash the program (or throw an exception) intentionally or we can change the conditional to avoid the loop and return a technically incorrect result.
Another option is to extend the sequence for negative integers, this shall be done latter on.
We also solve the numeric representation issue by using a programming language which supports arbitrary-precision arithmetic (aka [bignums](https://en.wikipedia.org/wiki/Arbitrary-precision_arithmetic)) by default, so let's `goto` Python.

```python
def fib(n):
    if n <= 1:
        return n;
    else:
        return fib(n - 1) + fib(n - 2)
```

While we could theoretically compute bigger Fibonacci numbers now, it would take ages to do so using this implementation.
While Python made the performance worse by a factor of ~50x in relation to C, the problem is the underlying algorithm being used.
By substituting each call to `fib` by the subsequent multiple-recursive calls it generates, we find out that there is lots of redundant computation being done.

```python
                         fib(4)
             fib(3)        +        fib(2)
     fib(2)     +  fib(1)       fib(1) + fib(0)
fib(1) + fib(0)
```

Notice that an invocation of `fib(n)` reaches the base cases (`fib(0)` and `fib(1)`) $$F_{n+1}$$ times.
In fact, let $$C_n$$ be the number of calls executed when computing `fib(n)`, then for all $$n > 1$$

$$C_n = 1 + C_{n-1} + C_{n-2}$$

Meanwhile, for the base cases we have

$$
C_0 + 1 = 2 = 2 F_1\\
C_1 + 1 = 2 = 2 F_2
$$

So we can try to conjecture that

$$
C_n + 1 = 2 F_{n+1}
$$

Supposing that holds for $$C_{n-1}$$ and $$C_{n-2}$$ the proof goes as follows:

$$
C_n = 1 + C_{n-1} + C_{n-2}\\
C_n + 1 = (C_{n-1} + 1) + (C_{n-2} + 1)\\
C_n + 1 = 2 F_n + 2 F_{n-1}\\
C_n + 1 = 2 (F_n + F_{n-1})\\
C_n + 1 = 2 F_{n+1}\\
$$

Thus we have proved that for all $$n \ge 0$$

$$
C_n = 2 F_{n+1} - 1
$$

With this we have proved that the naive implementation presented earlier has exponential time complexity (the Fibonacci sequence grows exponentially), more specifically $$\Theta(\phi^{n})$$, where $$\phi$$ is the golden ratio.
The previous theorem is also the sole reason this binary-recursive procedure is useful in [benchmarks](https://github.com/drujensen/fib), as we may easily calculate the exact number of function calls performed and find the average invocation time.


Going down the rabbit hole
-----

Looking back upon the recurrence relation $$F_k = F_{k-1} + F_{k-2}$$ one may intuitively deduce that it should be possible to compute $$F_{k+n}$$ in linear time if values of $$F_{k+n-1}$$ and $$F_{k+n-2}$$ are known.
For instance when $$n=0$$ only a single addition is needed; for $$n=1$$ we need two: the first to compute $$F_{k}$$ and another to find $$F_{k+1}$$; and so son.
The most common "efficient" procedure to compute Fibonacci numbers leverages this notion in order to reach $$\Theta(n)$$ time complexity and looks something like this:

```python
def fib(n):
    previous = 1
    current = 0
    for _ in range(n):
        previous, current = current, previous + current
    return current
```

A Python program that simply prints the result of `fib(47)` now takes about 0.04 seconds to complete on my machine (CPython v3.8.1).
In fact, that time is mostly the Python environment starting up and it is approximately the same when computing the 10,000th Fibonacci number.
We can even turn this function into a [generator](https://wiki.python.org/moin/Generators) so as to compute Fibonacci numbers on demand as we iterate through them.

```python
def fibs(n):
    previous = 1
    current = 0
    for _ in range(n):
        yield current
        previous, current = current, previous + current

# printing the first 100 numbers of the sequence
for n, fn in enumerate(fibs(100)):
    print("fib(%d) = %d" % (n, fn))
```

Although the loop-based version is definitely more efficient than the previous one, its implementation is not as obvious and does not resemble the sequence's mathematical definition.
Perhaps we can improve this by sending `previous` and `current` as additional arguments to a recursive procedure:

```python
def fib(n, previous = 1, current = 0):
    if n <= 0:
        return current
    else:
        return fib(n - 1, current, previous + current)
```

While performance remains mostly the same and the procedure is a tad more versatile (by setting `previous` and `current` to another pair of consecutive Fibonacci numbers we can now compute the sequence from any starting point, as if with a different "seed"), calling this new routine with somewhat bigger values of `n` yields a crash with the message `RecursionError: maximum recursion depth exceeded ...`.

This happens because Python does not optimize [tail calls](https://en.wikipedia.org/wiki/Tail_call), so each iteration takes some space in the call stack, eventually reaching its limit.
In fact, our procedure now has a space complexity of $$\Theta(n)$$ while the loop version was just $$\Theta(1)$$.
Most functional languages support proper tail recursion, but before we go there let's see how C++ fares in this case (since C doesn't have default argument values without [macros](https://modelingwithdata.org/arch/00000022.htm)).

```c++
constexpr int fib(int n, int prev = 1, int curr = 0)
{
	if (n <= 0)
		return curr;
	else [[likely]]
		return fib(n - 1, curr, prev + curr);
}
```

Modern compilers are able to recognize this pattern and perform Tail Call Optimization (TCO), so the procedure above is made equivalent to the constant-space `for` loop implementation.
Making the function `constexpr` also signals to the compiler that it should try to optimize calls for values known at compile time.
For instance, a `main` function that simply returns `fib(40)` gets compiled into

```asm
main:
        mov     eax, 102334155
        ret
```

Since we wish for proper tail recursion as well as infinite-precision arithmetic, I choose Scheme as our next programming language.
In the example below, `iterate` is a tail-recursive function defined inside the body of `fib` that performs the computation in constant space and linear time.

```scheme
(define (fib n)
  (let iterate ((n n) (previous 1) (current 0))
    (if (<= n 0) current
        (iterate (- n 1) current (+ previous current)))))
```


FFT: the Fast Fibonacci Transform
-----

One may realize that each call to `iterate` is basically a transformation applied to the last two parameters while `n` is simply a countdown controling how many times this is repeated.
This can be represented as follows:

$$
T(c, p) = (c + p, c)
$$

If $$p$$ and $$c$$ are consecutive Fibonacci numbers, we can say that

$$
T(F_k, F_{k-1}) = (F_k + F_{k-1}, F_k) = (F_{k+1}, F_k)
$$

and thus

$$T^n(F_k, F_{k-1}) = (F_{k+n}, F_{k+n-1})$$

$$T$$ happens to be a [linear transformation](https://en.wikipedia.org/wiki/Linear_map) (proving that property is left as an exercise to the reader).
Its transformation matrix, sometimes called the Fibonacci matrix, is easily found:

$$
A \begin{bmatrix}c \\ p\end{bmatrix} = \begin{bmatrix}c + p \\ c\end{bmatrix}\\
A = \begin{bmatrix}A \begin{bmatrix}1\\0\end{bmatrix} & A\begin{bmatrix}0\\1\end{bmatrix}\end{bmatrix}\\
A = \begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}
$$

After that, we can accomplish transformation composition through matrix multiplication, in other words:

$$
A^n \begin{bmatrix}0 \\ 1\end{bmatrix} = \begin{bmatrix}F_n \\ F_{n-1}\end{bmatrix}
$$

At this point we have found a method to compute Fibonacci numbers through matrix exponentiation, and since the latter can be achieved -- through a [Successive Squaring](https://en.wikipedia.org/wiki/Exponentiation_by_squaring) algorithm -- in $$\Theta(\log_2 n)$$ time, so can the former.
The Octave code below does exactly that.

```octave
function F_n = fib(n)

	A = [1, 1;
	     1, 0];

	x = [0;
	     1];

	y = A^n * x;

	F_n = y(1);

endfunction
```

If you are into linear algebra, you may remember that there is a special basis in which a linear transformation can be represented as a diagonal matrix.
This makes it a little bit easier to perform matrix exponentiation: simply raise each diagonal element to the desired power and then go back to the canonical basis to find the end result.
Using all this [eigen-stuff](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors) leads us to Binet's formula, the closed-form solution for Fibonacci numbers:

$$
F_n = {(\phi^n - \psi^n) \over (\phi - \psi)} = {(\phi^n - \psi^n) \over \sqrt{5}}
$$

where $$\phi$$ is the golden ratio and $$\psi$$ its complement (these are the eigenvalues for the Fibonacci transform).

So theoretically we could use that in our implementation:

```python
from math import sqrt

PHI = (1 + sqrt(5)) / 2  # golden ratio number
PSI = 1 - PHI            # and its complement

def fib(n):
    return round((PHI**n - PSI**n) / sqrt(5))
```

However, for big values of `n` we still get an `OverflowError: (..., 'Numerical result out of range')`; in some languages instead of throwing an exception the program would return its representation of infinity.
This happens because now we're dealing with floating-point numbers, which are not big enough for our desired range of values.

Going back to the Fibonacci matrix, we can assume that for some $$k$$ (notice that it is true when $$k=1$$)

$$
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^k = \begin{bmatrix}F_{k+1} & F_k\\ F_k & F_{k-1}\end{bmatrix}
$$

then

$$
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^k \begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix} = \begin{bmatrix}F_{k+1} & F_k\\ F_k & F_{k-1}\end{bmatrix} \begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}\\
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^{k+1} = \begin{bmatrix}F_{k+1} + F_k & F_k + F_{k-1}\\ F_{k+1} & F_k\end{bmatrix}\\
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^{k+1} = \begin{bmatrix}F_{k+2} & F_{k+1}\\ F_{k+1} & F_k\end{bmatrix}
$$

this means for all $$n \ge 1$$

$$
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^n = \begin{bmatrix}F_{n+1} & F_n\\ F_n & F_{n-1}\end{bmatrix}
$$

At this point, we can square both sides:

$$
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^n \begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^n = \begin{bmatrix}F_{n+1} & F_n\\ F_n & F_{n-1}\end{bmatrix} \begin{bmatrix}F_{n+1} & F_n\\ F_n & F_{n-1}\end{bmatrix}\\
\begin{bmatrix}1 & 1\\ 1 & 0\end{bmatrix}^{2n} = \begin{bmatrix}F_{n+1}^{2} + F_n^2 & F_n (F_{n+1} + F_{n-1})\\ F_n (F_{n+1} + F_{n-1}) & F_n^2 + F_{n-1}^{2}\end{bmatrix}
$$

And since the general rule still applies, we have

$$
F_{2n} = F_n (F_{n+1} + F_{n-1}) = F_n (F_{n+1} + F_{n+1} - F_n) = F_n (2F_{n+1} - F_n)\\
F_{2n+1} = F_{n+1}^{2} + F_n^2
$$

This means we can compute Fibonacci numbers through a successive squaring method, thus achieving $$\Theta(\log_2 n)$$ bigint arithmetic operations.
Evidently, this method has the same asymptotic time complexity as exponentating the Fibonacci matrix, but it may save a few operations.
The fast recursive procedure is given below in Haskell.
In case you've noticed, space complexity -- the call stack -- has risen from constant to $$\Theta(\log_2 n)$$, but since logarithmic growth is so slow, most of the time there is no need to worry about stack overflows.

```haskell
fib_ :: Int -> (Integer, Integer)
fib_ 0 = (0, 1)
fib_ n = let (fk, fk1) = fib_ (div n 2)
             fn        = fk * (2*fk1 - fk)
             fn1       = fk1^2 + fk^2
         in if mod n 2 == 0
            then (fn, fn1)
            else (fn1, fn + fn1)

fib :: Int -> Integer
fib n = fn where (fn, _) = fib_ n
```

Another way to see this is to think of the previously mentioned transformation $$T$$ as a special case of $$T_{pq}(a, b) = (a (q + p) + bq, aq + bp)$$ when $$p = 0, q = 1$$.
It is then always possible to find $$p', q'$$ such that $$T_{p'q'} = T_{pq}^2$$: just let $$p' = q^2 + p^2$$ and $$q' = q^2 + 2qp$$.
Let `n` be the number of transformations that need to be applied.
Then for each step, if `n` is odd we simply apply the transformation and go to the next iteration; otherwise `n` is even and we change `p` and `q` such that only half the number of transformations is now needed.
This is an exercise in Abelson & Sussman's classic, [Structure and Interpretation
of Computer Programs](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-11.html#footnote_Temp_70) (a.k.a. "The Wizard Book").

```scheme
(define (fib n)
  (let iter ([p 0] [q 1] [n n] [a 1] [b 0])
    (cond [(<= n 0) b]
          [(even? n)
           (iter (+ (* q q) (* p p))
                 (+ (* q q) (* 2 p q))
                 (/ n 2) a b)]
          [else
           (iter p q (- n 1)
                 (+ (* a (+ q p)) (* b q))
                 (+ (* a q) (* b p)))])))
```


Memoization and Streams
-----

Another common way to obtain Fibonacci numbers is to pre-compute them such that each input `n` maps to a memory location where $$F_n$$ is stored.
$$F_n$$ can thus be thought of as a vector being indexed at its nth position.

```python
fibs_ = [fn for fn in fibs(1000)] # fibs is the generator

def memo_fib(n):
    if n < len(fibs_):
        return fibs_[n]
    else:
        curr, prev = fibs_[-1], fibs_[-2]
        for _ in range(n - len(fibs_) + 1):
            prev, curr = curr, curr + prev
            fibs_.append(curr)
        return curr
```

The Python code above allocates a chunk of memory and fills it sequentially with the Fibonacci sequence such that later accesses need no computation and could, theoretically, be made in $$\Theta(1)$$ time.
When the number is too far down the sequence and hasn't been calculated yet, we start with the closest pair of Fibonacci numbers and continue to fill the vector until the desired number is reached.

This approach may end up taking too much space, so there's still some optimization to be done.
Another issue is that memory is updated dynamically, requiring eventual reallocations and other such expensive operations.

Using a language with better support for lambdas and first-class functions, we could turn this memoization / tabling technique into something a little more generic.
In this case we use Guile's hash-tables to map a procedure's argument list to its cached results.

```scheme
;; make a function that caches its past results
(define (memoize proc)
  (let ((cache (make-table)))
    (define (delegate . args)
      (let ((hit (lookup cache args)))
        (or hit
            (let ((result (apply proc args)))
              (insert! cache args result)
              result))))
    delegate))

;; GUILE specific
(define make-table make-hash-table)
(define lookup hash-ref)
(define insert! hash-set!)

;; example
(define memo-fib
  (memoize
    (lambda (n)
      (if (<= n 1) n
          (+ (memo-fib (- n 1)) (memo-fib (- n 2)))))))
```

This memoization process can be thought of as a data structure which contains past results and generates new ones on demand.
The same thing happens with [lazy](https://en.wikipedia.org/wiki/Lazy_evaluation) lists, which are potentially infinite data structures also known as streams.
Haskell, being a lazy programming language, has this behaviour by default:

```haskell
fibs :: Integer -> Integer -> [Integer]
fibs prev curr = prev : fibs curr (prev + curr)

main = do
    let fib = fibs 0 1 -- fib contains the entire sequence
    print (fib !! 47)  -- Fn = fib !! n
```

The snippet above shows a possibly infinite list named `fib` which contains the whole Fibonacci sequence.
It is returned by the function `fibs` in constant time and each indexing operation on it sequentially computes Fibonacci numbers while storing past results in the beggining of the list.


Negafibonacci
-----

All of the techniques and algorithms shown so far consider the Fibonacci sequence to be indexed by natural numbers.
Most implementations seen in the wild also make this assumption, sometimes throwing an error when negative integers are used, others just blatantly ignoring these inputs.

The sequence can be easily extended with the "Negafibonacci" numbers by following

$$
F_n = F_{n-1} + F_{n-2}\\
F_{n-2} = F_n - F_{n-1}
$$

which leads us to

$$
F_{-1} = F_{1} - F_{0} = 1 - 0 = 1\\
F_{-2} = F_{0} - F_{-1} = 0 - 1 = -1\\
F_{-3} = ... = 2\\
F_{-4} = -3\\
F_{-5} = 5\\
...
$$

It is then easy to notice that whenever $$n < 0$$

$$F(n) = F(-n)$$ if $$n$$ is odd, and

$$F(n) = -F(-n)$$ if $$n$$ is instead even.

Some may be tempted to write this in the mathematically equivalent form

$$F(n < 0) = (-1)^{n-1} F(-n)$$

but I personally discourage doing this in actual code as it makes it much less evident what the property is and may lead to an expensive exponentiation process just to get the right sign when compared to a simple conditional:

```python
fn = fib(abs(n))
if n < 0 and n % 2 == 0:
    return -fn
else:
    return fn
```


TL;DR
-----

If you came here to see a code snippet with a final, optimal algorithm for Fibonacci numbers, then I'm sorry to disappoint you.
Instead, the conclusion of this overly long post is that there will always be many ways to compute something, each with its own tradeoffs.

In the end, though, I can say that:

* Unless you're benchmarking something, forget about the double-recursive procedure.
* The sequence grows exponentially, so bignums are a must.
* When Fibonacci numbers are only required sparsely, use some form of the fast transform to guarantee $$\Theta(\log_2 n)$$ time and $$\Theta(1)$$ space complexity.
* A generator is a very clean way to iterate through Fibonacci numbers sequentially.
* If the whole sequence -- or perhaps some slice of it -- is needed, streams are the way to go.
* Dynamic memoization and/or static tabling is the approach people usually suggest to optimize Fibonacci numbers, but the memory overhead is hardly ever worth it: consider using the fast transform instead.
  Of course, if a value can be statically optimized (during compilation, for instance, with C++'s `constexpr`), then this is usually preferred.
* Translating math directly into code usually turns out terribly inefficient (see the double-recursive procedure), but using it smartly gives you very useful properties (see the FFT).
* Knowing different programming languages gives insight into useful techniques you wouldn't normally consider.
