# claude-ground-mass-det-family-law — the DETERMINANT-side family law that replaces the killed `budget = c*detP` (Fable Tier-1 item 3)

## Context (blind to any repo; self-contained finite RATIONAL 2x2 algebra, Mathlib only)

The program's central slogan is "the mass budget ANSWERS TO the kinematic invariant `det P`". A prior
kernel kill-test (`BudgetSignMismatch`, a REFERENCE here) showed the naive TRACE-side form is FALSE as a
family law: the sum-of-squares budget `budget a b x = a^2 + b^2 + 2 x^2` and the Gram determinant
`detP a b x = a b - x^2` depend on the off-diagonal `x` with OPPOSITE sign, so no constant `c` gives
`budget = c * detP` for all `(a,b,x)` (it only fits at a single witness). This job proves the CORRECT,
exact family law, which lives on the DETERMINANT / SPECTRAL side.

Work on the aperture-closure sector block (real symmetric, the same avatar as `BudgetSignMismatch`'s
`detP`, and the aperture-closure part of `MassPhaseDiagram`'s `B3` whose spectrum is `{lam-kap, lam,
lam+kap}` -- both REFERENCE only):

  `P lam kap = !![lam, kap; kap, lam]`   (real symmetric 2x2; eigenvalues `lam +/- kap`, `det = lam^2 - kap^2`).

Here `lam` is the free (uncoupled) sector mass and `kap` is the closure coupling. The GROUND MASS is the
least eigenvalue `mu- = lam - kap`; the free mass (at `kap = 0`) is `lam`; the BINDING DEFECT is
`Delta = mu- - lam`.

## Targets (rational; Matrix.det_fin_two / charpoly + fin_cases/ring/norm_num; NO transcendental, NO Complex, NO nlinarith)

1. `char_poly`: `(X * 1 - P lam kap).det = (X - (lam - kap)) * (X - (lam + kap))` (so the eigenvalues are
   exactly `lam - kap` and `lam + kap`). By `Matrix.det_fin_two`; `ring`.
2. `det_closed`: `(P lam kap).det = lam^2 - kap^2`. `Matrix.det_fin_two`; `ring`.
3. `trace_closed`: `(P lam kap).trace = 2 * lam`. By `Matrix.trace_fin_two` / `Fin.sum`; `ring`.
4. `det_eq_eigenvalue_product` (payload): `(P lam kap).det = (lam - kap) * (lam + kap)` -- the determinant
   is the product of the ground mass `mu- = lam-kap` and the top mass `mu+ = lam+kap`. `ring` from 2.
5. `defect_exact` (payload): the binding defect is EXACTLY the closure coupling:
   `(lam - kap) - lam = - kap` for ALL `lam kap` (i.e. `mu- = lam + (-kap)`, the ground mass is lowered
   from the free mass `lam` by exactly `kap`). Trivial `ring`, but STATE it as the family identity that
   contrasts with the killed `budget = c*detP` (the defect is `-kap`, not a fitted multiple of `detP`).
6. `groundmass_det_family_law` (PAYLOAD, the prize): the ground mass and the determinant determine each
   other EXACTLY over the whole family, given the trace: with `mu- = lam - kap` and `tr = 2*lam`,
   `(P lam kap).det = mu- * (tr - mu-)`, i.e. `lam^2 - kap^2 = (lam-kap)*(2*lam - (lam-kap))`. So the
   ground mass is the smaller root of `mu^2 - tr*mu + det = 0`: the spectral ground mass answers to the
   determinant invariant EXACTLY over the family. `ring`.
7. `spectral_answers_to_invariants` (the contrast, payload): the eigenvalues are an exact function of the
   invariants `(tr, det)` -- both `mu+ mu- = det` (target 4) and `mu+ + mu- = tr` (`(lam-kap)+(lam+kap) =
   2 lam`). Package: `((lam-kap)*(lam+kap) = (P lam kap).det) AND ((lam-kap)+(lam+kap) = (P lam kap).trace)`.
   Contrast (state in docstring, cite `BudgetSignMismatch`): the trace-side sum-of-squares budget is NOT a
   function of `det` alone (two configs with equal `det` and different budget exist -- that module's kill),
   whereas the ground mass IS fixed by `(tr, det)`. THIS is why the correct §3<->§4 tie is determinant-side.
8. `free_bridge_adjugate` (Fable's determinant-side free bridge): `P lam kap * (P lam kap).adjugate =
   (P lam kap).det * 1` (the `2x2` Cramer/adjugate identity, `Matrix.mul_adjugate`); i.e. the free
   determinant bridge holds identically -- the interacting deviation is entirely in the exact defect `-kap`.
9. `ground_mass_det_verdict` (verdict): package 4,5,6,7 -- the ground mass `mu- = lam-kap` = free mass +
   defect (`-kap` exact); `det = mu- * mu+ = mu-(tr - mu-)`; the spectrum answers to `(tr,det)` exactly.
   This is the determinant-side family law that the trace-side `budget = c*detP` failed to be.

MANDATORY non-degeneracy (all in-theorem, explicit): massive witness `lam=5, kap=3`: `mu- = 2` (ground
mass), `mu+ = 8`, `det = 16`, `defect = -3`, and `16 = 2*(10-2)`; critical/massless-ground witness
`lam=kap=4`: `mu- = 0` (massless ground state, binding saturates), `det = 0`; over-closure witness
`lam=3, kap=5`: `mu- = -2 < 0` (tachyonic ground, unphysical over-closure). Show `mu-` differs across
these (`2, 0, -2`) so the law is non-vacuous.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (`BudgetSignMismatch`,
`MassPhaseDiagram` are REFERENCES, NOT imports). Footprint exactly `[propext, Classical.choice,
Quot.sound]`; in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` on EVERY headline.
Rational 2x2 (real symmetric, NO Complex); `Matrix.det_fin_two`/`trace_fin_two`/`mul_adjugate` +
fin_cases/ring/norm_num; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith. Build under 3 min. Deliver
RequestProject/Main.lean (namespace `GroundMassDetFamilyLaw`) + ARISTOTLE_SUMMARY.md stating the honest
reading: this converts the central §3<->§4 tie from a witness-level coincidence (the killed trace-side
`budget = c*detP`) into an EXACT determinant-side family law (ground mass answers to `det` given `tr`);
it does NOT re-derive the spectrum/det (those are `MassPhaseDiagram`'s) -- the new content is the
family-law synthesis and the exact-defect / spectral-vs-invariants framing.
