import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option autoImplicit false

/-!
# Mass-shell (energy) projectors `Λ± = (pslash ± m)/2m` of the Dirac operator

This file complements the chiral (Weyl) projectors `P_{L,R} = (1 ∓ γ⁵)/2`
(`ChiralProjectorsDirac`), which split the Dirac spinor by **chirality**, with the
**mass-shell (energy) projectors**

  `Λ₊ = (pslash + m·1)/2m`,  `Λ₋ = (m·1 − pslash)/2m`,

which split the spinor by the **sign of energy** on the mass shell.  The mass `m`
is exactly what makes them well defined: the `1/2m` factor is singular as
`m → 0`, matching the physical fact that a massless spinor has no rest frame and
hence no energy split — only a chirality split (the chiral projectors survive
`m = 0`, the energy projectors do not).  This is the projector-level face of the
program thesis: mass is what turns the massless (chiral) edges into a rest-frame
energy split.

## Model (real Dirac-representation gammas, `(t,z)` plane ⟶ rational 4×4)

We use the PhysLean Dirac-representation gamma matrices, both **real**, restricted
to the `(t,z)` plane, so all matrices are rational (no `Complex`, no
`Real.sqrt/cos/sin`):

* `g0 = diag(1,1,-1,-1)`
* `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`
* `pslash E kz = E • g0 − kz • g3`   (Feynman slash of a momentum in the `(t,z)` plane)

The **on-shell** relation is `E² − kz² = m²` with `m ≠ 0`.

## Results

* `pslash_sq`            : `pslash² = (E² − kz²) • 1`  (`= m² • 1` on shell).
* `projectors_complete`  : `Λ₊ + Λ₋ = 1`.
* `projectors_idempotent`: `Λ₊² = Λ₊` and `Λ₋² = Λ₋`.
* `projectors_orthogonal`: `Λ₊ Λ₋ = 0` and `Λ₋ Λ₊ = 0`.
* `projector_ranks`      : `trace Λ₊ = 2` and `trace Λ₋ = 2` (two positive- and two negative-energy states).
* `massless_singular`    : `2m • Λ₊ = pslash + m • 1` stays finite as `m → 0`, while `Λ₊ ∼ 1/m` diverges.
* `mass_shell_projector_verdict` : the packaged statement, including the explicit on-shell
  witness `E = 5, kz = 3, m = 4`.

## PhysLean provenance

The gamma-matrix convention is that of PhysLean `PhysLean.Relativity.Spinors` /
`spaceTime.gamma` (the Dirac representation, with real `g0`, `g3` in the `(t,z)`
plane used here as a rational avatar), used as a REFERENCE / convention only, NOT
imported.  The physical energy split `(pslash + m)` as the Dirac-propagator
numerator is `[import]` Dirac theory; here it is realized as a finite,
kernel-checked matrix identity.

Draft status: kernel-checked with no proof escape hatches; every headline carries
an in-file `#print axioms` guard pinned to exactly
`[propext, Classical.choice, Quot.sound]`.
-/

namespace MassShellProjectors

open Matrix

/-- PhysLean Dirac-representation `γ⁰ = diag(1,1,-1,-1)` (real, restricted to the `(t,z)` avatar). -/
def g0 : Matrix (Fin 4) (Fin 4) ℚ := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- PhysLean Dirac-representation `γ³` (real, restricted to the `(t,z)` avatar). -/
def g3 : Matrix (Fin 4) (Fin 4) ℚ := !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]

/-- Feynman slash of a momentum in the `(t,z)` plane: `pslash = E • g0 − kz • g3`. -/
def pslash (E kz : ℚ) : Matrix (Fin 4) (Fin 4) ℚ := E • g0 - kz • g3

/-- Positive-energy projector `Λ₊ = (pslash + m·1)/2m`. -/
noncomputable def Lp (E kz m : ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
  (1 / (2 * m)) • (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ))

/-- Negative-energy projector `Λ₋ = (m·1 − pslash)/2m`. -/
noncomputable def Lm (E kz m : ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
  (1 / (2 * m)) • (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz)

/-- **Clifford/mass-shell identity:** `pslash² = (E² − kz²) • 1`.  On shell (`E² − kz² = m²`) this
reads `pslash² = m² • 1`.  Uses `g0² = 1`, `g3² = −1`, `g0 g3 + g3 g0 = 0`, verified entrywise. -/
theorem pslash_sq (E kz : ℚ) :
    pslash E kz * pslash E kz = (E ^ 2 - kz ^ 2) • (1 : Matrix (Fin 4) (Fin 4) ℚ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pslash, g0, g3, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- **Completeness:** `Λ₊ + Λ₋ = 1` (positive + negative energy exhaust the spinor). -/
theorem projectors_complete (E kz m : ℚ) (hm : m ≠ 0) :
    Lp E kz m + Lm E kz m = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Lp, Lm, pslash, g0, g3] <;> field_simp <;> ring

/-- **Idempotence (payload):** `Λ₊² = Λ₊` and `Λ₋² = Λ₋`, using `pslash² = m² • 1` on shell.
For `Λ₊`: `(pslash+m)² = pslash² + 2m·pslash + m² = 2m² + 2m·pslash = 2m·(pslash+m)`, so
`Λ₊² = (2m·(pslash+m))/4m² = (pslash+m)/2m = Λ₊`. -/
theorem projectors_idempotent (E kz m : ℚ) (hm : m ≠ 0) (h : E ^ 2 - kz ^ 2 = m ^ 2) :
    Lp E kz m * Lp E kz m = Lp E kz m ∧ Lm E kz m * Lm E kz m = Lm E kz m := by
  constructor
  · -- Λ₊² = Λ₊
    have hM : (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) *
        (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) =
        (2 * m) • (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) := by
      simp only [add_mul, mul_add, Matrix.mul_smul, Matrix.smul_mul, one_mul, mul_one,
        pslash_sq, h, smul_smul]
      module
    rw [Lp, Matrix.smul_mul, Matrix.mul_smul, hM, smul_smul, smul_smul]
    congr 1
    field_simp
  · -- Λ₋² = Λ₋
    have hM : (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz) *
        (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz) =
        (2 * m) • (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz) := by
      simp only [sub_mul, mul_sub, Matrix.mul_smul, Matrix.smul_mul, one_mul, mul_one,
        pslash_sq, h, smul_smul]
      module
    rw [Lm, Matrix.smul_mul, Matrix.mul_smul, hM, smul_smul, smul_smul]
    congr 1
    field_simp

/-- **Orthogonality (payload):** `Λ₊ Λ₋ = 0` and `Λ₋ Λ₊ = 0`, since
`(pslash+m)(m−pslash) = m² − pslash² = 0` on shell. -/
theorem projectors_orthogonal (E kz m : ℚ) (h : E ^ 2 - kz ^ 2 = m ^ 2) :
    Lp E kz m * Lm E kz m = 0 ∧ Lm E kz m * Lp E kz m = 0 := by
  constructor
  · have hM : (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) *
        (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz) = 0 := by
      simp only [add_mul, mul_sub, Matrix.mul_smul, Matrix.smul_mul, one_mul, mul_one,
        pslash_sq, h, smul_smul]
      module
    rw [Lp, Lm, Matrix.smul_mul, Matrix.mul_smul, hM, smul_zero, smul_zero]
  · have hM : (m • (1 : Matrix (Fin 4) (Fin 4) ℚ) - pslash E kz) *
        (pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ)) = 0 := by
      simp only [sub_mul, mul_add, Matrix.mul_smul, Matrix.smul_mul, one_mul, mul_one,
        pslash_sq, h, smul_smul]
      module
    rw [Lp, Lm, Matrix.smul_mul, Matrix.mul_smul, hM, smul_zero, smul_zero]

/-- **Ranks:** `trace Λ₊ = 2` and `trace Λ₋ = 2` (two positive- and two negative-energy states).
Since `trace pslash = 0`, `trace Λ₊ = (0 + 4m)/2m = 2`. -/
theorem projector_ranks (E kz m : ℚ) (hm : m ≠ 0) :
    Matrix.trace (Lp E kz m) = 2 ∧ Matrix.trace (Lm E kz m) = 2 := by
  constructor
  · simp [Lp, pslash, g0, g3, Matrix.trace, Matrix.diag, Fin.sum_univ_succ]
    field_simp
    ring
  · simp [Lm, pslash, g0, g3, Matrix.trace, Matrix.diag, Fin.sum_univ_succ]
    field_simp
    ring

/-- **Mass-role contrast (honest scope):** the *rescaled* projector `2m • Λ₊ = pslash + m • 1` stays
finite as `m → 0`.  But `Λ₊` itself carries the `1/2m` factor, so `Λ₊ ∼ 1/m` **diverges** as `m → 0`:
the energy split genuinely needs the mass (unlike the chirality split `P_{L,R} = (1 ∓ γ⁵)/2`, which
survives `m = 0`).  We record the finite identity; the divergence of `Λ₊` itself is the reason `Λ±`
are defined only for `m ≠ 0`. -/
theorem massless_singular (E kz m : ℚ) (hm : m ≠ 0) :
    (2 * m) • Lp E kz m = pslash E kz + m • (1 : Matrix (Fin 4) (Fin 4) ℚ) := by
  rw [Lp, smul_smul, show (2 * m) * (1 / (2 * m)) = 1 by field_simp, one_smul]

/-- **Verdict (package).**  `Λ± = (pslash ± m)/2m` are a complete pair of orthogonal idempotents
(`Λ₊+Λ₋=1`, `Λ₊²=Λ₊`, `Λ₋²=Λ₋`, `Λ₊Λ₋=0`, `Λ₋Λ₊=0`, `trace Λ₊ = trace Λ₋ = 2`) splitting the Dirac
spinor by the sign of energy on the mass shell `pslash² = m² • 1`; they are singular as `m → 0`.
This grounds the `(pslash + m)` Dirac-propagator numerator in the PhysLean gamma convention.

The second component is the mandatory explicit on-shell witness `E = 5, kz = 3, m = 4`
(`m² = 16`, `pslash² = 16 • 1`, `Λ₊` a genuine projector with `trace = 2`, and `Λ₊ ≠ 0`, `Λ₊ ≠ 1`). -/
theorem mass_shell_projector_verdict :
    (∀ E kz m : ℚ, m ≠ 0 → E ^ 2 - kz ^ 2 = m ^ 2 →
        Lp E kz m + Lm E kz m = 1 ∧
        Lp E kz m * Lp E kz m = Lp E kz m ∧
        Lm E kz m * Lm E kz m = Lm E kz m ∧
        Lp E kz m * Lm E kz m = 0 ∧
        Lm E kz m * Lp E kz m = 0 ∧
        Matrix.trace (Lp E kz m) = 2 ∧
        Matrix.trace (Lm E kz m) = 2) ∧
      (pslash 5 3 * pslash 5 3 = (16 : ℚ) • (1 : Matrix (Fin 4) (Fin 4) ℚ) ∧
        Lp 5 3 4 * Lp 5 3 4 = Lp 5 3 4 ∧
        Matrix.trace (Lp 5 3 4) = 2 ∧
        Lp 5 3 4 ≠ 0 ∧
        Lp 5 3 4 ≠ 1) := by
  refine ⟨fun E kz m hm h => ⟨projectors_complete E kz m hm, ?_, ?_, ?_, ?_, ?_, ?_⟩,
      ?_, ?_, ?_, ?_, ?_⟩
  · exact (projectors_idempotent E kz m hm h).1
  · exact (projectors_idempotent E kz m hm h).2
  · exact (projectors_orthogonal E kz m h).1
  · exact (projectors_orthogonal E kz m h).2
  · exact (projector_ranks E kz m hm).1
  · exact (projector_ranks E kz m hm).2
  · -- pslash² = 16 • 1 at the witness
    have := pslash_sq 5 3
    norm_num at this ⊢
    exact this
  · exact (projectors_idempotent 5 3 4 (by norm_num) (by norm_num)).1
  · exact (projector_ranks 5 3 4 (by norm_num)).1
  · -- Λ₊ ≠ 0
    intro hc
    have h00 := congrFun (congrFun hc 0) 0
    simp [Lp, pslash, g0, g3] at h00
    norm_num at h00
  · -- Λ₊ ≠ 1
    intro hc
    have h02 := congrFun (congrFun hc 0) 2
    simp [Lp, pslash, g0, g3] at h02

-- Axiom footprint checks (exactly `propext, Classical.choice, Quot.sound`).
/-- info: 'MassShellProjectors.pslash_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pslash_sq

/-- info: 'MassShellProjectors.projectors_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_complete

/-- info: 'MassShellProjectors.projectors_idempotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_idempotent

/-- info: 'MassShellProjectors.projectors_orthogonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_orthogonal

/-- info: 'MassShellProjectors.projector_ranks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projector_ranks

/-- info: 'MassShellProjectors.massless_singular' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_singular

/-- info: 'MassShellProjectors.mass_shell_projector_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_shell_projector_verdict

end MassShellProjectors
