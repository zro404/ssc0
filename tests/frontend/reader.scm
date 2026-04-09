(define reader-tests
  '(
    ("Quote" "'hello" 'hello)
    ("String" "\"hello\"" "hello")
    ("Simple string define" "(define var1 \"Hello\")" (define var1 "Hello"))
    ("Define with quote" "(define void-object (cons 'void '()))" (define void-object (cons 'void '())))
    ("Simple addition" "(+ 1 2)" (+ 1 2))
    ("Nested expr" "(+ (* 2 3) 4)" (+ (* 2 3) 4))
    ("Lambda" "(lambda (x) x)" (lambda (x) x))
   ))

(define reader-error-tests
  '(
    ("Detect missing paren" "(+ 1 2")
  ))
