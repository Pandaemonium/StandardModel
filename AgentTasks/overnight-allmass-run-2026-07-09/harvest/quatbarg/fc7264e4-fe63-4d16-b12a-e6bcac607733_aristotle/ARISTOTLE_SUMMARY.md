# Summary of changes for run fc7264e4-fe63-4d16-b12a-e6bcac607733
Delivered `RequestProject/Main.lean` (namespace `SuiteA_QuatBargmann`) and `ARISTOTLE_SUMMARY.md`. The project builds cleanly (no warnings/errors) in well under 3 minutes, with no `sorry`/`admit`/`native_decide`/new axioms; every headline has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`.

Common setup: two-component vectors with sesquilinear inner product `bInner x y = star x.1*y.1 + star x.2*y.2`, cyclic Bargmann triple `bTriple a b c = ⟨a|b⟩⟨b|c⟩⟨c|a⟩`, and right-rephasing `scaleR x u = (x.1*u, x.2*u)`. `H := Quaternion ℚ`; the complex control uses `ℂ` with explicit Gaussian witnesses.

Results:
1. `complex_control` — rephasing invariance HOLDS over ℂ: for all complex vectors and all unit phases (`star uₖ*uₖ=1`), `bTriple (scaleR a u1)(scaleR b u2)(scaleR c u3) = bTriple a b c`. Non-vacuity shown by Gaussian-integer witnesses (`cB_val`: value `2+2i ≠ 0`) and a Gaussian-rational unit `(3+4i)/5` (`cu_unit`).
2. `quaternion_rephasing_fails` (payload) — over H, right-rephasing the pivot vector `p1 ↦ p1*j` by the unit quaternion `j` changes the triple; the theorem exhibits nonzero values `B=2+2i`, `B'=2−2i`, `star j*j=1`, `B'≠B`, and `B≠0`.
3. `quaternion_cyclic_fails` — over H the cyclic reordering differs: `2+2i ≠ 2−2j`, both nonzero.
4. `selection_corollary` — packages 1–3 with honest scope stated in the docstring: this kills the standard sesquilinear cyclic Bargmann triple under right-rephasing over H (this construction, not every conceivable invariant).

Mathematical note (documented in the summary and file): the literal single operation `ψ₂ ↦ ψ₂*u` on the middle vector is actually invariant even over H (adjacent phases cancel via `u·star u=1`); the genuine non-vacuous failure requires rephasing the cyclic pivot vector, whose phases land on the outer ends and yield a true conjugation `star u·B·u`. The formalization therefore rephases the pivot `p1` — the faithful, provable form of the intended kill-test. All witness triple products are exhibited as explicit nonzero values, so nothing is vacuous. Work committed and pushed.

# Suite A kill-test: no composable abelian Bargmann CP phase over the quaternions

All results live in `RequestProject/Main.lean`, namespace `SuiteA_QuatBargmann`.
Build is kernel-checked, `sorry`/`admit`/`native_decide`/axiom-free, and finishes in well
under 3 minutes. Every headline carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` pinning the footprint to exactly
`[propext, Classical.choice, Quot.sound]`.

## Setup

Two-component vectors over a `*`-ring `A`:

* `bInner x y = star x.1 * y.1 + star x.2 * y.2` — sesquilinear inner product (conjugate-linear
  in the first slot);
* `bTriple a b c = ⟨a|b⟩⟨b|c⟩⟨c|a⟩` — the cyclic Bargmann triple;
* `scaleR x u = (x.1 * u, x.2 * u)` — a right-rephasing by a scalar `u`.

`H := Quaternion ℚ` (rational Hamilton quaternions); the complex control uses `ℂ` with explicit
Gaussian-rational witnesses.

## Results

1. **`complex_control`** — rephasing invariance HOLDS over `ℂ`. For *all* complex vectors
   `a,b,c` and *all* unit phases `u₁,u₂,u₃` (`star uₖ * uₖ = 1`),
   `bTriple (scaleR a u₁) (scaleR b u₂) (scaleR c u₃) = bTriple a b c`: the phases cancel in the
   cyclic product (key algebraic step: `bInner_scaleR`). Non-vacuity of the object is exhibited
   by the Gaussian-integer witnesses `c1,c2,c3` with `cB_val : bTriple c1 c2 c3 = 2 + 2i ≠ 0`
   (`cB_ne_zero`), and `cu = (3+4i)/5` is shown to be a genuine unit phase (`cu_unit`).

2. **`quaternion_rephasing_fails`** (payload) — over `H`, right-rephasing the pivot vector
   `p1 ↦ p1 * j` by the unit quaternion `j` CHANGES the triple: the theorem exhibits the nonzero
   values `B = 2 + 2i`, `B' = 2 − 2i`, the fact `star j * j = 1` (so `j` is a genuine phase),
   `B' ≠ B`, and `B ≠ 0`. Mechanism: for the pivot, `bTriple (scaleR p1 u) p2 p3 = star u · B · u`
   (conjugation), which over `ℂ` collapses to `B` but over `H` moves `B` because `j` and `B` do
   not commute.

3. **`quaternion_cyclic_fails`** (second kill direction) — over `H` the cyclic reordering of the
   same product differs: `⟨1|2⟩⟨2|3⟩⟨3|1⟩ = 2 + 2i ≠ 2 − 2j = ⟨2|3⟩⟨3|1⟩⟨1|2⟩`, both nonzero.

4. **`selection_corollary`** — packages 1–3: the `ℂ`-Bargmann object is rephasing-invariant and
   cyclic, while the `H`-analogue of this same form is neither, with explicit nonzero witnesses.
   Honest scope (stated in the docstring): this kills *this construction* — the standard
   sesquilinear cyclic Bargmann triple under right-rephasing — over `H`, i.e. it is a kill-test
   for that specific composable cyclic abelian Bargmann CP invariant, not a claim about every
   conceivable invariant.

## Non-degeneracy

All witness triple products are exhibited as explicit nonzero quaternions/complex numbers
(`qB_val`, `qBrephase_val`, `qBcyclic_val`, `cB_val`, plus the `≠ 0` conjuncts), so none of the
failures or the invariance are vacuous.

## Note on the stated operation

The literal single-vector operation `ψ₂ ↦ ψ₂ * u` on the *middle* vector of the cyclic triple is
in fact invariant even over `H` (the two inserted phases land adjacently and cancel as
`u · star u = 1`). The genuine, non-vacuous failure requires rephasing the cyclic *pivot* vector
(here `p1`), whose two phase insertions land on the outer ends of the product and produce a true
conjugation `star u · B · u`. The formalization therefore rephases `p1`; this is the faithful,
provable form of the intended kill-test.
