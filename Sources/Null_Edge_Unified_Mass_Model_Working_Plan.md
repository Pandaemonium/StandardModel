# Null-edge unified mass model: current working plan

**Current compact plan, 2026-06-27.**

This file is the active daily plan. The previous longform working document has
been archived at [`Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md`](Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md).
Major pivots are summarized in
[`../AgentTasks/null-edge-decision-log-2026-06-27.md`](../AgentTasks/null-edge-decision-log-2026-06-27.md).

Companion documents:

- [`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`](Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md)
- [`Null_Edge_Causal_Graph_Publication_Plan.md`](Null_Edge_Causal_Graph_Publication_Plan.md)
- [`Null_Edge_Causal_Graph_Strengthened_Program.md`](Null_Edge_Causal_Graph_Strengthened_Program.md)
- [`NullStrand_Lean_Roadmap_Improved.md`](NullStrand_Lean_Roadmap_Improved.md)
- [`../docs/NULLSTRAND.md`](../docs/NULLSTRAND.md)

## 1. Current thesis

The strongest defensible thesis is:

```text
Primitive spacetime transport can be organized as null-edge transport, while
effective mass appears as a canonical quadratic obstruction to remaining a
single free gapless null mode.
```

Do not claim:

```text
All mass is literally the same Plucker spread formula.
```

Use this hierarchy:

```text
canonical quadratic obstruction
> spectral gap, when an operator/Hessian/Hamiltonian/mass matrix is present
> mass-shell eigenvalue matching, when a kinetic shell equals an internal block
```

The word `canonical` is load-bearing. A map `B` is useful only when it is forced
by geometry, representation theory, gauge covariance, finite algebra, or an
explicit physical structure. If `B` is chosen after the mass is known, the claim
is just reparametrization.

## 2. Claim labels

Use these labels everywhere:

```text
Representation:
  Standard physics data are placed on null-edge variables without reducing
  freedom.

Reconstruction:
  A theorem recovers a known mechanism from null-edge primitives, with inputs
  still free.

Structural theorem:
  A qualitative feature is forced once specified algebraic inputs are assumed.

Prediction:
  A parameter or structure normally free in EFT is fixed or restricted.
```

Current global status:

```text
P1 finite Plucker theorem: finite identity / kinematic reconstruction.
P1.5 toy mass mechanisms: reconstruction and structural theorems.
P2 finite super-Dirac algebra: draft reconstruction theorem spine.
Gate C branch/projector/ghost problem: binding blocker.
Gate F prediction: open; no numerical mass prediction yet.
Gate H Furey/internal spectrum: promising support, not a Gate C solution.
```

## 3. Canonical obstruction table

| Mechanism | Canonical obstruction | Current status |
| --- | --- | --- |
| Finite null bundle | `B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}` | Finite identity; P1 core. |
| Dirac/Yukawa fermion | `B_Y = M : E_R -> E_L` | Reconstruction once `M` is given; predictive only if `M` is constrained. |
| W/Z bosons | `B_EW(X) = X H_0` | Structural theorem given SM electroweak group, Higgs representation, and vacuum section. |
| Photon | `B_EW(X) = 0` | Stabilizer direction; `u(1)_em`. |
| Higgs boson | radial Hessian/stiffness of `V` at vacuum | Scalar-potential reconstruction. |
| Neutrino | Dirac/Majorana/seesaw block | Stress test; no mechanism selected. |
| QCD/hadron mass | no clean finite `B` yet | QCD supplies confinement; Plucker supplies invariant accounting once momenta are given. |

## 4. Paper path

### P1: finite kinematic core

Working role:

```text
finite Plucker/null-spinor bundle theorem plus claim-boundary paper.
```

Core theorem:

```text
det(sum_i psi_i psi_i^dagger)
  = sum_{i<j} |psi_i wedge psi_j|^2.
```

Interpretation:

```text
A finite bundle of null momenta has invariant mass exactly to the extent that
its null directions fail to remain projectively collinear.
```

P1 should not depend on Gate C, Furey, continuum convergence, QCD dynamics, or
Yukawa prediction.

### P1.5: finite quadratic-obstruction toy mechanisms

Purpose:

```text
Show how known Higgs/Yukawa and electroweak mass mechanisms fit the same
null-edge obstruction pattern without claiming prediction.
```

Main ingredients:

```text
Yukawa checkerboard / chirality-flip square.
Abelian Higgs link stiffness.
Electroweak stabilizer and orbit-stiffness rank theorem.
Scalar/gauge null quadrature.
FMS/gauge-invariant wording.
```

### P2: finite dual-soldered super-Dirac operator

Target operator:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
D   = i D_N + Gamma_s Phi_H
```

Current trusted sign convention:

```text
D^2 = -K_null - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

Guardrail:

```text
Plucker/null spread belongs to the kinetic-symbol side.
Phi_H^2 is the zero-order Higgs/Yukawa mass block.
They are matched by an on-shell condition, not added as two independent masses.
```

### Later prediction paper

Prediction requires a finite-to-EFT map:

```text
F : M_finite -> M_EFT
```

and either:

```text
rank(dF) < dim M_EFT
```

or a nontrivial relation:

```text
R(theta_EFT) = 0.
```

Until then, use `reconstruction` or `structural theorem`, not `prediction`.

## 5. Gate status table

| Gate | Status | Current meaning |
| --- | --- | --- |
| Gate A: sign/grading convention | Mostly passed in draft theorem spine. | `Phi_H` is `chi_E`-odd internally and `Gamma_s`-even in the super-Dirac convention, giving `+Phi_H^2`. |
| Gate B: finite dual-soldered algebra | Strong draft progress. | Finite Lichnerowicz/super-Dirac square and scalar/gauge quadrature exist in draft form. |
| Gate C: branch/projector/ghost | Binding blocker. | Bare operator does not force aligned chirality; determinant-zero locus has extra off-branch/cyclotomic zeros; release requires projection/splitting plus safety. |
| Gate D: continuum/DEC | Open. | Use positive DEC/Hodge-Dirac and connection-Laplacian scaffolds before full Lorentzian/Krein/retarded claims. |
| Gate E: electroweak/FMS | Reconstruction strong, composite spectrum open. | Orbit-stiffness rank/stabilizer theorem exists; full gauge-invariant W/Z composite pole theorem remains open. |
| Gate F: prediction/moduli | Open. | Need codimension, rank deficit, forbidden operator, restricted texture, or forced relation. |
| Gate H: Furey/internal/anomaly | Promising support. | Useful internal finite algebra, anomaly/gauge/charge/legal-map support; does not solve Gate C. |

## 6. Gate C current truth

Gate C is no longer a simple no-doubling or coefficient-zero problem. The
physical object is determinant/propagator-zero structure.

Distinguish:

```text
p(q) = 0           coefficient-vector zero
det D(q) = 0      determinant branch / pole candidate
p(q)^2 = 0        massless Clifford branch condition in the flat slash case
```

C21 refuted the old bare alignment hope:

```text
Bare OperatorForcesAlignment is false for the actual four-component symbol.
```

At each nonzero null branch, the raw four-component kernel is expected and now
formalized as:

```text
two-dimensional;
chirality-balanced;
one left Weyl line plus one right Weyl line.
```

Therefore the active target is:

```text
OperatorForcesAlignmentAfterProjection.
```

Gate C release now requires a specified physical branch operator or projected
sector satisfying all of:

```text
NodalSetControlled
BranchProjectorsControlled
ProjectedKernelOneDim
ProjectedChiralityAligned
ProjectedKreinPositive
GhostZeroSafe
SpeciesSplittingAudited
```

Recent blockers:

```text
C43/C44: high branches lie on exact determinant-zero nodal curves.
C64: there are off-branch determinant zeros such as q_star.
C66: there is a cyclotomic/S4 orbit of extra zeros.
The natural g5 split T_lin does not control the full determinant-zero locus.
```

Strategic fork:

```text
Route B1: classify the full determinant-zero locus.
Route B2: after classification, build a richer split term that gaps unwanted
          zeros while preserving the origin.
Route B3: release only a projected physical sector, with the release certificate
          explicitly rewritten around projected zeros.
Route B4: move Gate C up one layer, treating D_+ as a kinetic seed and releasing
          only a specified physical-sector operator D_phys.
```

Do not claim Gate C released until ghost-zero safety and Krein-positive physical
sector are also proved. A flavored index alone is not enough.

## 7. Furey/Baez/DVT role

Current division of labor:

```text
Furey/Baez/DVT:
  finite internal algebraic half;
  charge/gauge data;
  anomaly inheritance;
  internal grading;
  legal Phi_H/Yukawa bookkeeping;
  possible texture/codimension constraints.

Null-edge:
  external kinetic geometry;
  Plucker mass;
  dual soldering;
  branch/nodal/Krein/ghost gates;
  continuum limit.
```

Product architecture:

```text
H_total = H_null/spin/graph/Krein tensor H_Furey/internal
D       = i D_N tensor 1 + Gamma_s tensor Phi_H
```

Furey/Baez can support Gate H and maybe Gate F. They do not release Gate C.

Key guardrail:

```text
Use modules/minimal ideals for the associative algebra generated by
complex-octonion left multiplication operators.
Do not use raw octonion multiplication as if it were associative.
```

Important open internal jobs:

```text
FureyRightHandedSectorCompletion:
  formalize J* or the appropriate conjugate sector and match missing
  right-handed singlets in the all-left convention.

FureyBaezIntertwinerCodimensionAudit:
  compute legal Phi_H/Yukawa intertwiner freedom and compare with generic SM
  Yukawa moduli.

FureyBaezEMStabilizerComparison:
  compare internal u(1)_em selection with ker(X -> X H_0).
```

## 8. Source packs by gate

### P1 / Plucker / twistor context

Use P1 source pack and theorem crosswalk in the manuscript draft. P1 should stay
finite and claim-bounded.

### Gate C / minimally doubled / ghost safety

Key source lanes:

```text
Creutz 1009.3154: point splitting.
Durr-Weber 2108.11766: topology blindness without species splitting.
Kimura-Creutz-Misumi 1110.2482 / 1011.0761: index and flavored mass.
Weber 2312.08526 / 2502.16500 / 1611.08388: spin-taste and flavored minimally doubled fermions.
Yumoto-Misumi 2112.13501: spectral-graph species/nodal classification.
Golterman-Shamir 2311.12790: propagator zeros and ghost hazards.
Luscher hep-lat/9802011: exact lattice chiral symmetry and Ginsparg-Wilson.
Hernandez-Jansen-Luscher hep-lat/9808010: overlap locality under gap/smoothness assumptions.
Kaplan 0912.2560: lattice chiral symmetry, domain walls, overlap, and anomalies.
Friedan 1982 Nielsen-Ninomiya proof: no-go pressure on naive chiral lattice kernels.
```

### Gate D / continuum

Key source lanes:

```text
Dabetic-Hiptmair 2507.19405: DEC Hodge-Dirac convergence scaffold.
Zahariev math/0609464: discrete connection Laplacians.
Singer-Wu 1306.1587: connection Laplacian spectral convergence.
Boguna-Krioukov 2506.18745: local causal-set d'Alembertian comparison.
```

### Gate E / FMS / electroweak

Key source lanes:

```text
Maas 2305.01960: FMS/gauge-invariant electroweak language.
Quigg FERMILAB-PUB-07-002-T: standard electroweak mass pattern review.
van Suijlekom et al. 2401.03705: quiver spectral-action comparison.
```

### Gate H / Furey/Baez/internal algebra

Recently ingested source anchors:

| arXiv ID | Zotero key | Role |
| --- | --- | --- |
| `2606.15235` | `DJRMU4CB` | Baez-Schwahn exceptional-Jordan SM gauge group. |
| `2209.13016` | `6VI58VGH` | Furey-Hughes one Weyl generation in `R tensor C tensor H tensor O`. |
| `1806.00612` | `Z232K7IU` | Furey ladder-operator SM gauge symmetry source. |
| `0904.1556` | `MZZEZUWA` | Baez-Huerta GUT/SM representation scaffold. |
| `math/0105155` | `WRIM6ZI7` | Baez octonion survey and convention background. |

Already present:

```text
2210.10126 Division algebraic symmetry breaking.
2206.06912 Octonion Internal Space Algebra for the Standard Model.
2505.07923 A Superalgebra Within.
```

Do not cite `1810.10465` as a Furey source without rechecking; in a dry run it
resolved to an unrelated deep-learning paper.

Candidate Gate H source anchors from the Pro hard-problem pass, not yet
independently citation-checked in this compact plan:

```text
2003.08814 Gresnigt: SM particle content with complete gauge symmetries from
  minimal ideals of Clifford algebras.
1705.01853 Tong: line operators and the global form of the Standard Model gauge
  group.
hep-th/9506115 Alvarez et al.: unimodularity/anomaly cancellation in NCG.
hep-th/0610241 Chamseddine-Connes-Marcolli: NCG Standard Model with neutrino
  mixing.
```

## 9. Current highest-priority work

### Immediate documentation/manuscript work

```text
1. Keep P1 independent and claim-safe.
2. Apply crosswalk overclaim fixes to P1 when the user is ready.
3. Keep the current plan compact; move historical analysis to archive/decision logs.
```

### Immediate Gate C work

```text
1. Full determinant-zero/nodal-locus classification beyond the known branch
   lines and cyclotomic witnesses.
2. Off-branch zero sector audit: Krein sign, residue, gauge coupling, ghost
   status.
3. Define PhysicalSectorData and D_phys before further release claims.
4. Search for or refute a local branch-flavor involution T_br.
5. Audit the RA-doubled flavored-Wilson overlap candidate.
6. If splitting is used, record every coefficient and sign partition in the
   prediction/moduli ledger unless symmetry/minimality fixes it.
```

### Immediate Furey/Baez work

```text
1. FureyRightHandedSectorCompletion.
2. FureyBaezIntertwinerCodimensionAudit.
3. LegalFiniteDiracForbiddenOperator theorem for Phi_H block form.
4. FureyBaezEMStabilizerComparison.
5. Consolidate existing Furey bridge theorems only where it improves citation
   and reviewability.
```

### Immediate continuum work

```text
1. Positive DEC/Hodge-Dirac proxy.
2. Connection-Laplacian gauge/holonomy audit.
3. Flat dual-soldered commutator theorem.
4. Lorentzian/Krein/retarded corrections only after the positive proxy is clear.
```

## 10. Stop rules

Downgrade or redesign if:

```text
Gate C determinant branches become unavoidable physical doublers.
Gauge-coupled zeros become Golterman-Shamir ghost-like singularities.
No projected physical sector can be made Krein-positive.
No DEC/continuum proxy survives basic scaling tests.
FMS composites cannot be made gauge-invariant.
Finite/quiver/internal moduli absorb all EFT freedom.
```

Keep going under `finite reconstruction` if:

```text
P1, P1.5, finite super-Dirac algebra, and Furey/internal legality work, but no
codimension or numerical prediction appears.
```

That outcome is still valuable: it would be a coherent, formalized null-edge
reconstruction of known mass mechanisms.

## 11. Bottom line

The project currently has:

```text
a strong finite kinematic theorem core;
a coherent canonical-obstruction language;
a draft finite super-Dirac square;
a gauge-invariant electroweak orbit-stiffness reconstruction;
a promising Furey/Baez internal algebra bridge;
a sharply isolated Gate C blocker.
```

The project does not yet have:

```text
a released Gate C physical branch theorem;
a full continuum Lorentzian convergence theorem;
a derivation of Yukawa values, gauge couplings, Lambda_QCD, or generation
number;
a numerical mass-spectrum prediction.
```

The next decisive successes would be:

```text
1. projected or split Gate C release with ghost/Krein safety;
2. Furey/Baez intertwiner codimension showing a real internal-sector constraint;
3. DEC/connection-laplacian continuum scaffold for the null-edge operator.
```
## 12. Gate C v3: regulated/projected release target

Update, 2026-06-27: follow-up Pro analysis recommends changing the Gate C
release target.

Decision:

```text
Do not release Gate C for the bare retarded symbol D_+.
Release Gate C, if at all, for a regulated/projected physical operator D_phys.
```

The bare operator remains valuable as the primitive null-edge kinetic seed, but
it should be marked:

```text
FATAL-FOR-NAIVE-FLAT, not fatal for the program.
```

Reason:

```text
The bare determinant-zero set is larger than the four modeled branch lines;
raw branch kernels are chirality-balanced;
T_lin misses off-branch/cyclotomic zeros;
flavored index and projected chirality do not imply ghost safety.
```

### 12.1 Null-Wilson regulator candidate

The clean candidate branch-control shape is:

```text
W(q) = sum_a (1 - cos q_a).
```

It has the key real-torus property:

```text
W(q) = 0 iff q = 0 mod 2*pi.
```

Therefore every non-origin real determinant zero of the bare symbol receives a
positive Wilson cost, whether or not the full zero locus has already been
classified.

Finite operator candidate:

```text
R_W = (r / (2 h)) sum_a (2 - T_a - T_a^sharp)
```

with flat symbol:

```text
R_W(q) = (r / h) sum_a (1 - cos q_a).
```

Near the physical origin, with `q_a = h k(ell_a)`:

```text
R_W(q) = O(h |k|^2),
```

so it does not change the leading continuum Dirac symbol. At high branches it
is cutoff-scale.

Claim label:

```text
regulated reconstruction / branch-control counterterm.
```

It is not prediction unless `r` and the regulator form are fixed by a separate
symmetry, minimality, spectral-action, or locality theorem.

### 12.2 Regulator caveat

A Wilson-like term is not automatically the final chiral-gauge solution. Treat
it as a kernel/regulator that may need an overlap, domain-wall, point-split, or
projected physical-sector construction.

Do not assume without proof that:

```text
D_NW = i D_N + Gamma_s R_W
```

is the correct final placement. The placement of `R_W`, its grading behavior,
its interaction with the Gate A square, and its effect on chirality must be
audited.

### 12.3 Gate C v3 release theorem schema

A publication-safe release theorem should have the form:

```text
Bare D_+ fails as a released physical operator.
A specified D_phys built from D_+, a null-Wilson/overlap/projected regulator,
and a physical-sector projection releases Gate C if:

1. non-origin real determinant zeros are regulated or projected out;
2. branch/taste/overlap chirality replaces raw ordinary branch chirality;
3. the retained sector is Krein-positive or has a positive physical quotient;
4. post-gauge residues are positive and ghost-zero artifacts are absent;
5. all regulator coefficients and counterterms are recorded in the moduli ledger
   unless they are forced.
```

Immediate theorem targets:

```text
wilson_zero_iff_origin;
wilson_positive_away_origin;
wilson_lifts_known_offBranch_zeros;
wilson_irrelevant_symbol;
nullWilson_gaugeCovariant;
projectedGateCRelease_from_wilson_residue.
```

Integrated C73 update:

```text
NullEdgeNullWilsonGaugeCovariance.lean now proves a finite link-dressed
null-Wilson regulator is gauge-covariant and Hilbert self-adjoint, and recovers
the flat scalar Wilson symbol in the trivial gauge.
```

Claim label:

```text
C0-supporting regulator theorem.
Not a C1 chirality theorem and not full Gate C release.
```

Next C0 gauge-robustness target:

```text
nullWilson_positiveSemidefinite:
  for unitary dressed shifts, each term 2 - T - T^sharp is
  (I - T)^sharp (I - T), hence the Wilson quadratic form is a sum of squared
  edge defects.

nullWilson_kernel_covariantlyConstant:
  the zero sector of the Wilson quadratic form is the common covariantly
  constant sector for the dressed null-edge shifts.
```

This would clarify what C0 can and cannot claim in gauge backgrounds:

```text
positive semidefinite regulator;
zero modes controlled by covariantly constant/holonomy sectors;
still no origin chirality or Gate C1 release.
```

## 13. Gate C v4: physical-sector data and RA-doubled flavored-Wilson overlap

Update, 2026-06-27: the Pro hard-problem responses sharpened the v3 Wilson
pivot. The upstream correction is:

```text
Old assumption:
  Gate C is a property of the raw flat D_+(q) on the full raw torus with
  ordinary Gamma_s chirality.

Current assumption:
  D_+(q) is only the retarded null-edge kinetic seed.
  Gate C is a theorem about specified physical-sector data and the released
  operator D_phys.
```

Introduce a compact release datum:

```text
PhysicalSectorData =
  (B_phys, P_phys, R, Gamma_phys, J_phys, H_sf, Locality, GhostSafe)
```

where `B_phys` is the admissible branch/momentum domain or quotient,
`P_phys` is a physical-sector projection/filter when present, `R` is the
branch-lifting/flavored regulator, `Gamma_phys` is the physical chirality
grading, `H_sf` is the legal spectral-flow kernel, and `GhostSafe` rules out
propagator-zero ghosts.

The revised Gate C theorem should say:

```text
Given the null-edge seed D_+, there exist physical-sector data such that:

1. D_phys has the intended continuum null-edge symbol near q = 0.
2. The retained origin branch has the desired Gamma_phys index.
3. All off-target determinant zeros are outside B_phys or lifted with a gap.
4. H_sf is genuinely Hermitian/self-adjoint in a positive physical Hilbert
   structure before applying sign(H_sf).
5. The regulator/projection is local or controlled quasi-local and
   gauge-covariant.
6. Lifted branches do not survive as gauge-coupled propagator-zero ghosts.
```

### 13.1 Candidate finite operator package

The most concrete candidate to audit is not a bare Wilson operator, but a
retarded/advanced doubled flavored-Wilson overlap seed.

Retarded seed:

```text
D_+[U] = (1/h) sum_a C_a (T_a[U] - I)
```

Spectral double:

```text
H_RA = H_R plus H_A

D_RA[U] =
  [ 0              D_+[U]  ]
  [ -D_+[U]^dagger 0       ]
```

This puts backward/advanced shifts in the spectral double instead of the
strictly retarded causal update block.

Gauge-covariant edge-cosines:

```text
S_a[U] = (1/2) (T_a[U] + T_a[U]^dagger)
```

Scalar Wilson lift:

```text
W[U] = sum_a (I - S_a[U])
```

Tetrahedral flavor scalar:

```text
F_tet[U] = (1/4!) sum_{pi in S4} S_{pi(1)} S_{pi(2)} S_{pi(3)} S_{pi(4)}
```

in the free commuting-shift limit:

```text
W(q) = sum_a (1 - cos q_a)
F_tet(q) = product_a cos q_a
```

Branch-flavor involution:

```text
T_br[U]
```

with the desired free-branch behavior:

```text
T_br = +1 on the intended origin branch;
T_br = -1 on unwanted chiral-balanced branch germs.
```

The proposed lift is:

```text
M_lift =
  r W
  + mu (I - T_br) / 2
  + lambda (I - F_tet)
```

and the Hermitian spectral-flow candidate is:

```text
H_NED[U;m] =
  Gamma_hat_sE (D_RA[U] + M_lift[U] - m I).
```

The overlap-style released candidate, if the Hermitian/gap assumptions are
proved, is:

```text
D_phys^ov[U] =
  (1/h) (I + Gamma_hat_sE sign(H_NED[U;m_0])).
```

This is only a candidate until the finite algebra, gap, locality, and ghost
clauses are checked.

### 13.2 Role of each lift term

```text
r W:
  positive scalar lift on the real torus; useful for q_star-type off-origin
  zeros; does not solve chirality.

lambda (I - F_tet):
  CKM-style tetrahedral flavor scalar; helps separate corner/taste sectors but
  is still scalar near the origin.

mu (I - T_br) / 2:
  essential branch-flavored mass. This is the only listed term that can
  separate unwanted branch germs that meet or approach the origin.
```

At the known off-branch witness

```text
q_star = (2*pi/3, 0, 0, 4*pi/3)
```

the free values are:

```text
W(q_star) = 3
F_tet(q_star) = 1/4
```

so the branch mass receives at least:

```text
3 r + (3/4) lambda
```

before the overlap mass `m_0`, ignoring any additional help from `T_br`.

### 13.3 Scalar Wilson no-go for Gate C release

Scalar Wilson positivity is a branch-lifting lemma, not a chiral release
theorem.

Reason:

```text
D_+(0) = 0
W(0) = 0
```

So a plain scalar Wilson lift still leaves the origin fiber untouched. Unless a
separate physical projection or flavored grading is supplied, the origin kernel
remains Gamma_s-balanced and has zero ordinary Gamma_s index.

More strongly, if an unwanted determinant-zero curve `q(t)` reaches the origin
and the lift is only `r W + lambda (I - F_tet)`, then near the origin:

```text
W(q(t)) = O(|q(t)|^2)
I - F_tet(q(t)) = O(|q(t)|^2)
```

while the overlap branch mass satisfies:

```text
b(0;m_0) = -m_0 < 0.
```

By continuity, the unwanted branch remains retained near the origin. Therefore
Gate C needs either:

```text
a principled B_phys excluding that branch germ;
a local/gauge-covariant T_br separating it;
or a different physical-sector construction.
```

### 13.4 Ghost-zero rule

Use this as a hard Gate C condition:

```text
No gauge-charged branch may be removed solely by a zero of its propagator or by
a vanishing point-split numerator.
```

For every lifted unwanted branch region, prefer a true inverse-propagator gap:

```text
sigma_min(D_RA(q) + M_lift(q) - m_0) >= g > 0.
```

Point-split filters can diagnose or build mass terms, but they should not be
the final mechanism that makes a gauge-charged pole disappear. Otherwise the
Golterman-Shamir ghost-zero warning remains active.

### 13.5 Immediate theorem targets from the Pro pass

```text
RA_double_antiHermitian:
  D_RA^dagger = -D_RA for any finite D_+.

RA_grading_anticommutes:
  if {Gamma_s, C_a}=0, then {Gamma_hat_s, D_RA}=0.

H_NED_hermitian:
  if D_RA^dagger=-D_RA, {Gamma_hat_sE,D_RA}=0,
  M_lift^dagger=M_lift, and [Gamma_hat_sE,M_lift]=0,
  then H_NED^dagger=H_NED.

wilson_qstar_value:
  W(q_star)=3.

tetFlavor_qstar_value:
  F_tet(q_star)=1/4.

scalarWilson_not_gateC_release:
  scalar Wilson lifting does not imply nonzero physical chiral index at the
  origin.

continuous_scalar_mass_failure:
  scalar lifts that vanish quadratically at the origin cannot separate an
  unwanted determinant-zero branch germ reaching the origin.

branchFlavorInvolution_exists_or_noGo:
  search for a local/gauge-covariant T_br with opposite eigenvalues on target
  and unwanted branch germs.

modifiedChirality_after_Tbr:
  Gamma_mod = Gamma_s T_br, or Gamma_s chi_E T_br when legal, is definite on
  the retained branch.

freeGhostZero_exclusion:
  lifted branches are removed by mass gaps, not point-split propagator zeros.
```

### 13.6 Gate C staging: C0 species health before C1 chiral release

The next working split is:

```text
Gate C0: external species health.
  Keep the origin branch.
  Gap every non-origin real-torus branch by an inverse-propagator mass gap.
  Preserve the leading null-edge continuum symbol.
  Exclude free propagator-zero ghosts.

Gate C1: physical chiral release.
  Choose the physical chirality grading and positive physical sector.
  Prove the retained origin branch is chiral in that grading.
  Prove the gauge/Krein/ghost/counterterm clauses needed for the physical
  Standard-Model-facing release.
```

This split matters because a scalar Wilson term can plausibly solve C0 without
solving C1. In the retarded/advanced double, the pure finite linear algebra
lemma is:

```text
If A^dagger = -A and m > 0, then A + m I is invertible, with singular value
bounded below by m.
```

Therefore, for:

```text
A = D_RA(q)
m = r W(q)
```

and real `q != 0`, the Wilson positivity `W(q)>0` should imply:

```text
D_RA(q) + r W(q) I is invertible.
```

This would gap every non-origin real-torus determinant zero, including unknown
off-branch or cyclotomic zeros, without first classifying the full zero locus.
It would not make the origin branch chiral. Therefore it is a C0 theorem, not a
Gate C release.

Immediate C0 theorem targets:

```text
antiHermitian_add_posScalar_invertible;
antiHermitian_add_posScalar_singularValue_bound;
DRA_antiHermitian;
DRA_wilson_invertible_away_origin;
DRA_wilson_gap_not_projector_zero;
GateC0SpeciesHealthy_from_RAWilson.
nullWilson_positiveSemidefinite;
nullWilson_kernel_covariantlyConstant.
```

Immediate C1 theorem targets:

```text
PhysicalSectorData;
Tbr_exists_or_noGo;
modifiedChirality_after_Tbr;
positivePhysicalSector;
GateC1ChiralPhysicalRelease;
StagedGateCReleased_from_C0_C1_GateH.
```

Use this claim language:

```text
RA-Wilson may release Gate C0.
It does not release Gate C1 or full Gate C.
```

## 14. Gate H sharpening: legal finite Dirac and forbidden-operator target

The Pro hard-problem response confirms the existing division:

```text
Gate H can certify the internal finite algebra, anomaly, gauge quotient,
chi_E grading, and legal Phi_H block structure.

Gate H must not be used to release Gate C.
```

If the total structure factorizes as:

```text
H = H_N tensor H_F
D_seed = D_N tensor 1
A_F, chi_E, J_F act only on H_F
branch projectors act only on H_N
```

then the internal algebra cannot determine the external branch/taste chirality
unless a new theorem couples branch idempotents to internal idempotents. In
particular, `chi_E` cannot by itself lift determinant zeros or assign the
needed branch signs.

### 14.1 Almost-commutative product target

Use:

```text
H_total = H_N tensor H_F
D_h = i D_N tensor 1 + Gamma_s tensor Phi_H
```

with:

```text
chi_E Phi_H + Phi_H chi_E = 0
[Phi_H, Gamma_s] = 0
Phi_H^dagger = Phi_H
```

The physical chirality candidates are:

```text
Gamma_phys = Gamma_s tensor chi_E
Gamma_phys = (Gamma_s T_br) tensor chi_E
```

The second is the realistic Gate C candidate if branch/taste signs are needed.
The `T_br` factor must come from null-edge branch analysis, not from Furey by
itself.

### 14.2 First realistic prediction-grade Gate H theorem

The best near-term prediction-style target is not a Yukawa value. It is a
forbidden-operator/codimension theorem:

```text
For the finite internal module extracted from Furey/Gresnigt/Baez/DVT data,
every chi_E-odd, J_F-real, first-order, gauge-covariant finite Dirac/Higgs
operator has exactly the Standard Model block form:

Phi_H = Phi(Y_u, Y_d, Y_e, Y_nu, M_R)
```

where:

```text
Y_u, Y_d, Y_e, Y_nu are arbitrary generation matrices;
M_R is symmetric if nu_R is present;
no leptoquark, diquark, proton-decay, wrong-hypercharge, or colored-Higgs
blocks occur.
```

This would be a genuine structural/codimension result if the forbidden blocks
vanish from the finite algebraic axioms rather than from manual deletion.

It still would not predict:

```text
fermion masses;
mixing angles;
Yukawa ranks;
hierarchies.
```

### 14.3 Right-handed neutrino and global gauge quotient guardrails

Use this distinction:

```text
Pure gauge/anomaly data do not force nu_R, because it is a gauge singlet.
Specific finite-triple or ideal-closure axioms may force or naturally include it.
```

For the true gauge group:

```text
The finite matter representation factors through
  (U(1) x SU(2) x SU(3)) / Z6.
```

Do not claim that local field data alone force Nature's global form to be
exactly `Z6`; line operators, topology, or GUT/global input may be needed for
that stronger statement.

### 14.4 Gate H theorem order

```text
H1 AlgebraToModuleExtraction:
  Furey/Gresnigt/Baez/DVT data produce (A_F,H_F,chi_E,J_F).

H2 GaugeQuotientKernel:
  the central Z6 acts trivially on the known finite matter module.

H3 AnomalyInheritance:
  hypercharge and mixed anomalies cancel with correct multiplicities.

H4 LegalYukawaHom:
  the allowed Higgs/Yukawa Hom space is exactly the SM block list, with full
  generation matrices if generation space is passive.

H5 ForbiddenOperator:
  leptoquark, diquark, proton-decay, wrong-hypercharge, and colored-Higgs
  finite blocks violate at least one finite-algebra condition.

H6 ProductSquare:
  D_h = iD_N tensor 1 + Gamma_s tensor Phi_H feeds into the existing Gate A
  square with the positive Phi_H^2 sign.
```

## 15. Wave 20 integration: C0/C1 split, taste no-go, and Gate H roadmap

Update, 2026-06-27: Wave 20 returned three relevant completed jobs.

### 15.1 C87 split audit

Verdict:

```text
SPLIT-VALID-BUT-C1-NEEDED-FOR-SM.
```

Meaning:

```text
Gate C0 is a valid and useful species-health layer.
Gate C1 remains mandatory for the Standard Model-facing chiral release.
```

The key correction is:

```text
C0 plus a chiral Gate H internal representation is not sufficient if the
external origin sector remains chiral-balanced.
```

Reason:

```text
In the factorized product H_N tensor H_F, the total chiral index factorizes.
If the external origin sector has index zero, the product index is zero no
matter how rich the internal representation is.
```

Claim discipline:

```text
RA-Wilson may release C0.
It cannot be advertised as Gate C release unless C1 is also discharged.
Gate H certifies internal legality/anomaly/Yukawa structure; it does not
repair the D_+ branch locus.
```

### 15.2 C88 taste-only origin no-go

C88 formalizes the C83 warning in a finite two-line model:

```text
A taste-only involution that is scalar on the origin corner cannot turn a
Gamma_s-balanced origin kernel into a single-chirality origin kernel.
```

Consequence:

```text
Origin polarization requires a non-taste/spinor-line auxiliary layer:
projected Weyl, domain-wall, overlap, or another physical-sector construction.
```

### 15.3 H9 Gate H forbidden-operator roadmap

H9 recommends starting Gate H finite-Dirac classification with the cheapest
forbidden-block lift:

```text
gauge_forbids_nonYukawa_blocks.
```

Use the direct SM charge table as the first carrier, with Furey/Gresnigt ideals
as a bridge theorem rather than forcing the full division-algebra derivation in
the first proof.

The planned `LegalFiniteDirac` predicate has five clauses:

```text
1. chi_E-odd;
2. Gamma_s-even for the super-Dirac sign;
3. J_F-real;
4. gauge-covariant under the true SM covering/quotient data;
5. order-one / conjugate-ideal compatible.
```

Important split:

```text
Gauge equivariance forbids wrong-hypercharge and colored-Higgs blocks.
Leptoquark, diquark, and proton-decay blocks require order-one plus J_F/ideal
structure, not gauge alone.
```

Treat `nu_R` with a flag:

```text
optional as pure gauge data;
possibly canonical under finite-triple or J_F closure.
```
