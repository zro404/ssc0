(load "src/runtime.scm")
(load "src/reader.scm")

(define void-object (cons 'void '()))
(define (void)
  void-object)
(define (void? obj)
  (eq? obj void-object))

(define (compile-file fpath)
  (display (string-append "Compiling " fpath "\n"))

  (call-with-input-file fpath (lambda (in-port)
    (let loop ((expr (read in-port)))
      (if (not (eof-object? expr))
        (begin
          (display expr)(newline)
          (loop (read in-port)))))
  ))

  ; TODO expander

  (call-with-output-file (string-append fpath ".asm") (lambda (out-port)
    (emit out-port runtime-asm)
    ; TODO codegen output
  ))

  (display (string-append "Successfully Compiled: " fpath "\n"))
)

(define (emit port asm)
  (display asm port)
)
