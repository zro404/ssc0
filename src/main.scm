(load "src/runtime.scm")

(define void-object (cons 'void '()))
(define (void)
  void-object)

(define outfile (void))

(define (compile-file fpath)
  (set! outfile (open-output-file (string-append fpath ".as")))
  (emit runtime-asm)
  ; TODO compiler logic

  ; cleanup
  (close-output-port outfile)
  (void)
)

(define (emit asm)
  (if
    (eq? outfile (void))
    ((display "Error: Output file port not initialized!")
     (newline))
    (display asm outfile)
  )
)

; (define (main)
;   (newline)
;   (display "Hello, World!")
;   (newline)
;   (void))
;
; (main)
