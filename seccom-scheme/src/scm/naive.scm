(define (list-ref lst n)
  (if (= n 0)
      (car lst)
      (list-ref (cdr lst) (- n 1))))

(define (fac n)
  (if (= n 0) 1
      (* n (fac (- n 1)))))

(define (gcd a b)
  (if (= b 0) a
      (gcd b (modulo a b))))

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(define (fibo n)
  (define (iter n prev curr)
    (if (= n 0) curr
        (iter (- n 1) curr (+ prev curr))))
  (iter n 1 0))

(define (^ b n)
  (define (iter b n prod)
    (cond ((= n 0) prod)
          ((even? n) (iter (square b) (halve n) prod))
          (else (iter b (- n 1) (* b prod)))))
  (iter b n 1))

(define (times b n)
  (define (iter b n sum)
    (cond ((= n 0) sum)
          ((even? n) (iter (double b) (halve n) sum))
          (else (iter b (- n 1) (+ b sum)))))
  (iter b n 0))

(define (square x) (* x x))
(define (halve x) (ash x -1))
(define (double x) (ash x 1))
