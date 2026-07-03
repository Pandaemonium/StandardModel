# Gate C2: the finite overlap index and the certified sign (technical summary)

Status: in-repo development summary, 2026-07-03. This document consolidates the
Gate C2 layer built during the 2026-07-02/03 overnight run into one coherent
mathematical narrative, records the honest scope, and states the open frontier
precisely. All Lean is draft-trust but kernel-checked, dependency footprint
`[propext, Classical.choice, Quot.sound]`, under `PhysicsSM/Draft/NullEdge/GateC2/`.
It extends the completed Gate C1 free chiral (overlap/Ginsparg-Wilson) release; it
does NOT claim a gauge index theorem, an anomaly, locality, or a continuum limit.

Claim label: **structural theorems** (finite matrix/operator algebra), with
explicit **consistency witnesses** and a concrete **nonzero-flux witness** (the
`pi`-flux triangle); the even-lattice / 2D-torus flux index and the anomaly bridge
remain the documented open frontier.

## 1. Setup

The overlap Dirac matrix is `Dov gamma5 eps = 1 + gamma5 . eps` for a chirality
involution `gamma5` (`gamma5^2 = 1`) and a sign-like involution `eps`
(`eps^2 = 1`); it satisfies the Ginsparg-Wilson relation
`gamma5 Dov + Dov gamma5 = Dov gamma5 Dov` (`OverlapGinspargWilson`, no
anticommutation needed). The lattice chiral index is the trace of the Luscher
modified chirality,

  overlapIndex gamma5 eps = (1/2) (Tr gamma5 - Tr eps)     (`OverlapIndexToy`).

The controlling fact: with balanced chirality `Tr gamma5 = 0`,
`overlapIndex = -(1/2) sig(eps)`, minus half the signature (`n_+ - n_-`) of the
sign involution. So the index depends ONLY on the eigenvalue-sign count of `eps`.

## 2. What is proved

**(a) Integrality.** `overlapIndex_isInteger`: for any involutions `gamma5, eps`,
`overlapIndex` is an integer, equal to `Tr(P_+^{gamma5}) - Tr(P_+^{eps})`, a
difference of the ranks of the `+1` eigenprojectors `P_+ = (1+M)/2` (trace of an
idempotent = `finrank` of its range over a characteristic-zero field, via
`LinearMap.IsProj.trace` and `Matrix.trace_toLin'_eq`). Needs only the involution
property, not Hermiticity. Lifted to finite-dimensional endomorphisms
(`OverlapIndexEndIntegrality.overlapIndexEnd_isInteger`) and instantiated at the
flagship free operator (`FlagshipOperatorIndex.flagship_operatorIndex_isInteger`):
the free tetrahedral chiral OPERATOR index is a well-defined integer, connecting
Gate C1 and Gate C2 end to end. `trace_ghatEnd` also identifies the End-level
index with the trace of the Luscher modified chirality
`f * (1 - (1/2) Dov)`, so the trace-index formula is a theorem rather than a
convention.
`OverlapIndexEigenspace.overlapIndexEnd_eq_eigenspace_dim_sub` rewrites the same
operator index as the difference of the `+1` eigenspace dimensions of the two
involutions, the transparent finite count behind the trace formula.
`trace_involution_eq_signature` and `overlapIndexEnd_eq_half_signature_sub`
also rewrite the trace of an involution as its `+/-` eigenspace signature and the
index as `(1/2)(sig f - sig g)`.
`OverlapIndexMatrixSignature.overlapIndex_eq_half_signature` transports this
controlling fact to concrete matrices via `Matrix.toLin'`, so explicit witnesses
and future gauge Wilson matrices have the same signature-index formula.

**(b) Free benchmark.** `tetraFreeOverlapIndex_eq_zero`: the free tetrahedral
overlap index is `0` for traceless chirality, because `Tr(gamma5 . Q) = 0` follows
from the chirality anticommutation `{gamma5, Q} = 0` plus trace cyclicity, and the
Wilson mass term is scalar. `tetraOverlapIndex_isInteger` certifies the concrete
free index is an integer. So the free theory carries no topology - the benchmark a
genuine gauge background must defeat.

**(b2) Free local-density benchmark.** `freeIndexDensity_eq_zero`: the operator
sign `signHfree` is expanded as a real-space kernel, the kernel diagonal is shown
translation-invariant, each free sign symbol is traceless, and therefore the free
local index density vanishes site-wise. This is the free/no-gauge local version of
the zero-index benchmark; it is not a gauge anomaly theorem.

**(b3) Operator value and the sum rule** (`FlagshipOperatorIndexZero.lean`).
`trace_signHfreeL`: the endomorphism trace of the operator sign equals the
site-sum of its kernel-diagonal spin-traces (product-basis computation), and
`trace_Gamma5opL = card . Tr gamma5`.  Consequences:
`operatorIndex_eq_sum_density` - unconditionally, the operator index equals the
site-sum of the local density, the finite exact form of "index = integral of the
index density" whose gauge-background version is the anomaly statement - and
`flagship_operatorIndex_eq_zero` - the free chiral OPERATOR index equals `0`
exactly.  The free benchmark now holds at all three levels: symbol,
certified-integer, operator value.  Still free/no-gauge.

**(c) The certified sign (no functional calculus).** The key C2b interface. A
**sign certificate** for a gapped (invertible) Hermitian `H` is a matrix `eps`
with `eps^2 = 1`, `eps H = H eps`, and `eps H` positive semidefinite - the finite,
functional-calculus-free defining conditions of `sign(H) = H |H|^{-1}`
(`OverlapSignCertificate.SignCertificate`). Two theorems make it well-posed:
- UNIQUENESS (`certifiedSign_unique`): any two certificates for the same `H`
  coincide. Slick proof: `(eps H)^2 = H^2` (from commutation + involution) and
  `eps H` PSD, so `eps H` is THE positive-semidefinite square root of `H^2`
  (unique); invertibility of `H` cancels.
- EXISTENCE (`OverlapSignExistence.certifiedSign_exists`, proved by Aristotle,
  ported): `epsCFC H = CFC.sqrt(H^2) . H^{-1} = |H| H^{-1}` is a certificate. The
  load-bearing step is `Commute (CFC.sqrt(H^2)) H` (a continuous-functional-
  calculus commutation).
- SELF-ADJOINTNESS (`OverlapSignHermitian.signCertificate_isHermitian`): any
  certificate for an invertible Hermitian `H` is automatically Hermitian, so the
  finite certificate conditions force a genuine self-adjoint involution.
Together (`certifiedSign_eq_epsCFC`): the certified overlap sign of any gapped
Hermitian is well-defined AND explicitly `|H| H^{-1}`. The STATEMENTS use only
involution + commutation + the Loewner order; the CFC appears only as a proof tool
for existence. A certified sign yields a GW overlap
(`SignCertificate.dov_ginspargWilson`).

Self-consistency (`OverlapSignHermitian.lean`): the three certificate conditions
already FORCE self-adjointness (`signCertificate_isHermitian` - `eps H` PSD is
Hermitian, so `H eps^* = H eps`, cancel `H`), so `eps^* = eps` is not an extra
hypothesis.  Hence `epsCFC H` is a genuine SELF-ADJOINT INVOLUTION - an orthogonal
reflection (`epsCFC_isSelfAdjoint_involution`).  The certificate story is thus
complete: the overlap sign of any gapped Hermitian EXISTS, is UNIQUE, is a
self-adjoint involution, and gives a GW overlap - a fully functional-calculus-free
characterization of `sign(H)`.

Abstract gauge interface (`GaugeOverlapInterface.lean`): for any gapped Hermitian
operator `H` and chirality involution `gamma5`, `epsCFC H` gives a
certificate-choice-independent integer overlap index and a GW overlap. Reduced to
computable form (`GaugeIndexInertiaForm.lean`): the index is
`(1/2)(sig gamma5 - Tr(epsCFC H))` UNCONDITIONALLY, and
`(1/2)(sig gamma5 - (n_+ - n_-))` in eigenvalue-count form
(`gaugeOverlap_index_eigenvalue_count_form`), now UNCONDITIONAL: the spectral
bridge `epsCFC_trace_eq_inertia` (`Tr(sign H) = n_+ - n_-`, via the continuous
functional calculus identity `epsCFC H = cfc sign H`; Aristotle job 25f0b738,
ported) is proved. So the gauge index is read directly off the eigenvalue signs of
`H_U`, no functional calculus in the final formula. The constructive frontier - exhibit a
genuine flux `H_U` with a nonzero index - is now REALIZED (section 2f).

**(d) Gauge invariance guardrail.** `overlapIndex_conj`: the index is invariant
under unitary conjugation. `SignCertificate.conj`: certificates transport
covariantly. Consequence: a nonzero index can NEVER come from a gauge/basis
conjugation of a trivial model - only from a genuine change of signature. This is
the discipline that separates a real topological index from a dressed-up trivial
one.

**(e) Nonzero-index witnesses (honest bridges).**
- `OverlapIndexWindingWitness.overlapIndex_gamma5WQ_epsWQ_eq`: a block-stacked
  graded involution family with index exactly `Q` for every winding charge `Q`.
  This is ALGEBRA-level - it exhibits involutions with the target signature; it
  does not derive them as `sign(H_U)` of an operator.
- `OverlapWindingSignJoin.signCertificate_HU_epsW` (+ `_unique`): the unit `epsW`
  IS the unique certified sign of an explicit gapped diagonal mass-defect
  (domain-wall) operator `HU = diag(-2,-3,-1,5)`, so its index `1` is a genuine
  sign-of-operator index - but of a DIAGONAL operator (a mass defect, not a gauge
  holonomy).
- `OverlapHoppingSignWitness.signCertificate_HU2_epsW` (+ `_unique`): strengthened
  to a genuinely NON-diagonal hopping operator `HU2 = epsW (C^H C)` (PSD for free),
  so the certificate is not special to diagonal operators. Caveat: `C` is real -
  this is a hopping operator with a FLAT connection (no complex link phase, no
  holonomy).

**(f) Genuine nonzero-FLUX index (the frontier witness).**
`FluxOverlapIndex.lean` (Aristotle job f3296d38, rewired onto the trusted repo
`overlapIndex` / `SignCertificate`) exhibits the smallest genuinely-fluxed model:
a `pi`-flux TRIANGLE (3-cycle) with links `u01=u12=1, u20=-1` and gauge-invariant
holonomy `-1` (`plaquette_gauge_invariant` - invariant under arbitrary site-phase
gauge transforms, so the flux is not a gauge artifact). The Hermitian gapped
hopping `Mtri` (rational spectrum `{1,1,-2}`) has certified RATIONAL sign
`epsTri=(2/3)Mtri+(1/3)`, pinned as `sign(Mtri)` by the finite positivity
certificate + uniqueness (`signCert_Mtri_unique`). With traceless
`gamma5U=1(x)sigma3` on `Fin 3 x Fin 2` and `HU=Mtri(x)1`,
`overlapIndex_flux : overlapIndex gamma5U epsU = -1` is a nonzero integer - the
trace of `sign(H_U)` of a genuine gauge-hopping operator, NOT a constructed defect
(`flux_is_nonzero_integer_witness` instantiates the abstract interface's
integrality with this nonzero value). The zero-flux triangle has index `+1`, and
`flux_shifts_index` proves `pi`-flux insertion shifts the index by `-2`: the
gauge-invariant holonomy demonstrably reaches the index. Honest scope: an odd
3-cycle carries a nonzero index at EVERY flux (a parity feature of odd loops), so
the sharp flux-driven statement is the `Delta=-2` jump, and a zero-to-nonzero flux
index needs an even lattice (section 4).

## 3. Honest scope: what is NOT proved

Validated by an adversarial Aristotle red-team (project ee95ba08: all statements
FAITHFUL, zero mismatches; caveats folded into docstrings):

1. **Genuine gauge flux realized on an odd cycle; zero-to-nonzero / even-lattice
   case open.** The `pi`-flux triangle (section 2f) IS a genuine gauge flux -
   gauge-invariant holonomy `-1`, index `-1` as the trace of `sign(H_U)`, index
   response `Delta=-2` to flux insertion. What is NOT yet done: because an odd
   cycle carries an index at every flux, a flux-vs-no-flux ZERO-to-nonzero jump
   needs an EVEN lattice, where a `2x2` plaquette `pi`-flux gives a balanced
   `+-sqrt 2` spectrum and index `0`; a genuine zero-to-nonzero flux index needs a
   2D Wilson-Dirac operator on a torus with net flux `2 pi` (section 4).
2. **No gauge anomaly / gauge index-density theorem.** The free local density is
   zero site-wise, but no gauge-background density has been connected to a chiral
   anomaly.
3. **No locality or continuum limit.**
4. The winding family (e) is algebra-level; only the `Q = 1` unit is tied to an
   operator.

## 4. The open frontier (precise)

The first genuine nonzero-FLUX finite operator is now built on the `pi`-flux
triangle. The remaining C2 frontier is the even-lattice / 2D-torus version and
the anomaly-density bridge. The design constraints (from the Aristotle strategy
job c36ea1a8 and the red-team) still govern successor constructions:
- The lattice must contain a CYCLE; a single link or a tree has no
  gauge-invariant flux (it gauges to zero).
- The nonzero index must arise from a gauge-invariant HOLONOMY forcing a signature
  imbalance in `eps_U = sign(H_U)`, not from a constructed defect.
- Tractability hint: a `pi`-flux configuration has link phase `e^{i pi} = -1`
  (REAL entries, no surds), the cleanest nontrivial case; e.g. a small periodic
  plaquette/torus with an odd number of `-1` links (a `Z_2` flux).

Concretely (ACHIEVED - `FluxOverlapIndex.lean`, Aristotle job f3296d38): the
`pi`-flux triangle builds an explicit gapped Wilson Hermitian `H_U` with `+/-1`
entries, pins `eps_U = sign(H_U)` via the certified-sign interface, and proves
`overlapIndex gamma5U eps_U = -1` with a `Delta=-2` response to flux insertion.
The remaining frontier is now (i) an EVEN lattice / 2D Wilson-Dirac operator on a
torus with net flux `2 pi`, giving a genuine ZERO-to-nonzero flux index (the odd
triangle carries an index at every flux); (ii) the anomaly / index-density bridge
connecting a gauge-background local density to the index; and (iii) locality and
the continuum limit. These are the successor gates.

## 5. File map

`OverlapIndexIntegrality`, `OverlapIndexEndIntegrality`, `OverlapIndexEigenspace`,
`OverlapIndexMatrixSignature`, `FlagshipOperatorIndex`
(integrality: matrix / endomorphism / eigenspace and signature count /
matrix-signature bridge / flagship-operator);
`TetraFreeIndexZero`
(free benchmark + certified integer), `TetraFreeIndexDensity` (free local density
zero), `FlagshipOperatorIndexZero` (operator density sum rule + exact free
operator index 0); `OverlapIndexWindingWitness` (winding = Q);
`OverlapSignCertificate` (certificate + uniqueness + GW), `OverlapSignExistence`
(existence + explicit `|H|H^{-1}`), `OverlapSignHermitian` (automatic
self-adjointness of certified signs + explicit self-adjoint `epsCFC`),
`GaugeOverlapInterface` (abstract gauge-overlap interface), `GaugeIndexInertiaForm`
(index in trace / eigenvalue-count form + the spectral bridge
`epsCFC_trace_eq_inertia`); `OverlapWindingSignJoin` (diagonal certified operator),
`OverlapHoppingSignWitness` (non-diagonal certified operator);
`OverlapIndexGaugeInvariance` (conjugation invariance); `FluxOverlapIndex` (the
concrete `pi`-flux triangle nonzero-index witness). The aggregator `GateC2.lean`
imports the whole layer: `lake build PhysicsSM.Draft.NullEdge.GateC2` kernel-checks
all 18 modules together. Prerequisite: the Gate C1 `GateC1/` overlap release and
`GateC1.OverlapIndexToy` index algebra.
