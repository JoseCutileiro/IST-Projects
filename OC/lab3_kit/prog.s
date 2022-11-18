                .data
A:              .word   1, 3, 1, 6, 4
                .word   2, 4, 3, 9, 5
mult:   .word   0

        .code
        daddi   $1, $0, A      ; *A[0]
        daddi   $5, $0, 1      ; $5 = 1 ;; i    
        daddi   $6, $0, 10     ; $6 = N ;; N = 10
        lw      $9, 0($1)      ; $9 = A[0]  ;; mult
        daddi   $1, $1, 8      ;

loop:   lw      $12, 0($1)     ; $12 = A[i]
        dmul    $12, $12, $9   ; $12 = $12*$9 ;; $12 = A[i]*mult
        dadd    $9, $9, $12    ; $9 = $9 + $12  ;; mult = mult + A[i]*mult

        daddi   $5, $5, 1      ; i++
        daddi   $1, $1, 8      ; 
        bne     $6, $5, loop   ; Exit loop if i == N
        
        sw      $9, mult($0)   ; Store result
        halt

;; Expected result: mult = f6180 (hex), 1008000 (dec)

