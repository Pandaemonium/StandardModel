import Mathlib

/-!
# A scoped grammar for origin-of-mass mechanism claims

An unqualified theorem classifying "all forms of mass" is not well posed:
changing the field content, operator-order bound, or observable readout changes
the possible mechanisms. This module makes the scope explicit as a finite typed
syntax. It separates:

* source rows in the declared action/transfer grammar;
* readout conventions such as invariant, pole, running, and screening mass;
* boundary mechanisms deliberately excluded from the grammar.

`classified_iff_admissible` is a **syntax-closure theorem**, not a derivation
of the Standard Model action. Its purpose is to make the quantifier in a later
physical exhaustiveness theorem precise and to prevent a tagged-sum tautology
from being advertised as dynamical completeness. A genuine physics theorem
must additionally map the quadratic expansion of a declared action into this
syntax and prove that map complete modulo gauge redundancy and field
redefinition.

The source taxonomy follows the mechanism audit in
`AutonomousLab/work/NE-DYNAMICS/CODEX_ORIGIN_OF_MASS_MECHANISM_MATRIX_2026-07-20.md`.
No external implementation is copied. Claim grade `M`, `[orig]`, for this
finite syntax only.
-/

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.ScopedMassMechanismGrammar

/-- Typed response domains prevent, for example, a gauge-orbit Gram operator
from being identified definitionally with a scalar-normal Hessian. -/
inductive ResponseDomain
  | fermionChiral
  | brokenGaugeOrbit
  | scalarNormal
  | neutrino
  | compositeTransfer
  deriving DecidableEq, Repr

/-- Named mechanism rows inside the declared grammar. The Dirac and Majorana
neutrino branches share a response domain but retain different provenance. -/
inductive SourceRow
  | fermionTurn
  | gaugeOrbitGram
  | scalarRadialHessian
  | neutrinoDirac
  | neutrinoMajorana
  | neutrinoWeinberg
  | compositeBinding
  deriving DecidableEq, Repr

/-- The response domain carried by each source row. -/
def SourceRow.domain : SourceRow -> ResponseDomain
  | .fermionTurn => .fermionChiral
  | .gaugeOrbitGram => .brokenGaugeOrbit
  | .scalarRadialHessian => .scalarNormal
  | .neutrinoDirac => .neutrino
  | .neutrinoMajorana => .neutrino
  | .neutrinoWeinberg => .neutrino
  | .compositeBinding => .compositeTransfer

/-- Readout conventions are not additional source mechanisms. -/
inductive MassReadout
  | invariantMass
  | poleMass
  | runningMass
  | screeningMass
  | transferGap
  deriving DecidableEq, Repr

/-- Payload types supplied by one declared finite theory. Distinct types are
intentional: even response rows require typed-domain separation, not merely a
chirality-parity argument. -/
structure TheoryContent where
  FermionResponse : Type
  GaugeResponse : Type
  ScalarResponse : Type
  NeutrinoResponse : Type
  CompositeResponse : Type

/-- The options that determine which extension/boundary rows are admitted. -/
structure Grammar (content : TheoryContent) where
  allowWeinberg : Bool
  allowCompositeTransfer : Bool

/-- A term admitted by the scoped mechanism grammar. The Boolean equalities on
the optional constructors make extension choices visible in theorem
hypotheses. -/
inductive AdmissibleTerm (T : TheoryContent) (G : Grammar T) :
    ResponseDomain -> Type
  | fermionTurn (response : T.FermionResponse) :
      AdmissibleTerm T G .fermionChiral
  | gaugeOrbitGram (response : T.GaugeResponse) :
      AdmissibleTerm T G .brokenGaugeOrbit
  | scalarRadialHessian (response : T.ScalarResponse) :
      AdmissibleTerm T G .scalarNormal
  | neutrinoDirac (response : T.NeutrinoResponse) :
      AdmissibleTerm T G .neutrino
  | neutrinoMajorana (response : T.NeutrinoResponse) :
      AdmissibleTerm T G .neutrino
  | neutrinoWeinberg (enabled : G.allowWeinberg = true)
      (response : T.NeutrinoResponse) : AdmissibleTerm T G .neutrino
  | compositeBinding (enabled : G.allowCompositeTransfer = true)
      (response : T.CompositeResponse) :
      AdmissibleTerm T G .compositeTransfer

/-- Recover the named source row without erasing the typed response domain. -/
def AdmissibleTerm.source {T : TheoryContent} {G : Grammar T}
    {d : ResponseDomain} : AdmissibleTerm T G d -> SourceRow
  | .fermionTurn _ => .fermionTurn
  | .gaugeOrbitGram _ => .gaugeOrbitGram
  | .scalarRadialHessian _ => .scalarRadialHessian
  | .neutrinoDirac _ => .neutrinoDirac
  | .neutrinoMajorana _ => .neutrinoMajorana
  | .neutrinoWeinberg _ _ => .neutrinoWeinberg
  | .compositeBinding _ _ => .compositeBinding

/-- Every source label recovered from an admitted term has exactly the term's
typed response domain. -/
theorem source_domain {T : TheoryContent} {G : Grammar T}
    {d : ResponseDomain} (term : AdmissibleTerm T G d) :
    term.source.domain = d := by
  cases term <;> rfl

/-- Existential packaging of all terms admitted by a fixed grammar. -/
abbrev Admitted (T : TheoryContent) (G : Grammar T) :=
  Sigma (AdmissibleTerm T G)

/-- Mechanisms outside the present quadratic/transfer grammar. They are named
explicitly so that relative exhaustiveness cannot silently become universal
exhaustiveness. -/
inductive BoundaryTerm
  | symmetricMassGeneration
  | higherDimensionalOperator (dimension : Nat)
  | undeclaredFieldContent
  | nonlocalResponse
  deriving DecidableEq, Repr

/-- The universe audited by this file: either a term admitted by the declared
grammar or an explicit boundary term. -/
inductive AuditedTerm (T : TheoryContent) (G : Grammar T)
  | admitted (term : Admitted T G)
  | boundary (term : BoundaryTerm)

/-- Classification is total on admitted syntax and deliberately refuses to
assign an in-grammar source label to boundary syntax. -/
def classify {T : TheoryContent} {G : Grammar T} :
    AuditedTerm T G -> Option SourceRow
  | .admitted term => some term.2.source
  | .boundary _ => none

/-- **Relative structural exhaustiveness.** Every admitted term has a named
source row whose domain agrees with the term's typed domain. -/
theorem admitted_has_named_source {T : TheoryContent} {G : Grammar T}
    (term : Admitted T G) :
    exists row : SourceRow,
      classify (AuditedTerm.admitted term) = some row /\
        row.domain = term.1 := by
  exact ⟨term.2.source, rfl, source_domain term.2⟩

/-- Boundary terms are never silently classified as one of the admitted
source rows. -/
theorem boundary_unclassified {T : TheoryContent} {G : Grammar T}
    (term : BoundaryTerm) :
    classify (AuditedTerm.boundary (T := T) (G := G) term) = none := rfl

/-- Exact syntax-level closure: classification succeeds if and only if the
audited term was constructed from the admitted grammar. -/
theorem classified_iff_admissible {T : TheoryContent} {G : Grammar T}
    (term : AuditedTerm T G) :
    (exists row, classify term = some row) <->
      exists admitted, term = AuditedTerm.admitted admitted := by
  cases term with
  | admitted admitted =>
      exact ⟨fun _ => ⟨admitted, rfl⟩,
        fun _ => ⟨admitted.2.source, rfl⟩⟩
  | boundary boundary =>
      constructor
      · rintro ⟨row, hrow⟩
        simp [classify] at hrow
      · rintro ⟨admitted, hadmitted⟩
        cases hadmitted

/-- A readout can be attached to a classified source without becoming a new
source row. This record keeps the two taxonomies orthogonal. -/
structure MassClaim (T : TheoryContent) (G : Grammar T) where
  source : Admitted T G
  readout : MassReadout

/-- Changing only the readout leaves the source term unchanged. -/
theorem MassClaim.withReadout_source {T : TheoryContent} {G : Grammar T}
    (claim : MassClaim T G) (readout : MassReadout) :
    ({ claim with readout := readout } : MassClaim T G).source = claim.source := rfl

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ScopedMassMechanismGrammar.admitted_has_named_source' depends on axioms: [] -/
#guard_msgs (whitespace := lax) in
#print axioms admitted_has_named_source

/-- info: 'PhysicsSM.Draft.NullEdge.ScopedMassMechanismGrammar.classified_iff_admissible' depends on axioms: [] -/
#guard_msgs (whitespace := lax) in
#print axioms classified_iff_admissible

end PhysicsSM.Draft.NullEdge.ScopedMassMechanismGrammar
