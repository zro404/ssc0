(load "src/runtime.scm")
(load "src/lexer.scm")

(define void-object (cons 'void '()))
(define (void)
  void-object)

(define (compile-file fpath)
  (display (string-append "Compiling " fpath "\n"))

  (call-with-input-file fpath (lambda (in-port)
    (let loop ((token (lexer-next-token in-port)))
      (if (not (eq? token (void)))
        (begin
          (display token)(newline) ;DEBUG
        (loop (lexer-next-token in-port)))
      )
    )
  ))

  ; TODO parser

  (call-with-output-file (string-append fpath ".asm") (lambda (out-port)
    (emit out-port runtime-asm)
    ; TODO codegen output
  ))

  (display (string-append "Successfully Compiled: " fpath "\n"))
)

(define (emit port asm)
  (display asm port)
)
