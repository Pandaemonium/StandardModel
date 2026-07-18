# Aristotle semantic context pack

Generated: 2026-07-17T19:57:19
Query: `explicit local nonlinear Lorentz Palatini link Euler coefficient from four-corner plaquette tangent and complementary coframe face`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean`

Score: `0.876`

```text
noncomputable section

/-!
# Nonlinear Lorentz Palatini response

This module pairs the corrected complementary coframe face with the exact
right-trivialized tangent of group-valued Lorentz plaquette holonomy. The
matrix tangent is first passed through the proved equivalence between the
six-component bivector fiber and the mostly-minus Lorentz Lie algebra. An
eta-Lorentz hypothesis on every link ensures that this coordinate recovery is
exact rather than a projection of an unconstrained matrix.

The resulting finite response one-form is

`sum_(x,a,b) [B_ab(e,x), (delta H_ab H_ab^(-1))^vee]_J`.

At identity link transport it reduces exactly to the existing coframe-derived
Krein response built from the oriented additive plaquette curl.

## Scope and provenance

This is an exact finite nonlinear response identity. It is not yet a scalar
action: no theorem here asserts that the right-logarithmic response one-form is
globally integrable on the link-connection space. Consequently this module
does not yet supply a nonlinear Euler equation or select Levi-Civita
transport.

The construction composes the guarded complementary face convention in
`LorentzCoframePalatiniFace`, the exact Lie-algebra equivalence in
`LorentzBivectorLieAlgebraBridge`, and the Aristotle-assisted plaquette tangent
in `LorentzPlaquetteTangent`. Claim label: finite identity. Originality tag:
`[orig]`.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/FinitePeriodicCoframeKreinPalatiniVariation.lean` [coframeLinkFaceFirstVariation_eq_eulerPairing]

Score: `0.868`

```text
theorem coframeLinkFaceFirstVariation_eq_eulerPairing
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (coframe : CoframeField Site) (variation : LinkPotential Site 6) :
    coframeLinkFaceFirstVariation shift transport coframe variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          kreinPair lorentzBivectorFundamentalSymmetry
            (kreinLinkEulerCoefficient lorentzBivectorFundamentalSymmetry shift
              transport (coframeFaceWeight coframe) site direction)
            (variation site direction))) := by
  exact lorentzBivectorLinkFaceFirstVariation_eq_eulerPairing _ _ _ _

omit [DecidableEq Site] in
/-- Stationarity of the coframe-derived link response is exactly vanishing
Krein-covariant divergence of the complementary Palatini face field. -/
```

### 3. `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean` [nonlinearCoframePalatiniResponse_identity]

Score: `0.858`

```text
theorem nonlinearCoframePalatiniResponse_identity
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    nonlinearCoframePalatiniResponse shift (identityConnection Site)
        (identityConnection_isEtaLorentz Site) coframe variation =
      coframeLinkFaceFirstVariation shift identityLinkTransport coframe
        variation := by
  unfold nonlinearCoframePalatiniResponse coframeLinkFaceFirstVariation
    lorentzBivectorLinkFaceFirstVariation kreinLinkFaceFirstVariation
  simp_rw [plaquetteTangentBivector_identity,
    covariantLinearizedPlaquetteCurvature_identity]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.lorentzGenerator_plaquetteTangentBivector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGenerator_plaquetteTangentBivector

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.plaquetteTangentBivector_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteTangentBivector_identity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.nonlinearCoframePalatiniResponse_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePalatiniResponse_identity

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse
```

### 4. `docs/DOCUMENT_MAP.md` [The null-edge program: core documents]

Score: `0.852`

```text
ly separates machine-checked finite algebra and embedding-based calibration from the still-open compact intrinsic probe carrier, dimensional selection, operator convergence, manifoldlike phase, and continuum Einstein-action bridge. [LIVE]
- `PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean` - exact convention bridge from the physical six-component `(12,13,23,01,02,03)` bivector fiber to the matrix Lorentz Lie algebra. It proves two-sided coordinate recovery and identifies the Krein product with `-1/2` times the generator trace pairing. This makes the nonlinear plaquette/face contraction type-correct; differentiable action variation and Levi-Civita selection remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean` - exact nonlinear product/inverse response of group-valued Lorentz plaquette holonomy. It proves the four-corner adjoint formula, Lorentz Lie-algebra closure under eta-Lorentz links, and exact reduction to the oriented additive plaquette curl at identity transport. It is the guarded right-trivialized response used by the scalar action successor. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean` and `NonlinearLorentzPalatiniAction.lean` - exact six-coordinate nonlinear response, scalar ordered action `-1/2 tr(hat(B_ab)(H_ab-I))`, inverse orientation `H_ba=H_ab^(-1)`, holonomy-weighted formal product/inverse response, and exact identity-link agreement with the coframe-derived Krein/additive theory. Curve-level differentiation, the nonlinear Euler equation, covariance, and Levi-Civita selection remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean` and `FinitePeriodicCoframeKreinPalatiniVariation.lean` - explicit orientation-`0123` Lorentz Hodge star, internal cof
```

### 5. `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean` [covariantLinearizedPlaquetteCurvature_identity]

Score: `0.852`

```text
theorem covariantLinearizedPlaquetteCurvature_identity
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkPotential Site 6) (site : Site) (a b : Fin 4) :
    covariantLinearizedPlaquetteCurvature shift identityLinkTransport variation
        site a b =
      additivePlaquetteCurl shift variation site a b := by
  funext component
  unfold covariantLinearizedPlaquetteCurvature covariantForwardDifference
    identityLinkTransport additivePlaquetteCurl
  rw [transportApply_one, transportApply_one]
  ring

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- Complementary-coframe pairing with the exact nonlinear Lorentz plaquette
response. This is a connection-space one-form, not yet a scalar action. -/
```

### 6. `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean` [nonlinearCoframePalatiniResponse]

Score: `0.849`

```text
def nonlinearCoframePalatiniResponse
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (hConnection : forall site direction,
      IsEtaLorentz (unitMatrix (connection site direction)))
    (coframe : CoframeField Site) (variation : LinkVariation Site) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair lorentzBivectorFundamentalSymmetry
          (coframeFaceWeight coframe site a b)
          (plaquetteTangentBivector shift connection hConnection variation
            site a b))))

omit [DecidableEq Site] in
/-- The nonlinear response has the existing coframe-derived Krein/additive
response as its exact identity-link tangent control. -/
```

### 7. `PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean`

Score: `0.848`

```text
import PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
import PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge

/-!
# Exact Lorentz plaquette tangent

This module supplies the nonlinear connection-variation bridge between the
group-valued periodic link substrate and the six-component Lorentz bivector
fiber. Links are invertible real `4 x 4` matrices. A six-component
right-trivialized variation is inserted by

`delta U = U hat(X)`,

where `hat` is the fixed mostly-minus Lorentz generator map. Applying the
formal product and inverse rules to an exact plaquette holonomy and translating
the result back to the identity gives a sum of four adjoint-transported link
generators. Eta-Lorentz links keep this tangent in the Lorentz Lie algebra. At
identity transport the result reduces exactly to the oriented additive
plaquette curl used by the linearized finite theory.

## Scope and provenance

These are exact finite matrix identities. The tangent is the algebraic
product/inverse response of the group-valued holonomy; this module does not
claim that the resulting right-logarithmic one-form has already been integrated
to a globally defined scalar action. Pairing this response with the corrected
complementary coframe face is the next Palatini step.

The plaquette architecture is inherited from
`FinitePeriodicLinkConnection`; the Lorentz generator convention is inherited
from `LorentzBivectorLieAlgebraBridge`. The four-corner tangent formula and its
Lean proof were prepared as a focused Aristotle task and reviewed against those
live definitions. Claim label: finite identity. Originality tag: `[comp]`.
-/
```

### 8. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.848`

```text
match.
The same ordered six-component fiber is proved equivalent to the matrix
Lorentz Lie algebra through `hat(B)=F(B) eta`, with exact two-sided coordinate
recovery. Its indefinite bivector pairing is exactly
`-1/2 tr(hat(B)hat(C))`. A nonlinear plaquette tangent can therefore be paired
with the coframe bivector only after it is proved to lie in this six-dimensional
Lorentz image; pairing a six-vector directly with an unconstrained matrix
holonomy would be the wrong mathematical shape.

`LorentzPlaquetteTangent` closes that nonlinear representation gate. For
right-trivialized link insertions `delta U = U hat(X)`, the exact formal
product/inverse response `delta H H^(-1)` of the group plaquette is proved to
equal a four-corner sum of adjoint-transported Lorentz generators. Eta-Lorentz
links keep the result inside the Lorentz Lie algebra, so the existing
six-coordinate equivalence applies without projecting an unconstrained
matrix. At identity transport the formula reduces exactly to the oriented
additive plaquette curl. This is an exact response one-form, not yet a theorem
that it integrates globally to the desired scalar holonomy action.

`NonlinearLorentzPalatiniAction` supplies the corresponding scalar ordered
holonomy functional
`-1/2 tr(hat(B_ab)(H_ab-I))`. Its formal product/inverse response is
`-1/2 tr(hat(B_ab) delta H_ab)`; equivalently, the right-trivialized tangent is
multiplied by the exact plaquette holonomy away from identity. The module proves
`H_ba=H_ab^(-1)`, so ordered face antisymmetry has the expected
`H-H^(-1)` architecture, and proves that both the action and response have the
correct flat controls. At identity links the formal response agrees exactly
with the existing coframe-derived Krein/additive response, including its
normalization. The bivec
```

## Scoped paper hits

### 1. A New Spin Foam Model for 4d Gravity

Score: `0.738`
Zotero key: `K8QAB5UD`
arXiv: `0708.1595`
DOI: `10.1088/0264-9381/25/12/125018`
URL: http://arxiv.org/abs/0708.1595

Abstract:

Spin-foam model for four-dimensional gravity from constrained Plebanski BF theory; source guardrail for distinguishing single-bivector simplicity from full spin-foam cross-simplicity constraints.

### 2. Higher gauge theory

Score: `0.735`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264

### 3. An invitation to higher gauge theory

Score: `0.730`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 4. Discrete Exterior Calculus

Score: `0.724`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.722`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
