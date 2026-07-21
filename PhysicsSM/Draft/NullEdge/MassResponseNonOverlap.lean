import Mathlib

/-!
# Mass-response non-overlap: the chirality-parity separation and its exact limit

Supporting facts for the origin-of-mass mechanism matrix (AFPL gate A0,
non-double-counting law). Kernel-checked realization of the parity separation
between the mass-response operator classes, and - importantly - the exact
statement of WHERE parity fails.

Result summary (over `ℂ²` with chirality grading `Γ = diag(1,-1)`):

- the chirality-ODD (off-diagonal) turn block - the fermion / Yukawa mass
  response - anticommutes with `Γ`;
- the chirality-EVEN (diagonal) block - the gauge-orbit Gram and the Higgs
  potential-Hessian responses - commutes with `Γ`;
- odd and even blocks are Hilbert-Schmidt orthogonal, so a fermion-mass response
  that is genuinely `Gamma`-ODD cannot double-count against a gauge/Higgs response
  that is genuinely `Gamma`-EVEN (self-audit `01de0e45` caveat: this is a
  CONDITIONAL parity statement - it delivers physical non-overlap only under the
  hypothesis that the actual response operators satisfy those `Gamma` parities;
  it is not an unconditional claim about arbitrary operators);
- **but evenness alone does NOT give orthogonality**: two even blocks (the
  gauge Gram and the Higgs Hessian) need not be Hilbert-Schmidt orthogonal, so
  their non-overlap law is NOT parity but TYPED DOMAINS / provenance (the gauge
  Gram lives on the generator-image space, the Higgs Hessian on the
  scalar-normal fluctuation space). `even_even_not_orthogonal` is the exact
  obstruction.

Provenance: statements verified independently at the pinned toolchain from the
Aristotle strategy return `93652564-f5c4-4fa3-bc5a-a8a734ab554a`
(task `2a0215f7`, run for the AFPL A0 exhaustiveness/SMG analysis;
`REPORT.md` in that job carries the full classification). Clean-room Mathlib
port; standard three axioms. This corrects the naive "parity separates all
rows" reading in the Opus origin-of-mass memo
(`AutonomousLab/work/NE-DYNAMICS/OPUS_LITERATURE_ORIGIN_OF_MASS_CLASSIFICATION_2026-07-20.md`):
parity separates ODD from EVEN only; even-vs-even needs typed domains.

Claim grade `M`, `[comp]` (independently verified reproduction of an
Aristotle-returned classification lemma set).
-/

namespace PhysicsSM.Draft.NullEdge.MassResponseNonOverlap

/-- Complex `2 × 2` matrices: one left- and one right-handed mode. -/
abbrev C2Matrix := Matrix (Fin 2) (Fin 2) ℂ

/-- The chirality grading `Γ = diag(1, -1)`. -/
def chirality : C2Matrix := !![(1 : ℂ), 0; 0, -1]

/-- A general chirality-odd (off-diagonal) block: the fermion-mass turn form. -/
def oddBlock (z w : ℂ) : C2Matrix := !![0, z; w, 0]

/-- A general chirality-even (diagonal) block: the gauge-Gram / Higgs-Hessian
form. -/
def evenBlock (a b : ℂ) : C2Matrix := !![a, 0; 0, b]

/-- The Hilbert-Schmidt inner product, written entrywise. -/
noncomputable def hsInner (A B : C2Matrix) : ℂ :=
  ∑ i, ∑ j, star (A i j) * B i j

/-- Off-diagonal (fermion-mass) blocks anticommute with chirality. -/
theorem oddBlock_anticommutes (z w : ℂ) :
    chirality * oddBlock z w = -(oddBlock z w * chirality) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [chirality, oddBlock, Matrix.mul_apply]

/-- Diagonal (gauge/Higgs) blocks commute with chirality. -/
theorem evenBlock_commutes (a b : ℂ) :
    chirality * evenBlock a b = evenBlock a b * chirality := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [chirality, evenBlock, Matrix.mul_apply]

/-- **Non-overlap of the fermion-mass row against the gauge/Higgs rows.**
Chirality-odd and chirality-even blocks are Hilbert-Schmidt orthogonal. -/
theorem odd_even_hilbertSchmidt_orthogonal (z w a b : ℂ) :
    hsInner (oddBlock z w) (evenBlock a b) = 0 := by
  simp [hsInner, oddBlock, evenBlock, Fin.sum_univ_two]

/-- **The exact limit of the parity argument.**  Evenness alone does NOT make
two responses orthogonal: the gauge-orbit Gram and the Higgs potential Hessian
are both even, so chirality cannot separate them - their non-overlap must come
from typed domains (generator-image space versus scalar-normal fluctuation
space), not parity. -/
theorem even_even_not_orthogonal :
    hsInner (evenBlock 1 0) (evenBlock 1 0) = 1 := by
  simp [hsInner, evenBlock, Fin.sum_univ_two]

/-- The odd and even block subspaces intersect only at zero. -/
theorem oddBlock_eq_evenBlock_iff (z w a b : ℂ) :
    oddBlock z w = evenBlock a b ↔ z = 0 ∧ w = 0 ∧ a = 0 ∧ b = 0 := by
  constructor
  · intro h
    have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
    have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
    have h10 := congrFun (congrFun h (1 : Fin 2)) (0 : Fin 2)
    have h11 := congrFun (congrFun h (1 : Fin 2)) (1 : Fin 2)
    simp [oddBlock, evenBlock] at h00 h01 h10 h11
    exact ⟨h01, h10, h00.symm, h11.symm⟩
  · rintro ⟨rfl, rfl, rfl, rfl⟩
    rfl

end PhysicsSM.Draft.NullEdge.MassResponseNonOverlap
