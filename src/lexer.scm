; TODO seperate detection logic for different token types into seperate funcs to later share with [read, read-token] runtime impl

; Progress:
; [x] parentheses
; [x] whitespace + comments
; [x] identifiers
; [x] integers (base 10)
; [x] quote '
; [x] strings
; [x] booleans
; [x] characters

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


(define (lexer-next-token in-port)
  (if (eof-object? (peek-char in-port))
    (void)
    (let ((ch (read-char in-port)))
      (cond
        ((char-whitespace? ch)
         (lexer-next-token in-port))

        ((char=? ch #\;)
         (let skip ((next-ch (peek-char in-port)))
           (if (or (char=? next-ch #\newline) (eof-object? ch))
             (lexer-next-token in-port) ; exit loop
             (begin
               (read-char in-port)
               (skip (peek-char in-port))))))

        ((char=? ch #\()
         (make-token 'LPAREN "("))

        ((char=? ch #\))
         (make-token 'RPAREN "("))

        ((char=? ch #\')
          (let scan ((next-ch (peek-char in-port)) (char-list '()))
            (if (delimiter? next-ch)
              (make-token 'QUOTE (list->string (reverse char-list)))
              (begin
                (read-char in-port)
                (scan (peek-char in-port) (cons next-ch char-list))))))

        ((char=? ch #\#)
         (let ((next-ch (read-char in-port)))
           (cond
             ((or (char=? next-ch #\t) (char=? next-ch #\f))
              (make-token 'BOOLEAN next-ch))
             ((char=? next-ch #\\)
              (let ((final-ch (read-char in-port)))
                (if (eof-object? final-ch)
                  (error "Expected Character Found EOF!")
                  (make-token 'CHARACTER final-ch))))
             (else (error (string-append "Expected Character/Boolean Found: " (string next-ch)))))))

        ((char=? ch #\")
         (let scan ((next-ch (peek-char in-port)) (char-list '()))
            (cond
            ((eof-object? next-ch)
              (error "Premature EOF"))

            ((char=? next-ch #\")
              (read-char in-port)
              (make-token 'STRING (list->string (reverse char-list))))

            ;; Escape sequences
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
           (if (char-numeric? next-ch)
             (begin
               (read-char in-port) ; Advance file ptr
               (scan (peek-char in-port) (cons next-ch digit-list)))
             (make-token 'NUMBER (string->number (list->string (reverse digit-list)))))))

        ((char-alphabetic? ch)
         (let scan ((next-ch (peek-char in-port)) (char-list (list ch)))
           (if (delimiter? next-ch)
             (make-token 'IDENTIFIER (list->string (reverse char-list)))
             (begin
               (read-char in-port) ; Advance file ptr
               (scan (peek-char in-port) (cons next-ch char-list))))))

        (else
          (error (string-append "Undefined token: " (string ch))))))))
