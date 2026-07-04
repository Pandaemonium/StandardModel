import Mathlib
import PhysicsSM.Draft.NullEdge.GateC2.GaugeIndexInertiaForm
import PhysicsSM.Draft.NullEdge.GateC2.HermitianSylvester

/-!
# Gate C2: the 2D Wilson-Dirac zero-to-nonzero flux index (PROOF TARGET)

PROOF TARGET for Aristotle. This is the even-lattice / 2D-torus successor to
the `pi`-flux triangle (`FluxOverlapIndex`, which showed a nonzero index at
EVERY flux, an odd-cycle parity artifact). Here the target is a genuine
ZERO-to-NONZERO flux-driven index jump on an `L=4` torus, per the design and
oracle validation in
`AgentTasks/nerd-gate-c2-next-frontier-2d-flux-plan-2026-07-03.md`
(the block reduction and per-block congruences below are oracle-verified
EXACTLY by computer algebra - `Scripts/oracle/validate_flux2d_wilson_dirac.py`
plus the session's scratch scripts - and are given here as concrete data, not
targets themselves; every `sorry` below is a genuinely new KERNEL proof
obligation).

## Physics content (context, not needed for the proofs)

2D Wilson-Dirac operator on an `L=4` torus, two link-charge sectors:
`H = sigma_x (x) D_x + sigma_y (x) D_y + sigma_z (x) (m + W)`,
`D_mu = (T_mu - T_mu^dag)/(2i)`, `W = 2 - (T_x+T_x^dag)/2 - (T_y+T_y^dag)/2`,
`m = -1`, with `T_x` carrying a Landau-gauge phase `exp(-2 pi i Q y / 4)`
(`Q=1`: genuine gauge flux, gauge-invariant holonomy `exp(2 pi i/4)` per
plaquette, `L*Q=4` total flux quanta; `Q=0`: trivial/free). Chirality
`gamma5U = 1 (x) sigma_z` (traceless).

Oracle facts (verified exactly, `L=4, m=-1`): `H` is Hermitian and gapped for
BOTH `Q=0,1`; the PLAIN `x`-translation (not the charge-carrying shift) is a
symmetry in this Landau gauge (nothing depends on `x`), and its 4-point
discrete Fourier transform block-diagonalizes `H` into 4 blocks of `8 x 8`
(one per `x`-momentum `k in {0,1,2,3}`), each block Gaussian-RATIONAL (no
surds - `L=4`'s momentum phases are 4th roots of unity). Each block's
eigenvalues are cubic-irrational (casus irreducibilis) - the EIGENVALUE route
is hopeless - but an EXPLICIT Gaussian-rational congruence
`S_k^dag * B_k * S_k = D_k` (rational diagonal, Sylvester-exact) was found by
pivoted symmetric elimination for all 8 blocks (4 per charge), verified
exactly against the source blocks. Inertia sums: `Q=1`: `-8` (index `+4`
against traceless `gamma5U`); `Q=0`: `0` (balanced). This is the finite
zero-to-nonzero flux witness.

## What is proved here

* Section 1: the lattice building blocks (`Fin 4 x Fin 4` sites, `Fin 2`
  spin), the two Hermitian Hamiltonians `HFlux`, `HFree`, and the traceless
  chirality `gamma5U`.
* Section 2: the plain-`x` Fourier block-diagonalization unitary `Ufour` and
  its unitarity.
* Section 3: the 8 explicit `8x8` blocks (`B{Flux,Free}{0,1,2,3}`) and the
  block-diagonalization identity for each charge (`Ufour * H * Ufourᴴ` is
  block-diagonal with these blocks).
* Section 4: the 8 explicit congruences (`S{Flux,Free}{k}`,
  `D{Flux,Free}{k}`) with `S_k^dag * B_k * S_k = diagonal D_k` exactly.
* Section 5: assembling sections 2-4 into ONE combined congruence
  `T^dag * H * T = (diagonal of all 32 D-values)` per charge via
  `Matrix.mul_assoc`, then `HermitianSylvester.congruence_preserves_inertia`
  gives the eigenvalue-sign counts of `H` directly from the known diagonal.
* Section 6: THE CAPSTONE - `overlapIndex gamma5U (epsCFC HFlux) = 4` and
  `overlapIndex gamma5U (epsCFC HFree) = 0`, via
  `gaugeOverlap_index_eigenvalue_count_form` (already proved, imported).

## General proof strategy notes (verified by hand where marked; use freely)

* **Hermitian-ness of `HFlux`/`HFree`.** Both `T_x` variants and `T_y` are
  SPARSE shift matrices (each row/column has exactly one nonzero entry); the
  Dirac term `(T-T^dag)/(2i)` is manifestly Hermitian by construction for any
  `T`, as is the Wilson term `2 - (T+T^dag)/2` (symmetrized). The full `H` is
  a sum of Kronecker products of Hermitian pieces with Hermitian Pauli
  matrices, hence Hermitian. This should reduce to `ext` + case-splitting on
  the finite index type + `simp`/`norm_num` on the sparse pattern, not dense
  1024-entry computation - use the sparsity (`if` conditions) rather than
  expanding everything.
* **`Ufour` unitarity.** `Ufour` is (up to the `1/2` normalization from
  `sqrt(4)`) the 4-point DFT tensored with the identity on `(y, spin)`.
  Unitarity reduces to the DISCRETE FOURIER ORTHOGONALITY identity
  `sum_{x} exp(2 pi i (k-k') x / 4) = 4 * [k = k']` (a finite geometric sum,
  provable via `Finset.geom_sum_eq` or direct case analysis on
  `k - k' mod 4 in {0,1,2,3}` using the four explicit 4th-root-of-unity
  values `{1,i,-1,-i}` and `Finset.sum_fin_eq_sum_range`-style unfolding
  followed by `ring`/`norm_num` on each of the 4 cases). This is a clean,
  general, well-known fact; do not brute-force a dense 32x32 product.
* **Block-diagonalization identity (`Ufour * H * Ufourᴴ` matches `B_k` on
  block `k`, zero off `k`-diagonal).** Same DFT-orthogonality mechanism:
  expand the matrix product as a `Finset.sum` over the shared `x`-index (or
  `x, x'`) and use orthogonality to collapse it to the `k=k'` block, matching
  the given `B_k` numeric entries. The off-block-diagonal vanishing and the
  on-block value should follow from the SAME orthogonality lemma as the
  unitarity check; consider proving one shared orthogonality lemma first and
  reusing it for both.
* **The 8 block congruences (`S_k^dag * B_k * S_k = diagonal D_k`).** Purely
  finite `8x8` complex-rational matrix arithmetic with EXPLICIT entries;
  `norm_num [Matrix.mul_apply, Fin.sum_univ_eight]`-style entrywise expansion
  (or `decide`-adjacent tactics on the rational arithmetic) should close
  these directly - no search needed, only computation.
* **Assembling the combined congruence.** With `T := Ufourᴴ * Sblock` (where
  `Sblock` is the block-diagonal matrix built from the 4 `S_k`'s per
  charge), `Tᴴ * H * T = Sblockᴴ * (Ufour * H * Ufourᴴ) * Sblock`, and since
  `Ufour * H * Ufourᴴ` is block-diagonal with blocks `B_k` and `Sblock` is
  block-diagonal with blocks `S_k`, their product is block-diagonal with
  blocks `S_k^dag * B_k * S_k = D_k` - i.e. `Tᴴ * H * T` is the genuine
  DIAGONAL matrix built from all 32 `D`-values. This step is matrix algebra
  (associativity + substitution of the already-established identities), not
  fresh computation - it should not require rediscovering any numbers.
* **Diagonal eigenvalue-sign counts.** For a matrix `Matrix.diagonal (fun i
  => (d i : ℂ))` with `d : n -> ℝ`, the eigenvalue-sign counts (`#{i : 0 <
  eigenvalues _ i}` etc.) equal the sign counts of `d` directly. This should
  follow the SAME machinery already used inside the imported
  `HermitianSylvester.congruence_preserves_inertia` (the `qform`/
  `maxPosDimF`/`maxPosDimF_eq_posCard` chain, reusable since none of those
  declarations are `private`): for a diagonal matrix, `qform` IS already the
  weighted form with `E = LinearEquiv.refl` and weights `d`, so
  `maxPosDimF_eq_posCard` applies directly without invoking the general
  spectral theorem. Prove this once as a general helper and reuse for both
  `Q=0,1`.
* **Invertibility.** Each `D_k` list has NO zero entries (verified); hence
  the assembled diagonal is invertible, hence (via the congruence, with `T`
  invertible since `Ufour` unitary and each `S_k` invertible - `det(S_k) !=
  0`, verified) `H` is invertible. Needed for the `[Invertible H]` instance
  consumed by `epsCFC`/`gaugeOverlap_index_eigenvalue_count_form`.

## Deliverables

No `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. Do NOT change any stated theorem;
helper lemmas/defs may be added freely, and the proof route may deviate from
the notes above if a cleaner path is found - but the numeric data (blocks,
congruences) must not be altered, since it has been independently verified.
If a stated identity appears false, STOP and report rather than adjusting
the data silently.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace FluxOverlapIndex2D

open Matrix
open scoped Kronecker ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface

attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

/-! ## Section 1: lattice building blocks -/

/-- Lattice sites of the `4 x 4` torus, `(x, y)`. -/
abbrev Site := Fin 4 × Fin 4

/-- Pauli `sigma_x`. -/
def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `sigma_y`. -/
def sigmaY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]

/-- Pauli `sigma_z`. -/
def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Forward `x`-shift, Landau-gauge phase `exp(-2 pi i Q y / 4)` for the
`Q=1` (flux) sector: phases `(1, -i, -1, i)` for `y = 0,1,2,3`. -/
def TxFlux : Matrix Site Site ℂ :=
  Matrix.of fun (p : Site) (q : Site) =>
    if q.1 = p.1 + 1 ∧ q.2 = p.2 then
      (![(1 : ℂ), -Complex.I, -1, Complex.I] p.2)
    else 0

/-- Forward `x`-shift, trivial phase (the `Q=0` / free sector). -/
def TxFree : Matrix Site Site ℂ :=
  Matrix.of fun (p : Site) (q : Site) => if q.1 = p.1 + 1 ∧ q.2 = p.2 then 1 else 0

/-- Forward `y`-shift, trivial phase (shared by both sectors). -/
def Ty : Matrix Site Site ℂ :=
  Matrix.of fun (p : Site) (q : Site) => if q.1 = p.1 ∧ q.2 = p.2 + 1 then 1 else 0

/-- The 2D Wilson-Dirac Hamiltonian built from a given `x`-shift `tx`. -/
def wilsonDirac (tx : Matrix Site Site ℂ) (m : ℂ) : Matrix (Site × Fin 2) (Site × Fin 2) ℂ :=
  let dx := (1 / (2 * Complex.I)) • (tx - tx.conjTranspose)
  let dy := (1 / (2 * Complex.I)) • (Ty - Ty.conjTranspose)
  let wilson := (2 : ℂ) • (1 : Matrix Site Site ℂ)
    - (1 / 2 : ℂ) • (tx + tx.conjTranspose) - (1 / 2 : ℂ) • (Ty + Ty.conjTranspose)
  dx ⊗ₖ sigmaX + dy ⊗ₖ sigmaY + (m • (1 : Matrix Site Site ℂ) + wilson) ⊗ₖ sigmaZ

/-- The `Q=1` (genuine gauge flux) Wilson-Dirac Hamiltonian, `m = -1`. -/
def HFlux : Matrix (Site × Fin 2) (Site × Fin 2) ℂ := wilsonDirac TxFlux (-1)

/-- The `Q=0` (free) Wilson-Dirac Hamiltonian, `m = -1`. -/
def HFree : Matrix (Site × Fin 2) (Site × Fin 2) ℂ := wilsonDirac TxFree (-1)

/-- The traceless chirality `gamma5U = 1 (x) sigma_z`. -/
def gamma5U : Matrix (Site × Fin 2) (Site × Fin 2) ℂ := (1 : Matrix Site Site ℂ) ⊗ₖ sigmaZ

theorem gamma5U_sq : gamma5U * gamma5U = 1 := by
  sorry

theorem HFlux_isHermitian : HFlux.IsHermitian := by
  sorry

theorem HFree_isHermitian : HFree.IsHermitian := by
  sorry

/-! ## Section 2: the plain-x Fourier block-reduction unitary -/

/-- Plain-`x`-momentum Fourier unitary (trivial on `(y, spin)`):
`Ufour[(k,y,s), (x,y',s')] = (1/2) exp(-2 pi i k x / 4) [y=y'][s=s']`. -/
def Ufour : Matrix (Site × Fin 2) (Site × Fin 2) ℂ :=
  Matrix.of fun (p : Site × Fin 2) (q : Site × Fin 2) =>
    if p.1.2 = q.1.2 ∧ p.2 = q.2 then
      Complex.exp (-2 * Real.pi * Complex.I * (p.1.1 : ℂ) * (q.1.1 : ℂ) / 4) / 2
    else 0

theorem Ufour_unitary : Ufour * Ufour.conjTranspose = 1 := by
  sorry

/-! ## Section 3: the 8 explicit 8x8 blocks (Gaussian-rational, oracle-exact) -/

def BFlux0 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ)]

def BFlux1 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ)]

def BFlux2 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ)]

def BFlux3 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ)]

def BFree0 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ)]

def BFree1 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 : ℂ)]

def BFree2 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (2 : ℂ), (0 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (-2 : ℂ)]

def BFree3 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 : ℂ);
  (-1 / 2 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 : ℂ)]

/-- Block index: `x`-momentum `k`, position `(y, spin)` collapsed to `Fin 8`
via `Fin 4 x Fin 2 ≃ Fin 8` (standard `finProdFinEquiv`-style collapse). -/
abbrev BlockIdx := Fin 4 × Fin 2

/-- Reindexing `((k,y),s) : Site x Fin 2` (with `k` fixed) to `Fin 8`. -/
def blockEquiv : BlockIdx ≃ Fin 8 := finProdFinEquiv.trans (finCongr (by norm_num))

/-- **Block-diagonalization, `Q=1`.**  `Ufour * HFlux * Ufourᴴ` restricted to
momentum `k` on both sides equals `BFlux k` (reindexed via `blockEquiv`), and
vanishes for `k ≠ k'` (stated as one combined entrywise identity). -/
theorem HFlux_block_diagonalization (k k' : Fin 4) (yz : BlockIdx) (yz' : BlockIdx) :
    (Ufour * HFlux * Ufour.conjTranspose) ((k, yz.1), yz.2) ((k', yz'.1), yz'.2)
      = if k = k' then
          (![BFlux0, BFlux1, BFlux2, BFlux3] k) (blockEquiv yz) (blockEquiv yz')
        else 0 := by
  sorry

/-- **Block-diagonalization, `Q=0`.**  Same statement for `HFree`. -/
theorem HFree_block_diagonalization (k k' : Fin 4) (yz : BlockIdx) (yz' : BlockIdx) :
    (Ufour * HFree * Ufour.conjTranspose) ((k, yz.1), yz.2) ((k', yz'.1), yz'.2)
      = if k = k' then
          (![BFree0, BFree1, BFree2, BFree3] k) (blockEquiv yz) (blockEquiv yz')
        else 0 := by
  sorry

/-! ## Section 4: the 8 explicit congruences (exact, Sylvester-verified) -/

def SFlux0 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 4 : ℂ);
  (0 : ℂ), (1 : ℂ), (0 : ℂ), (-1 : ℂ), (4 / 5 : ℂ), (3 / 2 : ℂ), (-1 / 13 : ℂ), (3 / 4 : ℂ);
  (1 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (2 / 5 : ℂ), (3 / 4 : ℂ), (6 / 13 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (2 / 5 : ℂ), (-1 / 4 : ℂ), (-2 / 13 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 5 : ℂ), (3 / 8 : ℂ), (3 / 13 : ℂ), (-1 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 8 : ℂ), (-1 / 13 : ℂ), (3 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (8 / 13 : ℂ), (-1 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFlux0 : Fin 8 → ℝ := ![1, -1/4, -2, 5/2, -8/5, 13/8, -8/13, -3/2]

def SFlux1 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (1 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (4 / 9 : ℂ), (-1 / 4 : ℂ), (8 / 17 : ℂ), (-1 / 10 : ℂ), (1 / 6 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 9 : ℂ), (3 / 16 : ℂ), (-6 / 17 : ℂ), (1 / 5 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-5 / 16 : ℂ), (10 / 17 : ℂ), (0 : ℂ), (1 / 3 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-15 / 17 : ℂ), (1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 10 : ℂ), (1 / 6 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFlux1 : Fin 8 → ℝ := ![1, -2, 9/4, -16/9, 17/16, -30/17, -3/5, -1/3]

def SFlux2 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (0 : ℂ), (1 / 4 : ℂ), (-1 / 2 : ℂ), (1 / 8 : ℂ), (-1 / 8 : ℂ), (-1 / 21 : ℂ), (1 / 4 : ℂ);
  (0 : ℂ), (1 : ℂ), (-1 / 4 : ℂ), (1 / 2 : ℂ), (-1 / 8 : ℂ), (5 / 8 : ℂ), (5 / 21 : ℂ), (3 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 : ℂ), (1 / 2 : ℂ), (-5 / 4 : ℂ), (-10 / 21 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ), (1 / 4 : ℂ), (2 / 21 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-5 / 2 : ℂ), (1 / 21 : ℂ), (-1 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (3 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (8 / 21 : ℂ), (1 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFlux2 : Fin 8 → ℝ := ![2, -2, 1, -2, -1/4, 21/8, -8/21, -3/2]

def SFlux3 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (-1 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (-1 / 2 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (1 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (-2 : ℂ), (0 : ℂ), (0 : ℂ), (-1 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 2 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFlux3 : Fin 8 → ℝ := ![1, -2, -1/4, 2, -1/2, -2, 3, -1]

def SFree0 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (1 : ℂ), (-3 : ℂ), (1 / 2 : ℂ), (0 : ℂ), (1 : ℂ), (-3 : ℂ), (-1 / 2 : ℂ);
  (1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-2 : ℂ), (0 : ℂ), (-1 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-3 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 2 : ℂ), (-1 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (1 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 2 : ℂ)]
def DFree0 : Fin 8 → ℝ := ![-1, 1/4, -2, 1/2, -2, 1/2, -4, 1]

def SFree1 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (1 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (11 / 8 : ℂ);
  (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (-1 / 5 : ℂ), (0 : ℂ), (-5 / 26 : ℂ), (-3 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 10 : ℂ), (0 : ℂ), (2 / 13 : ℂ), (1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (0 : ℂ), (-3 / 13 : ℂ), (-1 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 : ℂ), (-1 / 26 : ℂ), (1 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 2 : ℂ), (-3 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (7 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFree1 : Fin 8 → ℝ := ![1, -2, 5/4, -2, 13/10, -2, 12/13, -15/4]

def SFree2 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (0 : ℂ), (1 / 4 : ℂ), (-1 / 4 : ℂ), (1 / 8 : ℂ), (-1 / 8 : ℂ), (5 / 16 : ℂ), (3 / 16 : ℂ);
  (0 : ℂ), (1 : ℂ), (-1 / 4 : ℂ), (1 / 4 : ℂ), (-1 / 8 : ℂ), (1 / 8 : ℂ), (3 / 16 : ℂ), (5 / 16 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ), (1 / 4 : ℂ), (-1 / 4 : ℂ), (1 / 4 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-1 / 4 : ℂ), (1 / 4 : ℂ), (0 : ℂ), (1 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ), (5 / 16 : ℂ), (-3 / 16 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-3 / 16 : ℂ), (5 / 16 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (0 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFree2 : Fin 8 → ℝ := ![2, -2, 2, -2, 2, -2, 15/8, -15/8]

def SFree3 : Matrix (Fin 8) (Fin 8) ℂ := !![
  (1 : ℂ), (-1 : ℂ), (1 / 2 : ℂ), (-4 / 3 : ℂ), (1 / 5 : ℂ), (-4 / 7 : ℂ), (-1 / 26 : ℂ), (-1 / 8 : ℂ);
  (0 : ℂ), (1 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 / 2 : ℂ), (-3 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (1 : ℂ), (-5 / 3 : ℂ), (1 / 2 : ℂ), (-10 / 7 : ℂ), (2 / 13 : ℂ), (-1 / 2 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (1 / 10 : ℂ), (-2 / 7 : ℂ), (3 / 13 : ℂ), (-1 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-13 / 7 : ℂ), (1 / 2 : ℂ), (-11 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (5 / 26 : ℂ), (-3 / 8 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ), (-7 / 4 : ℂ);
  (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (0 : ℂ), (1 : ℂ)]
def DFree3 : Fin 8 → ℝ := ![1, -2, 3/4, -10/3, 7/10, -26/7, 12/13, -15/4]

theorem congruence_Flux0 : SFlux0.conjTranspose * BFlux0 * SFlux0
    = Matrix.diagonal (fun i => (DFlux0 i : ℂ)) := by sorry
theorem congruence_Flux1 : SFlux1.conjTranspose * BFlux1 * SFlux1
    = Matrix.diagonal (fun i => (DFlux1 i : ℂ)) := by sorry
theorem congruence_Flux2 : SFlux2.conjTranspose * BFlux2 * SFlux2
    = Matrix.diagonal (fun i => (DFlux2 i : ℂ)) := by sorry
theorem congruence_Flux3 : SFlux3.conjTranspose * BFlux3 * SFlux3
    = Matrix.diagonal (fun i => (DFlux3 i : ℂ)) := by sorry
theorem congruence_Free0 : SFree0.conjTranspose * BFree0 * SFree0
    = Matrix.diagonal (fun i => (DFree0 i : ℂ)) := by sorry
theorem congruence_Free1 : SFree1.conjTranspose * BFree1 * SFree1
    = Matrix.diagonal (fun i => (DFree1 i : ℂ)) := by sorry
theorem congruence_Free2 : SFree2.conjTranspose * BFree2 * SFree2
    = Matrix.diagonal (fun i => (DFree2 i : ℂ)) := by sorry
theorem congruence_Free3 : SFree3.conjTranspose * BFree3 * SFree3
    = Matrix.diagonal (fun i => (DFree3 i : ℂ)) := by sorry

theorem SFlux0_det_ne_zero : IsUnit SFlux0.det := by sorry
theorem SFlux1_det_ne_zero : IsUnit SFlux1.det := by sorry
theorem SFlux2_det_ne_zero : IsUnit SFlux2.det := by sorry
theorem SFlux3_det_ne_zero : IsUnit SFlux3.det := by sorry
theorem SFree0_det_ne_zero : IsUnit SFree0.det := by sorry
theorem SFree1_det_ne_zero : IsUnit SFree1.det := by sorry
theorem SFree2_det_ne_zero : IsUnit SFree2.det := by sorry
theorem SFree3_det_ne_zero : IsUnit SFree3.det := by sorry

/-! ## Section 5: assembling the combined congruence and the inertia counts

No further named declarations are fixed here; this section is intentionally
left to Aristotle's own judgment on the cleanest assembly. Given
`HFlux_block_diagonalization` / `HFree_block_diagonalization` (Section 3),
the 8 exact congruences and their determinant facts (Section 4), assemble
whatever intermediate lemmas are convenient (e.g. a combined invertible
`T := Ufour.conjTranspose * Sblock` with `Sblock` block-diagonal from the 4
`S_k`'s per charge, giving `Tᴴ * H * T` as the genuine 32-entry diagonal
matrix built from the `D`-lists via `blockEquiv`) to reach, via
`HermitianSylvester.congruence_preserves_inertia` (applied once with the
combined `T`, or in more than one step - whichever is easiest), the
eigenvalue-sign counts of `HFlux`/`HFree`. Counting signs among the 32 known
`D`-values (`3+,5-` per block, inertia `-2` each, for Flux: total `-8`;
`4+,4-` per block, inertia `0` each, for Free: total `0`) and combining with
`gaugeOverlap_index_eigenvalue_count_form` gives the Section 6 capstones. The
scaffolding above (blocks, congruences, determinants, block-diagonalization)
is believed sufficient; adjust intermediate lemma shapes freely as needed for
the assembly to close. -/

/-! ## Section 6: the capstone -/

instance : Invertible HFlux := by sorry
instance : Invertible HFree := by sorry

/-- **THE CAPSTONE (flux).** The genuine `L=4` `Q=1` Wilson-Dirac gauge
operator has overlap index exactly `4` against the traceless chirality -
a nonzero, flux-driven index on an EVEN lattice (unlike the odd-cycle
triangle, this lattice is bipartite/chiral-symmetric at zero flux, so the
jump is a genuine zero-to-nonzero transition, not a parity artifact). -/
theorem overlapIndex_flux2D :
    overlapIndex gamma5U (epsCFC HFlux) = 4 := by
  sorry

/-- **THE CAPSTONE (free).** At zero flux (`Q=0`), the same lattice has
overlap index exactly `0`: the balanced/bipartite case, confirming the index
genuinely responds to the flux rather than being an artifact of the lattice
shape. -/
theorem overlapIndex_free2D :
    overlapIndex gamma5U (epsCFC HFree) = 0 := by
  sorry

/-- **The zero-to-nonzero flux-driven index jump**, the frontier's target
statement. -/
theorem flux2D_index_jump :
    overlapIndex gamma5U (epsCFC HFlux) ≠ overlapIndex gamma5U (epsCFC HFree) := by
  rw [overlapIndex_flux2D, overlapIndex_free2D]
  norm_num

end FluxOverlapIndex2D
end GateC2
end NullEdge
end Draft
end PhysicsSM
