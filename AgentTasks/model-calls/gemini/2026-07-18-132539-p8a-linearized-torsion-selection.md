# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-18T13:24:18`
- Finished: `2026-07-18T13:25:39`
- Timeout seconds: `600`
- Max output tokens: `12000`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-18T13:23:48`
- Finished: `2026-07-18T13:23:56`
- Timeout seconds: `600`
- Max budget USD: `2.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
Hostile semantic audit for P8(a) of the null-edge GR program. Project context: the displayed nonlinear Lorentz Palatini action has an exact independent-link Euler equation, already proved equivalent at identity links to the Krein backward divergence of the complementary coframe face B_ab=(1/2) epsilon^(cdab) star(e_c wedge e_d). The attached new Lean module claims: (1) at the identity tetrad, its 24 linearized residual coordinates vanish iff all 24 Cartan torsion coordinates T^I_ab=V_a^I_b-V_b^I_a vanish; (2) the exact finite face increment is h L+h^2 Q; (3) a changing-carrier identity-link stationary family with fixed first jet and h->0 selects zero torsion. Known boundaries: no arbitrary-background or nonlinear Levi-Civita uniqueness, no graph-derived refinement, no varying-jet compactness, no continuum Riemann claim. Audit against false shape, vacuity, hollow telescoping, and docstring-outruns-kernel. Check especially direction/index orientation, use of predecessor/backward difference, whether the identity-link action theorem truly supplies the residual used, and whether fixed identity links plus varying coframe make the refinement theorem misleading or inconsistent. Return findings ordered by severity with exact theorem/line references, then a verdict (LAND / REVISE / REJECT), and precise corrective actions. Do not edit files.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedTorsionSelection.lean (416 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit

noncomputable section

/-!
# Linearized torsion selection from the null-edge Palatini link equation

The nonlinear null-edge Palatini action has two independent Euler sectors.
The coframe equation is the finite mixed Einstein equation.  The connection
equation is the covariant backward divergence of the complementary coframe
face, the discrete counterpart of `D(e wedge e) = 0`.  This module proves the
missing local torsion content of that second equation at the identity tetrad.

For an arbitrary four-direction coframe velocity, the twenty-four
identity-tetrad linearized Palatini connection coefficients vanish if and only
if all twenty-four independent Cartan torsion components vanish.  The proof is
an exact convention-locked calculation in the project ordering
`(12,13,23,01,02,03)`.

The exact finite face increment contains one further, quadratic term.  For a
spacing `h` it is

`h * linearized_connection_residual + h^2 * quadratic_defect`.

Consequently, if the exact local equation holds along nonzero spacings tending
to zero with a fixed first coframe jet, that jet is torsion-free.  A final
composition connects this local residual to identity-link stationarity on a
changing family of finite carriers.

This is a finite identity plus a conditional asymptotic theorem.  It does not
prove nonlinear Levi-Civita uniqueness, treat a nonidentity background
connection, construct a graph refinement, control a varying first jet, or
identify the selected links with continuum Levi-Civita transport.

Provenance: clean-room finite implementation of the standard Palatini
connection equation `D(e wedge e) = 0 => T = 0` for a nondegenerate tetrad,
specialized to the repository's mostly-minus metric, orientation `0123`, and
ordered Lorentz-bivector conventions.  The explicit quadratic defect is the
lattice product-rule correction and is project-original.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

/-- A first coframe jet: one internal-by-coordinate matrix for each of the
four null-edge directions. -/
abbrev CoframeVelocity :=
  Fin 4 -> Matrix (Fin 4) (Fin 4) Real

/-- Linearized Cartan torsion of a coframe velocity.  The first index is
internal; the last two are the antisymmetric derivative/coframe directions. -/
def linearizedCartanTorsion
    (velocity : CoframeVelocity) (internal first second : Fin 4) : Real :=
  velocity first internal second - velocity second internal first

/-- Every component of the linearized Cartan torsion vanishes. -/
def LinearizedTorsionFree (velocity : CoframeVelocity) : Prop :=
  forall internal first second,
    linearizedCartanTorsion velocity internal first second = 0

/-- Linearized complementary-face divergence at one point.  At the identity
tetrad this is the twenty-four-component Palatini connection equation. -/
def linearizedPalatiniConnectionResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity backwardDirection) direction backwardDirection component)

/-- The twenty-four independent torsion coordinates in the project bivector
ordering. -/
def linearizedTorsionCoordinate
    (velocity : CoframeVelocity) (internal : Fin 4) (component : Fin 6) : Real :=
  linearizedCartanTorsion velocity internal
    (bivectorFirst component) (bivectorSecond component)

/-- Explicit convention bridge from the twenty-four Cartan torsion
coordinates to the twenty-four identity-tetrad Palatini link coefficients. -/
def identityPalatiniTorsionResidual
    (velocity : CoframeVelocity) : Matrix (Fin 4) (Fin 6) Real :=
  !![-linearizedTorsionCoordinate velocity 0 0,
     -linearizedTorsionCoordinate velocity 0 1,
     -linearizedTorsionCoordinate velocity 0 2,
      linearizedTorsionCoordinate velocity 2 0 +
        linearizedTorsionCoordinate velocity 3 1,
     -linearizedTorsionCoordinate velocity 1 0 +
        linearizedTorsionCoordinate velocity 3 2,
     -linearizedTorsionCoordinate velocity 1 1 -
        linearizedTorsionCoordinate velocity 2 2;
      linearizedTorsionCoordinate velocity 0 4 -
        linearizedTorsionCoordinate velocity 3 2,
      linearizedTorsionCoordinate velocity 0 5 +
        linearizedTorsionCoordinate velocity 2 2,
     -linearizedTorsionCoordinate velocity 1 2,
     -linearizedTorsionCoordinate velocity 2 4 -
        linearizedTorsionCoordinate velocity 3 5,
      linearizedTorsionCoordinate velocity 1 4,
      linearizedTorsionCoordinate velocity 1 5;
     -linearizedTorsionCoordinate velocity 0 3 +
        linearizedTorsionCoordinate velocity 3 1,
     -linearizedTorsionCoordinate velocity 2 1,
      linearizedTorsionCoordinate velocity 0 5 +
        linearizedTorsionCoordinate velocity 1 1,
      linearizedTorsionCoordinate velocity 2 3,
     -linearizedTorsionCoordinate velocity 1 3 -
        linearizedTorsionCoordinate velocity 3 5,
      linearizedTorsionCoordinate velocity 2 5;
     -linearizedTorsionCoordinate velocity 3 0,
     -linearizedTorsionCoordinate velocity 0 3 +
        linearizedTorsionCoordinate velocity 2 0,
     -linearizedTorsionCoordinate velocity 0 4 -
        linearizedTorsionCoordinate velocity 1 0,
      linearizedTorsionCoordinate velocity 3 3,
      linearizedTorsionCoordinate velocity 3 4,
     -linearizedTorsionCoordinate velocity 1 3 -
        linearizedTorsionCoordinate velocity 2 4]

set_option maxHeartbeats 2000000 in
/-- The displayed torsion-coordinate bridge is exactly the project Palatini
coefficient at the identity tetrad. -/
theorem linearizedPalatiniConnectionResidual_identity_eq_torsionResidual
    (velocity : CoframeVelocity) (direction : Fin 4) (component : Fin 6) :
    linearizedPalatiniConnectionResidual 1 velocity direction component =
      identityPalatiniTorsionResidual velocity direction component := by
  fin_cases direction <;> fin_cases component <;>
    simp +decide [linearizedPalatiniConnectionResidual,
      identityPalatiniTorsionResidual, linearizedTorsionCoordinate,
      linearizedCartanTorsion,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- **Identity-tetrad Palatini connection equation equals zero torsion.**
The twenty-four linearized link equations are equivalent to the twenty-four
independent Cartan torsion equations. -/
theorem linearizedPalatiniConnectionResidual_identity_iff_torsionFree
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual 1 velocity direction component = 0) <->
      LinearizedTorsionFree velocity := by
  classical
  constructor
  · intro hResidual
    have hCoordinate (direction : Fin 4) (component : Fin 6) :
        identityPalatiniTorsionResidual velocity direction component = 0 := by
      rw [<- linearizedPalatiniConnectionResidual_identity_eq_torsionResidual]
      exact hResidual direction component
    have h00 := hCoordinate (0 : Fin 4) (0 : Fin 6)
    have h01 := hCoordinate (0 : Fin 4) (1 : Fin 6)
    have h02 := hCoordinate (0 : Fin 4) (2 : Fin 6)
    have h03 := hCoordinate (0 : Fin 4) (3 : Fin 6)
    have h04 := hCoordinate (0 : Fin 4) (4 : Fin 6)
    have h05 := hCoordinate (0 : Fin 4) (5 : Fin 6)
    have h10 := hCoordinate (1 : Fin 4) (0 : Fin 6)
    have h11 := hCoordinate (1 : Fin 4) (1 : Fin 6)
    have h12 := hCoordinate (1 : Fin 4) (2 : Fin 6)
    have h13 := hCoordinate (1 : Fin 4) (3 : Fin 6)
    have h14 := hCoordinate (1 : Fin 4) (4 : Fin 6)
    have h15 := hCoordinate (1 : Fin 4) (5 : Fin 6)
    have h20 := hCoordinate (2 : Fin 4) (0 : Fin 6)
    have h21 := hCoordinate (2 : Fin 4) (1 : Fin 6)
    have h22 := hCoordinate (2 : Fin 4) (2 : Fin 6)
    have h23 := hCoordinate (2 : Fin 4) (3 : Fin 6)
    have h24 := hCoordinate (2 : Fin 4) (4 : Fin 6)
    have h25 := hCoordinate (2 : Fin 4) (5 : Fin 6)
    have h30 := hCoordinate (3 : Fin 4) (0 : Fin 6)
    have h31 := hCoordinate (3 : Fin 4) (1 : Fin 6)
    have h32 := hCoordinate (3 : Fin 4) (2 : Fin 6)
    have h33 := hCoordinate (3 : Fin 4) (3 : Fin 6)
    have h34 := hCoordinate (3 : Fin 4) (4 : Fin 6)
    have h35 := hCoordinate (3 : Fin 4) (5 : Fin 6)
    simp +decide [identityPalatiniTorsionResidual,
      linearizedTorsionCoordinate, linearizedCartanTorsion,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond] at h00 h01 h02 h03 h04 h05 h10 h11 h12 h13 h14 h15 h20 h21 h22 h23 h24 h25 h30 h31 h32 h33 h34 h35
    intro internal first second
    fin_cases internal <;> fin_cases first <;> fin_cases second <;>
      simp [linearizedCartanTorsion] <;> linarith
  · intro hTorsion direction component
    rw [linearizedPalatiniConnectionResidual_identity_eq_torsionResidual]
    simp only [LinearizedTorsionFree] at hTorsion
    fin_cases direction <;> fin_cases component <;>
      simp +decide [identityPalatiniTorsionResidual,
        linearizedTorsionCoordinate, hTorsion]

/-! ## Exact finite defect and shrinking-spacing selection -/

/-- Quadratic product-rule defect in the finite complementary-face
divergence. -/
def quadraticPalatiniConnectionResidual
    (velocity : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight (velocity backwardDirection)
        direction backwardDirection component)

/-- Exact finite complementary-face increment for four predecessor coframes. -/
def finitePalatiniConnectionResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (increment : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight
          (coframe + increment backwardDirection)
          direction backwardDirection component -
        complementaryPalatiniFaceWeight coframe
          direction backwardDirection component)

/-- Exact lattice product rule: the finite Palatini connection residual along
a scaled coframe jet is linear in the spacing plus an explicit quadratic
defect. -/
theorem finitePalatiniConnectionResidual_scaled
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (spacing : Real) (direction : Fin 4) :
    finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing • velocity backwardDirection)
        direction =
      spacing • linearizedPalatiniConnectionResidual coframe velocity direction +
        spacing ^ 2 • quadraticPalatiniConnectionResidual velocity direction := by
  funext component
  unfold finitePalatiniConnectionResidual
    linearizedPalatiniConnectionResidual
    quadraticPalatiniConnectionResidual
  simp_rw [complementaryPalatiniFaceWeight_line]
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have hTerm (backwardDirection : Fin 4) :
      complementaryPalatiniFaceWeight coframe direction backwardDirection component +
            spacing * complementaryPalatiniFaceWeightFirstVariation coframe
              (velocity backwardDirection) direction backwardDirection component +
          spacing ^ 2 * complementaryPalatiniFaceWeight
            (velocity backwardDirection) direction backwardDirection component -
        complementaryPalatiniFaceWeight coframe direction backwardDirection component =
      spacing * complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection) direction backwardDirection component +
        spacing ^ 2 * complementaryPalatiniFaceWeight
          (velocity backwardDirection) direction backwardDirection component := by
    ring
  simp_rw [hTerm]
  rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]

/-- If the exact finite local connection equation holds along nonzero
spacings tending to zero for one fixed first coframe jet, its linearized
Palatini residual vanishes. -/
theorem finitePalatiniConnectionResidual_scaled_limit
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    forall direction component,
      linearizedPalatiniConnectionResidual coframe velocity direction component = 0 := by
  intro direction component
  let linear :=
    linearizedPalatiniConnectionResidual coframe velocity direction component
  let quadratic :=
    quadraticPalatiniConnectionResidual velocity direction component
  have hFactor (n : Nat) : linear + spacing n * quadratic = 0 := by
    have h := hResidual n direction component
    rw [finitePalatiniConnectionResidual_scaled] at h
    change spacing n * linear + spacing n ^ 2 * quadratic = 0 at h
    have hProduct : spacing n * (linear + spacing n * quadratic) = 0 := by
      calc
        spacing n * (linear + spacing n * quadratic) =
            spacing n * linear + spacing n ^ 2 * quadratic := by ring
        _ = 0 := h
    exact (mul_eq_zero.mp hProduct).resolve_left (hNonzero n)
  have hLimit : Tendsto (fun n => linear + spacing n * quadratic)
      atTop (nhds linear) := by
    simpa using tendsto_const_nhds.add (hToZero.mul tendsto_const_nhds)
  have hZero : Tendsto (fun n => linear + spacing n * quadratic)
      atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hFactor n
  exact tendsto_nhds_unique hLimit hZero

/-- At the identity tetrad, the shrinking-spacing local connection equation
selects a torsion-free first coframe jet. -/
theorem finitePalatiniConnectionResidual_identity_limit_torsionFree
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual 1
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    LinearizedTorsionFree velocity := by
  rw [<- linearizedPalatiniConnectionResidual_identity_iff_torsionFree]
  exact finitePalatiniConnectionResidual_scaled_limit 1 velocity spacing
    hNonzero hToZero hResidual

/-! ## Link-equation composition -/

/-- Under identity bivector transport, the exact backward face divergence is
the finite Palatini residual built from predecessor coframe increments. -/
theorem identityTransport_divergence_eq_finitePalatiniConnectionResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) :
    kreinFaceBackwardDivergence lorentzBivectorFundamentalSymmetry shift
        identityLinkTransport (coframeFaceWeight coframe) site direction =
      finitePalatiniConnectionResidual (coframe site)
        (fun backwardDirection =>
          coframe ((shift backwardDirection).symm site) - coframe site)
        direction := by
  classical
  funext component
  unfold kreinFaceBackwardDivergence finitePalatiniConnectionResidual
    kreinCovariantBackwardAdjoint identityLinkTransport coframeFaceWeight
  simp_rw [kreinAdjointApply_one]
  apply Finset.sum_congr rfl
  intro backwardDirection _
  congr 1
  congr 1
  module

/-- Identity-link stationarity supplies the exact finite local Palatini
residual equation at every site. -/
theorem identityConnectionStationary_finitePalatiniConnectionResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (hStationary : NonlinearCoframePlaquetteConnectionStationary shift
      (identityConnection Site) coframe) :
    forall site direction component,
      finitePalatiniConnectionResidual (coframe site)
        (fun backwardDirection =>
          coframe ((shift backwardDirection).symm site) - coframe site)
        direction component = 0 := by
  have hDivergence :=
    (nonlinearCoframePlaquetteConnectionStationary_identity_iff_divergence
      shift coframe).mp hStationary
  intro site direction component
  rw [<- identityTransport_divergence_eq_finitePalatiniConnectionResidual]
  exact hDivergence site direction component

/-- **Conditional changing-carrier torsion-selection endpoint.**  Let the
carrier, shifts, coframe, and distinguished site vary with the refinement
level.  If every identity-link null-edge Palatini action is connection
stationary and the four predecessor coframes have one fixed first jet at the
distinguished site, then shrinking nonzero spacing forces that jet to be
Cartan torsion-free.

The fixed-jet premise is deliberately explicit.  Proving compactness and
convergence for a varying graph-derived jet remains a separate gate. -/
theorem identityConnectionStationary_refinement_linearizedTorsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (coframe : (n : Nat) -> CoframeField (Site n))
    (site : (n : Nat) -> Site n)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hCenter : forall n, coframe n (site n) = 1)
    (hPredecessor : forall n direction,
      coframe n ((shift n direction).symm (site n)) =
        1 + spacing n • velocity direction)
    (hStationary : forall n,
      NonlinearCoframePlaquetteConnectionStationary (shift n)
        (identityConnection (Site n)) (coframe n)) :
    LinearizedTorsionFree velocity := by
  apply finitePalatiniConnectionResidual_identity_limit_torsionFree
    velocity spacing hNonzero hToZero
  intro n direction component
  have hLocal :=
    identityConnectionStationary_finitePalatiniConnectionResidual
      (shift n) (coframe n) (hStationary n) (site n) direction component
  rw [hCenter n] at hLocal
  have hIncrement :
      (fun backwardDirection =>
        coframe n ((shift n backwardDirection).symm (site n)) - 1) =
        fun backwardDirection => spacing n • velocity backwardDirection := by
    funext backwardDirection
    rw [hPredecessor n backwardDirection]
    module
  rw [hIncrement] at hLocal
  exact hLocal

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.linearizedPalatiniConnectionResidual_identity_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedPalatiniConnectionResidual_identity_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.finitePalatiniConnectionResidual_scaled_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finitePalatiniConnectionResidual_scaled_limit

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.identityConnectionStationary_finitePalatiniConnectionResidual' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_finitePalatiniConnectionResidual

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.identityConnectionStationary_refinement_linearizedTorsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_refinement_linearizedTorsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```


The packet contains the full hostile-audit request and verbatim Lean source; ignore the recorded Claude credit failure and perform that requested semantic review now. Return findings ordered by severity, exact theorem references, verdict LAND/REVISE/REJECT, and precise corrective actions.
```

## Extracted response text

```text
An audit of the `NonlinearLorentzPalatiniLinearizedTorsionSelection.lean` module reveals that the mathematical formulation, discrete calculus signs, and logical structure of the torsion selection theorem are remarkably solid. The definitions correctly align with the standard Palatini formalism, and the discrete adjoints naturally produce the expected backward difference signs.

No severe semantic, structural, or docstring-outruns-kernel issues were found. The explicit linear system of 24 equations in `identityPalatiniTorsionResidual` is non-degenerate and correctly forces all 24 independent components of the linearized Cartan torsion to vanish, which the Lean kernel verifies.

### Findings

1. **Discrete Calculus Sign Consistency (Positive Finding)**
   The exact finite residual `finitePalatiniConnectionResidual` is defined as $F(x - \hat{\nu}) - F(x)$. While this is the negative of the standard backward difference $F(x) - F(x - \hat{\nu})$, it is the *exact* correct sign for the formal adjoint of the forward difference $f(x + \hat{\nu}) - f(x)$ used in the discrete action. The `module` tactic in `identityTransport_divergence_eq_finitePalatiniConnectionResidual` confirms this exact algebraic match without requiring manual sign corrections.

2. **Torsion Index Orientation (Positive Finding)**
   The definition `linearizedCartanTorsion velocity internal first second` computes `velocity first internal second - velocity second internal first`. Given the predecessor increment $e(x - \hat{\mu}) = 1 + h v_\mu$, the velocity $v_\mu$ acts as the negative derivative $-\partial_\mu e$. The index contraction perfectly matches the antisymmetry of the Cartan torsion $T^I_{\mu\nu} = \partial_\mu e^I_\nu - \partial_\nu e^I_\mu$, ensuring the zero-locus is physically meaningful.

3. **Docstring and Premise Alignment (Positive Finding)**
   The docstring for `identityConnectionStationary_refinement_linearizedTorsionFree` explicitly acknowledges that the fixed first jet is a premise and that varying graph-derived jets remain a separate gate. This avoids the "docstring-outruns-kernel" anti-pattern. The use
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "An audit of the `NonlinearLorentzPalatiniLinearizedTorsionSelection.lean` module reveals that the mathematical formulation, discrete calculus signs, and logical structure of the torsion selection theorem are remarkably solid. The definitions correctly align with the standard Palatini formalism, and the discrete adjoints naturally produce the expected backward difference signs.\n\nNo severe semantic, structural, or docstring-outruns-kernel issues were found. The explicit linear system of 24 equations in `identityPalatiniTorsionResidual` is non-degenerate and correctly forces all 24 independent components of the linearized Cartan torsion to vanish, which the Lean kernel verifies.\n\n### Findings\n\n1. **Discrete Calculus Sign Consistency (Positive Finding)**\n   The exact finite residual `finitePalatiniConnectionResidual` is defined as $F(x - \\hat{\\nu}) - F(x)$. While this is the negative of the standard backward difference $F(x) - F(x - \\hat{\\nu})$, it is the *exact* correct sign for the formal adjoint of the forward difference $f(x + \\hat{\\nu}) - f(x)$ used in the discrete action. The `module` tactic in `identityTransport_divergence_eq_finitePalatiniConnectionResidual` confirms this exact algebraic match without requiring manual sign corrections.\n\n2. **Torsion Index Orientation (Positive Finding)**\n   The definition `linearizedCartanTorsion velocity internal first second` computes `velocity first internal second - velocity second internal first`. Given the predecessor increment $e(x - \\hat{\\mu}) = 1 + h v_\\mu$, the velocity $v_\\mu$ acts as the negative derivative $-\\partial_\\mu e$. The index contraction perfectly matches the antisymmetry of the Cartan torsion $T^I_{\\mu\\nu} = \\partial_\\mu e^I_\\nu - \\partial_\\nu e^I_\\mu$, ensuring the zero-locus is physically meaningful.\n\n3. **Docstring and Premise Alignment (Positive Finding)**\n   The docstring for `identityConnectionStationary_refinement_linearizedTorsionFree` explicitly acknowledges that the fixed first jet is a premise and that varying graph-derived jets remain a separate gate. This avoids the \"docstring-outruns-kernel\" anti-pattern. The use",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 6289,
    "candidatesTokenCount": 478,
    "totalTokenCount": 18285,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 6289
      }
    ],
    "thoughtsTokenCount": 11518,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "8uBbaoSANaW5sOIPzInUsAI"
}
```

## Error

```text

```
