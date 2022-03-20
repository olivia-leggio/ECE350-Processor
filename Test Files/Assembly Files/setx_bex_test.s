nop
nop
nop
nop
nop
setx 0				# r30 = 0
nop				# Avoid RAW hazard from first setx
setx 10				# r30 = 10 (with RAW hazard)
bex e1				# r30 != 0 --> taken
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
addi $r20, $r20, 1		# r20 += 1 (Incorrect)
e1: addi $r10, $r10, 1		# r10 += 1 (Correct)
add $r11, $r10, $r11		# Accumulate r10 score
add $r21, $r20, $r21		# Accumulate r20 score
and $r10, $r0, $r10		# r10 should be 1
and $r20, $r0, $r20		# r20 should be 0
