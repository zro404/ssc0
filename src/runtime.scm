(define runtime-asm "
  [BITS 64]
  global _start

  section .data
    _omem_msg db \"Out of heap memory!\", 10

  section .bss
  heap_space:
    resb 1024 * 1024  ; 1MB heap
  heap_end:

  section .text
  _start:
    ; init heap pointer
    lea r15, [rel heap_space]
    lea r14, [rel heap_end]

    ; align stack to 16 bytes (System V ABI compat)
    and rsp, -16

    ; call program entry
    call main

  _exit:
    mov rdi, rax
    mov rax, 60
    syscall

  ; rdi = size
  _alloc:
    mov rax, r15
    add r15, rdi

    cmp r15, r14
    jae _out_of_mem

    ret

  _out_of_mem:
    mov rax, 1
    mov rdi, 1
    mov rsi, _omem_msg
    mov rdx, 19
    syscall

    mov rdi, 1
    jmp _exit
")
