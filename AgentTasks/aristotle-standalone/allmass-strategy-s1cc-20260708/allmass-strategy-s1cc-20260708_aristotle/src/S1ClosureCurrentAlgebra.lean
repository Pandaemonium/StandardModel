/-
# S1 closure-current algebra: Lean rungs L1-L3 and an abstract K2/L4 rung

DRAFT (kernel-clean; no `s o r r y`). Transcribes the first three rungs of
the S1 closure contribution
(`AgentTasks/twoday-carrier-run-2026-07-07/s1-closure/`, adopted as
Amendment B of `Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md`; oracle
`Scripts/oracle/probe_s1_closure_oracle_v01.py`, findings F1/F2/F4):

* **L1 (SU(2) centrality).** For a 2x2 unitary with determinant 1, the
  per-face closure Gram is central: `(1-W)(1-W)^H = (2 - tr W) . 1`.
  Route: the generic 2x2 identity `W + adjugate W = (tr W) . 1`
  (`fin_two_add_adjugate`) plus `W^H = adjugate W` for special-unitary
  `W`. The scalar evaluation `2 - 2 cos t = 4 sin^2(t/2)` is included
  (`two_sub_two_cos`): the per-face closure Gram is the same
  `1 - cos` obstruction as the kernel-pinned two-edge aperture mass.
* **L2 (per-face split).** For any unitary `W`:
  `2 (1 - W) = (1-W)(1-W)^H + (W^H - W)` - the closure defect splits
  exactly into a Gram (energy-shaped, Hermitian) part and a
  field-strength (skew) part. Finding F1; the two parts scale as `a^4
  |F|^2` and `a^2 F` respectively (oracle R1.4), which is the
  chromomagnetic-vs-energy wording rail of Amendment B.
* **L3 (null-soldered square, abstract).** In any ring with an
  anti-homomorphism `#` fixing the two null Clifford coefficients
  (`c^# = c`, `c^2 = 0`, `c1 c2 = g + b`, `c2 c1 = g - b`), every
  two-term null-soldered current `L = c1 A + c2 B` (coefficients
  commuting with the `#`-images of the transports) satisfies

    `L^# L = g (A^# B + B^# A) + b (A^# B - B^# A)`

  - no PSD diagonal survives (finding F2: squares in this calculus are
  shaped like `D^#D` itself). Corollary (`closure_current_square`,
  finding F4 direction): if `A^# B` is `#`-skew the aperture-shaped part
  cancels and `L^# L = 2 (b (A^# B))`; with `A^# B = -K/2` this is the
  memo's exact representation `Q_C = L^# L`. The concrete two-transport
  model instantiation is rung L4 (queued; carry the guard-pinned 4-slot
  normalization and the `#`-vs-dagger caveat verbatim).

## Claim boundary

Finite algebra only. L3 is stated with explicit hypotheses (the
anti-homomorphism and commutation data), matching the run's
explicit-hypothesis lemma style; no claim about which concrete carriers
satisfy them beyond the oracle-verified two-transport class. Positivity
is NOT claimed anywhere - Amendment B's whole point is that these squares
carry none (gate S1-CC owns that question).

## Provenance

S1 contribution memo 2026-07-07 (verified: identities re-derived by hand,
oracle reproduced 24/24, executor crosscheck N in {3,4,5} x random null
pairs x {SU(2), SU(3)}) - [comp]; SU(2) centrality is Cayley-Hamilton
folklore - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra

open Matrix
open scoped BigOperators

/-! ## L1: SU(2) centrality of the per-face closure Gram -/

/-- Generic 2x2 identity: `W + adjugate W = (tr W) . 1` (any commutative
scalar ring; stated over `C` for this lane). -/
theorem fin_two_add_adjugate (W : Matrix (Fin 2) (Fin 2) ℂ) :
    W + W.adjugate = W.trace • 1 := by
  rw [Matrix.adjugate_fin_two, Matrix.trace_fin_two]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [add_comm]

/-- For special-unitary `W` (2x2, `W^H W = 1`, `det W = 1`), the
conjugate transpose IS the adjugate. -/
theorem conjTranspose_eq_adjugate_of_unitary_det_one
    (W : Matrix (Fin 2) (Fin 2) ℂ) (hU : Wᴴ * W = 1) (hdet : W.det = 1) :
    Wᴴ = W.adjugate := by
  have h2 : W * W.adjugate = 1 := by
    rw [Matrix.mul_adjugate, hdet, one_smul]
  calc Wᴴ = Wᴴ * (W * W.adjugate) := by rw [h2, mul_one]
    _ = (Wᴴ * W) * W.adjugate := by rw [mul_assoc]
    _ = W.adjugate := by rw [hU, one_mul]

/-- **L1 (SU(2) centrality).** The per-face closure Gram of a
special-unitary holonomy is central: `(1-W)(1-W)^H = (2 - tr W) . 1`.
Fails for SU(3) (oracle R1.3) - a pseudoreality luxury, not used by
L3/L4. -/
theorem su2_closure_gram_central (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hU : Wᴴ * W = 1) (hdet : W.det = 1) :
    (1 - W) * (1 - W)ᴴ = (2 - W.trace) • 1 := by
  have hWWH : W * Wᴴ = 1 := mul_eq_one_comm.mp hU
  have hexp : (1 - W) * (1 - W)ᴴ = 1 - W - Wᴴ + W * Wᴴ := by
    rw [conjTranspose_sub, conjTranspose_one]
    noncomm_ring
  rw [hexp, hWWH, conjTranspose_eq_adjugate_of_unitary_det_one W hU hdet]
  calc (1 : Matrix (Fin 2) (Fin 2) ℂ) - W - W.adjugate + 1
      = (2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (W + W.adjugate) := by
        rw [two_smul]
        noncomm_ring
    _ = (2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) - W.trace • 1 := by
        rw [fin_two_add_adjugate]
    _ = (2 - W.trace) • 1 := by rw [sub_smul]

/-- The scalar evaluation: `2 - 2 cos t = 4 sin^2(t/2)` - the per-face
closure Gram is the same `1 - cos` obstruction as the two-edge aperture
mass (the "aperture rhyme" of finding F1). -/
theorem two_sub_two_cos (t : ℝ) :
    2 - 2 * Real.cos t = 4 * Real.sin (t / 2) ^ 2 := by
  have h := Real.cos_sq (t / 2)
  have ht : 2 * (t / 2) = t := by ring
  rw [ht] at h
  rw [Real.sin_sq, h]
  ring

/-! ## L2: the exact per-face split -/

/-- **L2 (per-face split, finding F1).** For any unitary `W`, the closure
defect splits exactly into a Hermitian Gram part and a skew
field-strength part: `2 (1 - W) = (1-W)(1-W)^H + (W^H - W)`. The Gram
part is the energy-shaped (`a^4 |F|^2`) object of Amendment A0; the skew
part is the field-strength (`a^2 F`) object whose commutator descendant
is the Weitzenboeck `Q_C` slot - the two must never be conflated
(Amendment B wording rail). -/
theorem closure_defect_split {n : Type*} [Fintype n] [DecidableEq n]
    (W : Matrix n n ℂ) (hU : Wᴴ * W = 1) :
    (2 : ℂ) • ((1 : Matrix n n ℂ) - W)
      = (1 - W) * (1 - W)ᴴ + (Wᴴ - W) := by
  have hWWH : W * Wᴴ = 1 := mul_eq_one_comm.mp hU
  have hexp : (1 - W) * (1 - W)ᴴ = 1 - W - Wᴴ + W * Wᴴ := by
    rw [conjTranspose_sub, conjTranspose_one]
    noncomm_ring
  rw [hexp, hWWH, two_smul]
  noncomm_ring

/-! ## L3: the null-soldered square lemma (abstract) -/

section NullSolderedSquare

variable {R : Type*} [Ring R]

/-- **L3 (null-soldered square, finding F2).** In any ring with an
additive, multiplication-reversing map `s` ("the Krein adjoint") fixing
the two null Clifford coefficients, the square of a two-term
null-soldered current has NO diagonal part: it is an aperture-shaped
symmetric term plus a bivector-shaped antisymmetric term,

  `s(L) L = g (s(A) B + s(B) A) + b (s(A) B - s(B) A)`,

where `c1 c2 = g + b` and `c2 c1 = g - b`. Hypotheses are explicit (run
lemma style); the commutation data says the Clifford coefficients act on
a different tensor factor than the transports. -/
theorem null_soldered_square (s : R → R)
    (hadd : ∀ x y : R, s (x + y) = s x + s y)
    (hmul : ∀ x y : R, s (x * y) = s y * s x)
    (c₁ c₂ A B g b : R)
    (hs1 : s c₁ = c₁) (hs2 : s c₂ = c₂)
    (hc1 : c₁ * c₁ = 0) (hc2 : c₂ * c₂ = 0)
    (h12 : c₁ * c₂ = g + b) (h21 : c₂ * c₁ = g - b)
    (hA1 : Commute c₁ (s A)) (hA2 : Commute c₂ (s A))
    (hB1 : Commute c₁ (s B)) (hB2 : Commute c₂ (s B)) :
    s (c₁ * A + c₂ * B) * (c₁ * A + c₂ * B)
      = g * (s A * B + s B * A) + b * (s A * B - s B * A) := by
  have hsL : s (c₁ * A + c₂ * B) = s A * c₁ + s B * c₂ := by
    rw [hadd, hmul, hmul, hs1, hs2]
  have hA12 : Commute (s A) (c₁ * c₂) := (hA1.symm).mul_right (hA2.symm)
  have hB21 : Commute (s B) (c₂ * c₁) := (hB2.symm).mul_right (hB1.symm)
  have t1 : s A * c₁ * (c₁ * A) = 0 := by
    rw [mul_assoc, ← mul_assoc c₁ c₁ A, hc1, zero_mul, mul_zero]
  have t4 : s B * c₂ * (c₂ * B) = 0 := by
    rw [mul_assoc, ← mul_assoc c₂ c₂ B, hc2, zero_mul, mul_zero]
  have t2 : s A * c₁ * (c₂ * B) = (g + b) * (s A * B) := by
    calc s A * c₁ * (c₂ * B) = s A * (c₁ * c₂) * B := by
          rw [mul_assoc, mul_assoc, mul_assoc]
      _ = (c₁ * c₂) * s A * B := by rw [hA12.eq]
      _ = (g + b) * (s A * B) := by rw [h12, mul_assoc]
  have t3 : s B * c₂ * (c₁ * A) = (g - b) * (s B * A) := by
    calc s B * c₂ * (c₁ * A) = s B * (c₂ * c₁) * A := by
          rw [mul_assoc, mul_assoc, mul_assoc]
      _ = (c₂ * c₁) * s B * A := by rw [hB21.eq]
      _ = (g - b) * (s B * A) := by rw [h21, mul_assoc]
  rw [hsL, add_mul, mul_add, mul_add, t1, t2, t3, t4]
  noncomm_ring

/-- **Closure-current corollary (finding F4 direction).** If the
transport pairing `s(A) B` is `s`-skew (`s(B) A = -(s(A) B)`), the
aperture-shaped part cancels and the square is purely bivector:
`s(L) L = 2 (b (s(A) B))`. Instantiating `s(A) B = -K/2` on the
  two-transport carrier gives the memo's exact representation
  `Q_C = L^# L` - that instantiation is rung L4, queued. -/
theorem closure_current_square (s : R → R)
    (hadd : ∀ x y : R, s (x + y) = s x + s y)
    (hmul : ∀ x y : R, s (x * y) = s y * s x)
    (c₁ c₂ A B g b : R)
    (hs1 : s c₁ = c₁) (hs2 : s c₂ = c₂)
    (hc1 : c₁ * c₁ = 0) (hc2 : c₂ * c₂ = 0)
    (h12 : c₁ * c₂ = g + b) (h21 : c₂ * c₁ = g - b)
    (hA1 : Commute c₁ (s A)) (hA2 : Commute c₂ (s A))
    (hB1 : Commute c₁ (s B)) (hB2 : Commute c₂ (s B))
    (hskew : s B * A = -(s A * B)) :
    s (c₁ * A + c₂ * B) * (c₁ * A + c₂ * B)
      = 2 • (b * (s A * B)) := by
  rw [null_soldered_square s hadd hmul c₁ c₂ A B g b hs1 hs2 hc1 hc2
    h12 h21 hA1 hA2 hB1 hB2, hskew]
  rw [add_neg_cancel, mul_zero, zero_add, sub_neg_eq_add, two_smul,
    mul_add]

/-- **Indexed pointwise-product closure-current square.**  A family of
two-direction closure currents squares componentwise in the pointwise product
ring `ι → R`.

Claim boundary: this is plumbing for indexed families, not the
form-orthogonal direct-sum carrier theorem.  It is not a positivity theorem, and
it does not identify a component sum with a concrete carrier's `Q_C` until a
separate normalization/instantiation theorem supplies the pair index and
signs. -/
theorem closure_current_square_pi {ι : Type*} (s : R → R)
    (hadd : ∀ x y : R, s (x + y) = s x + s y)
    (hmul : ∀ x y : R, s (x * y) = s y * s x)
    (c₁ c₂ A B g b : ι → R)
    (hs1 : ∀ i, s (c₁ i) = c₁ i) (hs2 : ∀ i, s (c₂ i) = c₂ i)
    (hc1 : ∀ i, c₁ i * c₁ i = 0) (hc2 : ∀ i, c₂ i * c₂ i = 0)
    (h12 : ∀ i, c₁ i * c₂ i = g i + b i)
    (h21 : ∀ i, c₂ i * c₁ i = g i - b i)
    (hA1 : ∀ i, Commute (c₁ i) (s (A i)))
    (hA2 : ∀ i, Commute (c₂ i) (s (A i)))
    (hB1 : ∀ i, Commute (c₁ i) (s (B i)))
    (hB2 : ∀ i, Commute (c₂ i) (s (B i)))
    (hskew : ∀ i, s (B i) * A i = -(s (A i) * B i)) :
    (fun i => s (c₁ i * A i + c₂ i * B i))
        * (fun i => c₁ i * A i + c₂ i * B i)
      = fun i => 2 • (b i * (s (A i) * B i)) := by
  funext i
  exact closure_current_square s hadd hmul (c₁ i) (c₂ i) (A i) (B i) (g i) (b i)
    (hs1 i) (hs2 i) (hc1 i) (hc2 i) (h12 i) (h21 i)
    (hA1 i) (hA2 i) (hB1 i) (hB2 i) (hskew i)

end NullSolderedSquare

/-! ## Non-vacuity witness for the square-zero bivector hypotheses -/

section NonvacuityWitness

open GaussianInt

/-- The Gaussian integer `i`, used only for the concrete non-vacuity witness. -/
def witnessI : GaussianInt := ⟨0, 1⟩

/-- First square-zero, transpose-fixed generator in the non-vacuity witness. -/
def witnessC1 : Matrix (Fin 2) (Fin 2) GaussianInt := !![1, witnessI; witnessI, -1]

/-- Second square-zero, transpose-fixed generator in the non-vacuity witness. -/
def witnessC2 : Matrix (Fin 2) (Fin 2) GaussianInt := !![1, -witnessI; -witnessI, -1]

/-- The first witness generator is square-zero. -/
theorem witnessC1_square : witnessC1 * witnessC1 = 0 := by
  decide

/-- The second witness generator is square-zero. -/
theorem witnessC2_square : witnessC2 * witnessC2 = 0 := by
  decide

/-- The first witness generator is fixed by transpose. -/
theorem witnessC1_transpose : witnessC1.transpose = witnessC1 := by
  decide

/-- The second witness generator is fixed by transpose. -/
theorem witnessC2_transpose : witnessC2.transpose = witnessC2 := by
  decide

/-- The witness generators do not commute, so the bivector slot is nonzero. -/
theorem witnessC1_mul_C2_ne_C2_mul_C1 : witnessC1 * witnessC2 ≠ witnessC2 * witnessC1 := by
  decide

end NonvacuityWitness

/-! ## Abstract finite-product form layer for K2 direct-sum stabilization -/

noncomputable section FiniteProductForm

variable {ι V R W : Type*} [Fintype ι] [DecidableEq ι]
variable [CommSemiring R] [AddCommMonoid V] [Module R V]

/-- Include one finite-product component into the product target.

This is the algebraic placeholder for a pair block in the K2 direct-sum route.
It does not choose the physical pair index, signs, or carrier normalization. -/
def componentInclusion (i : ι) : V →ₗ[R] (ι → V) where
  toFun v := Pi.single i v
  map_add' := by
    intro v w
    ext j
    by_cases h : j = i
    · subst j
      simp
    · simp [Pi.single_eq_of_ne h]
  map_smul' := by
    intro a v
    ext j
    by_cases h : j = i
    · subst j
      simp
    · simp [Pi.single_eq_of_ne h]

/-- The finite orthogonal-product bilinear form with component forms `β i`.

For K2 this is the carrier-abstract form-level object whose off-diagonal
orthogonality is proved below. It is not a positivity structure and is not yet
the concrete null-edge carrier's Krein form. -/
abbrev finiteProductForm (β : ι → LinearMap.BilinForm R V) :
    LinearMap.BilinForm R (ι → V) where
  toFun x := {
    toFun := fun y => ∑ i, β i (x i) (y i)
    map_add' := by
      intro y z
      simp [Pi.add_apply, map_add, Finset.sum_add_distrib]
    map_smul' := by
      intro a y
      simp [Pi.smul_apply, map_smul, Finset.mul_sum] }
  map_add' := by
    intro x y
    ext z
    simp [Pi.add_apply, map_add, Finset.sum_add_distrib]
  map_smul' := by
    intro a x
    ext z
    simp [Pi.smul_apply, map_smul, Finset.mul_sum]

/-- A component inclusion is isometric for the matching component form.

This is a finite-product form identity only; it does not identify the component
with a physical closure-current block. -/
theorem finiteProductForm_component_same
    (β : ι → LinearMap.BilinForm R V) (i : ι) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) i) w) = β i v w := by
  classical
  simp only [finiteProductForm, componentInclusion, LinearMap.coe_mk, AddHom.coe_mk]
  rw [Finset.sum_eq_single i]
  · simp
  · intro j _ hji
    simp [Pi.single_eq_of_ne hji]
  · intro hi
    exact False.elim (hi (Finset.mem_univ i))

/-- Distinct component inclusions are orthogonal for `finiteProductForm`.

This is the precise no-cross-term algebraic fact needed before the K2
pair-stabilized direct-sum route can be instantiated on a concrete carrier. -/
theorem finiteProductForm_component_ne
    (β : ι → LinearMap.BilinForm R V) {i j : ι} (hij : i ≠ j) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) j) w) = 0 := by
  classical
  simp only [finiteProductForm, componentInclusion, LinearMap.coe_mk, AddHom.coe_mk]
  apply Finset.sum_eq_zero
  intro k _
  by_cases hki : k = i
  · subst k
    simp [Pi.single_eq_of_ne hij]
  · simp [Pi.single_eq_of_ne hki]

/-- Evaluating the finite-product form on an assembled family is the sum of
component evaluations.

This is the abstract form-level version of "the square of the assembled
pair-current is the sum of pair squares" once the carrier supplies the actual
component forms and maps. -/
theorem finiteProductForm_assemble_eval
    (β : ι → LinearMap.BilinForm R V) (L : ι → W → V) (x y : W) :
    finiteProductForm β (fun i => L i x) (fun i => L i y)
      = ∑ i, β i (L i x) (L i y) := by
  rfl

/-- Reassembling both arguments from component inclusions recovers the component
sum for the finite-product form.

This is carrier-abstract bilinear-form plumbing: it proves block-diagonal total
assembly for `finiteProductForm`. It is not yet a concrete closure-current or
Krein-form theorem. -/
theorem finiteProductForm_total
    (β : ι → LinearMap.BilinForm R V) (v w : ι → V) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (w j))
      = ∑ i, β i (v i) (w i) := by
  simp only [map_sum, LinearMap.coe_sum, Finset.sum_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_eq_single i]
  · rw [finiteProductForm_component_same]
  · intro j _ hj
    rw [finiteProductForm_component_ne _ (Ne.symm hj)]
  · simp

/-- Total-square specialization of `finiteProductForm_total`. -/
theorem finiteProductForm_total_square
    (β : ι → LinearMap.BilinForm R V) (v : ι → V) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (v j))
      = ∑ i, β i (v i) (v i) :=
  finiteProductForm_total β v v

/-- If every component pairing vanishes, then the assembled total pairing
vanishes. -/
theorem finiteProductForm_total_eq_zero_of_forall
    (β : ι → LinearMap.BilinForm R V) (v w : ι → V)
    (h : ∀ i, β i (v i) (w i) = 0) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (w j)) = 0 := by
  rw [finiteProductForm_total]
  exact Finset.sum_eq_zero (fun i _ => h i)

end FiniteProductForm

end PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
