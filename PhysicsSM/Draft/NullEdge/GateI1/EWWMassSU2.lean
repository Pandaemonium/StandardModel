import Mathlib

/-!
# Electroweak `W`-mass from an SU(2) transfer block (draft)

This file ties the electroweak `W`-mass to an **SU(2)-flavored transfer
structure** in a small, fully finite toy model.  We build a transfer block
carrying:

* a **neutral vacuum** sector with transfer eigenvalue `lamVac`, and
* a **charged (`W`-like) sector** — the SU(2) fundamental `j = 1/2` doublet,
  of complex dimension `2` — with transfer eigenvalue `lamCharged`.

The charged sector is *strictly subleading*, `lamCharged < lamVac`, exactly as
a massive excitation sits above the vacuum in an Osterwalder–Schrader (OS)
transfer-matrix picture.  Passing to the (lattice) Hamiltonian `H = -log T`
turns transfer eigenvalues `λ` into energies `E = -log λ`, and the `W`-like mass
is the **Hamiltonian gap** between the charged and vacuum sectors:

`wMass = E_charged - E_vac = -log lamCharged + log lamVac = -log (lamCharged / lamVac)`.

We prove:

* `wMass_pos`  : `0 < wMass B`  (a genuine positive mass gap),
* `wMass_eq_hamGap` : `wMass` equals the Hamiltonian energy gap,
* gauge invariance: `wMass` depends only on the transfer spectrum, hence is
  unchanged when the transfer operator is replaced by any conjugate
  representative `P⁻¹ T P` (`wMass_gauge_invariant`).

This reuses the two/three-level OS-gap pattern (a finite transfer spectrum with
a distinguished subleading sector).

**Honesty note.**  This is a *finite transfer-spectrum charged-sector gap
motivated by SU(2) electroweak structure*.  It is **not** the physical
`W`/Higgs mass mechanism, and it does **not** model electroweak symmetry
breaking: there is no gauge field, no scalar doublet dynamics, and the numbers
`lamVac, lamCharged` are inputs, not outputs of a Higgs potential.  The content
is the OS-style statement "a strictly subleading charged transfer sector yields
a positive, spectrum-only (gauge-invariant) Hamiltonian gap".
-/

open scoped BigOperators
open scoped Real

namespace PhysicsSM.Draft.NullEdge.GateI1.EWWMassSU2

/-- Complex dimension of the SU(2) fundamental (`j = 1/2`) charged sector: the
`W`-like doublet has dimension `2`.  Recorded to make the SU(2) flavor explicit;
the transfer block treats the doublet's common transfer eigenvalue as a single
`lamCharged`. -/
def su2FundamentalDim : ℕ := 2

/-- A small SU(2)-flavored transfer block: a neutral vacuum sector with transfer
eigenvalue `lamVac`, and a charged (`W`-like, fundamental `j = 1/2`) sector with
transfer eigenvalue `lamCharged`.  Both eigenvalues are positive (reflection
positivity / a positive transfer operator) and the charged sector is strictly
subleading, `lamCharged < lamVac`. -/
structure TransferBlock where
  /-- Transfer eigenvalue of the neutral vacuum sector (the leading eigenvalue). -/
  lamVac : ℝ
  /-- Transfer eigenvalue of the charged (`W`-like) sector. -/
  lamCharged : ℝ
  /-- The vacuum transfer eigenvalue is positive. -/
  vac_pos : 0 < lamVac
  /-- The charged transfer eigenvalue is positive. -/
  charged_pos : 0 < lamCharged
  /-- The charged sector is strictly subleading (massive excitation). -/
  charged_subleading : lamCharged < lamVac

namespace TransferBlock

variable (B B' : TransferBlock)

/-- The (lattice) Hamiltonian energy of a sector with transfer eigenvalue `lam`,
via `H = -log T`, i.e. `E = -log lam`. -/
noncomputable def energy (lam : ℝ) : ℝ := -Real.log lam

/-- The Hamiltonian gap between the charged and the vacuum sector. -/
noncomputable def hamGap : ℝ := energy B.lamCharged - energy B.lamVac

/-- The `W`-like mass: the Hamiltonian gap between the charged and vacuum
sectors, `wMass = -log (lamCharged / lamVac)`. -/
noncomputable def wMass : ℝ := -Real.log (B.lamCharged / B.lamVac)

/-
The `W`-mass is exactly the Hamiltonian energy gap between the charged and
vacuum sectors.
-/
theorem wMass_eq_hamGap : B.wMass = B.hamGap := by
  unfold TransferBlock.wMass TransferBlock.hamGap;
  unfold energy; rw [ Real.log_div ] <;> linarith [ B.charged_pos, B.vac_pos ] ;

/-
The `W`-like mass is strictly positive: a genuine mass gap.
-/
theorem wMass_pos : 0 < B.wMass := by
  exact neg_pos.mpr ( Real.log_neg ( div_pos B.charged_pos B.vac_pos ) ( by rw [ div_lt_one B.vac_pos ] ; exact B.charged_subleading ) )

theorem wMass_nonneg : 0 ≤ B.wMass := le_of_lt B.wMass_pos

/-
The charged/vacuum ratio lies strictly between `0` and `1`.
-/
theorem ratio_mem_Ioo : B.lamCharged / B.lamVac ∈ Set.Ioo (0 : ℝ) 1 := by
  exact ⟨ div_pos B.charged_pos B.vac_pos, by rw [ div_lt_iff₀ B.vac_pos ] ; linarith [ B.charged_subleading ] ⟩

/-! ### Matrix realization and gauge (conjugation) invariance -/

/-- The `2 × 2` transfer matrix realizing the block: `diag (lamVac, lamCharged)`
in the sector basis (vacuum ⊕ charged representative).  This is the two-level
OS-gap realization. -/
def toMatrix : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal ![B.lamVac, B.lamCharged]

@[simp] theorem trace_toMatrix : B.toMatrix.trace = B.lamVac + B.lamCharged := by
  unfold TransferBlock.toMatrix; aesop;

@[simp] theorem det_toMatrix : B.toMatrix.det = B.lamVac * B.lamCharged := by
  unfold TransferBlock.toMatrix; norm_num [ Matrix.det_fin_two ] ;

/-- Two transfer blocks are **gauge equivalent** when their transfer matrices are
related by conjugation (a change of transfer representative / basis):
`B'.toMatrix = P⁻¹ * B.toMatrix * P` for some invertible `P`. -/
def GaugeEquiv : Prop :=
  ∃ P : (Matrix (Fin 2) (Fin 2) ℝ)ˣ, B'.toMatrix = P⁻¹.val * B.toMatrix * P.val

/-
Conjugation preserves the trace of the transfer matrix.
-/
theorem GaugeEquiv.trace_eq (h : GaugeEquiv B B') :
    B'.toMatrix.trace = B.toMatrix.trace := by
      obtain ⟨ P, hP ⟩ := h;
      rw [ hP, Matrix.trace_mul_comm ];
      norm_num [ ← mul_assoc ]

/-
Conjugation preserves the determinant of the transfer matrix.
-/
theorem GaugeEquiv.det_eq (h : GaugeEquiv B B') :
    B'.toMatrix.det = B.toMatrix.det := by
      obtain ⟨ P, hP ⟩ := h;
      simp +decide [ hP, Matrix.det_mul ];
      rw [ inv_mul_eq_div, div_mul_cancel₀ _ ( by intro h; simpa [ h ] using P.isUnit.map ( Matrix.detMonoidHom ) ) ]

/-
Two ordered positive pairs with equal sum and equal product coincide. This is
the elementary fact that lets us recover individual eigenvalues from the
conjugation-invariant trace and determinant, given the ordering `charged < vac`.
-/
theorem ordered_pair_unique {a b a' b' : ℝ}
    (hsum : a + b = a' + b') (hprod : a * b = a' * b')
    (hlt : b < a) (hlt' : b' < a') : a = a' ∧ b = b' := by
      grind

/-- **Gauge invariance of the spectrum.**  Gauge-equivalent transfer blocks have
the same vacuum and charged eigenvalues: the transfer spectrum (hence all
physics extracted from it) is independent of the transfer representative up to
conjugation. -/
theorem GaugeEquiv.spectrum_eq (h : GaugeEquiv B B') :
    B'.lamVac = B.lamVac ∧ B'.lamCharged = B.lamCharged := by
  have htr := h.trace_eq
  have hdet := h.det_eq
  rw [trace_toMatrix, trace_toMatrix] at htr
  rw [det_toMatrix, det_toMatrix] at hdet
  have := ordered_pair_unique (a := B'.lamVac) (b := B'.lamCharged)
    (a' := B.lamVac) (b' := B.lamCharged) htr hdet
    B'.charged_subleading B.charged_subleading
  exact this

/-- **Gauge invariance of the `W`-mass.**  The `W`-like mass is unchanged under a
change of transfer representative up to conjugation; it is a function of the
transfer spectrum alone. -/
theorem wMass_gauge_invariant (h : GaugeEquiv B B') : B'.wMass = B.wMass := by
  obtain ⟨hv, hc⟩ := h.spectrum_eq
  unfold wMass
  rw [hv, hc]

/-- **Summary.**  For any SU(2)-flavored transfer block the `W`-like mass is a
strictly positive Hamiltonian gap, and it is gauge invariant (spectrum-only). -/
theorem wMass_pos_and_gauge_invariant :
    0 < B.wMass ∧ ∀ B'', GaugeEquiv B B'' → B''.wMass = B.wMass :=
  ⟨B.wMass_pos, fun _ h => B.wMass_gauge_invariant _ h⟩

end TransferBlock

end PhysicsSM.Draft.NullEdge.GateI1.EWWMassSU2
