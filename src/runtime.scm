(define runtime-asm "
  global _start

  section .bss
  heap_space:
    resb 1024 * 1024  ; 1MB heap

  section .text
  _start:
    ; init heap pointer
    lea r15, [rel heap_space]

    ; align stack to 16 bytes (System V ABI compat)
    and rsp, -16

    ; call program entry
    call main

    ; exit
    mov rdi, rax
    mov rax, 60
    syscall
")
