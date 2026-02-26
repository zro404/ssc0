; Progress:
; [x] parentheses
; [x] whitespace + comments
; [x] identifiers
; [x] integers (base 10)
; [x] quote '
; [x] strings
; [] booleans
; [] characters

(define (make-token type value)
  (list type value))

(define (token-type token)
  (car token))

(define (token-value token)
  (cdr token))


(define (delimiter? ch)
  (or (char-whitespace? ch)
      (char=? ch #\()
      (char=? ch #\))
      (eof-object? ch)))


(define (lexer in-port)
  (define (lex tokens)
    (if (eof-object? (peek-char in-port))
      (reverse tokens)
      (let ((ch (read-char in-port)))
        (cond
          ((char-whitespace? ch)
           (lex tokens))

          ((char=? ch #\;)
           (let skip ((next-ch (peek-char in-port)))
             (if 
               (or (char=? next-ch #\newline) (eof-object? ch))
               (lex tokens) ; exit loop
               (begin
                 (read-char in-port)
                 (skip (peek-char in-port)))
               )
             )
           )

          ((char=? ch #\()
           (lex (cons (make-token 'LPAREN "(") tokens)))

          ((char=? ch #\))
           (lex (cons (make-token 'RPAREN ")") tokens)))

          ((char=? ch #\')
            (let scan ((next-ch (peek-char in-port)) (char-list '()))
              (if 
                (delimiter? next-ch)
                (lex (cons (make-token 'QUOTE (list->string (reverse char-list))) tokens))
                (begin
                  (read-char in-port)
                  (scan (peek-char in-port) (cons next-ch char-list))))))

          ((char=? ch #\")
           (let scan ((next-ch (peek-char in-port)) (char-list '()))
              (cond
              ((eof-object? next-ch)
                (error "Premature EOF"))

              ((char=? next-ch #\")
                (read-char in-port)
                (lex (cons (make-token 'STRING (list->string (reverse char-list))) tokens)))

                     ;; Escape sequence
              ((char=? next-ch #\\)
                (read-char in-port) ; consume backslash
                (let ((esc (peek-char in-port)))
                  (cond
                    ((eof-object? esc)
                      (error "Incomplete Escape Sequence"))
                    ((char=? esc #\\)
                      (read-char in-port)
                      (scan (peek-char in-port) (cons #\\ char-list)))
                    ((char=? esc #\")
                      (read-char in-port)
                      (scan (peek-char in-port) (cons #\" char-list)))
                    ((char=? esc #\n)
                      (read-char in-port)
                      (scan (peek-char in-port) (cons #\newline char-list)))
                    ((char=? esc #\t)
                      (read-char in-port)
                      (scan (peek-char in-port) (cons #\tab char-list)))
                    (else
                      (error "Invalid Escape Sequence")))))

              (else 
                (begin
                  (read-char in-port)
                  (scan (peek-char in-port) (cons next-ch char-list))))
              )))

          ((char-numeric? ch)
           (let scan ((next-ch (peek-char in-port)) (digit-list (list ch)))
             (if 
               (char-numeric? next-ch)
               (begin
                 (read-char in-port) ; Advance file ptr
                 (scan (peek-char in-port) (cons next-ch digit-list)))
               (lex (cons (make-token 'NUMBER (string->number (list->string (reverse digit-list)))) tokens)))))

          ((char-alphabetic? ch)
           (let scan ((next-ch (peek-char in-port)) (char-list (list ch)))
             (if
               (delimiter? next-ch)
               (lex (cons (make-token 'IDENTIFIER (list->string (reverse char-list))) tokens))
               (begin
                 (read-char in-port) ; Advance file ptr
                 (scan (peek-char in-port) (cons next-ch char-list))))))

          (else
            (error (string-append "Undefined token: " (string ch))))))))

  (lex '()))
