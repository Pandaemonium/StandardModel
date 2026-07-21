import Mathlib

/-!
# Equal internal spectrum does not fix an arbitrary external readout

Independent Opus (Claude-family) contribution to the origin-of-mass gap-to-pole
gate (`MASS-ORIGIN-001`, track A gate A4) and a finite overlap control for the
Visionary "pole falsifier" (Codex synthesis 2026-07-20, falsifier #4). The
honest conclusion is narrower than that original label: internal spectral data
do not determine a fixed external readout unless that readout is itself encoded
by the spectral data.

## Intended reading

Fix a one-dimensional physical sector, the direction `e0 = (1,0)` of
`ℂ²`.  For a Hermitian involution `H` with `H^2 = 1` and `trace H = 0` the
spectrum is exactly `{-1, +1}`, and the spectral projector onto the `-1`
eigenspace is the Lagrange element `specProj H = (1 - H)/2`. The *selected
readout weight* at the lower gap edge is the overlap
`physWeight H = ⟨e0, specProj H e0⟩ = (specProj H) 0 0`. In the usual finite
spectral decomposition, this coefficient is the residue carried by that edge
in the corresponding resolvent matrix element; the resolvent identity itself
is not formalized in this module.

The main theorem exhibits two matrices with the *identical spectrum* (they are
unitarily conjugate, so every similarity/spectral invariant — in particular the
gap `2` — agrees) whose selected readout weights are `1` and `0`. The result is a
finite overlap obstruction: one fixed external direction is blind to the lower edge in
the weight-zero case. This is the algebraic distinction needed before comparing
with propagator-zero responses in the symmetric-mass-generation literature
(arXiv:2311.12790, arXiv:2412.19691, and arXiv:2101.01026), but it does not
itself construct an interacting propagator zero.

## SCOPE CORRECTION (docstring audit `364a29ac`)

This proves only that ONE FIXED, non-conjugacy-invariant observable can distinguish
unitarily conjugate involutions. Do NOT state it as the unqualified "a spectral gap
does not determine physical mass".

SECOND CORRECTION (meta-audit `a21c13e4`): my first attempt at the honest form -
"internal spectral data do not determine an external readout that is not itself
determined by that spectral data" - is VACUOUS; it repeats "not determined" as its own
premise. I over-corrected into a tautology. The sharp NON-vacuous statement is the
explicit one: THERE EXISTS A PAIR with EQUAL spectral data and UNEQUAL external
readouts - exhibited here for `C^2`, and in every finite dimension by
`GapPoleGeneralObstruction`. Cite the existential pair, not the tautology.

## Claim grade and scope

`M` (machine-verified finite fact), `[orig]` framing.  This is a finite linear
algebra obstruction.  It does **not** compute any physical mass, does **not**
concern the actual HNU quasienergy spectrum, and does **not** by itself refute
any landed theorem.  Its role is to make the A4 semantic obligation exact: any
"internal gap = physical mass" statement must supply the physical-sector
embedding as independent data, because the gap is blind to it.

Provenance: statement and proof are this repository's own (clean-room finite
construction); the physics framing follows the SMG/propagator-zero sources
above, logged in the dated origin-of-mass literature memo.
-/

namespace PhysicsSM.Draft.NullEdge.GapPoleResponseObstruction

open Matrix

/-- The Lagrange spectral projector onto the `-1` eigenspace of a Hermitian
involution with vanishing trace: `(1 - H)/2`. -/
noncomputable def specProj (H : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2⁻¹ : ℂ) • (1 - H)

/-- The physical spectral weight at the lower gap edge in the fixed direction
`e0 = (1,0)`. In a finite resolvent decomposition this is the coefficient of
the lower-edge pole; no resolvent theorem is asserted here. -/
noncomputable def physWeight (H : Matrix (Fin 2) (Fin 2) ℂ) : ℂ :=
  specProj H 0 0

/-- Under the spectrum hypotheses `H^2 = 1` (with `trace H = 0` giving the two
eigenvalues `±1`), the Lagrange element is idempotent: a genuine projector. -/
theorem specProj_idem (H : Matrix (Fin 2) (Fin 2) ℂ)
    (hInv : H * H = 1) : specProj H * specProj H = specProj H := by
  have hexp : (1 - H) * (1 - H) = (2 : ℂ) • (1 - H) := by
    have hx : (1 - H) * (1 - H) = 1 - H - H + H * H := by noncomm_ring
    rw [hx, hInv]; module
  simp only [specProj, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  rw [hexp, smul_smul]
  have h2 : (2⁻¹ * 2⁻¹ * 2 : ℂ) = 2⁻¹ := by norm_num
  rw [h2]

/-- The projector annihilates the `+1` eigenspace: `(H + 1) * specProj H = 0`,
so `range (specProj H)` lies in the `-1` eigenspace. -/
theorem specProj_annihilates (H : Matrix (Fin 2) (Fin 2) ℂ)
    (hInv : H * H = 1) : (H + 1) * specProj H = 0 := by
  have h : (H + 1) * specProj H = (2⁻¹ : ℂ) • ((H + 1) * (1 - H)) := by
    simp [specProj, Matrix.mul_smul]
  rw [h]
  have hx : (H + 1) * (1 - H) = 1 - H * H := by noncomm_ring
  rw [hx, hInv]
  simp

/-- The ordinary mass-pole model: `diag(-1, +1)`.  The physical sector `e0`
sits entirely in the `-1` eigenspace, so the lower gap edge is a full pole. -/
def Hpole : Matrix (Fin 2) (Fin 2) ℂ := !![(-1 : ℂ), 0; 0, 1]

/-- The hidden-edge model: `diag(+1, -1)`. The physical direction `e0` is
orthogonal to the `-1` eigenspace, so its lower-edge spectral weight vanishes. -/
def Hdark : Matrix (Fin 2) (Fin 2) ℂ := !![(1 : ℂ), 0; 0, -1]

/-- The equal-weight model `[[0,1],[1,0]]`: physical weight `1/2`. -/
def Hhalf : Matrix (Fin 2) (Fin 2) ℂ := !![(0 : ℂ), 1; 1, 0]

/-- The swap unitary conjugating `Hpole` to `Hdark`. -/
def swap2 : Matrix (Fin 2) (Fin 2) ℂ := !![(0 : ℂ), 1; 1, 0]

theorem Hpole_involution : Hpole * Hpole = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Hpole, Matrix.mul_apply, Fin.sum_univ_two]

theorem Hdark_involution : Hdark * Hdark = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Hdark, Matrix.mul_apply, Fin.sum_univ_two]

theorem Hpole_trace : Hpole.trace = 0 := by
  simp [Hpole, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

theorem Hdark_trace : Hdark.trace = 0 := by
  simp [Hdark, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

theorem Hpole_herm : Hpoleᴴ = Hpole := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Hpole, Matrix.conjTranspose_apply]

theorem Hdark_herm : Hdarkᴴ = Hdark := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Hdark, Matrix.conjTranspose_apply]

theorem swap2_involution : swap2 * swap2 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [swap2, Matrix.mul_apply, Fin.sum_univ_two]

theorem swap2_herm : swap2ᴴ = swap2 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [swap2, Matrix.conjTranspose_apply]

/-- `Hpole` and `Hdark` are unitarily conjugate: they have the **identical
spectrum**, hence every spectral invariant (the gap `2` included) agrees. -/
theorem Hpole_conj_Hdark : swap2 * Hpole * swap2 = Hdark := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [swap2, Hpole, Hdark, Matrix.mul_apply, Fin.sum_univ_two]

theorem physWeight_Hpole : physWeight Hpole = 1 := by
  simp [physWeight, specProj, Hpole]
  norm_num

theorem physWeight_Hdark : physWeight Hdark = 0 := by
  simp [physWeight, specProj, Hdark]

theorem physWeight_Hhalf : physWeight Hhalf = 2⁻¹ := by
  simp [physWeight, specProj, Hhalf]

/-- **The gap-to-pole obstruction.**  There exist two Hermitian involutions of
`ℂ²` that are unitarily conjugate — identical spectrum `{-1,+1}`, identical gap
`2` — yet whose physical two-point weight at the lower gap edge differs
maximally (`1` versus `0`).  Hence this ONE FIXED, non-conjugacy-invariant
readout is not determined by the spectrum: reading it requires the
physical-sector embedding as independent data.  (Audit `364a29ac`: this is the
honest form; it is NOT the unqualified claim that a spectral gap fails to
determine physical mass.) -/
theorem gap_does_not_fix_pole :
    ∃ H₁ H₂ : Matrix (Fin 2) (Fin 2) ℂ,
      (H₁ᴴ = H₁ ∧ H₁ * H₁ = 1 ∧ H₁.trace = 0) ∧
      (H₂ᴴ = H₂ ∧ H₂ * H₂ = 1 ∧ H₂.trace = 0) ∧
      (∃ U : Matrix (Fin 2) (Fin 2) ℂ, Uᴴ = U ∧ U * U = 1 ∧ U * H₁ * U = H₂) ∧
      physWeight H₁ ≠ physWeight H₂ := by
  refine ⟨Hpole, Hdark, ⟨Hpole_herm, Hpole_involution, Hpole_trace⟩,
    ⟨Hdark_herm, Hdark_involution, Hdark_trace⟩,
    ⟨swap2, swap2_herm, swap2_involution, Hpole_conj_Hdark⟩, ?_⟩
  rw [physWeight_Hpole, physWeight_Hdark]
  norm_num

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.GapPoleResponseObstruction.gap_does_not_fix_pole' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gap_does_not_fix_pole

end PhysicsSM.Draft.NullEdge.GapPoleResponseObstruction
