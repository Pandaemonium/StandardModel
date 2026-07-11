# Ward automorphism audit, 2026-07-11

Scope boundary:
- Audited only `AgentTasks/aristotle-standalone/codex-pub-ward-automorphism-quotient-20260711/WardAutomorphismQuotient/Main.lean`.
- No theorem sources, shared docs, or other files were edited.
- Checks were done by direct matrix algebra, with exact symbolic spot-checks in `sympy` for the displayed matrices.

## Statement audit

1. `commutes_Q_iff_family` - PASS.
   - Direct multiplication with a general `3 x 3` matrix `U = (u_ij)` gives
     `U * Q = Q * U` iff `u_10 = u_12 = u_20 = 0` and `u_11 = u_00`.
   - This is exactly the displayed five-parameter family `wardFamily a b c d e`.

2. `wardFamily_kreinUnitary_iff` - FAIL.
   - For `U = wardFamily a b c d e`,
     `U.conjTranspose * G * U` has `(0,0)` entry identically `0`.
   - Therefore it can never equal `1` (the `3 x 3` identity matrix), so the left side of the equivalence is impossible.
   - Exact correction:
     - if the intended metric-preservation law is standard Krein/isometry form, replace
       `U.conjTranspose * G * U = 1`
       with
       `U.conjTranspose * G * U = G`.
     - then the coordinate conditions need to include the missing `c/e` equations:
       `star c * a + star e * d = 0` and `star c * c + star e * e = 1`,
       in addition to the displayed `a/b/d` constraints.

3. `wardAutomorphism_classification` - FAIL.
   - This inherits the false `U.conjTranspose * G * U = 1` condition, so it is false as written.
   - The right-hand side is satisfiable, e.g. `a = 1, b = 0, c = 0, d = 0, e = 1`, while the left-hand side is impossible for every `U` of the family form.
   - Exact correction: repair the Ward/Krein condition first, then restate the classification with the full coordinate system.

4. `physical_compression_family` - PASS.
   - Direct multiplication gives
     `physP * wardFamily a b c d e * physI = !![e]`.
   - The null-sector coordinates `a, b, c, d` do not appear in the compressed physical line map.

5. `physical_identity_is_exact` - PASS.
   - With `hcomm : U * Q = Q * U` and `hphys : physP * U * physI = 1`,
     the declared `identityKernelHomotopy` satisfies
     `U - 1 = Q * identityKernelHomotopy U + identityKernelHomotopy U * Q`.
   - This is an exact algebraic quotient identity, not a continuous-path homotopy construction.

6. `nontrivial_exact_shear_witness` - FAIL.
   - The witness matrix `wardFamily 1 Complex.I 0 0 1` does commute with `Q`, has `physP * U * physI = 1`, and is exact relative to `Q`.
   - But it is not a Ward automorphism because
     `U.conjTranspose * G * U - 1 = !![-1, 1, 0; 1, -1, 0; 0, 0, 0]`.
   - Exact correction: either drop `IsWardAutomorphism` from the witness, or repair the Ward-unitary condition and choose a genuinely valid unitary witness.

7. `physical_phase_not_exact_control` - FAIL.
   - The control matrix `wardFamily 1 0 0 0 Complex.I` also commutes with `Q`, and its physical action is `!![Complex.I]`.
   - But it is not a Ward automorphism for the same reason as above: the `G`-preservation equation to `1` is impossible.
   - It is also not exact relative to `Q`, since the bottom-right entry of `U - 1` is `Complex.I - 1`, which cannot be produced by `Q * H + H * Q`.
   - Exact correction: after repairing the Ward condition, re-check the intended phase control example; as written, this is not a valid control theorem.

## Bottom line

- Safe core: the commutation normal form, the physical compression formula, and the exact kernel-quotient identity are correct.
- Broken core: the Ward/Krein unitary condition is incompatible with the stated `G` and `1`, so the classification and both witness/control theorems fail as written.
