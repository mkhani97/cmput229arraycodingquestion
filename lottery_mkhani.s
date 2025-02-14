    .data
array_base:  .space 20   # Reserve space for 5 integers (5 * 4 bytes)

    .text
    .globl Lottery

Lottery:
    # Store registers
    addi sp, sp, -16     # Allocate space on the stack
    sw ra, 12(sp)        # Store return address
    sw s0, 8(sp)         # Store s0
    sw s1, 4(sp)         # Store s1
    sw s2, 0(sp)         # Store s2

    # Load all arguments into registers
    mv s0, a0            # s0 = base address of array (a0)
    mv s1, a3            # s1 = X0 (a3, initial seed)
    mv a1, a1            # a1 = a (unchanged)
    mv a2, a2            # a2 = b (unchanged)
    mv a4, a4            # a4 = m (unchanged)

    sw s1, 0(s0)         # Store X0 at array[0]

    li s2, 1             # i = 1 (loop counter)
    li t2, 5             # Loop termination condition (generate 5 numbers)

generate_numbers:
    beq s2, t2, end_loop  # If i == 5, exit loop

    # Compute Xn+1 = (a * Xn + b) mod m
    mul t0, a1, s1       # t0 = a * Xn
    add t0, t0, a2       # t0 = (a * Xn) + b
    rem s1, t0, a4       # s1 = (a * Xn + b) % m (Xn+1)

    # Store Xn+1 in memory
    slli t1, s2, 2       # Offset = i * 4
    add t1, s0, t1       # Address = base + offset
    sw s1, 0(t1)         # Store Xn+1

    # Increment counter
    addi s2, s2, 1       
    j generate_numbers   # Loop back

end_loop:
    #Restore registers
    lw ra, 12(sp)        # Restore return address
    lw s0, 8(sp)         # Restore s0
    lw s1, 4(sp)         # Restore s1
    lw s2, 0(sp)         # Restore s2
    addi sp, sp, 16      # Deallocate stack space

    ret                  # Return to caller
