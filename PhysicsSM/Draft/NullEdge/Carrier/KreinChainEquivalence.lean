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
Recovered from Aristotle project `2687b7bb-68d7-4511-9f4d-e7b27e30e31c`; proof bodies verified locally
under the pinned toolchain before porting.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.KreinChainEquivalence

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
  constructor
  · intro h
    apply E.U.injective
    rw [map_zero, E.intertwine]; exact h
  · intro h
    rw [IsClosed, ← E.intertwine, h, map_zero]

/-- Target 1b: exactness matches across the equivalence, both ways. -/
theorem exact_map_iff (E : DecoderEquiv Q Q' B B') (x : V) :
    IsExact Q' (E.U x) ↔ IsExact Q x := by
  constructor
  · rintro ⟨z', hz'⟩
    refine ⟨E.U.symm z', ?_⟩
    apply E.U.injective
    rw [E.intertwine, LinearEquiv.apply_symm_apply]; exact hz'
  · rintro ⟨z, rfl⟩
    exact ⟨E.U z, E.intertwine z⟩

/-- Target 2: cohomologous representatives stay cohomologous. -/
theorem cohomologous_map (E : DecoderEquiv Q Q' B B') {x y : V}
    (h : Cohomologous Q x y) :
    Cohomologous Q' (E.U x) (E.U y) := by
  obtain ⟨z, hz⟩ := h
  refine ⟨E.U z, ?_⟩
  rw [← E.intertwine, ← hz, map_sub]

/-- Target 3: if the transported decoder differs from `D'` by a
`Q'`-homotopy correction, the two decoders agree on cohomology: on every
closed representative, `U (D x)` and `D' (U x)` are cohomologous. -/
theorem intertwined_decoder_cohomologous (E : DecoderEquiv Q Q' B B')
    (D : V →ₗ[ℝ] V) (D' : V' →ₗ[ℝ] V') (R : V →ₗ[ℝ] V')
    (hhom : ∀ x, E.U (D x) - D' (E.U x) = Q' (R x) + R (Q x))
    {x : V} (hx : IsClosed Q x) :
    Cohomologous Q' (E.U (D x)) (D' (E.U x)) := by
  refine ⟨R x, ?_⟩
  rw [hhom x, IsClosed] at *
  rw [hx, map_zero, add_zero]

/-- Target 4: the spectrum of the conjugated decoder equals the spectrum of
the decoder: the physical mass spectrum is presentation independent. -/
theorem spectrum_conj_eq (U : V ≃ₗ[ℝ] V') (D : V →ₗ[ℝ] V) :
    spectrum ℝ ((U.toLinearMap ∘ₗ D) ∘ₗ (U.symm.toLinearMap)) =
      spectrum ℝ D := by
  have h := AlgEquiv.spectrum_eq (U.conjAlgEquiv ℝ) D
  rw [LinearEquiv.conjAlgEquiv_apply] at h
  rw [LinearMap.comp_assoc]
  exact h

/-- Target 5: the Krein isometry maps a subspace on which `B` is positive
definite to a subspace of the same finrank on which `B'` is positive
definite: positive inertia is presentation independent. -/
theorem posdef_map (E : DecoderEquiv Q Q' B B') (W : Submodule ℝ V)
    (hpos : ∀ x ∈ W, x ≠ 0 → 0 < B x x) :
    (∀ y ∈ W.map E.U.toLinearMap, y ≠ 0 → 0 < B' y y) ∧
      Module.finrank ℝ (W.map E.U.toLinearMap) = Module.finrank ℝ W := by
  refine ⟨?_, LinearEquiv.finrank_map_eq E.U W⟩
  rintro y hy hy0
  rw [Submodule.mem_map] at hy
  obtain ⟨x, hxW, rfl⟩ := hy
  have hx0 : x ≠ 0 := fun h => hy0 (by rw [h]; simp)
  change 0 < B' (E.U x) (E.U x)
  rw [E.isometry x x]
  exact hpos x hxW hx0

/-- Target 6: an explicit rational two-dimensional witness — a nonidentity
intertwiner relating two genuinely different constraint differentials, with
a diagonal Krein form transported by construction. -/
theorem witness :
    ∃ (Q Q' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ))
      (B B' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) →ₗ[ℝ] ℝ)
      (E : DecoderEquiv Q Q' B B'),
        Q ≠ Q' ∧ E.U.toLinearMap ≠ LinearMap.id ∧
          Q ∘ₗ Q = 0 ∧ Q' ∘ₗ Q' = 0 := by
  classical
  set Um : Matrix (Fin 2) (Fin 2) ℝ := !![0,1;1,0] with hUm
  set Qm : Matrix (Fin 2) (Fin 2) ℝ := !![0,0;1,0] with hQm
  set Q'm : Matrix (Fin 2) (Fin 2) ℝ := !![0,1;0,0] with hQ'm
  set Bm : Matrix (Fin 2) (Fin 2) ℝ := !![1,0;0,-1] with hBm
  have hUU : Um * Um = 1 := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [hUm, Matrix.mul_apply, Fin.sum_univ_two]
  have hint : Um * Qm = Q'm * Um := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [hUm, hQm, hQ'm, Matrix.mul_apply, Fin.sum_univ_two]
  have hQ0 : Qm * Qm = 0 := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [hQm, Matrix.mul_apply, Fin.sum_univ_two]
  have hQ'0 : Q'm * Q'm = 0 := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [hQ'm, Matrix.mul_apply, Fin.sum_univ_two]
  let hinv : Invertible Um := ⟨Um, hUU, hUU⟩
  let U : (Fin 2 → ℝ) ≃ₗ[ℝ] (Fin 2 → ℝ) := Um.toLinearEquiv' hinv
  let Q : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) := Matrix.toLin' Qm
  let Q' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) := Matrix.toLin' Q'm
  let B : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) →ₗ[ℝ] ℝ := Matrix.toLinearMap₂' ℝ Bm
  let B' : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) →ₗ[ℝ] ℝ :=
    B.compl₁₂ U.symm.toLinearMap U.symm.toLinearMap
  have hUapp : ∀ x, U x = Um *ᵥ x := by
    intro x
    rw [← Matrix.toLin'_apply, ← Matrix.toLinearEquiv'_apply Um hinv, LinearEquiv.coe_coe]
  refine ⟨Q, Q', B, B', ⟨U, ?_, ?_⟩, ?_, ?_, ?_, ?_⟩
  · -- intertwine
    intro x
    change U (Q x) = Q' (U x)
    rw [hUapp, hUapp]
    change Um *ᵥ (Matrix.toLin' Qm x) = Matrix.toLin' Q'm (Um *ᵥ x)
    rw [Matrix.toLin'_apply, Matrix.toLin'_apply, Matrix.mulVec_mulVec,
      Matrix.mulVec_mulVec, hint]
  · -- isometry (by construction, `B'` is the pullback of `B` along `U`)
    intro x y
    change B' (U x) (U y) = B x y
    simp only [B', LinearMap.compl₁₂_apply, LinearEquiv.coe_coe, LinearEquiv.symm_apply_apply]
  · -- Q ≠ Q'
    intro h
    have h1 := LinearMap.congr_fun h (![1,0] : Fin 2 → ℝ)
    simp only [Q, Q', Matrix.toLin'_apply] at h1
    have h2 := congr_fun h1 1
    simp [hQm, hQ'm, Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h2
  · -- U ≠ id
    intro h
    have h1 := LinearMap.congr_fun h (![1,0] : Fin 2 → ℝ)
    simp only [LinearMap.id_coe, id_eq, LinearEquiv.coe_coe] at h1
    rw [hUapp] at h1
    have h2 := congr_fun h1 0
    simp [hUm, Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h2
  · -- Q ∘ₗ Q = 0
    change Matrix.toLin' Qm ∘ₗ Matrix.toLin' Qm = 0
    rw [← Matrix.toLin'_mul, hQ0, map_zero]
  · -- Q' ∘ₗ Q' = 0
    change Matrix.toLin' Q'm ∘ₗ Matrix.toLin' Q'm = 0
    rw [← Matrix.toLin'_mul, hQ'0, map_zero]

end PhysicsSM.Draft.NullEdge.KreinChainEquivalence

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.KreinChainEquivalence.intertwined_decoder_cohomologous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.KreinChainEquivalence.intertwined_decoder_cohomologous

/-- info: 'PhysicsSM.Draft.NullEdge.KreinChainEquivalence.spectrum_conj_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.KreinChainEquivalence.spectrum_conj_eq

/-- info: 'PhysicsSM.Draft.NullEdge.KreinChainEquivalence.witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.KreinChainEquivalence.witness
