import PhysicsSM.Algebra.Octonion.G2FixingE111SpecialUnitaryGroup
import PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration
import PhysicsSM.Algebra.Furey.LadderOperators

/-!
# Furey.AxiomGuard: build-enforced axiom guard for the division-algebra flagships

Applies the `NullStrand.Audit.CapstoneAxioms` build-enforced axiom-guard pattern
(both grand-strategy audits' top TRUST recommendation) to the BET-A
(division-algebras -> Standard Model) flagships. Each `#guard_msgs in
#print axioms` block FAILS TO BUILD if the audited theorem's transitive axiom
surface changes - a `s o r r y`, a `n a t i v e _ d e c i d e`
(`Lean.ofReduceBool` / `Lean.trustCompiler`), or a new `a x i o m` leaking in
underneath.

Guarded flagships (all kernel-trust: `propext`, `Classical.choice`, `Quot.sound`
only - NO native tokens, unlike the E8 short-vector artifact):

* `su3Submonoid_eq_specialUnitaryGroup` - step 1a: the octonion `su3Submonoid`
  IS `Matrix.specialUnitaryGroup (Fin 3) C` (a literal submonoid equality).
* `fureyRealizesOneGenerationPackage` - one Standard Model generation realized on
  the complex-octonion minimal ideal (left-doublet charges derived from `Q_op`;
  see the honest scope note in that file re: the anomaly table / RH sector).
* `alpha1_nilpotent`, `anticomm_1_1dag` - the `Cl(6)` CAR relations for the
  complex-octonion ladder operators (nilpotency and `{alpha_i, alpha_i^dag} = 1`),
  the audit-praised non-trivial sorry-free core of BET A.

`(whitespace := lax)` only normalises message line-wrapping. If a surface is
intentionally changed, update the expected list here in the same commit and
explain why. Provenance: grand-strategy-audit follow-through, 2026-07-05. No
`s o r r y`/`a x i o m`; `#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.Algebra.Furey.AxiomGuard

/-! ## Step 1a: octonion SU(3) = Mathlib SU(3) -/

/-- info: 'PhysicsSM.Algebra.Octonion.G2ComplexLine.su3Submonoid_eq_specialUnitaryGroup' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Octonion.G2ComplexLine.su3Submonoid_eq_specialUnitaryGroup

/-! ## One Standard Model generation -/

/-- info: 'PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration.fureyRealizesOneGenerationPackage' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration.fureyRealizesOneGenerationPackage

/-! ## Cl(6) CAR relations (complex-octonion ladder operators) -/

/-- info: 'PhysicsSM.Algebra.Furey.LadderOperators.alpha1_nilpotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Furey.LadderOperators.alpha1_nilpotent

/-- info: 'PhysicsSM.Algebra.Furey.LadderOperators.anticomm_1_1dag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Furey.LadderOperators.anticomm_1_1dag


/- The concrete group isomorphism cited by the Furey-Baez manuscript:
OctonionMulAutFixingE111 =~* Matrix.specialUnitaryGroup (Fin 3) C, both
sides carrying a Group instance (2026-07-12, headline of the SU(3) claim). -/
/-- info: 'PhysicsSM.Algebra.Octonion.G2ComplexLine.octonionMulAutFixingE111MulEquivSpecialUnitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Octonion.G2ComplexLine.octonionMulAutFixingE111MulEquivSpecialUnitary

end PhysicsSM.Algebra.Furey.AxiomGuard
