# Summary of changes for run daba5306-c9a9-4fed-91c7-92cc83994cc3
Delivered `RequestProject/Main.lean` (namespace `MassFourFaces`) plus `ARISTOTLE_SUMMARY.md`, proving over exact rationals that the several `mass²` dictionaries of a real symmetric trace-1 2×2 "density" `ρ = !![p, x; x, 1-p]` are faces of one wedge/determinant invariant.

Model: `rho`, `detR p x = p(1-p) - x²`, `Slin p x = 1 - tr(ρ²)`, `Hlin p = 1 - (p² + (1-p)²)`, diagonal readout `d p = ![p, 1-p]`, and `TVdiag p q = ½(|p-q| + |(1-p)-(1-q)|)`.

Theorems (all kernel-checked, no sorry/native_decide/new axioms):
- `slin_eq_two_det`: `Slin p x = 2·detR p x`.
- `hlin_eq_two_det_diag`: `Hlin p = 2·detR p 0` and `= 2p(1-p)`.
- `faces_agree` (payload): `Slin = 2·detR`, and at x=0, `Slin p 0 = Hlin p = 2·detR p 0 = 2p(1-p)` — det/entropy/Hlin are ONE invariant up to the factor 2.
- `tv_is_plucker_distance` (honest separation): `TVdiag p q = |p-q| = |p(1-q)-(1-p)q|` (the 2×2 Plücker wedge magnitude), and `TVdiag p p = 0`. TV is a two-argument Plücker *distance* between edges, distinct from the single-state entropy but built from the same wedge data.
- `four_faces_verdict`: packages the verdict together with exact masslessness — `detR p 0`, `Slin p 0`, `Hlin p` vanish iff `p ∈ {0,1}`, and `TVdiag p q = 0` iff `p = q`.

Mandatory non-degeneracy witnesses are in-theorem: `nondeg_pure_massless` (`Slin (1/2)(1/2)=0`, `det=0`), `nondeg_mixed` (`Slin (1/2) 0 = 1/2 = Hlin (1/2) = 2·det`), `nondeg_tv` (`TVdiag (1/2)(1/2)=0` vs `TVdiag 1 0 = 1`). The `nondeg_pure_massless` docstring honestly notes `Hlin` ignores `x` so it does not vanish at that point (the faces coincide only at x=0).

Constraints honored: only `Matrix.trace`/`Matrix.mul_apply` + `Fin.sum_univ_two` + `ring`/`norm_num`/`linarith`/`abs`; no Real transcendental, no Complex, no high-degree nlinarith. Every headline has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. The file builds cleanly in well under 3 minutes; a grep confirms no `sorry`/`admit`/`native_decide`. Work committed and pushed.

# claude-mass-four-faces — ARISTOTLE_SUMMARY

## Goal

Prove, over exact rationals (`ℚ`), that the several `mass²` dictionaries read off a real
symmetric trace-1 `2×2` "density" `ρ = !![p, x; x, 1-p]` are **faces of one
wedge/determinant invariant**, and honestly separate the *one-register* entropies from the
*two-register* total-variation distance.

All results live in `RequestProject/Main.lean`, namespace `MassFourFaces`.

## Model

- `rho p x = !![p, x; x, 1 - p]`
- `detR p x = p*(1-p) - x^2`               (Plücker / determinant invariant)
- `Slin p x = 1 - tr((rho p x)²)`          (linear entropy, via `Matrix.trace`/`Matrix.mul`)
- `Hlin p = 1 - (p² + (1-p)²)`             (diagonal linear entropy)
- `d p = ![p, 1-p]`                         (diagonal celestial readout, a prob vector)
- `TVdiag p q = ½(|p-q| + |(1-p)-(1-q)|)`   (total-variation distance of two readouts)

## Theorems proved (all kernel-checked, no `sorry`/`native_decide`/new axioms)

1. `slin_eq_two_det`      : `Slin p x = 2 * detR p x`.
2. `hlin_eq_two_det_diag` : `Hlin p = 2 * detR p 0` and `Hlin p = 2*p*(1-p)`.
3. `detR_diag`           : `detR p 0 = p*(1-p)` (helper).
4. `faces_agree`         : payload — `Slin = 2·detR`, and at `x=0`,
   `Slin p 0 = Hlin p = 2·detR p 0 = 2·p·(1-p)`. The det/linear-entropy/Hlin faces are ONE
   rational invariant up to the fixed factor `2`.
5. `tv_is_plucker_distance` : honest separation — `TVdiag p q = |p-q| =
   |p(1-q) - (1-p)q|`, the magnitude of the `2×2` Plücker wedge; and `TVdiag p p = 0`
   (collinear/massless). TV is a two-argument *distance* between two edges, distinct from
   the single-state entropy but built from the same wedge/determinant data.
6. `four_faces_verdict`  : the packaged verdict —
   - the single-register faces `det`, `Slin`, `Hlin` are one invariant (equal up to `2`);
   - `TV` is the two-register Plücker distance of the null directions;
   - masslessness is exact: `detR p 0 = 0 ↔ p ∈ {0,1}`, likewise `Slin p 0`, `Hlin p`, and
     `TVdiag p q = 0 ↔ p = q`.

### Non-degeneracy witnesses (explicit rationals, in-theorem)

- `nondeg_pure_massless` : `Slin (1/2) (1/2) = 0`, `detR (1/2) (1/2) = 0` (pure state; the
  off-diagonal kills the determinant). `Hlin` ignores `x`, so it is not `0` at this point —
  the faces coincide only at `x = 0`, which the docstring records honestly.
- `nondeg_mixed`        : `Slin (1/2) 0 = 1/2 = Hlin (1/2) = 2·detR (1/2) 0`.
- `nondeg_tv`           : `TVdiag (1/2) (1/2) = 0` (collinear) vs `TVdiag 1 0 = 1`.

## Constraints honored

- Techniques used: `Matrix.trace`/`Matrix.mul_apply` + `Fin.sum_univ_two` + `ring` /
  `norm_num` / `linarith` / `abs`. No `Real.sqrt`/`cos`/`sin`, no `Complex`, no
  high-degree `nlinarith`.
- Every headline carries an in-file
  `#guard_msgs (whitespace := lax) in #print axioms <thm>` verifying the footprint is
  exactly `[propext, Classical.choice, Quot.sound]`.
- Builds cleanly (`RequestProject.Main`) in well under 3 minutes; no `sorry`/`admit`/
  `native_decide`/new axioms.

## Honest scope

This is a **consolidation**: it shows the `mass²` dictionaries are faces of a single
wedge/determinant object, not four independent results. `det`, `Slin`, `Hlin` are one
single-register invariant (up to the factor `2`); `TVdiag` is the two-register Plücker
distance. All four vanish exactly at masslessness (`x=0` with `p ∈ {0,1}`, resp. `p=q`),
and all are built from the same wedge/determinant data.
