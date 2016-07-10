# Copyright: 2016 - Dario Ostuni <another.code.996@gmail.com>
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

.data
ERROR_INVALID:      .asciiz "Error: invalid char"
FIRST_STRING:       .asciiz "Insert starting string: "
SECOND_STRING:      .asciiz "Insert ending string: "
FROM:               .asciiz "\nFrom: "
TO:                 .asciiz "\nTo:   "
MAX_STRING_SIZE:    .word 512
.align 2
.text
.globl main
.ent main
main:
    subu $sp, $sp, 64
    sw $ra, 0($sp)
    sw $fp, 4($sp)
    move $fp, $sp
    la $s1, MAX_STRING_SIZE
    lw $s1, 0($s1)
    move $a0, $s1
    jal string_new
    move $s0, $v0
    move $a0, $s1
    jal string_new
    move $s1, $v0
    li $v0, 4
    la $a0, FIRST_STRING
    syscall
    move $a0, $s0
    jal string_read
    move $a0, $s0
    jal string_pop
    move $a0, $s0
    jal string_len
    move $s2, $v0
    li $s7, 0
    cc1:
    beq $s7, $s2, end_cc1
    move $a0, $s0
    move $a1, $s7
    jal string_get
    move $a0, $v0
    jal is_valid
    addiu $s7, $s7, 1
    j cc1
    end_cc1:
    li $v0, 4
    la $a0, SECOND_STRING
    syscall
    move $a0, $s1
    jal string_read
    move $a0, $s1
    jal string_pop
    move $a0, $s1
    jal string_len
    move $s3, $v0
    li $s7, 0
    cc2:
    beq $s7, $s3, end_cc2
    move $a0, $s1
    move $a1, $s7
    jal string_get
    move $a0, $v0
    jal is_valid
    addiu $s7, $s7, 1
    j cc2
    end_cc2:
    addiu $s2, $s2, 1
    addiu $s3, $s3, 1
    move $a0, $s2
    move $a1, $s3
    jal matrix_new
    move $s4, $v0
    move $a0, $s2
    move $a1, $s3
    jal matrix_new
    move $s5, $v0
    sw $zero, 20($sp)
    sw $zero, 24($sp)
    sw $zero, 28($sp)
    li $s6, 1
    ccp_1:
    beq $s6, $s2, end_ccp_1
    li $s7, 1
    ccp_2:
    beq $s7, $s3, end_ccp_2
    subu $a1, $s6, 1
    subu $a2, $s7, 1
    move $a0, $s4
    jal matrix_get
    sw $v0, 8($sp)
    move $a0, $s0
    subu $a1, $s6, 1
    jal string_get
    sw $v0, 12($sp)
    move $a0, $s1
    subu $a1, $s7, 1
    jal string_get
    move $a1, $v0
    lw $a0, 12($sp)
    jal distance
    lw $t0, 8($sp)
    add $t0, $t0, $v0
    bgtz $t0, no_zero1
    li $t0, 0
    no_zero1:
    sw $t0, 8($sp)
    move $a0, $s4
    move $a1, $s6
    move $a2, $s7
    move $a3, $t0
    jal matrix_set
    li $t8, 0
    li $t9, 1
    ccp_3:
    beq $t9, $s6, end_ccp_3
    sw $t8, 12($sp)
    sw $t9, 16($sp)
    move $a0, $s4
    move $a1, $t9
    move $a2, $s7
    jal matrix_get
    lw $t8, 12($sp)
    lw $t9, 16($sp)
    sub $t0, $s6, $t9
    li $t1, -2
    mul $t0, $t0, $t1
    add $t0, $v0, $t0
    ble $t0, $t8, no_replace3
    move $t8, $t0
    no_replace3:
    addiu $t9, $t9, 1
    j ccp_3
    end_ccp_3:
    lw $t0, 8($sp)
    ble $t8, $t0, no_update3
    sw $t8, 8($sp)
    move $a0, $s4
    move $a1, $s6
    move $a2, $s7
    move $a3, $t8
    jal matrix_set
    move $a0, $s5
    move $a1, $s6
    move $a2, $s7
    li $a3, 1
    jal matrix_set
    no_update3:
    li $t8, 0
    li $t9, 1
    ccp_4:
    beq $t9, $s7, end_ccp_4
    sw $t8, 12($sp)
    sw $t9, 16($sp)
    move $a0, $s4
    move $a1, $s6
    move $a2, $t9
    jal matrix_get
    lw $t8, 12($sp)
    lw $t9, 16($sp)
    sub $t0, $s7, $t9
    li $t1, -2
    mul $t0, $t0, $t1
    add $t0, $v0, $t0
    ble $t0, $t8, no_replace4
    move $t8, $t0
    no_replace4:
    addiu $t9, $t9, 1
    j ccp_4
    end_ccp_4:
    lw $t0, 8($sp)
    ble $t8, $t0, no_update4
    sw $t8, 8($sp)
    move $a0, $s4
    move $a1, $s6
    move $a2, $s7
    move $a3, $t8
    jal matrix_set
    move $a0, $s5
    move $a1, $s6
    move $a2, $s7
    li $a3, 2
    jal matrix_set
    no_update4:
    lw $t0, 28($sp)
    lw $t1, 8($sp)
    blt $t1, $t0, no_upgrade
    sw $t1, 28($sp)
    sw $s6, 20($sp)
    sw $s7, 24($sp)
    no_upgrade:
    addiu $s7, $s7, 1
    j ccp_2
    end_ccp_2:
    addiu $s6, $s6, 1
    j ccp_1
    end_ccp_1:
    lw $t0, 20($sp)
    lw $t1, 24($sp)
    li $t2, 0
    rec:
    sw $t0, 32($sp)
    sw $t1, 36($sp)
    sw $t2, 40($sp)
    move $a0, $s5
    move $a1, $t0
    move $a2, $t1
    jal matrix_get
    lw $t2, 40($sp)
    sw $v0, 44($sp)
    move $a0, $v0
    move $a1, $t2
    jal node_new
    move $t2, $v0
    sw $t2, 40($sp)
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t3, 44($sp)
    move $a0, $s4
    move $a1, $t0
    move $a2, $t1
    jal matrix_get
    beqz $v0, end_rec
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t2, 40($sp)
    lw $t3, 44($sp)
    addi $t0, $t0, -1
    addi $t1, $t1, -1
    addi $t3, $t3, -1
    beqz $t3, case1
    addi $t3, $t3, -1
    beqz $t3, case2
    j cont
    case1:
    addi $t1, $t1, 1
    j cont
    case2:
    addi $t0, $t0, 1
    cont:
    beqz $t0, end_rec
    beqz $t1, end_rec
    j rec
    end_rec:
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    bnez $t0 not_up1
    addi $t0, $t0, 1
    not_up1:
    bnez $t1 not_up2
    addi $t1, $t1, 1
    not_up2:
    sw $t0, 32($sp)
    sw $t1, 36($sp)
    la $a0, MAX_STRING_SIZE
    lw $a0, 0($a0)
    add $a0, $a0, $a0
    jal string_new
    sw $v0, 48($sp)
    la $a0, MAX_STRING_SIZE
    lw $a0, 0($a0)
    add $a0, $a0, $a0
    jal string_new
    sw $v0, 52($sp)
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t2, 40($sp)
    addi $t0, $t0, -1
    addi $t1, $t1, -1
    reconstruction:
    beqz $t2, end_reconstruction
    lw $t3, 0($t2)
    sw $t0, 32($sp)
    sw $t1, 36($sp)
    sw $t2, 40($sp)
    beqz $t3, ccase0
    addi $t3, $t3, -1
    beqz $t3, ccase1
    j ccase2
    ccase0:
    move $a0, $s0
    move $a1, $t0
    jal string_get
    lw $a0, 48($sp)
    move $a1, $v0
    jal string_push
    move $a0, $s1
    lw $a1, 36($sp)
    jal string_get
    lw $a0, 52($sp)
    move $a1, $v0
    jal string_push
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t2, 40($sp)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j end_ccase
    ccase1:
    move $a0, $s0
    move $a1, $t0
    jal string_get
    lw $a0, 48($sp)
    move $a1, $v0
    jal string_push
    lw $a0, 52($sp)
    li $a1, 45
    jal string_push
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t2, 40($sp)
    addi $t0, $t0, 1
    j end_ccase
    ccase2:
    move $a0, $s1
    move $a1, $t1
    jal string_get
    lw $a0, 52($sp)
    move $a1, $v0
    jal string_push
    lw $a0, 48($sp)
    li $a1, 45
    jal string_push
    lw $t0, 32($sp)
    lw $t1, 36($sp)
    lw $t2, 40($sp)
    addi $t1, $t1, 1
    end_ccase:
    lw $t2, 4($t2)
    j reconstruction
    end_reconstruction:
    lw $t0, 48($sp)
    lw $t1, 52($sp)
    li $v0, 4
    la $a0, FROM
    syscall
    li $v0, 4
    lw $a0, 4($t0)
    syscall
    li $v0, 4
    la $a0, TO
    syscall
    li $v0, 4
    lw $a0, 4($t1)
    syscall
    sw $fp, 4($sp)
    addu $sp, $sp, 64
    li $v0, 10
    li $a0, 0
    syscall
.end main

.ent distance
distance:
    beq $a0, $a1, end2
    li $t0, 65
    li $t1, 67
    li $t2, 71
    blt $a0, $a1, noswap
    xor $a0, $a0, $a1
    xor $a1, $a0, $a1
    xor $a0, $a0, $a1
    noswap:
    beq $a0, $t0, aCase
    beq $a0, $t1, cCase
    j end2m
    cCase:
    beq $a1, $t2, end2m
    j end1m
    aCase:
    beq $a1, $t1, end2m
    beq $a1, $t2, end1m
    j end2m
    end2:
    li $v0, 2
    jr $ra
    end1m:
    li $v0, -1
    jr $ra
    end2m:
    li $v0, -2
    jr $ra
.end distance

.ent is_valid
is_valid:
    li $t0, 65
    beq $t0, $a0, valid
    li $t0, 67
    beq $t0, $a0, valid
    li $t0, 71
    beq $t0, $a0, valid
    li $t0, 84
    beq $t0, $a0, valid
    la $a0, ERROR_INVALID
    li $v0, 4
    syscall
    li $a0, 1
    li $v0, 10
    syscall
    valid:
    jr $ra
.end is_valid

.ent node_new
node_new:
    move $t0, $a0
    move $t1, $a1
    li $a0, 8
    li $v0, 9
    syscall
    sw $t0, 0($v0)
    sw $t1, 4($v0)
    jr $ra
.end node_new

.ent matrix_new
matrix_new:
    move $t0, $a0
    move $t1, $a1
    mul $t2, $t0, $t1
    sll $t2, $t2, 2
    move $a0, $t2
    li $v0, 9
    syscall
    move $t3, $v0
    li $a0, 8
    li $v0, 9
    syscall
    sw $t1, 0($v0)
    sw $t3, 4($v0)
    li $t4, 0
    zero_cycle:
    beq $t4, $t2, end_zero_cycle
    addu $t5, $t4, $t3
    sw $zero, 0($t5)
    addiu $t4, $t4, 4
    j zero_cycle
    end_zero_cycle:
    jr $ra
.end matrix_new

.ent matrix_get
matrix_get:
    lw $t0, 0($a0)
    lw $t1, 4($a0)
    mul $t2, $a1, $t0
    addu $t2, $t2, $a2
    sll $t2, $t2, 2
    addu $t3, $t2, $t1
    lw $v0, 0($t3)
    jr $ra
.end matrix_get

.ent matrix_set
matrix_set:
    lw $t0, 0($a0)
    lw $t1, 4($a0)
    mul $t2, $a1, $t0
    addu $t2, $t2, $a2
    sll $t2, $t2, 2
    addu $t3, $t2, $t1
    sw $a3, 0($t3)
    jr $ra
.end matrix_set

.ent string_new
string_new:
    move $t0, $a0
    li $a0, 8
    li $v0, 9
    syscall
    move $t1, $v0
    move $a0, $t0
    li $v0, 9
    syscall
    sb $zero, 0($v0)
    sw $t0, 0($t1)
    sw $v0, 4($t1)
    move $v0, $t1
    jr $ra
.end string_new

.ent string_push
string_push:
    lw $t0, 4($a0)
    li $t1, 0
    search_null:
    addu $t2, $t1, $t0
    lbu $t3, 0($t2)
    beq $t3, $zero, end_search_null
    addiu $t1, $t1, 1
    j search_null
    end_search_null:
    sb $a1, 0($t2)
    sb $zero, 1($t2)
    jr $ra
.end string_push

.ent string_pop
string_pop:
    lw $t0, 4($a0)
    li $t1, 0
    psearch_null:
    addu $t2, $t1, $t0
    lbu $t3, 0($t2)
    beq $t3, $zero, pend_search_null
    addiu $t1, $t1, 1
    j psearch_null
    pend_search_null:
    addi $t2, $t2, -1
    sb $zero, 0($t2)
    jr $ra
.end string_pop

.ent string_len
string_len:
    lw $t0, 4($a0)
    li $t1, 0
    lsearch_null:
    addu $t2, $t1, $t0
    lbu $t3, 0($t2)
    beq $t3, $zero, lend_search_null
    addiu $t1, $t1, 1
    j lsearch_null
    lend_search_null:
    move $v0, $t1
    jr $ra
.end string_len

.ent string_get
string_get:
    lw $t0, 4($a0)
    addu $t0, $t0, $a1
    lbu $v0, 0($t0)
    jr $ra
.end string_get

.ent string_read
string_read:
    lw $t0, 0($a0)
    lw $t1, 4($a0)
    move $a0, $t1
    move $a1, $t0
    li $v0, 8
    syscall
    jr $ra
.end string_read
