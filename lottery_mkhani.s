.section .text
.global Lottery

Lottery:
    # Prologue: Preserve registers
    addi sp, sp, -16      # Make space on stack
    sw ra, 12(sp)         # Save return address
    sw s0, 8(sp)          # Save s0 (used for array base)
    sw s1, 4(sp)          # Save s1 (used for Xn)
    sw s2, 0(sp)          # Save s2 (used for loop counter)

    # Store initial values
    mv s0, a0            # Save base address of array in s0
    mv s1, a3            # Xn = initial seed X0

    sw s1, 0(s0)         # Store X0 at a0[0]

    li s2, 1             # i = 1 (loop counter)

generate_numbers:
    beq s2, 5, end_loop  # If i == 5, exit loop

    # Compute Xn+1 = (a * Xn + b) mod m
    mul t0, a1, s1       # t0 = a * Xn
    add t0, t0, a2       # t0 = (a * Xn) + b
    rem s1, t0, a4       # s1 = (a * Xn + b) % m (Xn+1)

    # Store Xn+1 in memory
    slli t1, s2, 2       # Offset = i * 4 (each integer is 4 bytes)
    add t1, s0, t1       # Address = base + offset
    sw s1, 0(t1)         # Store Xn+1

    # Increment counter
    addi s2, s2, 1       
    j generate_numbers   # Jump to next iteration

end_loop:
    # Epilogue: Restore registers and return
    lw ra, 12(sp)        
    lw s0, 8(sp)         
    lw s1, 4(sp)         
    lw s2, 0(sp)         
    addi sp, sp, 16      
    ret
