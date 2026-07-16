import Mathlib

/-!
# An exact finite transverse-kernel lift of a Pauli-Weyl symbol

This file carries out the theorem ladder requested in
`AgentTasks/afpl-domain-wall-weyl-aristotle-2026-07-13.md`.

## Strategy

We add one finite transverse direction, model it by a connected Hermitian
nearest-neighbour SSH-like chain with a one-dimensional kernel, and tensor its
kernel with a tangential continuum Pauli symbol.  The resulting kernel sector
carries that symbol exactly.  This is a finite algebraic precursor to a
domain-wall construction, not a domain-wall Dirac operator or a lattice
solution of the doubling problem.

## Three-site witness

The explicit three-site chain has a left-weighted kernel vector and an exact
rank-one square certificate `M^2 = 5 I - w w^T`.  The file proves these facts
for this witness only.  It does not classify longer chains or prove minimality.

## Coefficients

Hoppings `t = 1` (intra-cell) and `s = 2` (inter-cell), rational, with
`|t| < |s|` so the zero mode decays away from the left boundary.

Provenance: clean-room finite matrix formalization returned by Aristotle job
`9eb52ec3-fafd-4db5-aa32-fe41c9f9e953`, then semantically narrowed for the live
project.  The returned domain-wall and anomaly-inflow interpretation was not
retained because the displayed operator is a separable transverse-chain plus
continuum-symbol sum.
-/

namespace PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift

open Matrix

/-! ## Section 1 — the transverse Hermitian chain (over `ℝ`)

`Mchain` is the finite nearest-neighbour Hermitian chain: three sites, bonds of
strength `1` and `2`, zero on-site energy (chiral/bipartite structure). -/

/-- A transverse SSH-like chain: a real symmetric tridiagonal
nearest-neighbour matrix with rational entries and vanishing diagonal. -/
def Mchain : Matrix (Fin 3) (Fin 3) ℝ := !![0, 1, 0; 1, 0, 2; 0, 2, 0]

/-- The exact left-weighted zero mode `w = (2, 0, -1)`.
It is supported on the two sublattice-A sites `0` and `2` (both nonzero, so it
is *not* a basis vector and *not* produced by a disconnected zero row), with the
weight concentrated on the boundary site `0`. -/
def w : Fin 3 → ℝ := ![2, 0, -1]

/-- `Mchain` is Hermitian (here: real symmetric). -/
theorem Mchain_isHermitian : Mchain.IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Mchain, Matrix.conjTranspose_apply]

/-- The chain is *connected*: every row has a nonzero entry, so there is no
disconnected zero row that could produce a fake (basis-vector) kernel. -/
theorem Mchain_no_zero_row : ∀ i, ∃ j, Mchain i j ≠ 0 := by
  intro i
  fin_cases i
  · exact ⟨1, by simp [Mchain]⟩
  · exact ⟨0, by simp [Mchain]⟩
  · exact ⟨1, by simp [Mchain]⟩

/-- The zero mode is nonzero. -/
theorem w_ne_zero : w ≠ 0 := by
  intro h; have := congrFun h 0; simp [w] at this

/-- Exact left-weighting data: the mode is supported on both endpoints
(`w 0 ≠ 0` and `w 2 ≠ 0`, so it is connected, not a single basis vector), it
vanishes on the interior sublattice-B site (`w 1 = 0`, the chiral structure),
and its weight strictly decreases from the boundary, `|w 2| < |w 0|`, with exact
decay ratio `|w 2| / |w 0| = 1/2 = t/s`. -/
theorem w_localized :
    w 0 = 2 ∧ w 1 = 0 ∧ w 2 = -1 ∧ w 0 ≠ 0 ∧ w 2 ≠ 0 ∧ |w 2| < |w 0| := by
  refine ⟨rfl, rfl, rfl, ?_, ?_, ?_⟩
  · rw [show w 0 = (2:ℝ) from rfl]; norm_num
  · rw [show w 2 = (-1:ℝ) from rfl]; norm_num
  · rw [show w 2 = (-1:ℝ) from rfl, show w 0 = (2:ℝ) from rfl]; norm_num

/-- **Item 1–2 (kernel membership).** The mode is in the exact kernel. -/
theorem Mchain_mulVec_w : Mchain *ᵥ w = 0 := by
  funext i
  fin_cases i <;>
    simp [Mchain, w, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- **Exact spectral certificate.** The square of the chain is a rank-one
perturbation of a scalar: `Mchain² = 5·I − w wᵀ`.  This is the exact
characteristic-polynomial / sum-of-squares data behind the whole spectrum:
the nonzero eigenvalues are `±√5` (doubly degenerate `M²`-eigenvalue `5`) and
the single kernel direction `w` carries `M²`-eigenvalue `0`. -/
theorem Mchain_sq_certificate :
    Mchain * Mchain = (5 : ℝ) • (1 : Matrix (Fin 3) (Fin 3) ℝ) - vecMulVec w w := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Mchain, w, Matrix.mul_apply, Fin.sum_univ_three] <;> norm_num

/-- **Item 4 (gap identity).** For every vector,
`‖Mchain v‖² = 5‖v‖² − ⟨w, v⟩²`.  This is the exact quadratic form; it makes the
complement gap unconditional (no assumed spectrum). -/
theorem gap_identity (v : Fin 3 → ℝ) :
    (Mchain *ᵥ v) ⬝ᵥ (Mchain *ᵥ v) = 5 * (v ⬝ᵥ v) - (w ⬝ᵥ v) ^ 2 := by
  simp only [Mchain, w, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- **Item 4 (complement gap).** On the orthogonal complement of the kernel
(`⟨w, v⟩ = 0`) the operator satisfies the exact isometry-up-to-scale
`‖Mchain v‖² = 5‖v‖²`.  Hence every nonzero vector orthogonal to `w` has
`‖Mchain v‖² ≥ 5‖v‖²` with the uniform positive gap `√5`; the spectrum is not
assumed but derived from `gap_identity`. -/
theorem complement_gap (v : Fin 3 → ℝ) (h : w ⬝ᵥ v = 0) :
    (Mchain *ᵥ v) ⬝ᵥ (Mchain *ᵥ v) = 5 * (v ⬝ᵥ v) := by
  rw [gap_identity, h]; ring

/-- The complement gap is *nonvacuous and tight*: `v = (0,1,0)` is a nonzero
vector orthogonal to `w` for which `‖Mchain v‖² = 5 = 5‖v‖²`.  So `√5` is
actually attained, not a vacuous lower bound. -/
theorem complement_gap_tight :
    let v : Fin 3 → ℝ := ![0, 1, 0]
    v ≠ 0 ∧ w ⬝ᵥ v = 0 ∧ (Mchain *ᵥ v) ⬝ᵥ (Mchain *ᵥ v) = 5 ∧ v ⬝ᵥ v = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h; have := congrFun h 1; simp at this
  · simp [w, dotProduct, Fin.sum_univ_three]
  · simp [Mchain, Matrix.mulVec, dotProduct, Fin.sum_univ_three]; norm_num
  · simp [dotProduct, Fin.sum_univ_three]

/-- A vector is in the kernel iff it is a scalar multiple of `w`. -/
theorem mem_ker_iff (v : Fin 3 → ℝ) : Mchain *ᵥ v = 0 ↔ ∃ c : ℝ, v = c • w := by
  constructor
  · intro h
    have h0 := congrFun h 0
    have h1 := congrFun h 1
    have h2 := congrFun h 2
    simp [Mchain, Matrix.mulVec, dotProduct, Fin.sum_univ_three] at h0 h1 h2
    refine ⟨-(v 2), ?_⟩
    funext i; fin_cases i <;> simp [w] <;> linarith
  · rintro ⟨c, rfl⟩
    rw [Matrix.mulVec_smul, Mchain_mulVec_w, smul_zero]

/-- **Item 3 (kernel as a submodule).** The exact kernel is the line `ℝ ∙ w`. -/
theorem kernel_eq_span :
    LinearMap.ker (Mchain.mulVecLin) = Submodule.span ℝ {w} := by
  ext v
  rw [LinearMap.mem_ker, Matrix.mulVecLin_apply, Submodule.mem_span_singleton, mem_ker_iff]
  constructor
  · rintro ⟨c, rfl⟩; exact ⟨c, rfl.symm⟩
  · rintro ⟨c, rfl⟩; exact ⟨c, rfl.symm⟩

/-- The exact kernel of this three-site witness is one-dimensional. -/
theorem kernel_finrank :
    Module.finrank ℝ (LinearMap.ker (Mchain.mulVecLin)) = 1 := by
  rw [kernel_eq_span, finrank_span_singleton w_ne_zero]

/-! ## Section 2 — the tangential Pauli symbol and the finite Weyl lift (over `ℂ`)

We reuse the same chain over `ℂ` (`Mc`, `wc`) and tensor it with the spin
factor `ℂ²` on which the Pauli matrices act. -/

/-- The transverse chain over `ℂ`. -/
def Mc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 2; 0, 2, 0]

/-- The transverse zero mode over `ℂ`. -/
def wc : Fin 3 → ℂ := ![2, 0, -1]

/-- Pauli `X`. -/
def pauliX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `Y`. -/
def pauliY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]

/-- Pauli `Z`. -/
def pauliZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The tangential three-momentum **Weyl symbol** `H_W(k) = k·σ`. -/
def pauliSym (kx ky kz : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (kx : ℂ) • pauliX + (ky : ℂ) • pauliY + (kz : ℂ) • pauliZ

/-- **Item 5 (full finite operator).** The finite operator on the tensor space
`ℂ³ ⊗ ℂ²` at tangential momentum `k`:
`H(k) = Mchain ⊗ I₂ + I₃ ⊗ (k·σ)`. -/
def Hfull (kx ky kz : ℝ) : Matrix (Fin 3 × Fin 2) (Fin 3 × Fin 2) ℂ :=
  kroneckerMap (· * ·) Mc (1 : Matrix (Fin 2) (Fin 2) ℂ)
    + kroneckerMap (· * ·) (1 : Matrix (Fin 3) (Fin 3) ℂ) (pauliSym kx ky kz)

/-- The embedding of the spin factor onto the transverse kernel sector:
`e ↦ w ⊗ e`. -/
def embed (e : Fin 2 → ℂ) : Fin 3 × Fin 2 → ℂ := fun p => wc p.1 * e p.2

/-- The zero mode over `ℂ` lies in the kernel of `Mc`. -/
theorem Mc_mulVec_wc : Mc *ᵥ wc = 0 := by
  funext i
  fin_cases i <;>
    simp [Mc, wc, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- The embedding is nonvacuous/injective in the strong sense: a nonzero spinor
maps to a nonzero kernel state (the restricted sector is genuinely two-dimensional,
not collapsed). -/
theorem embed_ne_zero {e : Fin 2 → ℂ} (he : e ≠ 0) : embed e ≠ 0 := by
  intro h
  apply he
  funext s
  simpa [embed, wc] using congrFun h (0, s)

/-- **Item 5 (Hermiticity of the full operator).** `H(k)` is Hermitian for real
momenta. -/
theorem Hfull_isHermitian (kx ky kz : ℝ) : (Hfull kx ky kz).IsHermitian := by
  ext i j
  obtain ⟨i1, i2⟩ := i; obtain ⟨j1, j2⟩ := j
  fin_cases i1 <;> fin_cases i2 <;> fin_cases j1 <;> fin_cases j2 <;>
    simp [Hfull, Mc, pauliSym, pauliX, pauliY, pauliZ, Matrix.conjTranspose_apply,
      kroneckerMap_apply]

/-- Exact kernel-sector restriction/intertwining.  The full finite operator,
restricted to the transverse kernel sector, is exactly the Pauli-Weyl symbol:
for every spinor `e`,
`H(k) · (w ⊗ e) = w ⊗ ((k·σ) · e)`.
Equivalently `embed ∘ (k·σ) = H(k) ∘ embed`.  This is not a local periodic
three-dimensional lattice realization. -/
theorem weyl_restriction (kx ky kz : ℝ) (e : Fin 2 → ℂ) :
    (Hfull kx ky kz) *ᵥ (embed e) = embed ((pauliSym kx ky kz) *ᵥ e) := by
  funext p
  obtain ⟨i, s⟩ := p
  simp only [Hfull, embed, Matrix.mulVec, Matrix.add_apply, dotProduct,
    kroneckerMap_apply, Fintype.sum_prod_type]
  fin_cases i <;> fin_cases s <;>
    simp [Mc, wc, pauliSym, pauliX, pauliY, pauliZ, Fin.sum_univ_three, Fin.sum_univ_two,
      Matrix.one_apply] <;> ring

/-! ### Chirality witness

The Weyl symbol is `H_W(k) = k·σ`.  Extracting Pauli coordinates via
`c_a(k) = ½ tr(σ_a H_W(k))` recovers `c = (kx, ky, kz)`, so the velocity
Jacobian `∂c_a/∂k_b` is the identity, whose determinant is `+1`.  This is local
symbol data; it does not prove globally isolated chirality on a periodic
Brillouin zone. -/

/-- Pauli-`X` coordinate recovery: `tr(σ_x · H_W(k)) = 2 kx`. -/
theorem trace_pauliX (kx ky kz : ℝ) :
    (pauliX * pauliSym kx ky kz).trace = 2 * (kx : ℂ) := by
  simp [pauliX, pauliSym, pauliY, pauliZ, Matrix.trace, Matrix.diag, Fin.sum_univ_two,
    Matrix.mul_apply]; ring

/-- Pauli-`Y` coordinate recovery: `tr(σ_y · H_W(k)) = 2 ky`. -/
theorem trace_pauliY (kx ky kz : ℝ) :
    (pauliY * pauliSym kx ky kz).trace = 2 * (ky : ℂ) := by
  simp [pauliX, pauliSym, pauliY, pauliZ, Matrix.trace, Matrix.diag, Fin.sum_univ_two,
    Matrix.mul_apply]
  ring_nf
  rw [Complex.I_sq]; ring

/-- Pauli-`Z` coordinate recovery: `tr(σ_z · H_W(k)) = 2 kz`. -/
theorem trace_pauliZ (kx ky kz : ℝ) :
    (pauliZ * pauliSym kx ky kz).trace = 2 * (kz : ℂ) := by
  simp [pauliX, pauliSym, pauliY, pauliZ, Matrix.trace, Matrix.diag, Fin.sum_univ_two,
    Matrix.mul_apply]; ring

/-- The chirality Jacobian: the `3×3` real matrix of velocity coefficients
`∂c_a/∂k_b`, which by `trace_pauli*` equals the identity. -/
def chiralityJacobian : Matrix (Fin 3) (Fin 3) ℝ := !![1, 0, 0; 0, 1, 0; 0, 0, 1]

/-- Determinant-sign witness for the displayed local Pauli symbol:
`det(∂c_a/∂k_b) = 1 > 0`. -/
theorem chirality_det : chiralityJacobian.det = 1 := by
  simp [chiralityJacobian, Matrix.det_fin_three]

theorem chirality_pos : 0 < chiralityJacobian.det := by
  rw [chirality_det]; norm_num

/-! ## Scope of the result

The exact finite content is a connected three-site Hermitian chain with a
one-dimensional kernel, a rank-one square certificate, an exact quadratic
identity on its orthogonal complement, and an intertwining of the kernel sector
with the continuum Pauli symbol.

This does **not** yet establish a domain-wall fermion or an escape from lattice
doubling.  The tangential factor is the nonperiodic continuum symbol `k · sigma`,
not a local operator on a three-dimensional lattice.  The additive lift also
lacks the anticommuting gamma-matrix coupling of a domain-wall Dirac operator.
No opposite-chirality partner, bulk invariant, anomaly inflow, primitive-null
update, gauge coupling, or thermodynamic statement is identified here.

The complement identity concerns `Mchain` alone.  It must not be read as a
uniform gap for the separable full operator `Hfull`, whose two commuting
summands can have cancelling eigenvalues.  Finally, `w = (2, 0, -1)` is an exact
left-weighted vector on a three-site chain, not a proved asymptotically localized
boundary state in a chain family.
-/

/-- The three-dimensional Pauli spin factor `ℂ²`. -/
abbrev Spin := Fin 2

/-! ## Assumption-footprint pins

These guards prevent a later edit from silently adding nonstandard assumptions
to the structural results used by the 3+1 program.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift.Mchain_sq_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Mchain_sq_certificate

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift.complement_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complement_gap

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift.kernel_finrank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kernel_finrank

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift.weyl_restriction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_restriction

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift.chirality_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_det

end PhysicsSM.Draft.NullEdge.FiniteTransverseWeylLift
