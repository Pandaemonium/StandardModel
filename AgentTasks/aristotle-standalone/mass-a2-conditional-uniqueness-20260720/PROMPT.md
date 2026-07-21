# Strategy + lemma job: conditional uniqueness of the Yukawa coupling (gate A2, positive complement)

Type: classification + Mathlib-only lemma. Positive complement to the landed A2
no-go (`PlueckerYukawaModuli`: admissible Yukawas = `Hom_G(V_R,V_L)`, and Pluecker
modulus/determinant data does NOT uniquely select a point - two distinct
equivariant couplings can share norm and determinant).

This job pins EXACTLY WHEN uniqueness DOES hold. Prove:

1. **One-dimensional intertwiner + phase fixing => unique.** If
   `Hom_G(V_R,V_L)` is one-dimensional (each irreducible appears with
   multiplicity one on each side, `Σ_λ m_L,λ m_R,λ = 1`), then any two nonzero
   admissible couplings are complex scalar multiples of each other (Schur), so a
   single normalization convention (e.g. fixing the modulus AND a phase, or
   fixing one leading entry to be a positive real) determines the coupling
   uniquely. State and prove the scalar-multiple lemma and the exact normalization
   that removes the residual phase.
2. **Multiplicity > 1 => genuine moduli.** If some
   `m_L,λ m_R,λ ≥ 2`, exhibit a continuous family of admissible couplings with
   the same Pluecker modulus data (generalizing the landed `diag(1,0)` vs
   `diag(0,1)` counterexample to a one-parameter family), proving no
   normalization fixes the coupling.
3. **The Standard Model pin.** State the additional physical hypothesis that
   makes the observed Yukawa well-posed: the coupling is not a bare
   `Hom_G(V_R,V_L)` element but the contraction of the Higgs representation with a
   single invariant tensor, and the residual freedom is exactly the fermion
   field-redefinition (CKM/PMNS) group. Give the exact count of physical
   parameters that survive (masses + mixing angles + phases) for a concrete small
   generation number `n` as a Lean-checked arithmetic fact if feasible.

## Constraints

Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`; standard
axioms. Report axioms. Success: the one-dimensional-uniqueness lemma proved +
the multiplicity>1 moduli family + the SM-pin parameter count, closing the A2
gate (no-go landed + conditional uniqueness here).
