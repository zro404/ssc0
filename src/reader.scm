; READER:
;   reads port contents and returns an S-Expression

(load "src/lexer.scm")

(define (read in-port)
  (define (read-list elems)
    (let ((token (read-token in-port)))
      (if (not (eof-object? token))
        (case (token-type token)
          ((RPAREN)
           (reverse elems))

          ((LPAREN)
           (read-list (cons (read-list '()) elems)))

          ((QUOTE)
                (read-list (cons (list 'quote (read in-port)) elems)))

          (else
            (read-list (cons (token-value token) elems))))

        (error "Unexpected EOF!")
        )))

  (let ((token (read-token in-port)))
    (if (not (eof-object? token))
        (case (token-type token)


          ((RPAREN)
           (error "Unexpected \')\' !"))

          ((LPAREN)
           (read-list '()))

          ((QUOTE)
                (list 'quote (read in-port)))
          
          (else ; atom
            (token-value token)
          ))
        (eof-object)
        )))
