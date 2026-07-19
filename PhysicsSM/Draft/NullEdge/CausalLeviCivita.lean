import PhysicsSM.Draft.NullEdge.CausalMetricFirstJet

/-!
# Levi-Civita connection from an operator-reconstructed metric first jet

This module isolates the finite coordinate-algebra bridge from the corrected
causal-operator pairing to a Levi-Civita connection candidate. First, it applies
`CausalMetricFirstJet.recoveredFirstJet_eq` componentwise to a supplied metric
field. It then defines the standard Christoffel coefficients of the first and
second kind and proves that an exact metric-inverse relation plus symmetry of
the metric first jet imply:

* lowering the raised Christoffel coefficient recovers the first-kind symbol;
* symmetry in the two derivative directions (zero coordinate torsion);
* vanishing covariant derivative of the covariant metric.

These are guarded finite identities, not a construction of probes, metric
components, first derivatives, a chart, a manifold, or a continuum limit. In
particular, the difficult convergence premise remains that corrected operator
pairings recover the principal symbol on every metric component. Claim grade:
`M [comp]`.

Conventions: coordinate indices are ordered as `upper, derivativeLeft,
derivativeRight`; the metric signature is not used by these algebraic proofs;
and `gCov * gInv = 1` is the displayed lowering/raising convention.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CausalLeviCivita

open PhysicsSM.Draft.NullEdge.CausalMetricFirstJet

variable {K ι : Type*} [Field K]

/-- Apply the operator-recovered scalar first jet to every component of a
supplied covariant metric field. -/
def recoveredMetricFirstJet
    [Fintype ι] [DecidableEq ι]
    (probeCov : Matrix ι ι K) (L : K -> K) (X : ι -> K)
    (metricComponents : Matrix ι ι K) : ι -> Matrix ι ι K :=
  fun derivative left right =>
    recoveredFirstJet probeCov L X (metricComponents left right) derivative

/-- Componentwise metric version of the finite coordinate derivative identity.
Every corrected pairing premise is explicit; this theorem does not establish
that the causal operator satisfies those premises. -/
theorem recoveredMetricFirstJet_eq
    [Fintype ι] [DecidableEq ι]
    (probeCov probeInv : Matrix ι ι K)
    (L : K -> K) (X : ι -> K) (metricComponents : Matrix ι ι K)
    (metricDerivative : ι -> Matrix ι ι K)
    (hProbeInverse : probeCov * probeInv = 1)
    (hPrincipalSymbol : forall left right,
      operatorPairingVector L X (metricComponents left right) =
        Matrix.mulVec probeInv (fun derivative =>
          metricDerivative derivative left right)) :
    recoveredMetricFirstJet probeCov L X metricComponents = metricDerivative := by
  funext derivative left right
  exact recoveredFirstJet_apply_eq
    probeCov probeInv L X (metricComponents left right)
      (fun coordinate => metricDerivative coordinate left right)
      hProbeInverse (hPrincipalSymbol left right) derivative

/-- Symmetry of every covariant-metric first jet in its two metric indices. -/
def MetricFirstJetSymmetric (dg : ι -> Matrix ι ι K) : Prop :=
  forall derivative left right,
    dg derivative left right = dg derivative right left

/-- Christoffel coefficient of the first kind formed from a metric first jet. -/
def christoffelFirstKind
    (dg : ι -> Matrix ι ι K) (lower derivativeLeft derivativeRight : ι) : K :=
  (dg derivativeLeft lower derivativeRight
      + dg derivativeRight lower derivativeLeft
      - dg lower derivativeLeft derivativeRight) / 2

/-- The first-kind Christoffel coefficient is symmetric in its two derivative
directions when the metric first jet is symmetric. -/
theorem christoffelFirstKind_swap
    (dg : ι -> Matrix ι ι K)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (lower derivativeLeft derivativeRight : ι) :
    christoffelFirstKind dg lower derivativeLeft derivativeRight =
      christoffelFirstKind dg lower derivativeRight derivativeLeft := by
  unfold christoffelFirstKind
  rw [hSymmetric lower derivativeLeft derivativeRight]
  ring

section FiniteCoordinates

variable [Fintype ι] [DecidableEq ι]

/-- Christoffel coefficient of the second kind, obtained by raising the first
index of `christoffelFirstKind`. -/
def christoffelSecondKind
    (gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (upper derivativeLeft derivativeRight : ι) : K :=
  Finset.sum Finset.univ fun lower =>
    gInv upper lower
      * christoffelFirstKind dg lower derivativeLeft derivativeRight

/-- Lower the upper index of a supplied connection coefficient. -/
def loweredConnection
    (gCov : Matrix ι ι K) (connection : ι -> ι -> ι -> K)
    (lower derivativeLeft derivativeRight : ι) : K :=
  Finset.sum Finset.univ fun upper =>
    gCov lower upper * connection upper derivativeLeft derivativeRight

/-- Coordinate covariant derivative of the reconstructed covariant metric. -/
def covariantMetricDerivative
    (gCov : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (connection : ι -> ι -> ι -> K)
    (derivative left right : ι) : K :=
  dg derivative left right
    - loweredConnection gCov connection left derivative right
    - loweredConnection gCov connection right derivative left

omit [DecidableEq ι] in
/-- The reconstructed second-kind connection has zero coordinate torsion. -/
theorem christoffelSecondKind_swap
    (gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (upper derivativeLeft derivativeRight : ι) :
    christoffelSecondKind gInv dg upper derivativeLeft derivativeRight =
      christoffelSecondKind gInv dg upper derivativeRight derivativeLeft := by
  unfold christoffelSecondKind
  apply Finset.sum_congr rfl
  intro lower _
  rw [christoffelFirstKind_swap dg hSymmetric lower]

/-- Lowering the raised Christoffel coefficient recovers the first-kind symbol
under the displayed exact metric-inverse relation. -/
theorem lowered_christoffelSecondKind_eq_firstKind
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (lower derivativeLeft derivativeRight : ι) :
    loweredConnection gCov (christoffelSecondKind gInv dg)
        lower derivativeLeft derivativeRight =
      christoffelFirstKind dg lower derivativeLeft derivativeRight := by
  unfold loweredConnection christoffelSecondKind
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  simp_rw [← mul_assoc, ← Finset.sum_mul]
  change
    (Finset.sum Finset.univ fun raised =>
        (gCov * gInv) lower raised
          * christoffelFirstKind dg raised derivativeLeft derivativeRight) = _
  rw [hInverse]
  simp [Matrix.one_apply]

/-- The Christoffel connection built from symmetric metric first jets is
compatible with the supplied covariant metric. -/
theorem covariantMetricDerivative_christoffel_eq_zero
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (derivative left right : ι) :
    covariantMetricDerivative gCov dg (christoffelSecondKind gInv dg)
        derivative left right = 0 := by
  unfold covariantMetricDerivative
  rw [lowered_christoffelSecondKind_eq_firstKind gCov gInv dg hInverse,
    lowered_christoffelSecondKind_eq_firstKind gCov gInv dg hInverse]
  unfold christoffelFirstKind
  rw [hSymmetric derivative right left,
    hSymmetric right left derivative,
    hSymmetric left right derivative]
  ring

omit [DecidableEq ι] in
/-- Lowering the upper index preserves symmetry in the two derivative
directions of a supplied coordinate connection. -/
theorem loweredConnection_swap_of_connection_swap
    (gCov : Matrix ι ι K) (connection : ι -> ι -> ι -> K)
    (hTorsionFree : forall upper derivativeLeft derivativeRight,
      connection upper derivativeLeft derivativeRight =
        connection upper derivativeRight derivativeLeft)
    (lower derivativeLeft derivativeRight : ι) :
    loweredConnection gCov connection lower derivativeLeft derivativeRight =
      loweredConnection gCov connection lower derivativeRight derivativeLeft := by
  unfold loweredConnection
  apply Finset.sum_congr rfl
  intro upper _
  rw [hTorsionFree upper derivativeLeft derivativeRight]

/-- **Finite Levi-Civita uniqueness.** Any coordinate connection with zero
torsion and vanishing covariant derivative of the supplied metric first jet is
the Christoffel connection.  This is the uniqueness half of the fundamental
theorem, proved directly by cyclically permuting the metric-compatibility
equations and then raising the recovered first-kind coefficient. -/
theorem connection_eq_christoffelSecondKind_of_torsionFree_metricCompatible
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (connection : ι -> ι -> ι -> K)
    (hInverse : gCov * gInv = 1)
    (hTorsionFree : forall upper derivativeLeft derivativeRight,
      connection upper derivativeLeft derivativeRight =
        connection upper derivativeRight derivativeLeft)
    (hMetricCompatible : forall derivative left right,
      covariantMetricDerivative gCov dg connection derivative left right = 0) :
    connection = christoffelSecondKind gInv dg := by
  have hLowered (lower derivativeLeft derivativeRight : ι) :
      loweredConnection gCov connection lower derivativeLeft derivativeRight =
        christoffelFirstKind dg lower derivativeLeft derivativeRight := by
    have hFirst := hMetricCompatible derivativeLeft lower derivativeRight
    have hSecond := hMetricCompatible derivativeRight lower derivativeLeft
    have hThird := hMetricCompatible lower derivativeLeft derivativeRight
    unfold covariantMetricDerivative at hFirst hSecond hThird
    rw [loweredConnection_swap_of_connection_swap gCov connection
      hTorsionFree lower derivativeRight derivativeLeft] at hSecond
    rw [loweredConnection_swap_of_connection_swap gCov connection
      hTorsionFree derivativeLeft derivativeRight lower] at hSecond
    rw [loweredConnection_swap_of_connection_swap gCov connection
      hTorsionFree derivativeRight lower derivativeLeft] at hThird
    unfold christoffelFirstKind
    linear_combination
      (-(1 / 2 : K)) * hFirst + (-(1 / 2 : K)) * hSecond +
        (1 / 2 : K) * hThird
  have hRight : gInv * gCov = 1 := mul_eq_one_comm.2 hInverse
  funext upper derivativeLeft derivativeRight
  have hRaise :
      Matrix.mulVec gInv
          (fun lower => loweredConnection gCov connection lower
            derivativeLeft derivativeRight) =
        fun source => connection source derivativeLeft derivativeRight := by
    change Matrix.mulVec gInv
        (Matrix.mulVec gCov
          (fun source => connection source derivativeLeft derivativeRight)) = _
    rw [Matrix.mulVec_mulVec, hRight, Matrix.one_mulVec]
  rw [<- congrFun hRaise upper]
  unfold christoffelSecondKind Matrix.mulVec dotProduct
  simp_rw [hLowered]

/-- **Finite fundamental theorem of Levi-Civita geometry.** A symmetric metric
first jet with a supplied inverse admits exactly one torsion-free,
metric-compatible coordinate connection, namely the displayed Christoffel
connection. -/
theorem finiteLeviCivita_existsUnique
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (hSymmetric : MetricFirstJetSymmetric dg) :
    ∃! connection : ι -> ι -> ι -> K,
      (forall upper derivativeLeft derivativeRight,
        connection upper derivativeLeft derivativeRight =
          connection upper derivativeRight derivativeLeft) ∧
      (forall derivative left right,
        covariantMetricDerivative gCov dg connection derivative left right = 0) := by
  refine ⟨christoffelSecondKind gInv dg, ?_, ?_⟩
  · constructor
    · exact christoffelSecondKind_swap gInv dg hSymmetric
    · exact covariantMetricDerivative_christoffel_eq_zero
        gCov gInv dg hInverse hSymmetric
  · intro connection hConnection
    exact connection_eq_christoffelSecondKind_of_torsionFree_metricCompatible
      gCov gInv dg connection hInverse hConnection.1 hConnection.2

/-- Guarded finite Levi-Civita package: coordinate torsion vanishes and the
covariant metric derivative is zero under the exact reconstruction premises. -/
theorem finiteLeviCivitaPackage
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (upper derivative left right : ι) :
    christoffelSecondKind gInv dg upper derivative left =
        christoffelSecondKind gInv dg upper left derivative
      /\ covariantMetricDerivative gCov dg (christoffelSecondKind gInv dg)
        derivative left right = 0 := by
  exact
    ⟨christoffelSecondKind_swap gInv dg hSymmetric upper derivative left,
      covariantMetricDerivative_christoffel_eq_zero
        gCov gInv dg hInverse hSymmetric derivative left right⟩

end FiniteCoordinates

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalLeviCivita.recoveredMetricFirstJet_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms recoveredMetricFirstJet_eq

/-- info: 'PhysicsSM.Draft.NullEdge.CausalLeviCivita.finiteLeviCivitaPackage' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteLeviCivitaPackage

/-- info: 'PhysicsSM.Draft.NullEdge.CausalLeviCivita.finiteLeviCivita_existsUnique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteLeviCivita_existsUnique

end PhysicsSM.Draft.NullEdge.CausalLeviCivita
