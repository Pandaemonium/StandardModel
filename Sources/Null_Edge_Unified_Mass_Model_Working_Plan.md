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

Read this as an obstruction-geometry program, not as a single-formula mass
program. The trusted finite Plucker theorem is the core example, but the
larger target is to classify canonical failures of one-beam, one-branch,
one-orbit, or one-mode descriptions.

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

Use this template when proposing new mechanisms:

```text
zero locus / moduli locus
canonical obstruction map or section
quadratic norm, determinant, Hessian, or inverse-propagator gap
claim label: finite identity / reconstruction / structural theorem / prediction
```

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

Prediction ladder:

```text
Level 0: finite identity or reconstruction, no prediction claimed.
Level 1: absence theorem / forbidden operator / codimension result.
Level 2: rank, texture, or map-choice constraint.
Level 3: constrained finite-to-EFT relation R(theta_EFT)=0.
Level 4: numerical mass/coupling value.
```

Near-term Gate F should aim at Level 1 before mass-value claims.

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

Neutrino checkpoint:

| Option | Program meaning | Status |
| --- | --- | --- |
| `nu_R` absent | no sterile/right-handed block in the finite carrier | viable branch to audit, not selected |
| `nu_R` present, Dirac only | `M_D : E_R -> E_L` is legal, `M_R` forbidden or absent | stress-test branch |
| `nu_R` present with Majorana | `M_R : E_R -> E_R^c` is legal under finite-algebra clauses | stress-test branch |
| seesaw | second-order effective obstruction after integrating out heavy legal block | downstream only after legality is settled |

Do not hide this decision in prose. Every finite-algebra proposal should say
which row it supports, forbids, or leaves optional.

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

Named rule:

```text
Gate C is a branch-locus / physical-sector theorem,
not a scalar regulator theorem.
```

Scalar lifting can support Gate C0 species health. It cannot be advertised as
Gate C1 chiral release without branch-line/projector/index data and ghost-safe
inverse-propagator gaps.

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

### 13.7 Pro Gate C branch-line update

Update, 2026-06-27: the latest Pro memo sharpens Gate C into two theorem
families.

First, C0 should be promoted as a clean species-health theorem. For an
anti-Hermitian external symbol `A(q)` and scalar Wilson weight `W(q) >= 0`,

```text
||(A(q) + r W(q) I) v||^2
  = ||A(q) v||^2 + r^2 W(q)^2 ||v||^2
```

because the cross term vanishes. Therefore:

```text
sigma_min(A(q) + r W(q) I) >= r W(q).
```

For `W(q) = sum_a (1 - cos q_a)`, this gaps every non-origin real-torus zero
without requiring a full classification of `Z = {q | det D_+(q) = 0}`. This is
species health, not chiral release.

Second, C1 should be formulated as a release datum, not as a bare operator:

```text
ReleaseData =
  (D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)
```

Required clauses:

```text
C0SpeciesGap;
PhysicalProjectorLocalOrQuasilocal;
OriginWeylLineSelected;
MirrorAbsentOrInversePropagatorGapped;
NoGaugeChargedPropagatorZeroRemoval;
ContinuumWeylSymbolOnRetainedLine;
PositivePhysicalKreinOrHilbertSector;
AnomalyAccounting;
```

Direct unprojected overlap on the full bare `D_+` is now suspect until a mass
window theorem is proved. The target obstruction is:

```text
If an unwanted determinant-zero branch q(t) -> 0 satisfies
D_+(q(t)) v(t) = 0 and W(q(t)) crosses rho/r,
then X_rho(q) = D_+(q) + r W(q) I - rho I is singular.
```

Immediate theorem targets from this update:

```text
C0_antiHermitian_scalarWilson_gap;
scalar_originVanishing_deformation_cannot_polarize_balanced_kernel;
directOverlap_massWindow_safe_or_singularCrossing;
Tbr_branchClassifier_exists_or_noGo;
PiBr_projectedOverlap_release_contract;
domainWall_release_contract_after_branchSplit;
```

Wave 21/C90 recovered payload status (2026-06-27): the project now integrates the
original Aristotle hardening of
`PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`. Treat it as the
current API spine for `PiBr_projectedOverlap_release_contract` style work. It
does four useful things: renames the public verdict to
`ProjectedWilsonGateCRelease D_phys`; keeps the old `GateCReleased` name only as
a deprecated shim; separates residue/Krein positivity from no gauge-coupled
ghost zeros and the full Golterman-Shamir/BRST obligation; and exposes the
Wilson-regulator moduli clauses. It still does not construct `D_phys`, does not
release bare `D_+`, and does not close C1.

The native C1 fork is:

```text
T_br or Pi_br exists and is analytic/local/gauge-safe;
or no such branch classifier exists, forcing domain-wall/projected-overlap or
controlled quasi-local structure.
```

Use this claim language:

```text
RA-Wilson may release Gate C0.
It does not release Gate C1 or full Gate C.
```

### 13.8 Gate C v5: origin-polarization decision stack

Update, 2026-06-27: the strongest current C1 reframing is:

```text
C1 is an origin-polarization plus release-audit problem.
```

Before assembling another release theorem, decide whether the native finite
origin algebra can select one Weyl line at all.

Let:

```text
K0 = ker D_+(0)
Gamma0 = origin chirality on K0
J = balance symmetry with J Gamma0 J^-1 = -Gamma0
```

Then the key finite theorem is:

```text
If P0 commutes with J, then Tr(Gamma0 P0) = 0.
```

Proof shape:

```text
Tr(Gamma0 P0)
= Tr(J Gamma0 P0 J^-1)
= Tr((J Gamma0 J^-1)(J P0 J^-1))
= Tr((-Gamma0) P0)
= -Tr(Gamma0 P0).
```

Consequently any C1 projector with nonzero physical chiral index must fail to
commute with the balance symmetry. This turns the native route into a concrete
finite search:

```text
Find T0 in the native gauge-safe origin algebra such that:
  T0^2 = 1,
  T0^dagger = T0,
  [T0, G_i] = 0 for each gauge generator,
  Tr(Gamma0 (1 + T0)/2) = targetIndex != 0,
  (1 - T0)/2 supports an allowed inverse-propagator bad-sector mass.
```

Decision fork:

```text
Escape outcome:
  such a T0 exists.
  Next target: extend T0 to T_br(q,U), prove branch-germ separation,
  locality/quasi-locality, gauge safety, and a true bad-sector gap.

No-go outcome:
  every native gauge-safe origin endomorphism commutes with J.
  Then native finite/local T_br and non-scalar Wilson C1 release are impossible
  under these assumptions.
```

This should split the next Gate C work into named theorem packages:

```text
C106a_OriginPolarizationEscapeHatch:
  balanced-commutant zero-index theorem.

C106b_NativeOriginCommutantNoGo:
  if native origin algebra lies in the balance commutant, no native C1.

C106c_OriginPolarizerCertificate:
  data for T0, P0, nonzero index, and allowed bad mass.

C106d_BranchClassifierExtensionContract:
  extension T0 -> T_br(q,U) with branch, gauge, and locality clauses.

C106e_BadSectorMassGap:
  non-scalar bad-sector mass gives an inverse-propagator gap.

C106f_GhostZeroNoRelease:
  propagator-zero mirror removal is not C1 removal.

C106g_LocalityCertificateSoundness:
  formal projector does not imply locality or quasi-locality.

C106h_NativeC1ReleaseAssembly:
  conditional C1 from all certificates.
```

Projected overlap and domain-wall should remain live, but only as explicit
escape structures:

```text
Projected overlap:
  requires certified branch projector, mass window, local sign kernel,
  target index, bad-sector gap, and ghost-zero exclusion.

Domain wall:
  requires a null-edge-native bulk/boundary map, boundary Weyl mode,
  mirror gap, anomaly inflow, locality, and regulator stability.
```

Do not claim that a non-scalar Wilson term is independent of this decision. If
it is honest, it is `m (1 - T0)/2` or a legal variant generated by a native
origin polarizer. Without native `T0`, it is only a hand-chosen projector.

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

## 16. Lateral-analysis updates (2026-06-27)

### 16.1 Core language upgrades already to carry forward

- Add explicit observer-conditioned mixedness language alongside finite Plucker: `det(P)` is invariant, while `det(rho_{p|u}) = (m / E_u)^2` is frame-normalized.
- Record both observer operations used in the split:
  1) resolution observer (partial trace over hidden labels),
  2) kinematic observer (timelike normalization).
- Phrase Gate C as an algebraic-geometric branch problem: `Z := {q | det D_+(q) = 0}` plus branch-sheet/projector/cokernel data.

### 16.2 Additions to immediate work queues

- Gate C immediate tasks:
  1. branch locus/sheaf formulation (`det D_+(q)=0`) and local nodal charts;
  2. explicit branch-index or branch-involution theorem candidates (or no-go);
  3. gap proofs for lifted branches that are by inverse-propagator mass, not propagator-zero removal;
  4. explicit projected-physical-sector definition (`B_phys`, `P_phys`, `Gamma_phys`, ghost policy).

- Internal algebra tasks:
  1. treat forbidden-operator/codimension result as Gate F priority;
  2. run the intertwiner codimension audit after gauge/`J_F`/order constraints are explicit.

- Mass program sequencing:
  keep P1/P1.5/P2 separation, defer scalar spectrum claims, and keep “prediction” labels tied to constrained map geometry or codimension results.

## 17. Gate C architecture update: Wilson/Neuberger + CKM texture (2026-06-27)

The Gate C1 route has sharpened since the earlier branch-line and projected
release notes.

Current first physical architecture:

```text
Wilson/Neuberger overlap reference
  + CKM finite branch/flavor texture
  + null-edge homotopy/certificate stack.
```

Interpretation:

```text
Wilson/Neuberger resolves spacetime momentum doublers.
CKM splits finite branch/flavor sectors.
The null-edge endpoint must be gapped-homotopic to that reference.
```

Do not use literal naive CKM as the spacetime doubler-resolution operator.
CKM is a mass table/texture, not the primary kinetic lattice regulator.

The current reference kernel is:

```text
H_ref =
  Gamma_ref [
    D_W^0 tensor I_CKM
    + I tensor r_b(15I - M_CKM)
    - m0 I
  ].
```

The current null-edge endpoint is:

```text
H_ne =
  Gamma_K [
    D_ne^cov
    + W_NE,space
    + r_b(15R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

The combined free mass-window target is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

This produces:

```text
one light sector:
  spacetime corner n = 0 and CKM level ell = 0;

heavy sectors:
  all spacetime doublers n >= 1 and all CKM-heavy levels ell > 0.
```

The assembled Gate C1 certificate stack is now:

```text
CKM table;
shifted CKM/Wilson mass window;
sector-signature match;
C170/C181 sub-gap homotopy constants;
overlap sign/GW algebra;
true bad-sector inverse gap;
no propagator-zero mirror removal;
SMActsInternally or exact gauge dressing;
anomaly/index source theorem;
Krein-sign continuity;
non-ultralocal path-shell/resolvent control;
GateC1_NU assembly theorem.
```

Consequences for the unified mass program:

```text
Gate C is no longer an undefined “find a projector” blocker.
It is now a conditional reference-import theorem.
```

But it is still not closed:

```text
the actual null-edge Wilsonized kinetic operator must be specified;
the kinetic mismatch kappa must be bounded;
SMActsInternally must be checked in the Furey/Hughes convention;
reference index/locality/determinant/Krein/source certificates must be supplied;
returned Lean artifacts remain external until promoted and locally checked.
```

Mass/yukawa/prediction claims must still wait until this Gate C1 import is
instantiated. Gate H and CKM texture can support the construction, but they do
not replace the Wilson/Neuberger reference-import proof.

## 18. Gate C priority update: prove the null-edge endpoint is a Wilson-overlap import

Date: 2026-06-27
Source: Pro analysis pasted in
`C:\Users\Owner\.codex\attachments\9bc42fda-a54b-45e8-870c-9aec20a37454\pasted-text.txt`.

The unified mass program should treat Gate C1 as a reference-import theorem,
not as a request to invent a wholly new fermion-doubling solution.

The working architecture is:

```text
known Wilson/Neuberger overlap physics
  + CKM finite branch/flavor texture
  + null-edge gapped homotopy and sector-signature match.
```

This changes priorities:

```text
1. First prove the combined Wilson+CKM free mass window.
2. Specify the actual null-edge Wilsonized kinetic operator.
3. Bound kappa against the Wilson/Neuberger reference.
4. Keep omega and rho zero in the first theorem by using the same CKM table and R = I.
5. Add gauge/admissibility, branch-frame, anomaly, Krein, and determinant controls only after the free import theorem is stable.
```

Do not ask CKM alone to solve spacetime doubling. CKM is still valuable, but its
safe first role is:

```text
finite internal branch/flavor mass splitting.
```

The decisive mass window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

This should be the theorem that separates:

```text
one light sector:
  spacetime corner n = 0 and CKM level ell = 0;

all heavy sectors:
  spacetime doublers n >= 1 and CKM-heavy levels ell > 0.
```

The project should now avoid speculative mass/yukawa predictions until the
following concrete objects exist:

```text
H_ref;
H_ne;
sector-signature map S;
sub-gap homotopy bound;
overlap sign-kernel import theorem;
bad-sector inverse gap;
SMActsInternally certificate;
non-ultralocal control certificate.
```

Short version:

```text
Gate C1 is now a conditional import of a known working model.
The novelty is not replacing Wilson/Neuberger.
The novelty is interpreting a null-edge endpoint as lying in that same gapped
overlap component, with CKM as the finite branch/flavor texture.
```

## 19. C193 update: free Wilson+CKM reference window is now available

Date: 2026-06-27
Source: Aristotle project `e63bde80-6cec-4422-a350-0189a78037dc`, task
`0678f49b-4230-465f-94fa-4c0210598cdd`.

The combined Wilson+CKM free mass-window certificate has now been returned as a
standalone Lean theorem package.

This proves, for the reference shifted mass

```text
mu(n, ell) = 2 r_W n + w(ell) - m0
```

with

```text
w(0) = 0;
w(ell > 0) = 16 r_b,
```

that the window

```text
r_W > 0;
0 < m0 < min(2 r_W, 16 r_b)
```

gives:

```text
one light sector:
  (n, ell) = (0, 0);

all heavy sectors:
  spacetime doublers n >= 1;
  CKM-heavy sectors ell > 0;

uniform reference margin:
  gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

This is an important status change:

```text
The first finite reference theorem is no longer merely a plan.
It is now an external Aristotle Lean artifact awaiting local promotion/checking.
```

What this unlocks:

```text
sector-signature matching can use mu(n,ell) < 0 iff (n,ell) = (0,0);
C170/C181 homotopy budgets can use gamma_free as the explicit reference gap;
the next operator-level work can focus on kappa, alpha, beta rather than the
free Wilson+CKM sign table.
```

What it does not unlock:

```text
No full GateC1_NU claim yet.
No actual H_ne kappa bound yet.
No gauge/admissibility/anomaly/determinant/Krein certificate yet.
No local promotion into project Lean has been performed in this cycle.
```

## 20. C194-C203 update: C193 becomes the gap input, kappa is the critical path

Date: 2026-06-27
Source: completed Aristotle jobs C194-C203.

The program has now moved from "find the mass window" to "prove the actual
null-edge endpoint stays inside that window's gap budget."

The key result from C194 is the clean operator-level theorem:

```text
if H_ref has gap g;
if transported H_ne differs from H_ref by at most kappa;
if kappa < g;
then the straight-line homotopy remains gapped.
```

Together with C193, the natural choice is:

```text
g = gamma_free.
```

C201 gives the matching scalar and operator-style sign-stability theorem:

```text
perturbation below gamma_free cannot flip the physical/heavy sign pattern.
```

This makes the immediate Gate C proof target very crisp:

```text
ReferenceIsGapped:
  prove the CKM-decorated Wilson/Neuberger reference has gap gamma_free.

NullEdgeKineticCloseEnough:
  prove transported H_ne is within kappa of H_ref, with kappa < gamma_free.
```

C202 gives the branch-line lift language:

```text
maintained spectral island;
Riesz-style projector;
rank stability;
chiral-index stability.
```

C196 gives the sector-signature map that must match before reference import is
allowed. The signature slots are:

```text
rank;
chirality;
branch parity;
gauge representation;
mass sign;
Krein sign;
index weight.
```

C197 makes the Furey/Hughes audit precise:

```text
SM gauge generators must centralize the branch factor carrying J, Gamma_K, R,
and W_CKM, or an exact gauge-dressed substitute must be provided.
```

C195 and C203 prevent source overclaims:

```text
GW algebra does not imply determinant-line control.
Locality requires admissibility or an explicit non-ultralocal control
certificate.
Anomaly/index claims require physical-window/source hypotheses.
Ghost-zero exclusion is mandatory for the quantum target.
```

C198 is the fallback if a direct kappa estimate fails:

```text
H_Wilson+CKM -> H_abs.block -> H_ne.
```

It is a useful scaffold, but not yet a fully closed analytic theorem.

C200 is a caution, not a port:

```text
C200 reconstructed C193 without seeing the actual C193 Lean source.
Do not use that reconstructed port as authoritative.
Promote the real C193 artifact instead.
```

Updated short status:

```text
C193/C201 close the free sign-window and below-margin sign-stability layer.
C194 closes the abstract kappa-to-gapped-homotopy layer.
C196/C197/C202 define the import audits.
C195/C203 define source-contract boundaries.
The remaining hard mathematical object is the concrete H_ne and its kappa
bound relative to the Wilson+CKM reference.
```

## 21. C204-C208 update: abstract GateC1_NU_Free is assembled

Date: 2026-06-27
Source: completed Aristotle jobs C204-C208.

The free Gate C1 branch has crossed another threshold:

```text
There is now an external abstract Lean assembly theorem for GateC1_NU_Free.
```

This should not be overread. It is not the physical theorem yet, because its
key hypotheses still need concrete null-edge instantiation. But the logical
plumbing is no longer fuzzy.

Current structure:

```text
C193:
  Wilson+CKM mass window and gamma_free.

C205:
  ReferenceIsGapped gamma_free H_ref,
  assuming the concrete Clifford anticommutation/norm identity.

C194:
  kappa < gap gives gapped homotopy.

C201:
  perturbations below gamma_free preserve the sign split.

C202:
  maintained spectral island gives projector/rank/chiral-index persistence.

C207:
  these pieces assemble into GateC1_NU_Free.
```

C206 clarifies the exact missing null-edge data:

```text
H_ne = Gamma_K[D + W + r_b(15R - M_CKM) - m0 R].
```

with:

```text
kappa =
  kappaBranch + kappaKin + kappaWil + kappaCKM + kappaRm0.
```

First theorem simplification:

```text
kappaCKM = 0 if the CKM table transports exactly;
kappaRm0 = 0 if R transports exactly;
then only kappaBranch + kappaKin + kappaWil must be bounded.
```

The main remaining proof obligation is now:

```text
kappaBranch + kappaKin + kappaWil < gamma_free.
```

plus concrete instantiation of:

```text
H_ne;
transport S and Sinv;
Gamma_K / Clifford anticommutation;
sector-signature map;
SMActsInternally.
```

C208 updates the source plan. Add/ingest next:

```text
Kato for Riesz projection stability;
Davis-Kahan for finite-dimensional spectral subspace perturbation;
Hasenfratz-Laliena-Niedermayer for GW index theorem;
Narayanan-Neuberger for vacuum-overlap/determinant line;
Fujikawa as secondary chiral-Jacobian support.
```

Short status:

```text
We now have an abstract free-gate theorem stack.
We still lack the concrete null-edge endpoint data and its kappa bound.
```

## 22. C209-C213 update: still choosing the concrete operator

Date: 2026-06-27
Source: completed Aristotle jobs C209-C213.

The latest batch gives an important reality check:

```text
We have an abstract GateC1_NU_Free theorem stack.
We do not yet have a frozen concrete operator model.
```

C212 states the boundary most clearly. We are still choosing the operator until
the following are fixed:

```text
finite carrier, basis, and exact field;
explicit H_ref matrix entries;
explicit H_ne matrix entries;
explicit kappa value or interval;
free side-condition zeros.
```

Once these are fixed, the task becomes a proof about a model rather than a model
selection process.

C210 gives the best-case kappa theorem:

```text
exact branch, kinetic/Wilson, CKM, and R transport
  -> kappa = 0.
```

The realistic first theorem is:

```text
exact CKM/R transport
  -> kappa = kappaBranch + kappaKin + kappaWil.
```

Thus the concrete target is:

```text
kappaBranch + kappaKin + kappaWil < gamma_free.
```

C209 says the C205 Clifford/gap input should be connected to existing project
modules before inventing anything new:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean;
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean.
```

C211 gives the execution plan for promoting the real returned Lean artifacts
into `PhysicsSM/Draft/NullEdge/GateC1/`. This should be the next local Lean
engineering task, but it requires local checks before any claim that the project
builds with those files.

C213 updates determinant-line provenance:

```text
Narayanan-Neuberger:
  overlap determinant origin and phase ambiguity.

Kaplan-Schmaltz:
  domain-wall eta-invariant / partial inflow cross-check.

Hasenfratz-Laliena-Niedermayer:
  still needed for the GW index-theorem source contract.
```

Short status:

```text
We have the abstract theorem stack.
We need to freeze and formalize the concrete finite operator.
The next highest-value work is not another abstract certificate; it is concrete
operator instantiation and artifact promotion.
```

## 23. C214-C218 update: pivot from external abstraction to local promotion

Date: 2026-06-27
Source: completed Aristotle jobs C214-C218.

The strongest message from C218 is operational:

```text
Stop submitting broad abstract jobs until the external theorem stack is locally
promoted and the concrete operator is frozen.
```

C214-C217 are useful scaffolds:

```text
C214:
  proposes a Fin 3 generation/CKM carrier over Complex.

C215:
  proposes a momentum-corner diagonal H_ref model.

C216:
  gives a toy finite H_ne transport model with exact CKM/R transport and
  nonzero branch/kinetic/Wilson residuals.

C217:
  gives exact rational arithmetic for a balanced gamma_free window.
```

But they are not yet the final operator:

```text
The C214 Fin 3 carrier is generation-only.
The C215 H_ref corner model omits full spinor/internal carrier composition.
The C216 H_ne matrices are illustrative unless adopted.
The C217 numeric residual is a template unless derived from actual H_ne.
```

Therefore the unified mass program should pause speculative theorem expansion
and do the local engineering step:

```text
promote the real C193/C194/C201/C202 artifacts into Draft;
locally check them;
choose the authoritative first finite carrier;
define H_ref and H_ne;
derive kappa pieces from those definitions.
```

Only after that should we ask for more external proof work, and those jobs
should be narrow implementation jobs against the local modules.

## 24. C219-C221 update: local handoff is ready

Date: 2026-06-27
Source: completed Aristotle jobs C219-C221.

C219 gives the readiness checklist for local promotion:

```text
read the real artifact files;
create thin Draft modules C193/C194/C201/C202;
use aliases or exact wrappers;
preserve statement identity;
run targeted checks before claiming success.
```

C220 gives the Clifford bridge target:

```text
Use C21 actual Clifford-symbol conventions.
Do not invent a new gamma convention.
Keep the chirality-balanced bare-branch obstruction explicit.
Prove only the local anticommutation/norm bridge into C205.
```

C221 gives the finite Wilson reference source route:

```text
Wilson term = graph Laplacian / second difference;
corner-basis is enough for the first free theorem;
full DFT can wait for non-corner dispersion.
```

Operational consequence:

```text
Stop external broad-job expansion.
Proceed to local Draft promotion and targeted local Lean checks when approved.
```

## 25. C222-C224 update: exact promotion surface

Date: 2026-06-28
Source: completed Aristotle jobs C222-C224.

The exact promotion surface is now:

```text
C193 -> CKMWilsonWindow.lean;
C194 -> GappedHomotopy.lean;
C201 -> SignStability.lean;
C202 -> ProjectorPersistence.lean.
```

The local C21/branch files should not be copied into the Gate C1 Draft package.
They remain external sources for a later bridge theorem.

The first bridge theorem should be:

```text
branchKernel_chiralIndex_zero.
```

This is intentionally not a release theorem. It only translates the known
chirality-balanced C21 result into the C202/C205 projector/chiral-index
vocabulary.

The graph-matrix sources support `H_ref` only:

```text
arXiv:2112.13501;
arXiv:2311.11320.
```

They support Wilson-Laplacian/corner-basis representation and species-count
checks, not the null-edge endpoint `H_ne`.

Operational consequence:

```text
The next concrete step is additive Draft promotion of the four artifacts,
followed by targeted local checks if/when requested.
```

## 26. Local Draft promotion applied

Date: 2026-06-28

The four self-contained Gate C1 artifacts have been copied into Draft modules:

```text
PhysicsSM/Draft/NullEdge/GateC1/CKMWilsonWindow.lean;
PhysicsSM/Draft/NullEdge/GateC1/GappedHomotopy.lean;
PhysicsSM/Draft/NullEdge/GateC1/SignStability.lean;
PhysicsSM/Draft/NullEdge/GateC1/ProjectorPersistence.lean.
```

This is a local promotion milestone, but not a verification milestone:

```text
No local Lean checks were run.
The files are Draft-only.
They must not be treated as trusted until checked and reviewed.
```

The next proof-facing step is to check the promoted leaves and then build the
C220 bridge target:

```text
branchKernel_chiralIndex_zero.
```

## 27. Pro operator-freeze update: CKM is internal texture, not the spacetime resolver

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\9bc42fda-a54b-45e8-870c-9aec20a37454\pasted-text.txt`.

The compact Gate C plan should now be read through one firm architectural rule:

```text
Wilson/Neuberger overlap resolves spacetime doublers.
CKM supplies the finite branch/flavor mass texture.
The null-edge endpoint must be gapped-homotopic to that reference.
```

This is important because it keeps the project from trying to re-solve a known
fermion-doubling problem from scratch. The reference model is the established
Wilson/Neuberger overlap architecture. The null-edge work is to show that the
null-edge endpoint lies in the same gapped component and carries the same
sector signature.

The reference kernel is:

```text
H_ref =
  Gamma_ref [
    D_W^0 tensor I_CKM
    + I tensor r_b(15I - M_CKM)
    - m0 I
  ].
```

The null-edge endpoint is:

```text
H_ne =
  Gamma_K [
    D_ne^cov
    + W_NE,space
    + r_b(15R_ne - M_CKM^ne)
    - m0 R_ne
  ].
```

The clean free mass window remains:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

This separates:

```text
one light sector:
  spacetime corner n = 0 and CKM level ell = 0;

all heavy sectors:
  spacetime doublers n >= 1 and CKM-heavy levels ell > 0.
```

The current proof priority is therefore:

```text
1. Verify the promoted Draft theorem leaves.
2. Freeze the finite carrier and authoritative H_ref/H_ne definitions.
3. Keep omega and rho zero in the first theorem by exact CKM transport and R = I.
4. Prove the remaining kappa-style endpoint mismatch is below gamma_free.
5. Only then assemble GateC1_NU_Free.
```

Do not overclaim:

```text
CKM texture alone does not prove spacetime no-doubling.
Ginsparg-Wilson algebra alone does not prove determinant-line control.
The free overlap import does not by itself prove anomaly, gauge, Krein, ghost,
or quantum chiral-gauge consistency.
```

The most important next theorem is not another broad audit. It is a concrete
operator-freeze theorem:

```text
the chosen null-edge H_ne, after transport, differs from the
Wilson/Neuberger+CKM H_ref by less than gamma_free.
```

## 28. C225-C227 update: local Gate C1 Draft API spine

Date: 2026-06-28
Source: completed Aristotle jobs C225-C227.

Local integration applied:

```text
Fixed the leading provenance comment in the four promoted Draft leaves so
import Mathlib can be first.

Added two projector/chiral-index obstruction lemmas to ProjectorPersistence:
  chiralIndex_zero_of_rank_balanced;
  chiralIndex_zero_of_trace_zero.

Added Draft module:
  PhysicsSM/Draft/NullEdge/GateC1/OperatorFreeze.lean.
```

The new `OperatorFreeze` API freezes:

```text
H_ref;
H_ne;
transport S and Sinv;
gammaFree;
kappa + omega + rho + alpha + beta.
```

The current first-pass close shape is now:

```text
omega = 0   exact CKM transport;
rho   = 0   R_ref = R_ne = I;
alpha = 0   free theory U = 1;
beta  = 0   flat branch frame;
kappa < gammaFree.
```

Then:

```text
FrozenOverlap + BudgetDecomposition + kappa < gammaFree
  -> transported H_ne is gapped-homotopic to H_ref.
```

C227 adds a useful formal guardrail:

```text
CKM cannot lift spacetime doublers when r_W = 0.
Wilson/Neuberger supplies the spacetime doubler gap.
```

C226 clarifies the next obstruction bridge:

```text
branchKernel_chiralIndex_zero
```

should prove the bare C21 branch kernel has zero chiral index in the GateC1
projector vocabulary. This preserves the known failure of the bare branch
symbol and prevents accidental overclaim.

Status:

```text
All changes are Draft/local.
No live-repo Lean checks were run in this integration pass.
No trusted code was promoted.
No full GateC1_NU theorem is claimed.
```

Next concrete local work:

```text
1. Verify the promoted Draft leaves plus OperatorFreeze when requested.
2. Resolve any live import/namespace issues.
3. Add the branchKernel_chiralIndex_zero bridge.
4. Freeze concrete H_ref/H_ne and prove the first-pass kappa bound.
```

## 29. C228-C230 update: source contracts and projector persistence boundaries

Date: 2026-06-28
Source: completed Aristotle jobs C228-C230.

C228 makes the source-contract split explicit:

```text
Neuberger:
  overlap/Ginsparg-Wilson reference construction.

Hernandez-Jansen-Luscher:
  locality only under smooth/admissible gauge hypotheses.

Creutz-Kimura-Misumi:
  flavored mass/overlap support; not proof of null-edge spacetime
  no-doubling.

Luscher:
  anomaly-free abelian chiral gauge construction; not automatic nonabelian SM
  determinant-line closure.

Adams:
  overlap anomaly/index density in the physical mass window; null-edge import
  requires gapped homotopy and sector-signature match.

Golterman-Shamir:
  propagator-zero mirror removal is forbidden.
```

C229 sharpens the branch-projector lift:

```text
Gapped homotopy alone is not yet a physical projector theorem.
It must feed a spectral-island/Riesz projector chain with a real spectral/range
condition and then chiral-index persistence.
```

Do not use the weak fingerprint:

```text
idempotent + commuting + equal rank
```

as a Riesz projector uniqueness theorem. It is underdetermined.

C230 parks the Dirac-Kahler chiral/flavour projection analogy:

```text
useful as bookkeeping warning about noncommuting chiral/flavour projectors;
not a Gate C1 mechanism;
not a replacement for Wilson/Neuberger;
not evidence for bad-sector inverse gap or anomaly/Krein/determinant safety.
```

Updated next work:

```text
1. Check the Draft GateC1 local API spine when verification is requested.
2. Build the GappedReferenceImportCertificate API after OperatorFreeze.
3. Strengthen the Riesz/projector API with spectral/range data.
4. Keep Watterson/Dirac-Kahler as a parked literature note only.
```

## 30. C231 and C233 update: live-port hygiene and stronger spectral projector data

Date: 2026-06-28
Source: completed Aristotle jobs C231 and C233.

C231 confirms the `OperatorFreeze` port is structurally right but still
unverified live:

```text
OperatorFreeze depends only on CKMWilsonWindow, GappedHomotopy, and
SignStability.
It does not need ProjectorPersistence.
Its namespace risk is low.
The live PhysicsSM.Draft.NullEdge.GateC1 import prefix remains to be verified
by a local Lean check.
```

Applied local fix:

```text
Demoted the stale duplicate doc comment before
chiralIndex_zero_of_rank_balanced in ProjectorPersistence.
```

C233 replaces the weak Riesz projector fingerprint:

```text
idempotent + commuting + equal rank
```

with the stronger uniqueness data:

```text
range equals the target generalized-eigenspace sum;
kernel equals the complementary generalized-eigenspace sum.
```

Do not port C233's standalone Lean artifact verbatim:

```text
it uses names under GateC1.OperatorFreeze that would collide with the C227
OperatorFreeze API.
```

Instead, future local work should create a deliberately named module:

```text
SpectralProjectorAPI.lean
```

with:

```text
eq_of_isIdempotent_range_ker;
weak_fingerprint_not_unique;
IsSpectralProjector with range/kernel spectral data;
IsSpectralProjector.unique.
```

Status:

```text
No live Lean checks were run.
The next verification request should check the Draft GateC1 leaves and
OperatorFreeze before adding an aggregator.
```

## 31. C232 and C234 update: zero-index bridge core and SpectralProjectorAPI

Date: 2026-06-28
Source: completed Aristotle jobs C232 and C234.

New Draft modules:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelChiralIndexZero.lean;
PhysicsSM/Draft/NullEdge/GateC1/SpectralProjectorAPI.lean.
```

C232 proves the generic branch-kernel obstruction:

```text
nonzero null p;
P idempotent;
P commutes with gamma5;
range(P) = ker(cliffordSymbol p);
=> chiralIndex gamma5 P = 0.
```

This is exactly the claim discipline we need:

```text
the bare branch kernel is chirality-balanced;
therefore the bare branch kernel cannot be the final C1 physical Weyl release.
```

The actual branch specialization still needs the live high-momentum branch
geometry:

```text
TetrahedralHighMomentumNullBranch.lean
```

to discharge:

```text
branchP_ne_zero;
branchP_mink_zero.
```

C234 provides the safe spectral-projector module we wanted after C233:

```text
GateC1.SpectralProjectorAPI
```

with:

```text
range/kernel uniqueness for idempotents;
weak-fingerprint counterexample;
IsSpectralProjector with generalized-eigenspace range/kernel data;
Kato and Davis-Kahan source-contract placeholders.
```

Status:

```text
Both modules are Draft-only.
No live Lean checks were run.
No trusted code was promoted.
```

Next concrete local work:

```text
1. Integrate C235 when it completes, especially the branchP specialization.
2. Then, if verification is requested, check the GateC1 Draft module spine.
3. Only after checks pass, add a clean GateC1 aggregator.
```

## 32. Pro architecture update: Gate C should use a Null-Edge Overlap release

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\5230e00c-8f61-493e-b9e2-b467d63d70a6\pasted-text.txt`.

This is the clearest current Gate C architectural rule:

```text
The finite null-edge seed should not be the complete chiral-release operator.

The finite null-edge seed should define the null-edge/path-combinatorial kernel
inside a Wilson/flavored-Wilson Hermitian overlap construction.

The overlap sign function or equivalent domain-wall transfer construction
should supply the C1 chiral release.
```

The preferred operator pipeline is:

```text
null-edge finite kernel
  -> gamma5-Hermitian Wilson/flavored-Wilson Hermitian kernel H_ne
  -> Neuberger overlap sign operator sign(H_ne)
  -> Ginsparg-Wilson chiral projectors
  -> Weyl determinant / anomaly-free multiplet construction
```

Domain-wall form is an equivalent implementation:

```text
null-edge-derived four-dimensional kernel
  -> five-dimensional domain-wall transfer/sign engine
  -> boundary overlap operator in the infinite-wall limit.
```

Do not make the fifth/domain-wall direction a physical null direction in the
first theorem. Treat it as the spectral-flow/sign-function direction.

### 32.1 What this changes in the unified mass program

This keeps the main project thesis intact:

```text
primitive propagation is organized by discrete lightlike/null-edge steps;
mass and branch structure arise from obstructions, gaps, and path sums.
```

But it changes the Gate C burden:

```text
Do not ask the retarded finite null-edge operator D_+ to be one-handed by
itself.

Ask it to supply a null-edge kernel whose overlap/domain-wall completion has
the correct chiral index and branch-mass signs.
```

This is not a retreat from the null-edge program. It is the least-risk bridge
from null-edge path combinatorics to known successful chiral lattice fermion
machinery.

### 32.2 Candidate operator

For allowed null-edge shifts `T_ell(U)`, define a symmetrized kernel:

```text
D_ne^0 =
  (1 / 2a) sum_{ell in S_+}
    c_ell Gamma_ell (T_ell - T_ell^dagger).
```

Add a Wilson/species-splitting term:

```text
W_ne =
  (r / a) sum_{ell in S_+} b_ell (2 - T_ell - T_ell^dagger)
  + W_flav.
```

Then:

```text
A_ne = D_ne^0 + W_ne - rho/a;
H_ne = gamma5 A_ne;
D_ov,ne = (rho/a)(1 + gamma5 sign(H_ne)).
```

Use `W_flav = 0` only if scalar Wilson branch masses separate the actual
null-edge branches. Otherwise use a flavored or matrix-valued Wilson mass.

The physical Weyl theory should be stated with Ginsparg-Wilson projectors:

```text
gamma5_hat = gamma5 (1 - (a/rho) D_ov,ne);
P_hat_pm = (1 +/- gamma5_hat) / 2;
P_pm = (1 +/- gamma5) / 2.
```

This matters for claim discipline:

```text
The physical one-handed theory is a GW projected determinant/measure problem.
It is not literally the statement that the finite seed has only one Weyl pole.
```

### 32.3 Branch-mass window as the next concrete target

If the free null-edge kernel has branch zeros `p_j`, define:

```text
m_j = W_ne(p_j) - rho/a.
```

The first real C1 operator theorem should prove a branch-mass sign pattern:

```text
desired physical branch:
  m_j < 0;

mirror/doubler branches:
  m_j > 0.
```

Then prove:

```text
H_ne(p)^2 >= g^2 > 0
```

away from controlled topological-sector boundaries. This is the true
inverse-propagator gap statement. It must not be replaced by propagator-zero
mirror removal.

### 32.4 Assumptions to discard or relax

Discard:

```text
finite seed as complete release operator;
retardedness as a C1 proof;
scalar Wilson lift as direct mirror removal;
CKM/flavor as spacetime doubler removal;
novelty as a requirement for the first working C1 operator.
```

Relax:

```text
ultralocality and exact finite range;
strict translation invariance outside the free-symbol theorem.
```

Postpone:

```text
deriving the tetrad/null frame from a bare graph.
```

Gate C should use the known chiral lattice solution path first, then interpret
its kernel/sign/path-sum structure in null-edge language.

### 32.5 Updated near-term work

Replace broad abstract C1 searching with this concrete stack:

```text
1. Define the gamma5-Hermitian null-edge kernel H_ne.
2. Prove its continuum branch expansion.
3. Classify free branch zeros and branch masses.
4. Prove a scalar Wilson branch window or show that a flavored/matrix Wilson
   mass is required.
5. Prove the free overlap gap and no mirror pole.
6. Prove the Ginsparg-Wilson relation for D_ov,ne.
7. Prove gapped homotopy to the Wilson/Neuberger+CKM reference, or compute the
   index directly.
8. Add admissible-gauge/locality or controlled path-sum hypotheses.
9. Only after that, address determinant-line/anomaly/Krein/ghost audits for the
   Standard Model multiplet.
```

Current status:

```text
The program now has a sharper candidate C1 operator architecture.
It still does not have the explicit H_ne branch-mass window, overlap gap, or
full Standard Model determinant/anomaly construction.
```

## 33. Higher-context Pro update: retarded seed is not the overlap sign kernel

Date: 2026-06-28
Source: Pro analysis in
`C:\Users\Owner\.codex\attachments\42a823cf-1c8c-4337-a9e8-59cc85d1e72a\pasted-text.txt`.

The higher-context response confirms the direction in Section 32, but sharpens
one critical implementation rule:

```text
Do not apply the overlap sign function directly to the raw retarded null-edge
operator D_+.
```

If `D_+` is retarded or non-Hermitian, it should be treated as a primitive
path/propagator seed. The overlap sign construction needs a Hermitian or
Hilbertized Hermitian kernel.

Allowed first-pass routes:

```text
Option A:
  replace D_+ by a symmetric / Euclideanized / gamma-Hermitian null-edge kernel.

Option B:
  build a Hermitian retarded/advanced dilation:

    H_RA =
      [ 0                         D_+ + W - m0 R ]
      [ (D_+ + W - m0 R)^dagger   0             ],

  then apply the sign function to H_RA.
```

The retarded/Feynman-checkerboard intuition should re-enter through:

```text
propagators;
resolvent expansions;
domain-wall transfer matrices;
path-sum representations of sign(H_NE).
```

### 33.1 Refined Gate C endpoint

Use:

```text
D_ov,NE(U) = rho [ 1 + Gamma_NE sign(H_NE(U)) ],
```

where:

```text
H_NE(U) =
  Gamma_NE [
    D_NE,sym^cov(U)
    + W_NE,space(U)
    + W_NE,int(U)
    - m0 R_NE
  ].
```

First theorem simplification:

```text
R_NE = I;
W_NE,int = 0;
Gamma_NE = S gamma5 S^-1;
free theory U = 1.
```

Then later add CKM/internal texture:

```text
W_NE,int = S(I tensor W_CKM)S^-1 + controlled error.
```

Do not make `R_NE` arbitrary in the first theorem. If `R_NE` is nontrivial, the
mass-window problem becomes:

```text
W_NE,int v = m0 R_NE v,
```

which is a generalized eigenvalue problem and should be delayed.

### 33.2 First decisive theorem

The first theorem should be a reference-import theorem:

```text
NullEdgeOverlapReferenceImport:
  H_ref has the known Wilson/overlap mass window and gap;
  H_NE is Hermitian or Hilbertized Hermitian;
  H_NE is transported to the reference Hilbert space by S;
  ||H_NE - S H_ref S^-1|| <= epsilon < gap(H_ref);
  therefore the straight-line homotopy remains gapped;
  sign(H_NE) is well-defined;
  the index/sector signature is imported from H_ref.
```

If the direct estimate is too crude, use:

```text
H_ref -> H_block -> H_NE
```

where `H_block` has the null-edge sector table and a deliberately large gap.

### 33.3 Updated claim labels

Keep this distinction:

```text
GateC1_local:
  local/quasi-local conventional release.

GateC1_NU:
  controlled non-ultralocal release.

GateC1_formal:
  algebraic toy or projector-only result.
```

`GateC1_formal` cannot close C1. It may help with obstruction theorems, APIs,
or finite sanity checks only.

### 33.4 Updated next work

The next proof order is:

```text
1. Define the Hermitian or RA-dilated null-edge kernel.
2. Prove the free symbol/sector match to Wilson/overlap reference data.
3. Prove the reference mass window.
4. Prove the gapped homotopy/reference import theorem.
5. Derive sign/GW algebra and index persistence.
6. Prove branch-line spectral lift.
7. Prove true bad-sector inverse gap and no propagator-zero mirror removal.
8. Add gauge covariance/dressing and path-sum/resolvent/domain-wall control.
9. Only then address determinant-line/anomaly/Krein/regulator closure for the
   Standard Model multiplet.
```

Current status:

```text
The project has a safer and more explicit operator architecture.
The raw retarded seed remains valuable, but only as path/combinatorial input.
The missing object is still the actual Hermitian H_NE and its reference-import
gap bound.
```

## 34. C238 update: make `H_ne` the primitive, not `D_ov,ne`

Date: 2026-06-28
Source: completed Aristotle job C238.

C238 strongly supports the new Null-Edge Overlap direction, with one important
discipline rule:

```text
H_ne is the primitive Gate C1 kernel.
D_ov,ne is a derived release operator.
```

Therefore the immediate work is not "prove the overlap release works" in one
step. It is:

```text
T1:
  prove H_ne is self-adjoint on a named Hilbert structure.

T2:
  prove the tetrahedral free-symbol/doubler/gap theorem, or identify the
  surviving branch that forces M_br.

T3:
  prove sign(H_ne) gives the Ginsparg-Wilson algebra once T1 and the gap hold.
```

C238's highest-risk warning is the tetrahedral Brillouin-zone geometry:

```text
Do not use cubic lattice doubler intuition.
The tetrahedral shift set must have its own dual-cell / branch-count / gap
analysis.
```

Current assumption changes:

```text
Discard:
  bare retarded seed as release operator;
  propagator-zero mirror removal;
  chirality-balanced branch kernel as an acceptable endpoint;
  implicit self-adjointness of D_+;
  cubic Brillouin-zone intuition.

Keep:
  true inverse-propagator bad-sector gap;
  named Hilbert or Hilbertized structure;
  gauge-covariant adjointness;
  anomaly/determinant-line source contracts;
  path-sum/resolvent control as a later theorem.
```

Local consequence:

```text
The first useful Draft Lean target is the abstract algebra:
  if D is gamma-odd anti-self-adjoint and E, mu are gamma-even
  self-adjoint, then gamma(D + E - mu) is self-adjoint.

The second useful Draft target is conditional:
  if gamma^2 = 1 and eps^2 = 1, then
  D = 1 + gamma eps satisfies the normalized Ginsparg-Wilson algebra.

The hard physics target remains:
  tetrahedral free-field branch/gap analysis.
```

Status:

```text
C238 is integrated as strategy guidance.
No live Lean checks were run.
No GateC1_NU theorem is claimed.
```

## 40. C240 update: tetrahedral scalar-Wilson branch table is now proved in Draft package

Date: 2026-06-28
Source: completed Aristotle job C240.

C240 proves the finite/free branch-table calculation for the proposed
tetrahedral Null-Edge Overlap kernel. The returned Lean module has been copied
into:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralBranchWindow.lean
```

The result is significant but bounded.

What it proves:

```text
1. The tetrahedral coframe identities for B_A.
2. The concrete tetrahedral moment identities.
3. Linear independence of the four homogeneous rows (1, v_A).
4. The branch inference:
     sum_A B_A sin(k_A) = 0
     => sin(k_A) = 0 for every A.
5. At branch points, scalar Wilson gives:
     m_n = (2 r n - rho) / a.
6. In the window a > 0 and 0 < rho < 2r:
     m_0 < 0,
     m_n > 0 for n = 1, ..., 4.
```

What it assumes:

```text
The four k_A are independent 2*pi-periodic coordinates on the null-edge
Brillouin torus.
```

This assumption should be upgraded to a theorem next:

```text
For Lambda = span_Z {n_A}, prove that p -> (n_A dot p)_A identifies the dual
Brillouin torus with (R / 2*pi Z)^4.
```

Meaning for Gate C:

```text
The old scalar-Wilson no-go still applies to direct chiral selection on the
balanced bare branch kernel.

C240 uses scalar Wilson differently: as a branch-mass term inside the Hermitian
overlap sign kernel.
```

Therefore the current default is:

```text
Use M_br = 0 for the first free model unless the global free gap or torus
geometry theorem finds an unlifted residual branch.
```

The next decisive work is:

```text
1. lattice-duality / Brillouin-torus theorem;
2. global free no-zero/gap theorem for the C240 scalar Wilson window;
3. sign(H_ne) and Ginsparg-Wilson algebra assembly;
4. bad-sector inverse-gap and no-ghost audit;
5. later gauge/anomaly/Krein/source-contract layers.
```

Status:

```text
Aristotle reported the focused C240 package built without proof placeholders.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 35. C235 update: actual bare-branch obstruction is proved in Draft package

Date: 2026-06-28
Source: completed Aristotle job C235.

C235 proves the actual branch-kernel zero-index obstruction against the C21
Clifford-symbol conventions. The returned proof has been copied into:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchKernelActualChiralIndexZero.lean
```

Claim:

```text
Any idempotent projector P whose fixed space is the actual branch kernel
ker(cliffordSymbol(branchP a)) and that commutes with gamma5 has
chiralIndex gamma5 P = 0.
```

Meaning:

```text
The bare branch kernel is chirality-balanced in the actual symbol layer.
It has one gamma5-positive and one gamma5-negative Weyl line.
No chirality-commuting projector onto that bare kernel can produce a nonzero
physical chiral index.
```

This strengthens the current Gate C diagnosis:

```text
The finite retarded/null-edge seed remains valuable as a path/combinatorial
kinetic input.
It cannot itself be the C1 release if the release is a chirality-commuting
projector onto the bare branch kernel.
```

Connection to the new Null-Edge Overlap path:

```text
The overlap route does not contradict C235.
It escapes the obstruction by changing the object:
  from bare branch-kernel projector
  to Hermitian Wilson kernel + sign(H_ne) + Ginsparg-Wilson projectors.
```

Status:

```text
Aristotle reported the focused package built without proof placeholders.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 39. C241 update: scalar Wilson first, constrained branch mass only if needed

Date: 2026-06-28
Source: completed Aristotle job C241.

C241 resolves the scalar-vs-flavored branch-mass policy.

Default:

```text
M_br = 0.
```

Use `M_br` only if the actual branch test finds:

```text
two branches are zeros of D_ne^0;
scalar W_ne assigns them the same branch mass;
one branch must be kept and the other lifted.
```

C241 proves:

```text
scalar_shift_preserves_degeneracy:
  a constant scalar shift cannot split a Wilson-degenerate pair.
```

It also proves:

```text
branch_mass_interpolation_four:
  on 16 branch points, the cos-product Walsh basis can realize any branch-mass
  profile uniquely.
```

This supports:

```text
If scalar Wilson fails on distinct branch points, a cos-product M_br can
separate them.
```

But it also creates a predictivity warning:

```text
unconstrained M_br can fit anything on the 16 branches.
```

Therefore:

```text
M_br must be sparse, symmetry-constrained, and introduced only by necessity.
Every coefficient must be recorded as extra moduli freedom.
```

Integrated Draft module:

```text
PhysicsSM/Draft/NullEdge/GateC1/BranchMass.lean
```

Current proof order:

```text
1. Finish the tetrahedral branch/gap test.
2. If scalar W_ne succeeds, keep M_br = 0.
3. If scalar W_ne fails, use C241 to construct the minimal needed M_br.
4. Separately prove Hermiticity/gamma5-even/gauge-covariant realization for
   the chosen M_br.
5. Separately prove no-ghost inverse gap.
```

Status:

```text
Aristotle reported the C241 focused file built without proof placeholders.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 37. Literature update: proof pressure is now on the tetrahedral branch test

Date: 2026-06-28
Source note:

```text
AgentTasks/null-edge-gate-c1-overlap-kernel-literature-review-2026-06-28.md
```

The literature review reinforces the current architecture:

```text
Use Wilson/Neuberger overlap and Ginsparg-Wilson/domain-wall machinery for the
chiral release.

Use null-edge path combinatorics to build the Hermitian kernel H_ne and
interpret sign/resolvent kernels as path sums.
```

It also reinforces the main technical risk:

```text
The tetrahedral/non-orthogonal branch geometry must be proved directly.
```

Relevant source lessons:

```text
Neuberger:
  the overlap operator solves the reference no-doubling/sign problem.

Luescher:
  GW chirality is the safe chiral-symmetry realization.

Hernandez-Jansen-Luescher:
  locality is conditional and belongs at the background-gauge/source-contract
  layer.

Kaplan:
  domain-wall gives the same sign mechanism in unfolded/topological form.

Adams and flavored-overlap work:
  add M_br only if scalar Wilson fails the branch-mass test.

Creutz and hyperdiamond literature:
  non-orthogonal lattice fermions can have subtle doubling/symmetry/fine-tuning
  tradeoffs.

Golterman-Shamir:
  never count propagator zeros as healthy mirror removal.
```

Near-term proof target:

```text
tetrahedral centered null-edge kinetic + scalar Wilson branch theorem.
```

If that theorem succeeds:

```text
M_br = 0 is acceptable for the first free Gate C1 theorem.
```

If it fails:

```text
introduce a constrained gamma5-even Hermitian M_br and record the added freedom
as a branch/flavor mass choice, not a prediction.
```

## 38. C239 update: Hermitian kernel validity is now a Draft API

Date: 2026-06-28
Source: completed Aristotle job C239.

C239 proves the abstract algebraic piece behind the proposed first Gate C1
kernel. The returned module is integrated at:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapKernel.lean
```

The formal payload:

```text
If D is gamma5-odd and anti-Hermitian,
and E is gamma5-even and Hermitian,
and the mass shift is real,
then
  H = gamma5 (D + E - rho/a)
is Hermitian.
```

The split theorem covers:

```text
E = W_ne + M_br,
```

where both terms are Hermitian and gamma5-even.

Program meaning:

```text
The first Gate C1 operator target can now be stated cleanly:
  build D_ne^0, W_ne, and optionally M_br so that they satisfy the C239
  structural assumptions.
```

This does not prove:

```text
spectral gap;
branch mass window;
overlap sign existence;
Ginsparg-Wilson release;
locality/path-sum control;
anomaly or determinant-line closure.
```

It proves only the kernel-validity layer needed before those questions can be
asked.

Next proof pressure:

```text
Prove the tetrahedral centered kernel actually satisfies the C239 assumptions,
then prove the free branch/gap theorem.
```

Status:

```text
Aristotle reported the C239 focused file built without proof placeholders.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 36. C242 update: reference import is now an explicit Draft API

Date: 2026-06-28
Source: completed Aristotle job C242.

C242 adds the clean mathematical bridge needed by the Null-Edge Overlap route.
The returned Draft module is now copied into:

```text
PhysicsSM/Draft/NullEdge/GateC1/NullEdgeOverlapReferenceImport.lean
```

The key theorem shape is:

```text
H_refS = S H_ref S^-1;
||H_ne - H_refS|| <= epsilon < gap(H_refS);

then

H_t = (1 - t) H_refS + t H_ne
```

has a uniform inverse gap:

```text
gap(H_t) >= gap - epsilon > 0.
```

This is the formal version of the current Gate C strategy:

```text
Do not prove chiral release from scratch.
Prove that the null-edge Hermitian kernel remains in the same gapped
sign/index sector as the Wilson/Neuberger reference.
```

C242 also adds a claim-layer discipline:

```text
formal:
  sector equality only;

NU_Free:
  add Neuberger and Ginsparg-Wilson contracts;

NU_BackgroundGauge:
  add locality/admissible-background contract;

NU_Quantum:
  add determinant-line and anomaly contracts.
```

Source contracts remain hypotheses, not theorems:

```text
Neuberger overlap;
Ginsparg-Wilson algebra;
Hernandez-Jansen-Luscher locality;
Luscher determinant/measure;
anomaly accounting.
```

Immediate consequence:

```text
The concrete H_ne task is now sharply reduced:
  define the Hermitian null-edge kernel;
  prove its reference gap estimate;
  feed that estimate into NullEdgeOverlapReferenceImport.
```

Status:

```text
Aristotle reported the C242 focused file built without proof placeholders.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```

## 41. Pro feedback update: direct tetrahedral scalar-Wilson proof before reference import

Date: 2026-06-28
Source note:

```text
AgentTasks/null-edge-pro-feedback-tetrahedral-scalar-wilson-2026-06-28.md
```

The first free Gate C1 model should now be treated as:

```text
rank-4 tetrahedral null-edge lattice
  -> Euclidean/Hilbert Hermitian sign kernel H_tet
  -> scalar Wilson branch mass with 0 < rho < 2r
  -> direct global free gap theorem
  -> overlap/Ginsparg-Wilson operator D_ov,tet
  -> no-mirror-pole theorem
```

Do not prove the free theorem by vague reference to hypercubic Wilson.  The
lattice model must be stated as:

```text
Lambda_tet ~= Z^4 generated by e_A = a n_A;
Hom(Lambda_tet, U(1)) ~= (R / 2*pi Z)^4;
T_A -> exp(i k_A).
```

The key trap is avoided by saying:

```text
H_tet is the gapped sign kernel.
D_ov,tet is the operator with the physical zero.
```

So:

```text
H_tet(0) = -(rho/a) gamma5;
D_ov,tet(0) = 0.
```

The Euclidean/Hilbert convention must be explicit:

```text
B_A dagger = B_A;
{gamma5, B_A} = 0;
D_ne^0 dagger = -D_ne^0;
{D_ne^0, gamma5} = 0;
H_tet dagger = H_tet.
```

Current Aristotle launch priorities:

```text
C244: rank-4 lattice/BZ theorem.
C247: Euclidean Clifford convention and centered kernel theorem.
C243: global free gap theorem.
C248: corrected overlap/GW algebra.
C249: free no-mirror-pole theorem.
C246: post-C240 strategy audit.
```

`M_br` remains fallback only:

```text
M_br = 0 unless scalar Wilson fails a proved branch/gap test.
```

Status:

```text
This is a free-kernel strategy update, not a completed Gate C1 release.
No trusted Lean theorem, gauge theorem, anomaly theorem, or Standard Model
chiral determinant claim is promoted here.
```
## 42. C246 update: theorem ladder is now fixed until the free model passes or fails

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-c246-next-wave-queue-aristotle-2026-06-28.md
```

C246 confirms the current short ladder:

```text
1. C244 rank-4 lattice/BZ theorem.
2. C247 Euclidean Clifford sign-kernel convention.
3. C243 global free gap.
4. C248 overlap/GW algebra and corrected projectors.
5. C249 free no-mirror-pole theorem.
```

Only after those pass should the program move to:

```text
reference-import cross-check;
BackgroundGauge layer;
Quantum/anomaly/determinant-line layer.
```

If C243 or C249 finds a residual branch or mirror pole, that specific failure
is the only trigger for:

```text
C245 fallback M_br.
```

Current decision:

```text
M_br = 0 unless scalar Wilson fails a proved branch/gap test.
```

Status:

```text
C246 is planning integration only.
No Lean theorem was changed or promoted.
No Gate C release is claimed.
```
## 43. D4 update: useful envelope, not the active Gate C lattice

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-pro-d4-lattice-guidance-2026-06-28.md
```

D4 is now a parallel lane, not a mainline replacement.

Precise lattice relation:

```text
L_H subset D4,
[D4 : L_H] = 8,
D4 / L_H ~= (Z/2Z)^3.
```

Dual/BZ relation:

```text
T_D4 -> T_LH is an 8-fold cover.
```

Therefore the tetrahedral phases `k_A` are complete coordinates for the
current tetrahedral torus, but not for the full D4 torus.

Important physics consequence:

```text
D4 with only h_A shifts gives 8 disconnected copies.
D4 with D4 roots adds timelike/spacelike primitive steps.
Full D4 changes the branch theorem and scalar-Wilson proof.
```

So the active C1 proof stays on:

```text
L_H = span_Z {h_A}.
```

D4 is useful later for:

```text
symmetry envelope;
triality / Spin(8) bridge;
24-cell / F4 geometry;
coset bookkeeping;
possible M_br constraint if scalar Wilson fails a proved test.
```

Rule:

```text
D4 is an envelope, not the Gate C1 release lattice.
```

Follow-up correction from C250/Pro:

```text
T_D4 -> T_LH is an 8-fold cover/unfolding.
The D4 momentum torus covers the tetrahedral momentum torus.
The tetrahedral torus is the folded quotient.
```

Do not say that the D4 torus is the folded one.

Stronger null-only guardrail:

```text
L_same =
  {x in Z^4 : x_0, x_1, x_2, x_3 all have the same parity}.

L_H subset L_same subset D4,
[L_same : L_H] = 2,
[D4 : L_same] = 4.
```

Any integral null translation for:

```text
q(x) = -x_0^2 + (1/3)(x_1^2 + x_2^2 + x_3^2)
```

lies in `L_same`, so null translations alone cannot connect full D4.

Therefore:

```text
D4 sites with only h_A shifts:
  8 disconnected copies.

D4 sites with D4 root shifts:
  connected, but not purely null-edge.

All-eight-future-null body-diagonal model:
  possible later experiment on L_same, not a harmless relabeling of L_H.
```

Recommended side-lane jobs:

```text
D4 inclusion/index/SNF;
D4 dual and BZ cover theorem;
D4 causal shell classification;
D4 disconnected-copy theorem;
L_same null-vector theorem;
optional all-eight-null L_same branch analysis only after the L_H proof.
```

## 45. C244 update: tetrahedral Brillouin-torus theorem integrated

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-c244-tetrahedral-lattice-duality-aristotle-2026-06-28.md
```

C244 integrated the completed Draft Lean theorem:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralLatticeDuality.lean
```

This closes the main C240 caveat for the active tetrahedral lattice:

```text
For the rank-4 translation lattice L_H = span_Z {h_A}, the four k_A are
independent 2*pi-periodic Brillouin-torus coordinates.
```

Formal payload:

```text
NtetMat_det = -16;
NtetMatZ_det_natAbs = 16;
homogeneousTetraMap_injective;
toTorusHom_surjective;
mem_nullEdgeDualLattice;
tetraTorusEquiv :
  ((Fin 4 -> R) / nullEdgeDualLattice) ~= (Fin 4 -> AddCircle (2*pi)).
```

Meaning:

```text
The C240 branch-window calculation now rests on a formalized rank-4
tetrahedral torus model, not an implicit cubic Brillouin-zone analogy.
```

Boundary:

```text
This does not prove the global free gap C243.
This does not prove the overlap projector algebra C248.
This does not claim Gate C1_NU.
It was integrated in Draft code only and was not locally checked in this pass.
```

## 46. Stay/coin update: onsite fiber evolution is allowed

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-stay-move-decision-memo-2026-06-28.md
```

Use this physical claim:

```text
All nontrivial spatial transport steps are lightlike/null.
The update rule may also include local onsite fiber evolution.
```

Layering:

```text
transport graph:
  null spatial shifts;

onsite fiber dynamics:
  local coin/rest/mass/Yukawa/Wilson/internal terms;

path sum / propagator:
  histories made from null transports and onsite factors.
```

This is useful because massive Dirac behavior, Wilson branch lifting, Higgs/
Yukawa mixing, finite internal Dirac data, and quantum-walk coin rotations are
local fiber effects rather than spatial transport effects.

Gate C meaning:

```text
The current overlap kernel already has a null-transport plus onsite/fiber split.

Kinetic null-shift part:
  (i/a) sum_A B_A sin(k_A)

Onsite branch-shaping part:
  (1/a)(r sum_A(1 - cos k_A) - rho)
```

Admissible onsite terms should be:

```text
local;
gauge-covariant or gauge-scalar;
tetrahedral-symmetric unless intentionally broken;
Hermitian and gamma5-even for Wilson/branch-mass use;
or explicitly identified as Yukawa/chirality/internal finite-Dirac data;
recorded as added moduli if not symmetry-forced.
```

Practical impact:

```text
Keep the active L_H scalar-Wilson overlap proof unchanged.
Interpret Wilson, Yukawa, finite internal Dirac, and possible M_br terms as
onsite/fiber-layer structure.
Add a future API theorem:
  onsite fiber operators do not alter the null transport graph.
```

## 44. Continued literature analysis: what should influence the next proof step

Date: 2026-06-28
Source:

```text
AgentTasks/null-edge-continued-lit-analysis-2026-06-28.md
```

The broader literature reinforces the current path:

```text
overlap/Ginsparg-Wilson:
  use as the chiral-release engine;

hyperdiamond / minimally doubled fermions:
  use as warnings about non-orthogonal branch geometry;

flavored mass overlap:
  use only if scalar Wilson fails a named branch/gap test;

A4*/exact symmetry lattices:
  use as evidence that high-symmetry non-cubic lattices are useful, not as a
  Gate C shortcut;

D4/triality:
  use as envelope/internal-symmetry lane, not active release lattice.
```

Concrete conclusion:

```text
Do not branch further until C244/C247/C243 return.
```

If C243 succeeds:

```text
move to C248/C249 integration.
```

If C243 fails:

```text
activate C245 only for the specific residual zero or mirror pole.
```

Potential later jobs:

```text
C254 D4 inclusion/index/SNF theorem.
C255 finite-volume parity theorem for pi corners.
C256 hyperdiamond warning audit.
C257 BackgroundGauge locality/admissibility source-contract API.
C258 M_br proved-need API.
```
