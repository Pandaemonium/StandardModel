# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-18T13:48:50`
- Finished: `2026-07-18T13:50:22`
- Timeout seconds: `600`
- Max output tokens: `16000`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

noncomputable section

/-!
# General-tetrad linearized torsion selection

This module removes the identity-tetrad restriction from the local
linearized Palatini connection theorem.  The reduction is algebraic.  The
ordinary exterior-square action of an internal basis change is conjugated by
the fixed Lorentz Hodge matrix, producing the transport seen by the Palatini
face coefficients.  A supplied inverse coframe then carries an arbitrary
nondegenerate background to the identity, where the exact twenty-four
component theorem is already available.

The principal result says that, at every coframe with a supplied two-sided
inverse, all twenty-four linearized connection coefficients vanish if and
only if the linearized Cartan torsion vanishes.  The finite-spacing and
changing-carrier consequences retain the exact quadratic defect from the
identity-background predecessor.

This is a finite algebraic identity and a conditional first-jet limit.  It
does not treat a nonidentity background link connection, prove nonlinear
Levi-Civita uniqueness, derive metric dual-cell weights or a graph
refinement, control varying coframe jets, or identify the selected transport
with continuum Levi-Civita holonomy.

Provenance: clean-room finite implementation of the standard nondegenerate
tetrad step in the Palatini implication `D(e wedge e) = 0 => T = 0`, using the
repository's mostly-minus metric, orientation `0123`, and ordered bivector
basis `(12,13,23,01,02,03)`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Arbitrary internal-basis covariance -/

/-- The exterior-square transport conjugated into the Hodge-dual Palatini
face coordinates.  For proper Lorentz matrices this reduces to the ordinary
bivector transport, but the conjugated expression is meaningful for every
real internal basis change. -/
def palatiniBivectorTransport
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar)

/-- Conjugation by the Lorentz Hodge matrix converts the exterior-square
action into the action on Hodge-dualized Palatini faces. -/
theorem palatiniBivectorTransport_mul_lorentzHodgeStar
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    palatiniBivectorTransport matrix * lorentzHodgeStar =
      lorentzHodgeStar * wedgeTwoTransport matrix := by
  unfold palatiniBivectorTransport
  calc
    -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar) *
          lorentzHodgeStar =
        -(lorentzHodgeStar * wedgeTwoTransport matrix *
          (lorentzHodgeStar * lorentzHodgeStar)) := by
            simp only [neg_mul, Matrix.mul_assoc]
    _ = -(lorentzHodgeStar * wedgeTwoTransport matrix *
          (-(1 : Matrix (Fin 6) (Fin 6) Real))) := by
            rw [lorentzHodgeStar_sq]
    _ = lorentzHodgeStar * wedgeTwoTransport matrix := by simp

/-- On a proper eta-Lorentz basis change the conjugated Palatini transport is
exactly the repository's ordinary exterior-square bivector transport. -/
theorem palatiniBivectorTransport_eq_wedgeTwoTransport
    (matrix : Matrix (Fin 4) (Fin 4) Real)
    (hLorentz : IsEtaLorentz matrix) (hProper : matrix.det = 1) :
    palatiniBivectorTransport matrix = wedgeTwoTransport matrix := by
  have hCommute := wedgeTwoTransport_commutes_lorentzHodgeStar
    matrix hLorentz hProper
  unfold palatiniBivectorTransport
  rw [hCommute.symm, Matrix.mul_assoc, lorentzHodgeStar_sq]
  simp

set_option maxHeartbeats 2000000 in
/-- Polarizing the coframe wedge commutes with an arbitrary internal basis
change through the exterior-square representation. -/
theorem coframeWedgeFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    coframeWedgeFirstVariation (matrix * coframe) (matrix * variation)
        first second =
      transportApply (wedgeTwoTransport matrix)
        (coframeWedgeFirstVariation coframe variation first second) := by
  funext component
  fin_cases component <;>
    simp +decide [coframeWedgeFirstVariation, transportApply,
      wedgeTwoTransport, Matrix.mul_apply, bivectorFirst, bivectorSecond,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The polarized Hodge-dual Palatini face is covariant under every internal
basis change when transported by `palatiniBivectorTransport`. -/
theorem palatiniFaceWeightFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    palatiniFaceWeightFirstVariation (matrix * coframe) (matrix * variation)
        first second =
      transportApply (palatiniBivectorTransport matrix)
        (palatiniFaceWeightFirstVariation coframe variation first second) := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_mul]
  simp only [transportApply_eq_mulVec, Matrix.mulVec_mulVec]
  rw [palatiniBivectorTransport_mul_lorentzHodgeStar]

/-- Matrix transport commutes with a doubly indexed weighted finite sum of
fiber fields. -/
theorem transportApply_weightedDoubleSum_fin4
    (matrix : Matrix (Fin 6) (Fin 6) Real)
    (weight : Fin 4 -> Fin 4 -> Real)
    (field : Fin 4 -> Fin 4 -> Fiber 6) :
    transportApply matrix (fun component =>
        Finset.sum Finset.univ (fun first =>
          Finset.sum Finset.univ (fun second =>
            weight first second * field first second component))) =
      fun component =>
        Finset.sum Finset.univ (fun first =>
          Finset.sum Finset.univ (fun second =>
            weight first second *
              transportApply matrix (field first second) component)) := by
  rw [transportApply_sum_fin4]
  funext component
  apply Finset.sum_congr rfl
  intro first _
  rw [transportApply_sum_fin4]
  apply Finset.sum_congr rfl
  intro second _
  rw [transportApply_scale]

/-- Weighted-double-sum form of the polarized complementary Palatini face. -/
theorem complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation coframe variation
        first second =
      fun component =>
        Finset.sum Finset.univ (fun left =>
          Finset.sum Finset.univ (fun right =>
            ((1 / 2 : Real) *
                spacetimeAlternatingSymbol left right first second) *
              palatiniFaceWeightFirstVariation coframe variation
                left right component)) := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro left _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro right _
  ring

/-- The polarized complementary Palatini face has the same arbitrary-basis
covariance as each Hodge-dualized coframe face. -/
theorem complementaryPalatiniFaceWeightFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        (matrix * coframe) (matrix * variation) first second =
      transportApply (palatiniBivectorTransport matrix)
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation first second) := by
  rw [complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum,
    complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum]
  simp_rw [palatiniFaceWeightFirstVariation_mul]
  exact (transportApply_weightedDoubleSum_fin4
    (palatiniBivectorTransport matrix)
    (fun left right => (1 / 2 : Real) *
      spacetimeAlternatingSymbol left right first second)
    (fun left right =>
      palatiniFaceWeightFirstVariation coframe variation left right)).symm

/-- The full twenty-four-component linearized connection residual is
covariant under every internal basis change. -/
theorem linearizedPalatiniConnectionResidual_mul
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (direction : Fin 4) :
    linearizedPalatiniConnectionResidual (matrix * coframe)
        (fun backwardDirection => matrix * velocity backwardDirection)
        direction =
      transportApply (palatiniBivectorTransport matrix)
        (linearizedPalatiniConnectionResidual coframe velocity direction) := by
  unfold linearizedPalatiniConnectionResidual
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_mul]
  exact (transportApply_sum_fin4
    (palatiniBivectorTransport matrix)
    (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity backwardDirection) direction backwardDirection)).symm

/-! ## Torsion covariance and arbitrary-tetrad selection -/

/-- The four internal components of linearized torsion for one ordered pair
of derivative directions. -/
def linearizedTorsionFiber
    (velocity : CoframeVelocity) (first second : Fin 4) : Fin 4 -> Real :=
  fun internal => linearizedCartanTorsion velocity internal first second

/-- Internal basis change acts on the internal index of Cartan torsion by
ordinary matrix-vector multiplication. -/
theorem linearizedTorsionFiber_mul
    (matrix : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (first second : Fin 4) :
    linearizedTorsionFiber
        (fun direction => matrix * velocity direction) first second =
      Matrix.mulVec matrix (linearizedTorsionFiber velocity first second) := by
  funext internal
  simp [linearizedTorsionFiber, linearizedCartanTorsion,
    Matrix.mul_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  ring

/-- **General-tetrad Palatini connection equation equals zero torsion.**
For a coframe with a supplied inverse, the twenty-four linearized connection
equations vanish exactly when all Cartan torsion components vanish. -/
theorem linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual coframe velocity
        direction component = 0) <->
      LinearizedTorsionFree velocity := by
  have hRight : coframe * inverseCoframe = 1 := mul_eq_one_comm.2 hLeft
  constructor
  · intro hResidual
    have hIdentityResidual : forall direction component,
        linearizedPalatiniConnectionResidual 1
          (fun backwardDirection =>
            inverseCoframe * velocity backwardDirection)
          direction component = 0 := by
      intro direction component
      rw [<- hLeft]
      rw [linearizedPalatiniConnectionResidual_mul]
      unfold transportApply
      simp [hResidual]
    have hTransformedTorsion :
        LinearizedTorsionFree (fun direction =>
          inverseCoframe * velocity direction) :=
      (linearizedPalatiniConnectionResidual_identity_iff_torsionFree
        (fun direction => inverseCoframe * velocity direction)).mp
          hIdentityResidual
    intro internal first second
    have hZero : Matrix.mulVec inverseCoframe
        (linearizedTorsionFiber velocity first second) = 0 := by
      rw [<- linearizedTorsionFiber_mul]
      funext transformedInternal
      exact hTransformedTorsion transformedInternal first second
    have hRecover := congrArg (Matrix.mulVec coframe) hZero
    simp only [Matrix.mulVec_mulVec, hRight, Matrix.one_mulVec,
      Matrix.mulVec_zero] at hRecover
    exact congrFun hRecover internal
  · intro hTorsion
    have hTransformedTorsion :
        LinearizedTorsionFree (fun direction =>
          inverseCoframe * velocity direction) := by
      intro internal first second
      have hFiber := linearizedTorsionFiber_mul inverseCoframe velocity
        first second
      have hZero : linearizedTorsionFiber velocity first second = 0 := by
        funext sourceInternal
        exact hTorsion sourceInternal first second
      change linearizedTorsionFiber
        (fun direction => inverseCoframe * velocity direction)
          first second internal = 0
      rw [hFiber, hZero, Matrix.mulVec_zero]
      rfl
    have hIdentityResidual : forall direction component,
        linearizedPalatiniConnectionResidual 1
          (fun backwardDirection =>
            inverseCoframe * velocity backwardDirection)
          direction component = 0 :=
      (linearizedPalatiniConnectionResidual_identity_iff_torsionFree
        (fun direction => inverseCoframe * velocity direction)).mpr
          hTransformedTorsion
    have hVelocity :
        (fun direction =>
          coframe * (inverseCoframe * velocity direction)) = velocity := by
      funext direction
      rw [<- Matrix.mul_assoc, hRight]
      simp
    intro direction component
    have hCovariance := linearizedPalatiniConnectionResidual_mul coframe 1
      (fun backwardDirection => inverseCoframe * velocity backwardDirection)
      direction
    simp only [Matrix.mul_one] at hCovariance
    rw [hVelocity] at hCovariance
    rw [hCovariance]
    unfold transportApply
    simp [hIdentityResidual]

/-! ## Explicit nonidentity background control -/

/-- A simple nonidentity anisotropic coframe used to witness that the general
selection theorem is genuinely beyond the identity background. -/
def anisotropicCoframe : Matrix (Fin 4) (Fin 4) Real :=
  !![2, 0, 0, 0;
     0, 3, 0, 0;
     0, 0, 5, 0;
     0, 0, 0, 7]

/-- The displayed two-sided inverse candidate for `anisotropicCoframe`. -/
def anisotropicInverseCoframe : Matrix (Fin 4) (Fin 4) Real :=
  !![1 / 2, 0, 0, 0;
     0, 1 / 3, 0, 0;
     0, 0, 1 / 5, 0;
     0, 0, 0, 1 / 7]

/-- The anisotropic control has the displayed inverse and is not the identity
coframe. -/
theorem anisotropicCoframe_inverse_and_nonidentity :
    anisotropicInverseCoframe * anisotropicCoframe = 1 ∧
      anisotropicCoframe ≠ 1 := by
  constructor
  · ext row column
    fin_cases row <;> fin_cases column <;>
      simp +decide [anisotropicInverseCoframe, anisotropicCoframe,
        Matrix.mul_apply, Fin.sum_univ_four]
  · intro hIdentity
    have hEntry := congrFun (congrFun hIdentity (0 : Fin 4)) (0 : Fin 4)
    norm_num [anisotropicCoframe, Matrix.one_apply] at hEntry

/-- On the explicit nonidentity anisotropic background, all twenty-four
linearized Palatini connection equations vanish exactly when Cartan torsion
vanishes. -/
theorem anisotropicCoframe_connectionResidual_iff_torsionFree
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual anisotropicCoframe velocity
        direction component = 0) <->
      LinearizedTorsionFree velocity :=
  linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    anisotropicCoframe anisotropicInverseCoframe
      anisotropicCoframe_inverse_and_nonidentity.1 velocity

/-! ## Finite-spacing and changing-carrier consequences -/

/-- At any fixed invertible background tetrad, exact finite local connection
equations at nonzero shrinking spacings force the fixed first coframe jet to
be torsion-free. -/
theorem finitePalatiniConnectionResidual_invertible_limit_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    LinearizedTorsionFree velocity := by
  rw [<- linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft]
  exact finitePalatiniConnectionResidual_scaled_limit coframe velocity spacing
    hNonzero hToZero hResidual

/-- **Conditional general-background changing-carrier endpoint.**  The finite
carrier may vary with refinement.  If its distinguished center has one fixed
invertible coframe, its four predecessor coframes have one fixed first jet,
and every identity-link action is connection stationary, then shrinking
nonzero spacing forces that jet to be torsion-free. -/
theorem identityConnectionStationary_refinement_invertible_linearizedTorsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (coframeField : (n : Nat) -> CoframeField (Site n))
    (site : (n : Nat) -> Site n)
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hCenter : forall n, coframeField n (site n) = coframe)
    (hPredecessor : forall n direction,
      coframeField n ((shift n direction).symm (site n)) =
        coframe + spacing n • velocity direction)
    (hStationary : forall n,
      NonlinearCoframePlaquetteConnectionStationary (shift n)
        (identityConnection (Site n)) (coframeField n)) :
    LinearizedTorsionFree velocity := by
  apply finitePalatiniConnectionResidual_invertible_limit_torsionFree
    coframe inverseCoframe hLeft velocity spacing hNonzero hToZero
  intro n direction component
  have hLocal :=
    identityConnectionStationary_finitePalatiniConnectionResidual
      (shift n) (coframeField n) (hStationary n) (site n) direction component
  rw [hCenter n] at hLocal
  have hIncrement :
      (fun backwardDirection =>
        coframeField n ((shift n backwardDirection).symm (site n)) - coframe) =
        fun backwardDirection => spacing n • velocity backwardDirection := by
    funext backwardDirection
    rw [hPredecessor n backwardDirection]
    module
  rw [hIncrement] at hLocal
  exact hLocal

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.palatiniFaceWeightFirstVariation_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniFaceWeightFirstVariation_mul

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.linearizedPalatiniConnectionResidual_invertible_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedPalatiniConnectionResidual_invertible_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.anisotropicCoframe_connectionResidual_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms anisotropicCoframe_connectionResidual_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.finitePalatiniConnectionResidual_invertible_limit_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finitePalatiniConnectionResidual_invertible_limit_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.identityConnectionStationary_refinement_invertible_linearizedTorsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_refinement_invertible_linearizedTorsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection


Hostile semantic audit of this exact Lean source. Return a concise verdict. Check: (1) whether palatiniBivectorTransport = -H C(L) H gives the claimed arbitrary internal-basis covariance with H^2=-1; (2) whether reducing a supplied-inverse coframe to identity genuinely proves the 24-equation iff zero torsion statement; (3) whether the reverse direction uses the correct left/right inverse orientation; (4) whether the finite-spacing and changing-carrier corollaries overclaim existence, nonlinear Levi-Civita recovery, nonidentity link transport, metric compatibility, or continuum physics; (5) vacuity, false shape, hidden assumptions, sign/index drift, and docstring-outruns-kernel. Output PASS or FAIL first, then only severe findings and precise corrections. Keep final answer under 700 words.
```

## Extracted response text

```text
PASS

### Semantic Audit Findings

1. **Arbitrary Internal-Basis Covariance**: The definition `palatiniBivectorTransport matrix = -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar)` correctly implements the conjugation $P(M) = -H C(M) H$. The proof `palatiniBivectorTransport_mul_lorentzHodgeStar` correctly verifies $P(M) H = H C(M)$ using the exact metric signature property $H^2 = -1$. The brute-force component-wise proof `coframeWedgeFirstVariation_mul` correctly establishes the base covariance, which lifts flawlessly to the Palatini face and the full 24-component residual.
2. **Supplied-Inverse Reduction**: The theorem `linearizedPalatiniConnectionResidual_invertible_iff_torsionFree` genuinely reduces the arbitrary-background problem to the identity-background theorem. The algebraic manipulation correctly factors the residual into the conjugated transport of the identity-background residual evaluated on the transformed velocity $e^{-1} v$.
3. **Left/Right Inverse Orientation**: The proof correctly uses the left inverse property $e^{-1} e = 1$ to evaluate the identity residual in the forward direction, and correctly invokes the right inverse property $e e^{-1} = 1$ (derived via `mul_eq_one_comm`) to recover the original velocity $e (e^{-1} v) = v$ in the reverse direction. Matrix multiplication associativity is strictly respected.
4. **Finite-Spacing and Changing-Carrier Corollaries**: The corollaries `finitePalatiniConnectionResidual_invertible_limit_torsionFree` and `identityConnectionStationary_refinement_invertible_linearizedTorsionFree` are perfectly scoped. They strictly claim `LinearizedTorsionFree velocity` as a conditional limit. The docstrings explicitly disclaim existence proofs, nonlinear Levi-Civita recovery, nonidentity link transport, metric compatibility, and continuum physics, matching the kernel statements exactly.
5. **General Integrity**:
   - **Vacuity**: The explicit construction of `anisotropicCoframe` and its inverse proves the non-vacuity of the general-tetrad extension.
   - **Sign/Index Drift**: The signs in the Hodge conjugation and the index summations in the weighted double sums are rigorously tracked and verified by `simp +decide` and `ring`.
   - **Hidden Assumptions**: None. The module relies only on standard Mathlib axioms (`propext`, `Classical.choice`, `Quot.sound`) and the previously established identity-background theorem.

The code is mathematically sound, logically rigorous, and perfectly aligned with its documentation.
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "PASS\n\n### Semantic Audit Findings\n\n1. **Arbitrary Internal-Basis Covariance**: The definition `palatiniBivectorTransport matrix = -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar)` correctly implements the conjugation $P(M) = -H C(M) H$. The proof `palatiniBivectorTransport_mul_lorentzHodgeStar` correctly verifies $P(M) H = H C(M)$ using the exact metric signature property $H^2 = -1$. The brute-force component-wise proof `coframeWedgeFirstVariation_mul` correctly establishes the base covariance, which lifts flawlessly to the Palatini face and the full 24-component residual.\n2. **Supplied-Inverse Reduction**: The theorem `linearizedPalatiniConnectionResidual_invertible_iff_torsionFree` genuinely reduces the arbitrary-background problem to the identity-background theorem. The algebraic manipulation correctly factors the residual into the conjugated transport of the identity-background residual evaluated on the transformed velocity $e^{-1} v$.\n3. **Left/Right Inverse Orientation**: The proof correctly uses the left inverse property $e^{-1} e = 1$ to evaluate the identity residual in the forward direction, and correctly invokes the right inverse property $e e^{-1} = 1$ (derived via `mul_eq_one_comm`) to recover the original velocity $e (e^{-1} v) = v$ in the reverse direction. Matrix multiplication associativity is strictly respected.\n4. **Finite-Spacing and Changing-Carrier Corollaries**: The corollaries `finitePalatiniConnectionResidual_invertible_limit_torsionFree` and `identityConnectionStationary_refinement_invertible_linearizedTorsionFree` are perfectly scoped. They strictly claim `LinearizedTorsionFree velocity` as a conditional limit. The docstrings explicitly disclaim existence proofs, nonlinear Levi-Civita recovery, nonidentity link transport, metric compatibility, and continuum physics, matching the kernel statements exactly.\n5. **General Integrity**: \n   - **Vacuity**: The explicit construction of `anisotropicCoframe` and its inverse proves the non-vacuity of the general-tetrad extension.\n   - **Sign/Index Drift**: The signs in the Hodge conjugation and the index summations in the weighted double sums are rigorously tracked and verified by `simp +decide` and `ring`.\n   - **Hidden Assumptions**: None. The module relies only on standard Mathlib axioms (`propext`, `Classical.choice`, `Quot.sound`) and the previously established identity-background theorem.\n\nThe code is mathematically sound, logically rigorous, and perfectly aligned with its documentation.",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 5542,
    "candidatesTokenCount": 570,
    "totalTokenCount": 21468,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 5542
      }
    ],
    "thoughtsTokenCount": 15356,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "suZbarvmIrfE-8YP-fWysAg"
}
```

## Error

```text

```
