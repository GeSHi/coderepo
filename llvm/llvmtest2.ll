; ModuleID = '/tmp/webcompile/_11133_0.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-linux-gnu"

@.str = private constant [4 x i8] c"%d\0A\00", align 1 ; <[4 x i8]*> [#uses=1]

define i32 @factorial(i32 %X) nounwind readnone {
entry:
  %0 = icmp eq i32 %X, 0                          ; <i1> [#uses=1]
  br i1 %0, label %bb2, label %bb1

bb1:                                              ; preds = %entry
  %1 = add nsw i32 %X, -1                         ; <i32> [#uses=2]
  %2 = icmp eq i32 %1, 0                          ; <i1> [#uses=1]
  br i1 %2, label %factorial.exit, label %bb1.i

bb1.i:                                            ; preds = %bb1
  %3 = add nsw i32 %X, -2                         ; <i32> [#uses=1]
  %4 = tail call i32 @factorial(i32 %3) nounwind  ; <i32> [#uses=1]
  %5 = mul nsw i32 %4, %1                         ; <i32> [#uses=1]
  br label %factorial.exit

factorial.exit:                                   ; preds = %bb1.i, %bb1
  %6 = phi i32 [ %5, %bb1.i ], [ 1, %bb1 ]        ; <i32> [#uses=1]
  %7 = mul nsw i32 %6, %X                         ; <i32> [#uses=1]
  ret i32 %7

bb2:                                              ; preds = %entry
  ret i32 1
}

define i32 @main(i32 %argc, i8** nocapture %argv) nounwind {
entry:
  %0 = getelementptr inbounds i8** %argv, i64 1   ; <i8**> [#uses=1]
  %1 = load i8** %0, align 8                      ; <i8*> [#uses=1]
  %2 = tail call i32 @atoi(i8* %1) nounwind readonly ; <i32> [#uses=4]
  %3 = icmp eq i32 %2, 0                          ; <i1> [#uses=1]
  br i1 %3, label %factorial.exit, label %bb1.i

bb1.i:                                            ; preds = %entry
  %4 = add nsw i32 %2, -1                         ; <i32> [#uses=2]
  %5 = icmp eq i32 %4, 0                          ; <i1> [#uses=1]
  br i1 %5, label %factorial.exit.i, label %bb1.i.i

bb1.i.i:                                          ; preds = %bb1.i
  %6 = add nsw i32 %2, -2                         ; <i32> [#uses=1]
  %7 = tail call i32 @factorial(i32 %6) nounwind  ; <i32> [#uses=1]
  %8 = mul nsw i32 %7, %4                         ; <i32> [#uses=1]
  br label %factorial.exit.i

factorial.exit.i:                                 ; preds = %bb1.i.i, %bb1.i
  %9 = phi i32 [ %8, %bb1.i.i ], [ 1, %bb1.i ]    ; <i32> [#uses=1]
  %10 = mul nsw i32 %9, %2                        ; <i32> [#uses=1]
  br label %factorial.exit

factorial.exit:                                   ; preds = %factorial.exit.i, %entry
  %11 = phi i32 [ %10, %factorial.exit.i ], [ 1, %entry ] ; <i32> [#uses=1]
  %12 = tail call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %11) nounwind ; <i32> [#uses=0]
  ret i32 undef
}

declare i32 @atoi(i8* nocapture) nounwind readonly

declare i32 @printf(i8* nocapture, ...) nounwind
