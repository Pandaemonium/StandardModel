import Mathlib

/-!
# Target/mirror finite spectral algebra: a witness-and-no-go audit

This file is a finite, exact toy layer supporting the "one anomaly-free
generation via target/mirror decoupling" grand strategy (see
`CODEX_TARGET_MIRROR_GRAND_STRATEGY_2026-07-13.md`).

We fix a `4`-dimensional single-particle space, split into a **target** block
(indices `0,1`) and a **mirror** block (indices `2,3`).  Two structures act on it:

* a **chirality grading** `Γ = diag(1,1,-1,-1)` — target is `+1`, mirror is `-1`;
* a **gauge charge operator** `Q = diag q` — gauge invariance of an operator `M`
  means `M` commutes with `Q` (charge conservation).

A **relativistic mass** is a Hermitian operator that *anticommutes* with the
chirality grading (`AntiChi`); a **chemical-potential / Wilson-type** operator
*commutes* with it.  This distinction is the whole game: it is what separates a
genuine mass gap of a Dirac/Weyl cone from a trivial energy shift.

The results below are all finite, kernel-checked linear algebra over `ℚ`.  They
establish four things and are honest about what they do **not** establish:

1. `chiral_mass_forces_zero` — for a genuinely *chiral* charge assignment
   (mirror in the conjugate rep, no charge-matched pairs) there is **no** nonzero
   gauge-invariant relativistic mass at all.
2. `mass_same_chirality_zero` / `mass_pairs_target_mirror` — *any* relativistic
   mass has a vanishing mirror-mirror block and only connects target to mirror:
   "a quadratic mass merely pairs target and mirror."
3. `vectorlike_gauge_mass_exists` — in the vector-like case a gauge-invariant
   mass exists, but (by 2) it is purely a target↔mirror pairing (a Dirac mass) —
   the doubling.
4. `chemicalPotential_*` — the naive finite bundle "gauge invariant + block
   diagonal + annihilates target + positive spectral gap on the mirror" is
   satisfied by a **trivial** chemical potential that is *not* a mass
   (`chemicalPotential_not_mass`).  Hence that bundle is **vacuous** as a
   decoupling claim; the physical content is in hypotheses that are *not* finite
   (locality, symmetry non-breaking, and gap survival in the thermodynamic
   limit).  A genuinely nonzero rational gap certificate is nonetheless exhibited
   (`mirror_gap_witness`) as pure linear algebra.

Nothing here proves anomaly cancellation, a Standard Model representation,
many-body symmetric mass generation, a thermodynamic gap, or a physical chiral
gauge theory.

Provenance: clean-room finite linear algebra returned by Aristotle job
`f0d38cd0-cdec-46ef-800b-b588e3e07740`, then namespace-adapted and
semantically narrowed for the live project.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo

/-- Chirality grading: target (`0,1`) is `+1`, mirror (`2,3`) is `-1`. -/
def chi : Fin 4 → ℚ
  | 0 => 1 | 1 => 1 | 2 => -1 | 3 => -1

/-- A **chiral** charge assignment: mirror carries the conjugate charges of the
target, and no target charge equals any mirror charge. -/
def qChiral : Fin 4 → ℚ
  | 0 => 2 | 1 => 3 | 2 => -2 | 3 => -3

/-- A **vector-like** charge assignment: mirror carries the *same* charges as the
target (target `i` is paired with mirror `i+2`). -/
def qVec : Fin 4 → ℚ
  | 0 => 2 | 1 => 3 | 2 => 2 | 3 => 3

/-- Gauge invariance of `M`: it commutes with the charge operator `diagonal d`. -/
def CommDiag (d : Fin 4 → ℚ) (M : Matrix (Fin 4) (Fin 4) ℚ) : Prop :=
  M * Matrix.diagonal d = Matrix.diagonal d * M

/-- `M` is a *relativistic mass*: it anticommutes with the chirality grading. -/
def AntiChi (M : Matrix (Fin 4) (Fin 4) ℚ) : Prop :=
  M * Matrix.diagonal chi = - (Matrix.diagonal chi * M)

/-- Entrywise form of gauge invariance: `M i j (d j - d i) = 0`. -/
theorem comm_entry {d M} (h : CommDiag d M) (i j : Fin 4) :
    M i j * d j = d i * M i j := by
  have := congrFun (congrFun h i) j
  simpa [Matrix.mul_diagonal, Matrix.diagonal_mul] using this

/-- Entrywise form of the mass condition: `M i j (χ j + χ i) = 0`. -/
theorem anti_entry {M} (h : AntiChi M) (i j : Fin 4) :
    M i j * chi j = - (chi i * M i j) := by
  have := congrFun (congrFun h i) j
  simpa [Matrix.mul_diagonal, Matrix.diagonal_mul] using this

/-!
## 1.  The sharp chiral no-go

For a genuinely chiral spectrum there is **no** nonzero gauge-invariant mass.
-/

/-- **Chiral no-go.** With the chiral charge assignment, any gauge-invariant
relativistic mass is identically zero.  Physically: a chiral fermion cannot be
given a symmetric quadratic (bilinear) mass — the origin of the chiral-gauge
regularization obstruction. -/
theorem chiral_mass_forces_zero {M} (hc : CommDiag qChiral M) (ha : AntiChi M) :
    M = 0 := by
  ext i j
  have e1 := comm_entry hc i j
  have e2 := anti_entry ha i j
  fin_cases i <;> fin_cases j <;>
    simp only [chi, qChiral, Matrix.zero_apply] at e1 e2 ⊢ <;> linarith

/-!
## 2.  Any relativistic mass merely pairs target and mirror

This holds for *every* charge assignment: it is a consequence of the chirality
grading alone.
-/

/-- A relativistic mass has vanishing entries between states of equal chirality;
in particular its **mirror-mirror block is zero**, so it cannot gap the mirror by
itself. -/
theorem mass_same_chirality_zero {M} (ha : AntiChi M) {i j : Fin 4}
    (h : chi i = chi j) : M i j = 0 := by
  have e2 := anti_entry ha i j
  have hj : chi j = chi i := h.symm
  rw [hj] at e2
  have hchi : chi i = 1 ∨ chi i = -1 := by fin_cases i <;> simp [chi]
  rcases hchi with h1 | h1 <;> rw [h1] at e2 <;> linarith

/-- **"A quadratic mass merely pairs target and mirror."**  Any nonzero entry of
a relativistic mass connects opposite chiralities, i.e. a target index to a
mirror index (or vice versa). -/
theorem mass_pairs_target_mirror {M} (ha : AntiChi M) {i j : Fin 4}
    (h : M i j ≠ 0) : chi i ≠ chi j :=
  fun hchi => h (mass_same_chirality_zero ha hchi)

/-!
## 3.  Vector-like case: a gauge mass exists, but it is exactly the pairing
-/

/-- An explicit nonzero gauge-invariant relativistic mass in the *vector-like*
case: the Dirac pairing of target mode `0` with mirror mode `2`. -/
def diracMass : Matrix (Fin 4) (Fin 4) ℚ :=
  Matrix.of ![![0,0,1,0],![0,0,0,0],![1,0,0,0],![0,0,0,0]]

theorem diracMass_antiChi : AntiChi diracMass := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diracMass, chi, Matrix.mul_diagonal, Matrix.diagonal_mul]

theorem diracMass_gaugeInv : CommDiag qVec diracMass := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diracMass, qVec, Matrix.mul_diagonal, Matrix.diagonal_mul]

theorem diracMass_ne_zero : diracMass ≠ 0 := by
  intro h
  have := congrFun (congrFun h 0) 2
  simp [diracMass] at this

/-- The witness mass only has target↔mirror entries: its target-target and
mirror-mirror blocks vanish. -/
theorem diracMass_only_cross {i j : Fin 4} (h : chi i = chi j) : diracMass i j = 0 :=
  mass_same_chirality_zero diracMass_antiChi h

/-!
## 4.  The vacuity trap: a positive mirror gap is trivially satisfiable

The finite bundle "gauge invariant + no target-mirror matrix elements +
annihilates the target + positive spectral gap on the mirror" is satisfied by a
trivial *chemical potential* `diag(0,0,1,1)`, which is **not** a mass.  So that
bundle alone certifies nothing about chiral decoupling.
-/

/-- Mirror-projector chemical potential `diag(0,0,1,1)`. -/
def chemicalPotential : Matrix (Fin 4) (Fin 4) ℚ :=
  Matrix.diagonal ![0,0,1,1]

/-- It is gauge invariant for *every* charge assignment (both are diagonal). -/
theorem chemicalPotential_gaugeInv (d : Fin 4 → ℚ) : CommDiag d chemicalPotential := by
  unfold CommDiag chemicalPotential
  rw [Matrix.diagonal_mul_diagonal, Matrix.diagonal_mul_diagonal]
  ext i j; simp [mul_comm]

/-- It has no target↔mirror matrix elements (it is diagonal). -/
theorem chemicalPotential_no_cross {i j : Fin 4} (h : i ≠ j) :
    chemicalPotential i j = 0 := by
  simp [chemicalPotential, Matrix.diagonal_apply_ne _ h]

/-- It annihilates the target: rows `0,1` are zero. -/
theorem chemicalPotential_annihilates_target (j : Fin 4) :
    chemicalPotential 0 j = 0 ∧ chemicalPotential 1 j = 0 := by
  constructor <;> fin_cases j <;> simp [chemicalPotential, Matrix.diagonal]

/-- Its mirror block is the identity — a (trivial) positive gap of `1`. -/
theorem chemicalPotential_mirror_id :
    chemicalPotential 2 2 = 1 ∧ chemicalPotential 3 3 = 1 := by
  constructor <;> simp [chemicalPotential, Matrix.diagonal]

/-- **The point of the vacuity trap.**  Despite satisfying the entire finite
bundle above, the chemical potential is *not* a relativistic mass: it commutes,
rather than anticommutes, with the chirality grading. -/
theorem chemicalPotential_not_mass : ¬ AntiChi chemicalPotential := by
  intro h
  have := anti_entry h 2 2
  rw [(chemicalPotential_mirror_id).1] at this
  simp only [chi] at this
  norm_num at this

/-!
## 5.  A genuinely nonzero rational spectral-gap certificate

As pure linear algebra, a nontrivial mirror block can have a certified positive
spectral gap.  Here `B = [[2,1],[1,2]]` satisfies `⟨x, B x⟩ ≥ 1 · ‖x‖²` with the
bound saturated at `x = (1,-1)`, so the least eigenvalue (spectral gap above `0`)
is exactly `1 > 0`.  A sum-of-squares certificate proves the lower bound. -/
theorem mirror_gap_witness (x0 x1 : ℚ) :
    2 * x0 ^ 2 + 2 * (x0 * x1) + 2 * x1 ^ 2 ≥ 1 * (x0 ^ 2 + x1 ^ 2) := by
  nlinarith [sq_nonneg (x0 + x1)]

/-- Saturation: the gap `1` is sharp (attained at `x = (1,-1)`). -/
theorem mirror_gap_sharp :
    2 * (1 : ℚ) ^ 2 + 2 * (1 * (-1)) + 2 * (-1) ^ 2 = 1 * ((1 : ℚ) ^ 2 + (-1) ^ 2) := by
  norm_num

/-- But such a nontrivial (off-diagonal) mirror block is **not** gauge invariant
under the chiral (distinct-charge) assignment: charge conservation forces the
mirror block of any gauge-invariant operator to be diagonal.  So a certified
positive gap and gauge invariance with a chiral spectrum are in tension at the
quadratic level — the off-diagonal gap must come from a many-body (quartic)
operator, not a bilinear. -/
theorem gauge_mirror_diagonal {M} (hc : CommDiag qChiral M) {i j : Fin 4}
    (hij : (i = 2 ∧ j = 3) ∨ (i = 3 ∧ j = 2)) : M i j = 0 := by
  rcases hij with ⟨hi, hj⟩ | ⟨hi, hj⟩
  · subst hi; subst hj
    have e1 := comm_entry hc 2 3; simp only [qChiral] at e1; linarith
  · subst hi; subst hj
    have e1 := comm_entry hc 3 2; simp only [qChiral] at e1; linarith

end PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.chiral_mass_forces_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.chiral_mass_forces_zero

/-- info: 'PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.chemicalPotential_not_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.chemicalPotential_not_mass

/-- info: 'PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.mirror_gap_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TargetMirrorBilinearNoGo.mirror_gap_witness
