import PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol
import PhysicsSM.Draft.NullEdge.GateC1.BranchWilsonSquareCore

/-!
# Gate C1 branch Wilson symbol scaffold

This Draft module records the branch-retention direction for Gate C1 in Lean.

The scalar Wilson symbol in `TetraScalarWilsonSymbol` is a checked gap and
sign-kernel brick, but it is not by itself the physical chiral branch selector:
the current program keeps the scalar Wilson layer as the overlap seed and puts
physical branch retention into a separate matrix-valued Wilson/projector layer.

This file provides a minimal finite-symbol API for that layer.  It intentionally
does not assert that such a branch selector has been constructed, is local, is
gauge covariant, or carries the Standard Model anomaly.  Those are later C1
obligations.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraBranchWilsonSymbol

open scoped BigOperators ComplexOrder
open TetraQMatrixSquareExact
open TetraScalarWilsonSymbol
open BranchWilsonSquareCore

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Matrix-valued branch Wilson data over the rank-4 tetrahedral momentum torus.

`W k` is the branch-selective Wilson correction at momentum `k`.  Hermiticity is
included because the intended overlap seed is a Hermitian kernel after chirality
multiplication. -/
structure BranchWilsonData where
  /-- Momentum-space matrix-valued Wilson correction. -/
  W : (Fin 4 -> ℝ) -> Matrix Spin Spin ℂ
  /-- Euclidean finite-symbol Hermiticity audit. -/
  W_hermitian : ∀ k, star (W k) = W k

/-- Branch Wilson/free symbol:
`K_branch(k) = a^{-1} (i Q(sin k) + W(k))`. -/
def Kbranch (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ) :
    Matrix Spin Spin ℂ :=
  ((a : ℂ)⁻¹) •
    (Complex.I • TetraEuclideanSlashData.Q D (sinCoeffs k) + BW.W k)

/-- Hermitian overlap seed associated to a branch Wilson symbol and a chosen
finite chirality matrix. -/
def Hbranch (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ) :
    Matrix Spin Spin ℂ :=
  gamma5 * Kbranch D a BW k

/-- The scalar Wilson symbol is the special branch-Wilson case with
`W(k) = mWilson(r,rho,k) * I`.

This theorem is deliberately only a specialization identity.  It does not claim
that the scalar Wilson correction selects the physical branch. -/
theorem Kbranch_eq_scalar_K_of_W_eq_scalar
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ)
    (hW : BW.W k =
      ((mWilson r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ)) :
    Kbranch D a BW k = TetraScalarWilsonSymbol.K D a r rho k := by
  unfold Kbranch TetraScalarWilsonSymbol.K
  rw [hW]

/-! ## Matrix-valued branch-Wilson square and gap-transfer theorems

These specialize the machine-checked abstract identities of
`BranchWilsonSquareCore` to the concrete branch symbol `Kbranch`, with
`Q := TetraEuclideanSlashData.Q D (sinCoeffs k)` (the kinetic slash symbol) and
`W := BW.W k` (the branch-Wilson correction, Hermitian by `BW.W_hermitian`).

The Hermiticity of the kinetic symbol `Q` is taken as an explicit hypothesis
`hQ` so this layer does not depend on the internal fields of
`TetraEuclideanSlashData`; in the intended Euclidean convention each `D.B A` is
Hermitian and the real coefficients `sinCoeffs k` keep `Q` Hermitian, so `hQ`
holds. -/

/-- The branch symbol is definitionally the abstract `Kab` of
`BranchWilsonSquareCore`. -/
theorem Kbranch_eq_Kab
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ) :
    Kbranch D a BW k =
      BranchWilsonSquareCore.Kab a
        (TetraEuclideanSlashData.Q D (sinCoeffs k)) (BW.W k) :=
  rfl

/-- **Exact branch-Wilson square identity (bookkeeping spine).**
`star K * K = a⁻² • (Q² + W² + i • (W·Q − Q·W))`, with `Q` the kinetic slash
symbol and `W = BW.W k`.  The commutator term `i • [W, Q]` is Hermitian, so the
right-hand side is Hermitian. -/
theorem Kbranch_sq_exact
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ)
    (hQ : star (TetraEuclideanSlashData.Q D (sinCoeffs k))
        = TetraEuclideanSlashData.Q D (sinCoeffs k)) :
    star (Kbranch D a BW k) * Kbranch D a BW k =
      (((a ^ 2)⁻¹ : ℝ) : ℂ) •
        (TetraEuclideanSlashData.Q D (sinCoeffs k)
            * TetraEuclideanSlashData.Q D (sinCoeffs k)
          + BW.W k * BW.W k
          + Complex.I • (BW.W k * TetraEuclideanSlashData.Q D (sinCoeffs k)
              - TetraEuclideanSlashData.Q D (sinCoeffs k) * BW.W k)) := by
  rw [Kbranch_eq_Kab]
  exact BranchWilsonSquareCore.Kab_sq_exact a _ _ hQ (BW.W_hermitian k)

/-- **General inverse-propagator lower bound (no commutation).**
`star K * K ⪰ a⁻² • (W² + i • [W, Q])`; the dropped kinetic remainder
`a⁻² • Q²` is positive semidefinite and only helps. -/
theorem Kbranch_sq_ge_branch
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ)
    (hQ : star (TetraEuclideanSlashData.Q D (sinCoeffs k))
        = TetraEuclideanSlashData.Q D (sinCoeffs k)) :
    (star (Kbranch D a BW k) * Kbranch D a BW k -
      (((a ^ 2)⁻¹ : ℝ) : ℂ) • (BW.W k * BW.W k
        + Complex.I • (BW.W k * TetraEuclideanSlashData.Q D (sinCoeffs k)
            - TetraEuclideanSlashData.Q D (sinCoeffs k) * BW.W k))).PosSemidef := by
  rw [Kbranch_eq_Kab]
  exact BranchWilsonSquareCore.Kab_sq_ge_branch a _ _ hQ (BW.W_hermitian k)

/-- **Decisive sector gap-transfer (no commutation).**  For a Hermitian sector
compressor `E` (intended `E = 1 - P`, the mirror / bad sector), a positivity gap
`γ` of the Hermitian combination `W² + i • [W, Q]` on that sector transfers to an
inverse-propagator gap `a⁻² γ` of `K = Kbranch` on the same sector.  This is the
clause-3 `inverseBadSectorGap` input, and crucially needs **no** `[W, Q] = 0`
hypothesis, so `BW.W k` may break chirality balance and avoid the zero-index
trap. -/
theorem Kbranch_badSector_gap
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ)
    (E : Matrix Spin Spin ℂ) (gamma : ℝ)
    (hQ : star (TetraEuclideanSlashData.Q D (sinCoeffs k))
        = TetraEuclideanSlashData.Q D (sinCoeffs k))
    (hE : star E = E)
    (hWgap : (E * (BW.W k * BW.W k
        + Complex.I • (BW.W k * TetraEuclideanSlashData.Q D (sinCoeffs k)
            - TetraEuclideanSlashData.Q D (sinCoeffs k) * BW.W k)) * E
          - (gamma : ℂ) • E).PosSemidef) :
    (E * (star (Kbranch D a BW k) * Kbranch D a BW k) * E
      - (((a ^ 2)⁻¹ * gamma : ℝ) : ℂ) • E).PosSemidef := by
  rw [Kbranch_eq_Kab]
  exact BranchWilsonSquareCore.Kab_badSector_gap a _ _ E gamma hQ
    (BW.W_hermitian k) hE hWgap

/-- **Bridge from the inverse-propagator gap to the Hermitian island.**  When
the chirality `gamma5` is a Hermitian involution and the seed `H = Hbranch` is
Hermitian, `H² = star K · K`.  Combined with `Kbranch_badSector_gap`, an
inverse-propagator gap on a sector becomes an `H²`-gap there, i.e. a separated
spectral island of `H` (clause 1 of `BranchRetentionCertificate`). -/
theorem Hbranch_sq_eq (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a : ℝ)
    (BW : BranchWilsonData (Spin := Spin)) (k : Fin 4 -> ℝ)
    (hg : star gamma5 = gamma5) (hg2 : gamma5 * gamma5 = 1)
    (hH : star (Hbranch gamma5 D a BW k) = Hbranch gamma5 D a BW k) :
    Hbranch gamma5 D a BW k * Hbranch gamma5 D a BW k
      = star (Kbranch D a BW k) * Kbranch D a BW k := by
  unfold Hbranch
  exact BranchWilsonSquareCore.H_sq_eq_Ksq gamma5 (Kbranch D a BW k) hg hg2 hH

/-- Predicate: a branch Wilson correction commutes with a finite chirality
matrix at every momentum.  This is often the wrong condition for nonzero index,
but it is a useful audit flag. -/
def CommutesWithChirality (gamma5 : Matrix Spin Spin ℂ)
    (BW : BranchWilsonData (Spin := Spin)) : Prop :=
  ∀ k, BW.W k * gamma5 = gamma5 * BW.W k

/-- Predicate: a branch Wilson correction anticommutes with a finite chirality
matrix at every momentum.  The finite overlap-index facade proves that a
sign-classifier anticommuting with chirality gives zero finite index, so this is
a danger flag for physical C1 unless additional structure changes the setting. -/
def AnticommutesWithChirality (gamma5 : Matrix Spin Spin ℂ)
    (BW : BranchWilsonData (Spin := Spin)) : Prop :=
  ∀ k, BW.W k * gamma5 = -(gamma5 * BW.W k)

/-- Lightweight branch-retention audit predicate for a proposed branch Wilson
symbol.

This is intentionally qualitative.  Later modules should replace these fields
with quantitative spectral-island, locality, covariance, and anomaly
certificates. -/
structure BranchWilsonAudit
    (gamma5 : Matrix Spin Spin ℂ)
    (BW : BranchWilsonData (Spin := Spin)) : Prop where
  /-- The Wilson correction is Hermitian by data. -/
  hermitian : ∀ k, star (BW.W k) = BW.W k
  /-- The branch selector is not globally scalar on the finite spin space. -/
  not_forced_scalar : ¬ ∀ k, ∃ c : ℂ, BW.W k = c • (1 : Matrix Spin Spin ℂ)
  /-- The branch selector is not an everywhere anticommuting classifier. -/
  not_everywhere_anticomm :
    ¬ AnticommutesWithChirality gamma5 BW

end TetraBranchWilsonSymbol
end GateC1
end NullEdge
end Draft
end PhysicsSM
