(load "src/runtime.scm")
(load "src/lexer.scm")

(define void-object (cons 'void '()))
(define (void)
  void-object)

(define (compile-file fpath)
  (display (string-append "Compiling " fpath "\n"))

  (define tokens '())

  (call-with-input-file fpath (lambda (in-port)
    (set! tokens (lexer in-port))
  ))

  ; TODO parser

  (call-with-output-file (string-append fpath ".asm") (lambda (out-port)
    (emit out-port runtime-asm)
    ; TODO Codegen output
  ))

  (display (string-append "Successfully Compiled: " fpath "\n"))
)

; (define (read-file fpath)
;     (let loop ((chars '()))
;       (let ((ch (read-char in-port)))
;         (if (eof-object? ch)
;           (list->string (reverse chars))
;           (loop (cons ch chars))))))))

(define (emit port asm)
  (display asm port)
)
