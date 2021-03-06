; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 -no-integrated-as -verify-machineinstrs | FileCheck %s
; PR7509
target triple = "i386-apple-darwin10"
%asmtype = type { i32, i8*, i32, i32 }

; Arguments 1 and 4 must be the same. No other output arguments may be
; allocated %eax.

define i32 @func(i8* %s) nounwind ssp {
; CHECK-LABEL: func:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, (%esp) ## 4-byte Spill
; CHECK-NEXT:    movl (%esp), %ecx ## 4-byte Reload
; CHECK-NEXT:    ## InlineAsm Start
; CHECK-NEXT:    arg0 %eax
; CHECK-NEXT:    arg1 %ecx
; CHECK-NEXT:    arg2 %edx
; CHECK-NEXT:    arg3 %esi
; CHECK-NEXT:    arg4 %ecx
; CHECK-NEXT:    ## InlineAsm End
; CHECK-NEXT:    movl %ecx, %edi
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
  %0 = tail call %asmtype asm "arg0 $0\0A\09arg1 $1\0A\09arg2 $2\0A\09arg3 $3\0A\09arg4 $4", "={ax},=r,=r,=r,1,~{dirflag},~{fpsr},~{flags}"(i8* %s) nounwind, !srcloc !0 ; <%0> [#uses=1]
  %asmresult = extractvalue %asmtype %0, 0              ; <i64> [#uses=1]
  ret i32 %asmresult
}

!0 = !{i32 108}
