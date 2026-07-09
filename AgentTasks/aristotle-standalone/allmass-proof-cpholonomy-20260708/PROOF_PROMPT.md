# Proof: CP phase as projective null-ray holonomy (Conjecture D)

## Context (blind to the wider repo)

A finite null-edge program has mass = null-direction disagreement `|ψᵢ∧ψⱼ|²`, which
forgets phases. But the spinor brackets `⟨ij⟩ = ψᵢ∧ψⱼ` retain phase, and the closed
triple product `J = ⟨12⟩⟨23⟩⟨31⟩` is a **Bargmann-type holonomy** of three null rays.
The conjecture: mixing matrices are overlaps between coherence bases, and the physical
CP phase is the gauge-invariant phase of such a holonomy — CP-odd because conjugation
reverses the loop. This is the route to CKM/PMNS + CP separate from mass eigenvalues.

## Targets (`src/CPHolonomy.lean`, three `sorry`s)

`bracket ψ φ = ψ₀φ₁ − ψ₁φ₀` (the `2`-spinor wedge = `det[ψ|φ]`);
`tripleJ p1 p2 p3 = bracket p1 p2 · bracket p2 p3 · bracket p3 p1`.

1. `triple_SL2_invariant`: under a common `g` with `det g = 1`,
   `tripleJ (g·p1)(g·p2)(g·p3) = tripleJ p1 p2 p3`. Key lemma: `bracket (g·ψ)(g·φ) =
   det g · bracket ψ φ` (a `2×2` determinant identity — `bracket` is the `2×2` det of
   the columns, and `det(g·[ψ|φ]) = det g · det[ψ|φ]`). Then the product picks up
   `(det g)³ = 1`. Prove the bracket-scaling lemma first (`Matrix.det_mul` /
   direct `2×2` expansion via `Matrix.det_fin_two` or `ring`).
2. `triple_CP_odd`: `tripleJ (conj p1)(conj p2)(conj p3) = conj (tripleJ p1 p2 p3)`.
   `bracket (conj ψ)(conj φ) = conj (bracket ψ φ)` (conjugation is a ring hom;
   `map_mul`/`map_sub`), then the product conjugates. So `Im J` is a genuine CP-odd
   invariant, `Im J ≠ 0` ⇒ non-gaugeable CP violation.
3. `triple_mass_magnitude`: `‖tripleJ‖ = ‖⟨12⟩‖·‖⟨23⟩‖·‖⟨31⟩‖` (`norm_mul`), tying
   the CP magnitude to the three pairwise disagreements — CP violation requires
   genuine three-way non-collinearity (all brackets `≠ 0`).

If a cleaner or more standard gauge-invariant CP-odd invariant is warranted (e.g. a
normalized Jarlskog-type combination that is also invariant under *independent*
rescalings `ψᵢ ↦ λᵢ ψᵢ`, not just common `SL(2,ℂ)`), you MAY additionally state and
prove it — but note honestly that `tripleJ` as defined is `SL(2,ℂ)`-invariant but NOT
independent-rescaling-invariant (it scales by `λ₁²λ₂²λ₃²`), so its *phase* is the
physical object only after fixing a normalization; make that scope explicit.

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, guarded with in-file `#print axioms`.
Mathlib only. Deliver the file + axiom prints + `ARISTOTLE_SUMMARY.md`: the three
identities, the exact invariance group of the *phase*, and an honest note on the
normalization/rescaling scope (what makes `arg J` a physical CP invariant).
