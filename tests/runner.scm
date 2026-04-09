;; ---------- helpers ----------

(define (pad-right str width)
  (let ((len (string-length str)))
    (if (< len width)
        (string-append str (make-string (- width len) #\space))
        str)))

(define NAME-WIDTH 24)

;; ---------- normal tests ----------

(define (run-test test)
  (let ((name (car test))
        (input (cadr test))
        (expected (caddr test)))
    (let ((result (read-from-string input)))
      (if (equal? result expected)
          (begin
            (display "  PASS: ")
            (display (pad-right name NAME-WIDTH))
            (display " | ")
            (display input)
            (newline))
          (begin
            (display "  FAIL: ")
            (display (pad-right name NAME-WIDTH))
            (display " | ")
            (display input)
            (newline)
            (display "    expected: ")
            (write expected)
            (newline)
            (display "    got:      ")
            (write result)
            (newline))))))

;; ---------- error handling ----------

(define (expect-error thunk)
  (let ((result (ignore-errors (lambda () (thunk)))))
    (not result)))

(define (run-error-test test)
  (let ((name (car test))
        (input (cadr test)))
    (if (expect-error (lambda () (read-from-string input)))
        (display "  PASS: ")
        (display "  FAIL: "))
    (display (pad-right name NAME-WIDTH))
    (display " | ")
    (display input)
    (newline)))

;; ---------- runners ----------

(define (run-tests tests)
  (for-each run-test tests))

(define (run-error-tests tests)
  (for-each run-error-test tests))

;; ---------- entry ----------

(load "tests/frontend/reader.scm")
(display "Testing Reader...\n")
(run-tests reader-tests)
(run-error-tests reader-error-tests)
