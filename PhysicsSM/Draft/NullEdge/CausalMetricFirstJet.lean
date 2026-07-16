import PhysicsSM.Draft.NullEdge.CausalOperatorMetric

/-!
# First derivatives from an operator-reconstructed inverse metric

This module records the finite linear-algebra bridge from corrected
causal-operator pairings to a coordinate first jet.  Given probe functions
`X nu`, a scalar field `F`, an inverse metric `gInv`, and its supplied covariant
inverse `gCov`, define

`partial^C F = gCov * correctedCarreDuChamp(L, X, F)`.

If the pairing vector is exactly `gInv * partial F` and
`gCov * gInv = 1`, matrix-vector associativity recovers `partial F`.  A second
theorem shows that adding any scalar zeroth-order potential to `L` leaves this
recovered first jet unchanged.

These are conditional finite identities, not a construction of probes, a
metric inverse, coordinate charts, differentiability, or operator convergence.
Their purpose is to make the next connection/curvature layer depend on one
explicit first-jet interface rather than an informal index contraction.  Claim
grade: `M [comp]`.

Provenance: the identity is the standard raising/lowering contraction
`g_{mu nu} g^{nu rho} partial_rho F = partial_mu F`, specialized to the
corrected principal-symbol pairing formalized in `CausalOperatorMetric`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CausalMetricFirstJet

open PhysicsSM.Draft.NullEdge.CausalOperatorMetric

variable {K ι : Type*} [Field K] [Fintype ι] [DecidableEq ι]

/-- Vector of corrected operator pairings between coordinate probes and one
scalar field. -/
def operatorPairingVector
    (L : K -> K) (X : ι -> K) (F : K) : ι -> K :=
  fun nu => correctedCarreDuChamp L (X nu) F

/-- Candidate finite coordinate first jet obtained by lowering the probe
pairing vector with a supplied covariant metric. -/
def recoveredFirstJet
    (gCov : Matrix ι ι K) (L : K -> K) (X : ι -> K) (F : K) : ι -> K :=
  Matrix.mulVec gCov (operatorPairingVector L X F)

/-- **Finite coordinate derivative identity.** If corrected pairings with the
coordinate probes equal the inverse metric applied to the target derivative,
then lowering by a left inverse recovers that derivative exactly. -/
theorem recoveredFirstJet_eq
    (gCov gInv : Matrix ι ι K)
    (L : K -> K) (X : ι -> K) (F : K) (derivative : ι -> K)
    (hInverse : gCov * gInv = 1)
    (hPrincipalSymbol :
      operatorPairingVector L X F = Matrix.mulVec gInv derivative) :
    recoveredFirstJet gCov L X F = derivative := by
  rw [recoveredFirstJet, hPrincipalSymbol, Matrix.mulVec_mulVec,
    hInverse, Matrix.one_mulVec]

/-- Pointwise form of `recoveredFirstJet_eq`, matching the usual displayed
index identity `g_{mu nu} Gamma(X^nu,F) = partial_mu F`. -/
theorem recoveredFirstJet_apply_eq
    (gCov gInv : Matrix ι ι K)
    (L : K -> K) (X : ι -> K) (F : K) (derivative : ι -> K)
    (hInverse : gCov * gInv = 1)
    (hPrincipalSymbol :
      operatorPairingVector L X F = Matrix.mulVec gInv derivative)
    (mu : ι) :
    recoveredFirstJet gCov L X F mu = derivative mu := by
  exact congrFun
    (recoveredFirstJet_eq gCov gInv L X F derivative
      hInverse hPrincipalSymbol) mu

omit [DecidableEq ι] in
/-- Scalar zeroth-order potentials cancel before the metric is used to lower
the pairing vector, so they cannot alter the recovered first jet. -/
theorem recoveredFirstJet_addScalarPotential
    [CharZero K]
    (gCov : Matrix ι ι K) (L : K -> K) (V : K)
    (X : ι -> K) (F : K) :
    recoveredFirstJet gCov (addScalarPotential L V) X F =
      recoveredFirstJet gCov L X F := by
  unfold recoveredFirstJet operatorPairingVector
  congr 1
  funext nu
  exact correctedCarreDuChamp_addScalarPotential L V (X nu) F

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalMetricFirstJet.recoveredFirstJet_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms recoveredFirstJet_eq

/-- info: 'PhysicsSM.Draft.NullEdge.CausalMetricFirstJet.recoveredFirstJet_addScalarPotential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms recoveredFirstJet_addScalarPotential

end PhysicsSM.Draft.NullEdge.CausalMetricFirstJet
