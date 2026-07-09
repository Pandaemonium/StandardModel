# claude-dirac-operator-massshell-det — det(pslash - m.1) = (m^2 - p^2)^2 vanishes exactly on the mass shell (the 4-spinor determinant face of mass)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

The program characterizes mass two ways by a DETERMINANT. At the little-group level, the 2x2 spinor
matrix `P(p)=p.sigma` has `det P = m^2` (the null-edge disagreement). This job proves the 4-SPINOR
companion: the characteristic determinant of the full Dirac operator `D = pslash - m.1` on the mass
shell. The physical fact is standard: `D` is invertible OFF the mass shell and singular (`det D = 0`)
exactly ON it -- this is the dispersion relation, and it is exactly the "determinant-level mass-shell
test `det D(q) = 0`" the program uses to certify a genuine (non-doubled) mode.

Because `pslash^2 = (E^2 - kz^2).1`, the operator `pslash` has characteristic polynomial `(X^2 -
(E^2-kz^2))^2`, so the determinant is a PERFECT SQUARE and the square root cancels -- everything is
rational, no `Real.sqrt`:

  `det(pslash - m.1) = (m^2 - E^2 + kz^2)^2`   (`= (m^2 - p^2)^2`, `p^2 = E^2 - kz^2`).

On shell (`E^2 - kz^2 = m^2`) this is `0`; off shell it is a positive square. (All arithmetic verified
numerically for on/off/massless witnesses before this handoff.)

## The model (real Dirac-rep gammas, (t,z) plane -> rational 4x4; same convention as the projector modules)

All REAL, so rational 4x4 (no Complex):
* `g0 = !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]`   (= diag(1,1,-1,-1))
* `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`
* `pslash E kz = E . g0 - kz . g3`
* `D E kz m = pslash E kz - m . (1 : Matrix (Fin 4) (Fin 4) Q)`   (the Dirac operator, rational 4x4)

## Targets (rational; Matrix det via `Matrix.det_fin_four` if available, else cofactor `Matrix.det_succ_row_zero`/Leibniz; then `ring`; NO Complex, NO transcendental, NO nlinarith)

1. `pslash_sq`: `pslash E kz * pslash E kz = (E^2 - kz^2) . (1 : Matrix (Fin 4) (Fin 4) Q)`.
   `ext i j; fin_cases i <;> fin_cases j <;> simp [pslash,g0,g3,Matrix.mul_apply,Fin.sum_univ_four] <;> ring`.
2. `dirac_det` (PAYLOAD): `(D E kz m).det = (m^2 - E^2 + kz^2)^2`. Expand the explicit 4x4 determinant
   (`Matrix.det_fin_four`, or cofactor expansion) of `pslash E kz - m.1` and close the degree-4
   polynomial identity in `E,kz,m` by `ring`. (The perfect-square factorization makes this a pure
   polynomial identity; NO sqrt, NO nlinarith.)
3. `det_zero_iff_massshell` (PAYLOAD): `(D E kz m).det = 0 <-> E^2 - kz^2 = m^2`. From target 2:
   `(m^2 - E^2 + kz^2)^2 = 0 <-> m^2 - E^2 + kz^2 = 0 <-> E^2 - kz^2 = m^2` (`pow_eq_zero_iff`,
   `sub_eq_zero`). The Dirac operator is singular EXACTLY on the mass shell.
4. `det_pos_iff_off_shell`: `0 < (D E kz m).det <-> E^2 - kz^2 != m^2` (equivalently `m^2 != E^2-kz^2`):
   off the mass shell the determinant is a positive square; `D` is invertible. (Use `sq_pos_of_ne_zero`
   / `pow_pos`-style with the `<->` to the nonvanishing of `m^2 - E^2 + kz^2`.)
5. `massless_det`: at `m = 0`, `(D E kz 0).det = (E^2 - kz^2)^2`. The massless Dirac-operator determinant
   is the SQUARE of the little-group disagreement `E^2 - kz^2` (which is `det P` for the 2x2 little-group
   matrix -- stated as interpretation in the docstring; the little-group `P` is a SEPARATE object, not
   claimed equal here).
6. `dirac_massshell_det_verdict` (VERDICT): package -- for all `E kz m`, `det(pslash - m.1) =
   (m^2-E^2+kz^2)^2`, which is `0` iff `E^2-kz^2=m^2` (on the mass shell, `D` singular) and `> 0` iff off
   shell (`D` invertible). This is the 4-spinor Dirac-operator determinant face of mass, complementing
   the 2x2 little-group `det P = m^2`, and it realizes the program's determinant-level mass-shell test
   `det D(q) = 0`.

MANDATORY non-degeneracy (all in-theorem, explicit): on-shell witness `E=5,kz=3,m=4`
(`E^2-kz^2=16=m^2`, `det(D 5 3 4)=0`); off-shell witness `E=5,kz=3,m=3` (`det(D 5 3 3)=(9-25+9)^2=49 !=
0`, so `D` invertible off shell); massless witness `E=5,kz=3,m=0` (`det(D 5 3 0)=(9-25)^2=256`). Prove
each by `norm_num` on target 2 (or directly).

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE for
the gamma convention, NOT an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on EVERY headline. Rational 4x4 (real gammas ->
no Complex); Matrix.det (det_fin_four / cofactor) + fin_cases/simp/norm_num/ring; NO Real.sqrt/cos/sin,
NO Complex, NO nlinarith. The determinant is a perfect square so the whole thing is a rational polynomial
identity closed by `ring`. Build under 4 min. Deliver RequestProject/Main.lean (namespace
`DiracOperatorMassShellDet`) + ARISTOTLE_SUMMARY.md WITH the PhysLean gamma-provenance line and the honest
reading (the 4-spinor det face of mass, real (t,z) avatar, [import] Dirac dispersion realized as finite
kernel-checked matrix algebra).
