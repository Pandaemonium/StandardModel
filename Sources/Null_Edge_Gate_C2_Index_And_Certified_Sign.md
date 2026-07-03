# Gate C2: the finite overlap index and the certified sign (technical summary)

Status: in-repo development summary, 2026-07-03. This document consolidates the
Gate C2 layer built during the 2026-07-02/03 overnight run into one coherent
mathematical narrative, records the honest scope, and states the open frontier
precisely. All Lean is draft-trust but kernel-checked, dependency footprint
`[propext, Classical.choice, Quot.sound]`, under `PhysicsSM/Draft/NullEdge/GateC2/`.
It extends the completed Gate C1 free chiral (overlap/Ginsparg-Wilson) release; it
does NOT claim a gauge index theorem, an anomaly, locality, or a continuum limit.

Claim label: **structural theorems** (finite matrix/operator algebra), with
explicit **consistency witnesses** and one documented **open construction**.

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
Gate C1 and Gate C2 end to end.

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
Together (`certifiedSign_eq_epsCFC`): the certified overlap sign of any gapped
Hermitian is well-defined AND explicitly `|H| H^{-1}`. The STATEMENTS use only
involution + commutation + the Loewner order; the CFC appears only as a proof tool
for existence. A certified sign yields a GW overlap
(`SignCertificate.dov_ginspargWilson`).

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

## 3. Honest scope: what is NOT proved

Validated by an adversarial Aristotle red-team (project ee95ba08: all statements
FAITHFUL, zero mismatches; caveats folded into docstrings):

1. **No genuine gauge flux / holonomy.** Every operator exhibited is a mass defect
   or a flat-connection hopping. No operator with nontrivial holonomy around a loop
   (a real magnetic flux) is constructed, so no index has yet been shown to equal a
   gauge-invariant topological charge. This is the central open problem (section 4).
2. **No gauge anomaly / gauge index-density theorem.** The free local density is
   zero site-wise, but no gauge-background density has been connected to a chiral
   anomaly.
3. **No locality or continuum limit.**
4. The winding family (e) is algebra-level; only the `Q = 1` unit is tied to an
   operator.

## 4. The open frontier (precise)

The remaining C2b step is a genuine nonzero-FLUX finite operator. The design
constraints (from the Aristotle strategy job c36ea1a8 and the red-team):
- The lattice must contain a CYCLE; a single link or a tree has no
  gauge-invariant flux (it gauges to zero).
- The nonzero index must arise from a gauge-invariant HOLONOMY forcing a signature
  imbalance in `eps_U = sign(H_U)`, not from a constructed defect.
- Tractability hint: a `pi`-flux configuration has link phase `e^{i pi} = -1`
  (REAL entries, no surds), the cleanest nontrivial case; e.g. a small periodic
  plaquette/torus with an odd number of `-1` links (a `Z_2` flux).

Concretely: build an explicit gapped Wilson Hermitian `H_U` on such a lattice with
integer/`+/-1` entries, use the certified-sign interface to pin `eps_U = sign(H_U)`
(exhibit + verify, or via `certifiedSign_exists`), and prove `overlapIndex gamma5
eps_U` equals the flux charge (`+/- 1`) - or prove it is `0` at that size and give
the smallest size that would be nonzero (an equally valuable negative result). An
Aristotle construction job (f3296d38) is attempting this. After it, the
anomaly/index-density bridge and locality are the successor gates.

## 5. File map

`OverlapIndexIntegrality`, `OverlapIndexEndIntegrality`, `FlagshipOperatorIndex`
(integrality: matrix / endomorphism / flagship-operator); `TetraFreeIndexZero`
(free benchmark + certified integer), `TetraFreeIndexDensity` (free local density
zero), `FlagshipOperatorIndexZero` (operator density sum rule + exact free
operator index 0); `OverlapIndexWindingWitness` (winding = Q);
`OverlapSignCertificate` (certificate + uniqueness + GW), `OverlapSignExistence`
(existence + explicit `|H|H^{-1}`); `OverlapWindingSignJoin` (diagonal certified
operator), `OverlapHoppingSignWitness` (non-diagonal certified operator);
`OverlapIndexGaugeInvariance` (conjugation invariance). Prerequisite: the Gate C1
`GateC1/` overlap release and `GateC1.OverlapIndexToy` index algebra.
