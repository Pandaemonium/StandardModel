# Adversarial semantic audit: finite Jordan-Clifford phase character

Act as a hostile mathematical referee. Audit the verbatim Lean sources appended
to this prompt. Do not edit or prove anything. Return a severity-ranked report.

Intended reading:

1. `phaseCharacter` is an additive character only on the finite center-label
   group `Fin 3 x Fin 2 x Fin 6`, valued in phase exponents modulo six on all
   actual even five-mode Fock occupations.
2. Its finite kernel is exactly the six standard powers and every such label
   has a unique corresponding trusted unit-level covering-kernel witness that
   maps to identity.
3. We do NOT claim that the finite labels are definitionally the trusted kernel
   type, that this is the kernel of the full continuous covering-group action
   on the complete spinor representation, or that the weak/color split is
   derived from Jordan data.

Audit questions:

- Is the additive law semantically the intended modular center multiplication,
  including wraparound in all three `Fin` coordinates?
- Does equality of function-valued characters really quantify over all 16 even
  occupations, rather than only six hand-picked bidegrees?
- Is `characterKernel_eq_standardPowers` stronger than cardinality and free of
  a hidden type identification?
- Does `characterKernel_unique_unitCovering_witness` establish only a unique
  correspondence to the explicit trusted family, as claimed, or accidentally
  overstate an action-kernel theorem?
- Are the standard generator and missing-`SU(2)` control nondegenerate?
- Check all-left hypercharge convention, `6Y = 3 N_W - 2 N_V`, parity, and
  `SU(3) x SU(2) x U(1)` center ordering.
- Check vacuity, hollow telescoping, docstring-outruns-kernel, false shape,
  convention drift, and hidden assumptions.

Output:

1. Verdict: PASS, PASS WITH REQUIRED SCOPE EDITS, or FAIL.
2. Findings ordered HIGH/MEDIUM/LOW with declaration names.
3. Exact strongest manuscript sentence earned.
4. Exact statements that remain forbidden.
5. The smallest next theorem that would lift this to a continuous
   representation-kernel result.
