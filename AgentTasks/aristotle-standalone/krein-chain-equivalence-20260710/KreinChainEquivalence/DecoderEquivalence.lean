import Mathlib

/-!
# Krein-chain equivalence of finite decoders: the intertwiner half

The landed module `DecoderChainHomotopy` (parent repository) proves that
same-carrier homotopy shifts `D' = D + QR + RQ` act identically on
constraint cohomology.  This package supplies the OTHER half of the proposed
decoder equivalence: an invertible intertwiner `U` between two carriers with
`U Q = Q' U` and Krein isometry `B' (U x) (U y) = B x y`.  Together the two
halves make the moduli reading of carrier non-rigidity precise: individual
matrix presentations are coordinates; cohomology, spectrum, and positive
inertia are the invariants.

## Targets

1. `closed_map_iff` / `exact_map_iff` — the intertwiner matches closed and
   exact representatives both ways (so it induces a bijection on cohomology
   classes at the representative level).
2. `cohomologous_map` — cohomologous representatives stay cohomologous.
3. `intertwined_decoder_cohomologous` — if the transported decoder differs
   from `D'` by a `Q'`-homotopy, then on every closed representative
   `U (D x)` and `D' (U x)` are cohomologous: the two presentations induce
   the same physical operator.
4. `spectrum_conj_eq` — conjugation by the intertwiner preserves the
   spectrum of the decoder (the physical mass spectrum is presentation
   independent).
5. `posdef_map` — the Krein isometry carries `B`-positive-definite
   subspaces to `B'`-positive-definite subspaces of the same finrank
   (positive inertia is presentation independent).
6. `witness` — an explicit rational two-dimensional instance with a
   nonidentity intertwiner and `Q' ≠ Q`, showing the equivalence relates
   genuinely different presentations.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean KreinChainEquivalence/DecoderEquivalence.lean` first; avoid a
full lake build until the holes are closed.
-/

namespace KreinChainEquivalence

variable {V V' : Type*}
  [AddCommGroup V] [Module ℝ V] [AddCommGroup V'] [Module ℝ V']

/-- A representative is closed when the constraint differential kills it. -/
def IsClosed (Q : V →ₗ[ℝ] V) (x : V) : Prop := Q x = 0

/-- A representative is exact when it is a constraint image. -/
def IsExact (Q : V →ₗ[ℝ] V) (x : V) : Prop := ∃ z, x = Q z

/-- Two representatives are cohomologous when their difference is exact. -/
def Cohomologous (Q : V →ₗ[ℝ] V) (x y : V) : Prop := ∃ z, x - y = Q z

/-- A Krein-chain equivalence between two finite decoder carriers: an
invertible intertwiner for the constraint differentials that is an isometry
of the Krein forms. -/
structure DecoderEquiv (Q : V →ₗ[ℝ] V) (Q' : V' →ₗ[ℝ] V')
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (B' : V' →ₗ[ℝ] V' →ₗ[ℝ] ℝ) where
  U : V ≃ₗ[ℝ] V'
  intertwine : ∀ x, U (Q x) = Q' (U x)
  isometry : ∀ x y, B' (U x) (U y) = B x y

variable {Q : V →ₗ[ℝ] V} {Q' : V' →ₗ[ℝ] V'}
  {B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ} {B' : V' →ₗ[ℝ] V' →ₗ[ℝ] ℝ}

/-- Target 1a: closedness matches across the equivalence, both ways. -/
theorem closed_map_iff (E : DecoderEquiv Q Q' B B') (x : V) :
    IsClosed Q' (E.U x) ↔ IsClosed Q x := by
  sorry

/-- Target 1b: exactness matches across the equivalence, both ways. -/
theorem exact_map_iff (E : DecoderEquiv Q Q' B B') (x : V) :
    IsExact Q' (E.U x) ↔ IsExact Q x := by
  sorry

/-- Target 2: cohomologous representatives stay cohomologous. -/
theorem cohomologous_map (E : DecoderEquiv Q Q' B B') {x y : V}
    (h : Cohomologous Q x y) :
    Cohomologous Q' (E.U x) (E.U y) := by
  sorry

/-- Target 3: if the transported decoder differs from `D'` by a
`Q'`-homotopy correction, the two decoders agree on cohomology: on every
closed representative, `U (D x)` and `D' (U x)` are cohomologous. -/
theorem intertwined_decoder_cohomologous (E : DecoderEquiv Q Q' B B')
    (D : V →ₗ[ℝ] V) (D' : V' →ₗ[ℝ] V') (R : V →ₗ[ℝ] V')
    (hhom : ∀ x, E.U (D x) - D' (E.U x) = Q' (R x) + R (Q x))
    {x : V} (hx : IsClosed Q x) :
    Cohomologous Q' (E.U (D x)) (D' (E.U x)) := by
  sorry

/-- Target 4: the spectrum of the conjugated decoder equals the spectrum of
the decoder: the physical mass spectrum is presentation independent. -/
theorem spectrum_conj_eq (U : V ≃ₗ[ℝ] V') (D : V →ₗ[ℝ] V) :
    spectrum ℝ ((U.toLinearMap ∘ₗ D) ∘ₗ (U.symm.toLinearMap)) =
      spectrum ℝ D := by
  sorry

/-- Target 5: the Krein isometry maps a subspace on which `B` is positive
definite to a subspace of the same finrank on which `B'` is positive
definite: positive inertia is presentation independent. -/
theorem posdef_map (E : DecoderEquiv Q Q' B B') (W : Submodule ℝ V)
    (hpos : ∀ x ∈ W, x ≠ 0 → 0 < B x x) :
    (∀ y ∈ W.map E.U.toLinearMap, y ≠ 0 → 0 < B' y y) ∧
      Module.finrank ℝ (W.map E.U.toLinearMap) = Module.finrank ℝ W := by
  sorry

/-- Target 6: an explicit rational two-dimensional witness — a nonidentity
intertwiner relating two genuinely different constraint differentials, with
a diagonal Krein form transported by construction. -/
theorem witness :
    ∃ (Q Q' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ))
      (B B' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) →ₗ[ℝ] ℝ)
      (E : DecoderEquiv Q Q' B B'),
        Q ≠ Q' ∧ E.U.toLinearMap ≠ LinearMap.id ∧
          Q ∘ₗ Q = 0 ∧ Q' ∘ₗ Q' = 0 := by
  sorry

end KreinChainEquivalence
