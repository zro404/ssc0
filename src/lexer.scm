(define (make-token type value)
  (list type value))

(define (token-type token)
  (car token))

(define (token-value token)
  (cdr token))


(define (lexer in-port)
  (define (lex tokens)
    (if (eof-object? (peek-char in-port))
      (reverse tokens)
      (let ((ch (read-char in-port)))
        (cond
          ((char-whitespace? ch)
           (lex tokens))

          ((char=? ch #\()
           (lex (cons (make-token 'LPAREN "(") tokens)))

          ((char=? ch #\))
           (lex (cons (make-token 'RPAREN ")") tokens)))

          (else
            (error (string-append "Undefined token: " (string ch))))))))

  (lex '()))
