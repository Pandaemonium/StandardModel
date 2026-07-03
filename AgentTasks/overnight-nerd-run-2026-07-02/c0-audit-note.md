# Gate C0 convention audit - GateC1 (overnight 2026-07-03)

Task T6. Scope: three-J separation and claim-scope terminology audit of the
`PhysicsSM/Draft/NullEdge/GateC1/` tree against the Gate C0/L0 conventions in
`docs/CONVENTIONS.md` (three-J rule; Krein non-overclaim; tetrahedral
claim-scope) and the mass-unification wording rules. Audit note only - prose
findings, no mass rewrite (per task scope). Grounded in targeted greps for
`gamma5`, `Hermitian`, `spectral gap`, `Krein`, `J_K`, `self-adjoint`.

## Verdict

The GateC1 tree is largely convention-clean. It respects the three-J rule by
omission (it is a kinematic lane using only `gamma5`), uses "Krein" correctly
as an audit concept, and carries physical properties as explicit hypothesis
fields rather than as established facts. Two wording items warrant a scope
note; neither is a correctness defect and neither requires renaming.

## Findings

### A. "Hermitian" as a name is an intended property (from the C1 gap red-team)

The names "Hermitian kernel", "Hermitian sign-kernel", "Hermitian overlap-seed
kernel" are pervasive (`NullEdgeOverlapKernel`, `TetraFreeOperator` line 381,
`TetraScalarWilsonSymbol` `H`, `SpectralIslandIndexPredicates`,
`TetraBranchWilsonSymbol`). The C1 gap semantic red-team (Aristotle `ffed1801`)
correctly flagged that under the operator-gap milestone's hypotheses (gamma5
*unitary* only) Hermiticity of `Hfree` is a TARGET, not an established
property.

Status after tonight: symbol-level Hermiticity is now *conditionally proven* -
`TetraSymbolHermitian.H_symbol_hermitian` gives `star (H gamma5 D a r rho k) =
H ...` under the two explicit gamma5 Clifford relations `star gamma5 = gamma5`
and `{gamma5, Q} = 0`. Operator-level (real-space `Hfree`) self-adjointness
remains a target (needs a sesquilinear field inner product + inner-product
Parseval).

Recommendation (non-blocking, docstring-level): where a docstring calls the
object a "Hermitian ... kernel" as if established, add a half-sentence that
Hermiticity is the intended property, proven at symbol level under the two
gamma5 relations and pending at operator level. The names themselves reflect
design intent and are standard lattice terminology; do not rename.
`PhysicalC1Criteria` already does this correctly - it carries
`hermitian_seed : H.IsHermitian` as a HYPOTHESIS field.

### B. "spectral gap" vs "coercive gap" wording

`spectral gap` occurs in `NullEdgeOverlapReferenceImport` (`GapBound gap A`
structure), `OverlapLocality`/`OverlapLocalityCertificates` (locality FROM a
gap), `ProjectorPersistence` (persistence UNDER a maintained gap),
`SpectralProjectorAPI` (Davis-Kahan contract UNDER a gap),
`SpectralIslandIndexPredicates`. In every case scanned, "spectral gap" is used
as an ABSTRACT PREDICATE or HYPOTHESIS ("under a spectral gap ..."), not as an
established property of the concrete tetrahedral operator - so these are
honest conditionals.

The one concrete free-operator result proved tonight
(`tetraFreeOperator_gap_equalN`) is deliberately worded as a *coercive
inverse-propagator gap* (`Hfree^* Hfree >= gamma`), NOT a spectral gap,
because self-adjointness is not yet established. This matches the
mass-unification wording rule in `docs/CONVENTIONS.md` (reserve "spectral gap"
for genuine operator spectra / self-adjoint contexts).

Recommendation: keep the concrete free-operator statement at "coercive
inverse-propagator gap" until real-space self-adjointness lands; the abstract
gap predicates are fine as written (they are hypotheses, correctly labeled).

### C. Three-J separation (Krein / Tomita / charge conjugation)

`docs/CONVENTIONS.md` Gate C0 requires `J_K` (Krein fundamental symmetry,
`= gamma5` in the lattice realization), `J_C` (charge conjugation), and
`J_mod` (state-dependent Tomita) to never be conflated. GateC1 uses `gamma5`
consistently as the chirality / sign-kernel prefactor (`H = gamma5 K`), i.e.
as `J_K`. It does NOT invoke Tomita modular conjugation `J_mod` (correct - that
is state-dependent and belongs only to Gate I2/D dynamics), and does not
conflate charge conjugation into the Krein symbol. "Krein" appears only as an
audit concept (`PositivityKreinAudit`, "positivity/Krein/no-ghost audit"),
consistent with the non-overclaim rule "Krein J-self-adjointness is a necessary
Lorentzian audit, not a stability theorem." No three-J conflation found.

### D. Claim scope (regulator-level)

No Lorentz-invariance or continuum overclaim found in the scanned files. The
concrete results are regulator-level; `PhysicalC1Criteria` correctly stages
physical health (Hermiticity, positivity, Krein, no-ghost) as hypothesis
fields of an audit structure rather than as proven facts. Consistent with the
tetrahedral claim-scope convention (regulator, not ontology).

## Actions

- No code changes made (audit-only per task scope).
- Docstring scope-notes under Finding A/B are offered to the C1 lane owner as
  optional, non-blocking hygiene; the newly added
  `TetraSymbolHermitian.H_symbol_hermitian` already discharges the symbol-level
  half of Finding A.
- No convention amendment to `docs/CONVENTIONS.md` needed; the existing Gate
  C0/L0 and mass-unification wording rules already cover these cases and
  GateC1 largely complies.
