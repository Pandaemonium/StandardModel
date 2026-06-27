# Null-edge unified mass model: working paper plan

**Working document, 2026-06-26.**

Companion documents:

- [`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`](Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md)
- [`Null_Edge_Causal_Graph_Publication_Plan.md`](Null_Edge_Causal_Graph_Publication_Plan.md)
- [`Null_Edge_Causal_Graph_Strengthened_Program.md`](Null_Edge_Causal_Graph_Strengthened_Program.md)
- [`NullStrand_Lean_Roadmap_Improved.md`](NullStrand_Lean_Roadmap_Improved.md)
- [`../docs/NULLSTRAND.md`](../docs/NULLSTRAND.md)

Provenance: synthesized from ChatGPT Pro feedback supplied on 2026-06-26,
with earlier NullStrand/null-edge roadmap conventions folded in. The source
feedback stressed that the viable target is not "the Pluecker theorem alone
explains every mass mechanism," but a broader null-edge operator architecture in
which effective masses are spectral gaps, constraints, or rest-frame invariants
of dynamics whose primitive transport steps are null.

## 1. Central thesis

The strongest safe unifying slogan is:

```text
Mass is the obstruction to a null-edge system remaining a single free null ray.
```

Equivalently:

```text
Mass is a quadratic obstruction of null-edge dynamics.
```

This should replace any overly strong slogan such as:

```text
All mass is literally the same Pluecker spread formula.
```

The Pluecker theorem is the finite kinematic prototype. It proves that a finite
bundle of null spinor momenta can have timelike total momentum, with invariant
mass squared equal to total pairwise Pluecker spread. Other Standard Model mass
mechanisms should be represented as different kinds of quadratic obstruction
inside a shared null-edge operator framework. Reserve "spectral gap" for places
where an actual operator, Hessian, Hamiltonian, or mass matrix has a gap.

## 2. Claim hierarchy

### Level 1: kinematic unification

This level is already strong and is the subject of P1.

Given a finite bundle of null momenta,

```text
P = sum_i psi_i psi_i^dagger,
```

the invariant mass satisfies

```text
det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Interpretation: composite mass is the rest-frame invariant produced by
non-collinearity among null momentum components.

This covers:

- two photons or two null momenta forming a timelike total momentum;
- finite null-spinor bundles;
- the kinematic accounting side of confined relativistic/QCD mass;
- the celestial monopole/dipole picture, where mass is the deficit between
  energy monopole and momentum dipole.

This level does not explain why a bundle is trapped, why nature chooses a
particular distribution, or why observed particle masses have their measured
values.

### Level 2: operator unification

This is the next serious target.

A first-order null-edge operator should have primitive null shifts, but its
square should produce effective kinetic shells, internal mass blocks, curvature
terms, frame/spin-connection terms, and Higgs-gradient terms:

```text
D_h = i sum_a c(alpha^a) nabla_a + Gamma_s Phi_H
```

with

```text
D_h^2 =
  -K_h
  + Phi_H^2
  + curvature terms
  + frame/spin-connection terms
  + Higgs-gradient terms.
```

Then a massive mode is not a primitive timelike step. It is a mode satisfying

```text
K_h(xi) = m^2,
```

where `K_h` is built from null-edge propagation and `m^2` comes from an internal
or condensate spectral gap.

The crucial guardrail is:

```text
Pluecker/null spread = kinetic-side invariant.
Phi_H^2              = zero-order Higgs/Yukawa mass block.
```

There should not be a second additive Pluecker mass hidden in `Phi_H^2`.

### Level 3: predictive unification

This is the hard long-term target.

To explain "all mass" in the strongest sense, the finite null-edge geometry must
constrain at least one Standard Model input that is normally free, such as:

```text
v, lambda, Y_u, Y_d, Y_e, Y_nu, g, g', g_s, Lambda_QCD.
```

If the model merely stores observed Yukawa matrices, gauge couplings, the Higgs
potential, and the QCD scale in free input data, it represents the Standard
Model masses but does not derive them.

The program is still valuable before this level. A unified mechanism showing
that the Standard Model mass mechanisms can be represented with primitive
null-edge transport would already be a serious result.

## 3. Mass phenomena and null-edge interpretations

```text
Phenomenon                    Null-edge interpretation
----------------------------  ------------------------------------------------
Finite null bundle            Pluecker spread of non-collinear null momenta
Two photons in a box           Timelike total momentum from null components
Hadron/proton mass             Confined relativistic/null color dynamics;
                               QCD supplies confinement, Pluecker supplies
                               invariant accounting
Dirac fermion mass             Higgs/Yukawa chirality-flip gap between left and
                               right null Weyl channels
W/Z mass                       Gauge-holonomy directions that fail to preserve
                               the Higgs condensate acquire a gap
Photon masslessness            Gauge direction preserving the Higgs condensate
                               remains gapless
Higgs boson mass               Radial stiffness/spectral gap of the condensate
                               amplitude mode
Neutrino mass                  Tiny Dirac/Majorana/sterile-sector gap in an
                               almost-null weak channel
```

This table is safer than saying "all mass is trapped light." The better claim is
that mass is the failure of null-edge propagation to remain a single free,
gapless null mode.

## 4. How the main mass mechanisms fit

### 4.1 Pluecker/null-bundle mass

This is P1's proved finite theorem.

Primitive data:

```text
psi_i : finite family of null spinors
P     : sum_i psi_i psi_i^dagger
```

Mass formula:

```text
m^2 = det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Interpretation: mass is projective spread among null directions. Mass vanishes
exactly when all spinors share one projective null direction.

Claim type: finite identity and kinematic reconstruction.

### 4.2 Fermion Higgs/Yukawa mass

For fermions, the bridge is chirality.

Massless Weyl fermions propagate in chiral null channels. A Dirac mass couples
left and right Weyl sectors. In the Standard Model, fermion masses arise from
Yukawa couplings to the Higgs field after the Higgs field has a nonzero vacuum
value.

Null-edge expression:

```text
null motion is in L and R Weyl channels;
Yukawa/Higgs coupling is the vertex amplitude that flips channels.
```

Minimal operator:

```text
D_h = i D_N + Gamma_s Phi_H
D_N = sum_a c(alpha^a) nabla_a
```

For one Dirac fermion after symmetry breaking:

```text
Phi_H ~ [[0, M^dagger],
         [M, 0]]

M = y v / sqrt(2)
```

Then:

```text
Phi_H^2 = [[M^dagger M, 0],
           [0, M M^dagger]]
```

The squared equation gives:

```text
-K_h + Phi_H^2 = 0,
K_h(xi) = |M|^2
```

Interpretation: fermion mass is an internal chirality-flip spectral gap that a
null-edge kinetic shell must match on shell.

Claim type: operator reconstruction target. Numerical Yukawa values are not
derived unless the finite model constrains `M`.

### 4.3 W/Z electroweak gauge-boson mass

Gauge boson masses are not left/right chirality flips. They arise because the
Higgs condensate makes some gauge directions costly while leaving the
electromagnetic direction gapless.

Null-edge expression:

```text
gauge fields are null-edge holonomies;
the Higgs field is an internal section;
mass is failure of holonomy to preserve the Higgs vacuum.
```

Start with a finite Higgs edge action:

```text
S_H = sum_{x,a} |U_a(x) H(x + h ell_a) - H(x)|^2 + V(H).
```

If `H` sits in a vacuum configuration `H_0`, the quadratic edge term is
approximately:

```text
sum_{x,a} |(U_a(x) - 1) H_0|^2.
```

Gauge generators preserving `H_0` remain massless. Gauge generators moving
`H_0` acquire a quadratic energy cost.

Interpretation:

```text
W/Z mass = holonomy-condensate mismatch gap.
photon   = holonomy direction preserving the Higgs vacuum.
```

Claim type: finite graph-Higgs theorem target.

Important wording: avoid saying "the gauge symmetry literally breaks" as if a
local redundancy were an observable symmetry. Prefer gauge-invariant or
gauge-fixed-with-audit language:

```text
the Higgs field defines a covariant internal reference section;
holonomies that move this section acquire a quadratic energy cost.
```

### 4.4 QCD and hadron mass

QCD mass is conceptually close to the null-bundle theorem but dynamically much
harder.

Safe statement:

```text
QCD explains why the relativistic/null constituents are confined.
The Pluecker theorem gives the finite kinematic invariant of the confined
bundle.
```

Do not claim:

```text
the current theorem derives proton mass.
```

A later null-edge QCD program would have to derive or model:

- confinement;
- running coupling;
- `Lambda_QCD`;
- trace anomaly;
- hadron spectrum;
- color holonomy dynamics on null edges.

Claim type: conceptual bridge and future dynamics program.

### 4.5 Higgs boson mass

The Higgs boson's own mass is neither a Yukawa mass nor a W/Z gauge mass. In the
Standard Model it is the curvature of the Higgs potential around the vacuum,
schematically:

```text
m_h^2 ~ 2 lambda v^2
```

up to convention.

Null-edge interpretation:

```text
Higgs scalar mass = spectral gap of the condensate amplitude/radial mode.
```

This fits the broad "mass as spectral gap" slogan, but it is not directly a
Pluecker spread of null rays.

Claim type: future scalar-field/spectral-action target.

### 4.6 Neutrino mass

Neutrinos are an edge case and should be treated carefully.

Null-edge interpretation:

```text
almost pure weak-visible null propagation
+ tiny Dirac/Majorana/sterile-sector gap
= small neutrino mass.
```

The current program does not decide:

- Dirac versus Majorana;
- sterile/right-handed sectors;
- seesaw scale;
- PMNS matrix;
- mass ordering;
- absolute neutrino mass scale.

Claim type: stress-test and future model-selection target.

## 5. Proposed paper path

### P1: finite kinematic core

Working title:

```text
Disagreeing Light: a formalized finite theorem for mass from null momenta
```

Purpose:

- prove the finite Pluecker/null-bundle mass theorem;
- establish massless iff projectively collinear;
- connect to celestial moment/closure language;
- connect to twistor and static Dirac-square-root wrappers with status labels;
- state the unified mass program without claiming the later mechanisms are
  already proved.

Manuscript revision guidance:

- add a claim-boundary box near the abstract;
- phrase "origin of mass" as finite kinematic origin of invariant mass for a
  null bundle;
- keep QCD/Higgs/neutrino sections as motivation and bridge, not as proved
  consequences;
- use the phrase "mass is the obstruction to a null-edge system remaining a
  single free null ray" as the broader program slogan;
- explicitly state that the present paper proves the first mechanism exactly and
  identifies the operator form later mechanisms must take.

### P1.5: null-edge mass mechanisms toy theorem note

Purpose: make the "all mass as null-edge spectral gaps" vision credible before
attempting the full Standard Model.

Proposed title:

```text
Null-edge spectral gaps: three finite toy theorems for Higgs and gauge mass
```

Core toy theorems:

1. Yukawa checkerboard theorem.
2. Abelian Higgs null-edge theorem.
3. Electroweak stabilizer theorem.

This note should be short, formalization-driven, and honest about free
parameters.

### P2: finite super-Dirac operator

Purpose:

- build the first-order dual-soldered operator;
- prove the graded square;
- separate kinetic Pluecker/null shell from zero-order `Phi_H^2`;
- audit frame, curvature, and Higgs-gradient terms.

Core operator:

```text
D_h(A,H) =
  i sum_a c(alpha^a) nabla_a^A
  + Gamma_s Phi_H.
```

Target square:

```text
D_h^2 =
  -K_h(A)
  + Phi_H^2
  + C_diamond(A)
  + T_frame
  - i Gamma_s sum_a c(alpha^a) [nabla_a^A, Phi_H].
```

Claim type: operator unification/reconstruction.

### Later paper: predictive constraints

Purpose:

- ask whether the finite null-edge geometry constrains Standard Model
  parameters;
- build a moduli-rank ledger;
- distinguish reconstruction from prediction.

Prediction gate:

```text
F : M_finite -> M_EFT
```

The model predicts only if the image has codimension or if some EFT parameter is
independently forced by the finite geometry.

## 6. Three immediate finite toy theorem targets

### 6.1 Yukawa checkerboard theorem

Informal statement:

```text
null L/R propagation + constant chirality-flip M
=> massive Dirac dispersion p^2 = M^dagger M.
```

Prototype equations:

```text
i partial_+ psi_L = M psi_R
i partial_- psi_R = M^dagger psi_L
```

Squaring gives:

```text
-partial_+ partial_- psi_L + M M^dagger psi_L = 0
-partial_- partial_+ psi_R + M^dagger M psi_R = 0
```

Finite version:

```text
D_chiral =
  i D_null
  + Gamma_s [[0, M^dagger],
             [M, 0]]
```

Target square:

```text
D_chiral^2 =
  -K_null
  + [[M^dagger M, 0],
     [0, M M^dagger]]
  + gradient terms.
```

Vacuum simplification: if `M` is constant, gradient terms vanish.

Why it matters: this is the cleanest proof that a massive elementary fermion can
be represented using only null microscopic propagation plus an internal
chirality-flip gap.

### 6.2 Abelian Higgs null-edge theorem

Informal statement:

```text
finite null-edge Higgs covariant difference
+ vacuum modulus |phi| = v
=> quadratic gauge-holonomy mass term.
```

Finite action:

```text
S = sum_{x,a} |U_a(x) phi(x + h ell_a) - phi(x)|^2
    + lambda (|phi|^2 - v^2)^2.
```

For `U_a(x) = exp(i A_a(x))` and `phi = v + h_scalar(x)` in unitary-gauge
language, the quadratic term contains:

```text
v^2 A_a(x)^2.
```

Gauge-invariant reading:

```text
holonomies that move the condensate section have quadratic energy cost.
```

Why it matters: this shows gauge-boson mass can arise on a graph whose primitive
transport edges are null.

### 6.3 Electroweak stabilizer theorem

Informal statement:

```text
H_0 in C^2,
G = SU(2)_L x U(1)_Y,
Stab(H_0) = U(1)_em.
```

Consequences:

```text
dim G - dim U(1)_em = 3
```

so three gauge directions acquire a Higgs-condensate mismatch gap, while one
direction remains massless.

Interpretation:

```text
photon = holonomy direction preserving H_0;
W+, W-, Z = holonomy directions moving H_0.
```

Why it matters: this is the finite-algebra gateway from Abelian Higgs mass to
actual electroweak mass structure.

## 7. Full unified operator target

The eventual operator should combine fermions, gauge holonomies, Higgs field,
Yukawa block, and dual-soldered null-edge propagation:

```text
D_h(A,H) =
  i sum_a c(alpha^a) nabla_a^A
  + Gamma_s Phi_H.
```

Desired square:

```text
D_h^2 =
  -K_h(A)
  + Phi_H^2
  + C_diamond(A)
  + T_frame
  - i Gamma_s sum_a c(alpha^a) [nabla_a^A, Phi_H].
```

Interpretation of terms:

```text
null-edge propagation       -> kinetic shell
dual soldering              -> Lorentzian Dirac symbol
gauge holonomy              -> curvature and Pauli terms
frame/tetrad compatibility  -> removal/control of T_frame
Higgs/Yukawa block          -> fermion mass gaps
Higgs covariant variation   -> W/Z-type condensate mismatch gaps
spectral action             -> possible bosonic dynamics and prediction gate
```

This is the unified theorem to aim for. It does not by itself predict numerical
masses. It gives a common null-edge operator architecture for the mass
mechanisms.

## 8. Manuscript claim language

Avoid:

```text
We explain the origin of all mass.
```

Use:

```text
We prove the finite kinematic core of a broader null-edge origin-of-mass
program. In this program, primitive visible propagation is lightlike. Composite
mass is Pluecker spread of null momentum bundles; fermion mass is chirality
mixing between null Weyl channels; W/Z mass is the spectral gap of gauge
holonomies that do not preserve the Higgs condensate; hadron mass is confined
relativistic/null QCD energy; and the Higgs boson's own mass is the radial
spectral gap of the condensate. The present paper proves the first mechanism
exactly and identifies the operator-theoretic form the later mechanisms must
take.
```

Short version:

```text
Primitive microscopic propagation is null; effective mass arises from bundle
spread, chirality mixing, condensate mismatch, confinement, or condensate
stiffness.
```

## 9. Claim ledger

```text
Claim                                              Status
-------------------------------------------------  ---------------------------
Finite bundle mass equals Pluecker spread          Finite identity, P1
Massless iff all null spinors are collinear        Finite identity, P1
QCD/hadron mass fits null-bundle accounting        Conceptual bridge
Fermion mass as chirality-flip gap                 Operator theorem target
W/Z mass as holonomy-condensate mismatch gap       Finite graph-Higgs target
Photon as stabilizer direction                     Electroweak algebra target
Higgs boson mass as radial condensate gap          Scalar potential target
Neutrino mass as tiny hidden-sector gap            Future model-selection target
Observed mass values are derived                   Not established
Yukawa matrices are predicted                      Not established
QCD scale is derived                               Not established
```

## 10. Risks and guardrails

### Overclaim risk

Risk: readers hear "the Pluecker theorem explains all mass."

Guardrail: state that the Pluecker theorem is the finite kinematic prototype,
while Higgs/Yukawa, W/Z, QCD, Higgs-scalar, and neutrino masses are different
gap mechanisms in a shared null-edge architecture.

### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```

### Gauge-language risk

Risk: saying a local gauge redundancy literally breaks.

Guardrail: use stabilizer and covariant-reference-section language. In finite
graph terms, holonomies preserving the Higgs section remain gapless; holonomies
moving it acquire quadratic cost.

### Prediction-risk

Risk: the model merely reparametrizes the Standard Model.

Guardrail: maintain a moduli-rank ledger. A prediction requires fewer effective
parameters or an independently forced restriction.

### QCD overreach

Risk: claiming the finite Pluecker theorem derives proton mass.

Guardrail: say QCD supplies confinement and dynamics; Pluecker supplies finite
invariant accounting for summed null/relativistic momenta.

## 11. Recommended next jobs

### Writing jobs

1. Revise P1 abstract and introduction around the three-level hierarchy.
2. Add an early claim-boundary box to P1.
3. Add the mass-phenomena table to P1 or a companion bridge note.
4. Draft P1.5 as a short theorem-driven bridge note.
5. Add a source-audit checklist for CERN/CMS/ATLAS/DOE/Wilczek/FMS references
   before public citation.

### Lean/formalization jobs

1. State the Yukawa checkerboard theorem in a finite chiral block model.
2. Prove the constant-`M` square with separated `Gamma_s` and internal grading.
3. Formalize a finite Abelian Higgs edge action and extract the quadratic
   holonomy mass term.
4. Formalize the electroweak stabilizer theorem for `SU(2)_L x U(1)_Y` acting
   on a Higgs doublet.
5. Connect the toy theorems to the dual-soldered super-Dirac square target.

### Aristotle jobs

1. Massive strategy job: design the P1.5 theorem package and identify the
   smallest Lean statements.
2. Lean proof job: finite chiral checkerboard square with constant mass block.
3. Lean proof job: Abelian Higgs null-edge quadratic mass extraction.
4. Lean proof/audit job: electroweak stabilizer and mass-matrix rank.
5. Audit job: gauge-invariant phrasing and FMS-style pitfalls for finite graph
   Higgs language.
6. Strategy job: moduli-rank prediction ledger for the unified mass program.

## 12. Source/provenance checklist before citation

The supplied feedback referenced the following source lanes. Before manuscript
submission, verify exact citation metadata and decide which sources belong in P1
versus P1.5 or later papers:

- CERN/CERN Courier on Higgs/Yukawa couplings and the non-predictive status of
  Yukawa strengths.
- CERN/CMS/ATLAS public or review material on Higgs mechanism and W/Z versus
  photon masses.
- Quigg/electroweak review material for standard W/Z mass and photon
  masslessness language.
- DOE and Wilczek "mass without mass" sources for QCD/proton mass motivation.
- FMS mechanism literature for gauge-invariant Higgs-mechanism phrasing.

Keep public-facing citations separate from technical sources. For technical
claims, prefer review articles, textbooks, or primary papers over outreach pages.

## 13. Decision checklist for the unified mass paper

Before presenting a paper as a unified model for mass using null edges, answer:

1. Which mechanisms are actually proved in this paper?
2. Which mechanisms are represented as finite toy models?
3. Which mechanisms are only conceptual bridges?
4. Does the operator use only null primitive shifts?
5. Is the Pluecker kinetic invariant separated from `Phi_H^2`?
6. Are `Gamma_s`, internal grading, and form/cochain degree separated?
7. Is gauge-boson mass phrased through condensate stabilizers or covariant
   mismatch, not naive breaking of a local redundancy?
8. Is QCD confinement treated as input/future work unless actually derived?
9. Does the model constrain any Standard Model free parameter?
10. Are all prediction claims labeled separately from reconstruction claims?

If the answer to item 9 is "no," the paper can still claim a unified null-edge
representation of mass mechanisms, but not a numerical derivation of the mass
spectrum.

## 14. Bottom line

The viable program is:

```text
all effective mass as spectral gaps of null-edge dynamics,
```

not:

```text
all mass as the same Pluecker formula.
```

The Pluecker theorem is the finite kinematic prototype. Higgs/Yukawa mass is an
internal chirality-flip gap. W/Z mass is a condensate-holonomy mismatch gap. QCD
mass is confined relativistic/null color energy. The Higgs boson's own mass is
the condensate radial-mode gap. Neutrino mass is a tiny gap in an almost-null
weak channel.

This is coherent and worth developing. The hard part is proving that the
null-edge finite operator naturally yields the Standard Model structure and,
eventually, constrains at least one parameter the Standard Model leaves free.

## 15. Pro response refinement: obstruction forms and sharper P1.5 targets

**Update, 2026-06-26.** A follow-up ChatGPT Pro pass endorsed the working
plan's central distinction: the coherent thesis is not that every mass is the
same Pluecker formula, but that primitive spacetime transport is null while
effective mass is a spectral gap, obstruction, or rest-frame invariant of
null-edge dynamics.

### 15.1 Manuscript-level claim

Use this as the strongest manuscript-level claim:

```text
We develop a null-edge architecture for mass in which all primitive spacetime
transport is lightlike. Composite invariant mass is Pluecker spread of finite
null-momentum bundles; elementary fermion mass is a Higgs/Yukawa chirality-flip
gap between left and right null Weyl channels; W/Z mass is a
condensate-holonomy mismatch gap; QCD/hadron mass is confined relativistic/null
color energy; the Higgs boson's own mass is the radial gap of the condensate;
and neutrino mass is a tiny Dirac/Majorana/hidden-sector gap. The present paper
proves the finite Pluecker mechanism exactly and states the finite toy theorems
and operator square needed to extend the framework.
```

Short slogan for introductions:

```text
Mass is the obstruction to a null-edge system remaining one free gapless null
ray.
```

Use `spectral gap` in technical sections. Use `obstruction to remaining one free
gapless null ray` in broad introductions, because composite Pluecker mass is a
rest-frame/timelike-total-momentum invariant rather than literally always a
bound-state energy gap.

### 15.2 Quadratic obstruction template

A useful unifying mathematical template is:

```text
m^2 = value or eigenvalue of B^dagger B,
```

where `B` measures failure to remain in a massless, null, or gapless subspace.

```text
Mechanism            Obstruction map B                         Mass statement
-------------------  ----------------------------------------  ------------------------------
Finite null bundle   Pluecker-minor map psi_i wedge psi_j      sum |psi_i wedge psi_j|^2
Dirac/Yukawa mass    Chirality-flip map M : R -> L             spec(M^dagger M)
W/Z bosons           Vacuum-orbit map X -> X H_0               |X H_0|^2; kernel is photon
Higgs boson          Hessian/radial curvature of V at vacuum   radial scalar gap
QCD/hadrons          Confining color Hamiltonian/holonomies    confined color-energy gaps
Neutrinos            Dirac/Majorana/seesaw mass matrix         tiny hidden-sector gaps
```

This makes the program less metaphorical: mass is not `stuff`; it is the
norm-square or spectral value of a failure mode. The Pluecker theorem is the
first fully formalized case of this template.

### 15.3 Meaning of primitive null propagation

Define the null-edge assumption carefully:

```text
Every primitive spacetime transport term is supported on null edges.
```

Do not require every internal algebraic map to be lightlike. In the intended
model:

- fermions propagate between spacetime vertices along null edges;
- gauge holonomies live on null edges;
- Higgs and scalar fields may live on vertices;
- Yukawa, Majorana, scalar-potential, and internal maps are local vertex or
  fiber maps;
- mass appears only after null-edge propagation is coupled to internal gaps,
  condensates, holonomies, or confinement.

This avoids a false objection: a Higgs value at a vertex is not a slower-than-light
particle trajectory. It is a local section. The null-edge claim concerns
spacetime transport terms.

The minimal decorated null-tetrad graph for the unified mass program should
carry:

```text
(V, E; ell_a(x), alpha^a(x), h_a(x), U_spin_a(x), U_gauge_a(x),
 H_x, Phi_H(x), Gamma_s, chi_E, J).
```

For universal field operators, the null frame should come from a dynamical
tetrad or spin frame, not a fixed observer. In the tetrahedral 3+1 convention:

```text
ell_A(x) = e_0(x) + n_A^i e_i(x),
alpha^A(x) = 1/4 e^0(x) + 3/4 n_A^i e^i(x).
```

### 15.4 P1 role refined

P1 should keep the Pluecker theorem central and keep Standard Model examples as
bridges. The theorem says: given a finite family of visible null momenta, the
invariant mass of the total bundle is pairwise Pluecker spread. It does not
derive the dynamics that trapped the bundle.

Use this QCD sentence:

```text
QCD supplies confinement and dynamics; Pluecker supplies invariant accounting.
```

Expanded form:

```text
The Pluecker theorem is not a derivation of proton mass. It is the exact finite
invariant that any null/relativistic constituent account must reproduce once the
bound system's null momenta are given.
```

### 15.5 P1.5 toy theorem 1: Yukawa checkerboard / chirality-flip gap

Let `E_L` and `E_R` be finite-dimensional internal/flavor spaces. Let

```text
M : E_R -> E_L
```

be a constant Yukawa/Higgs mass matrix after symmetry breaking. Let `nabla_+`
and `nabla_-` be null finite-difference operators along two light-cone
directions, commuting with `M`. Consider:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Applying the opposite null derivative gives:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R,
```

where `K_L` and `K_R` are the chosen null kinetic mass-shell operators, for
example `K = -nabla_- nabla_+` up to light-cone sign convention.

The theorem should establish:

```text
massive Dirac propagation can be built from null L/R propagation plus a local
chirality-flip gap.
```

For flavor, squared masses are singular values of `M`, i.e. eigenvalues of
`M^dagger M` and `M M^dagger`. This reconstructs the Standard Model mechanism if
`M` is input; it does not predict the entries of `M`.

Grading guardrail:

```text
Phi_H should commute with spacetime chirality Gamma_s in D = i D_N + Gamma_s Phi_H,
while being odd with respect to the internal grading chi_E.
```

If `Phi_H` anticommutes with the same `Gamma_s`, the sign of `Phi_H^2` flips.

### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.

### 15.7 P1.5 toy theorem 3: electroweak stabilizer and rank-three mass form

Let:

```text
G = SU(2)_L x U(1)_Y
```

act on a Higgs doublet `H in C^2`, with Standard Model convention:

```text
Q = T_3 + Y/2,
Y(H) = 1.
```

Take:

```text
H_0 = (0, v/sqrt(2)).
```

Define the quadratic obstruction form on gauge Lie algebra directions:

```text
q(X) = |X H_0|^2.
```

Then:

```text
ker q = u(1)_em,
rank q = dim(SU(2) x U(1)) - dim(U(1)_em) = 3.
```

In usual normalized fields, the quadratic form is:

```text
q(W, B) = v^2/8 * (g^2 ((W^1)^2 + (W^2)^2) + (g W^3 - g' B)^2).
```

The basis is:

```text
W^+ = (W^1 - i W^2) / sqrt(2),
W^- = (W^1 + i W^2) / sqrt(2),
Z   = (g W^3 - g' B) / sqrt(g^2 + g'^2),
A   = (g' W^3 + g B) / sqrt(g^2 + g'^2).
```

Mass pattern:

```text
m_W = g v / 2,
m_Z = sqrt(g^2 + g'^2) v / 2,
m_gamma = 0.
```

Null-edge interpretation:

```text
photon = holonomy direction preserving H_0,
W^+, W^-, Z = holonomy directions moving H_0.
```

This is reconstruction of the Standard Model mass pattern unless `G`, the Higgs
representation, `v`, `g`, and `g'` are forced by the finite null-edge geometry.

### 15.8 Gauge-invariant wording and FMS guardrail

Avoid saying:

```text
local gauge symmetry literally breaks.
```

Use:

```text
the Higgs field defines a covariant internal reference section; holonomies that
move it acquire quadratic energy cost.
```

The finite edge functional:

```text
|U_e H_t - H_s|^2
```

is gauge-invariant. In a vacuum/trivialization expansion, its dominant
quadratic terms look like ordinary W/Z mass terms. This is the bridge to the
usual perturbative language and is compatible with FMS-style caution about
physical observables being gauge-invariant composites.

### 15.9 Higgs boson and neutrino appendices

Higgs scalar radial gap theorem target:

```text
V(H) = lambda (H^dagger H - v^2/2)^2,
H = (0, (v + h)/sqrt(2)),
V(H) = lambda (v h + h^2/2)^2 = lambda v^2 h^2 + O(h^3).
```

With conventional scalar kinetic normalization:

```text
m_h^2 = 2 lambda v^2.
```

Treat this as the radial stiffness/spectral gap of the condensate amplitude. It
fits the broad spectral-gap slogan but is not a Pluecker spread.

Neutrino stress-test theorem target:

```text
M_seesaw = [[0, m_D],
            [m_D^T, M_R]].
```

When `M_R` is invertible and large, Schur complement reduction gives:

```text
M_light approximately -m_D M_R^(-1) m_D^T.
```

Null-edge interpretation: the visible weak channel remains almost null because
the gap is induced only through a hidden heavy sector. This is future
model-selection work, not an explanation of neutrino data.

### 15.10 Super-Dirac mechanism separation

The unified object remains:

```text
D_h(A, H) = i D_N(A) + Gamma_s Phi_H,
D_N(A) = sum_a C_a nabla_a^A,
C_a = c(alpha^a).
```

The shift `nabla_a^A` is along the null edge `ell_a`; `C_a = c(alpha^a)` supplies
the dual-soldered Dirac symbol. Do not use the diagonal operator
`c(ell_a) nabla_ell_a` as the continuum Dirac symbol.

Under clean grading hypotheses:

```text
{Gamma_s, C_a} = 0,
[Gamma_s, nabla_a^A] = 0,
[Gamma_s, Phi_H] = 0,
[C_a, Phi_H] = 0,
```

one gets:

```text
D_h^2 = -D_N(A)^2 + Phi_H^2
        - i Gamma_s sum_a C_a [nabla_a^A, Phi_H].
```

The kinetic square decomposes as:

```text
D_N(A)^2 = K_h(A) + C_diamond(A) + T_frame.
```

So the desired schematic identity is:

```text
D_h^2 = -K_h(A) - C_diamond(A) - T_frame
        + Phi_H^2
        - i Gamma_s sum_a C_a [nabla_a^A, Phi_H].
```

Term roles:

```text
K_h(A)                  null-edge kinetic shell
Phi_H^2                 fermion Higgs/Yukawa mass block
C_diamond(A)            gauge curvature / Pauli coupling
T_frame                 tetrad/spin-connection compatibility defect
[nabla, Phi_H]          Higgs-gradient/Yukawa variation term
```

Important separation:

```text
fermion masses live in Phi_H^2;
W/Z masses live in |nabla^A H|^2 or its spectral-action analogue.
```

This prevents conflating fermion mass blocks with gauge-boson condensate masses.

### 15.11 Null edges versus mere graph discretization

A skeptical reader will ask whether this is just the Standard Model on a
lightlike graph. The answer must be theorem-based. Null edges do real work only
if the program proves a package like:

1. finite Pluecker theorem for null bundles;
2. dual-soldered commutator theorem for the continuum Dirac symbol;
3. graded square theorem with correct kinetic, curvature, frame, and `Phi_H^2`
   terms;
4. Higgs/Yukawa checkerboard theorem from null L/R propagation plus local flip;
5. Abelian/nonabelian Higgs edge theorem from null-edge holonomy-condensate
   mismatch;
6. electroweak stabilizer theorem: photon is stabilizer direction and W/Z are
   the three massive orbit directions.

With only a graph discretization, this is a representation. With the theorem
package, it becomes coherent null-edge reconstruction. With a parameter
constraint, it becomes predictive.

### 15.12 Sharpened prediction candidates

Early prediction candidates are probably structural rather than full numerical
masses:

- forbidden Pauli counterterms;
- restricted Yukawa rank, texture, or zero pattern;
- anomaly cancellation forcing a representation class;
- forced Higgs representation or stabilizer;
- spectral-action relation among `g`, `g'`, `g_s`, `lambda`, or `v`;
- finite-geometry reason for generation number;
- absence or presence of a specific Lorentz-dispersion correction.

Until such a constraint is proved, call the program unified reconstruction, not
numerical derivation of the mass spectrum.

### 15.13 Referee-facing response posture

Likely objection:

```text
This is a poetic restatement of standard facts: two null particles can have
invariant mass, Higgs/Yukawa couplings give fermion masses, the Higgs mechanism
gives W/Z mass, and QCD gives proton mass.
```

Response:

```text
Correct that the ingredients are standard. The contribution is a finite,
machine-checkable null-edge theorem spine and a single operator architecture in
which primitive spacetime transport remains null while the known mass mechanisms
appear as distinct finite obstruction forms.
```

Likely objection:

```text
The Pluecker theorem does not derive proton mass or the Yukawa spectrum.
```

Response:

```text
Correct. P1 proves the kinematic invariant. QCD and Yukawa dynamics are later
layers. Numerical mass prediction requires a moduli-rank/codimension constraint.
```

Likely objection:

```text
Gauge symmetry is redundancy, so breaking language is misleading.
```

Response:

```text
Use gauge-invariant link language: holonomies that fail to preserve a Higgs
section acquire quadratic edge cost. The usual W/Z mass terms appear only after a
vacuum/trivialization expansion.
```

### 15.14 Sharpened stop rule

Use this stop rule for the unified mass manuscript:

```text
If no finite null-edge theorem does more than repackage standard mass terms,
call the work a null-edge representation, not a unified origin-of-mass theory.
```

The program becomes genuinely surprising if the finite null-edge structure
forces a Standard-Model-like internal sector, constrains a coupling/Yukawa/gauge
relation, forbids a counterterm, predicts a dispersion correction, or forces a
representation/anomaly pattern.
## 16. Pro response refinement: quadratic obstruction as the umbrella language

**Update, 2026-06-26.** A second follow-up Pro pass sharpened the core language.
Use **quadratic obstruction** as the top-level mathematical umbrella. Reserve
**spectral gap** for operator spectra, Hessians, mass matrices, and Hamiltonian
or Dirac-square contexts.

This avoids a subtle overclaim: the P1 Pluecker theorem is not literally an
operator spectral-gap theorem. It is a finite invariant of a state, or a
rest-frame obstruction for a null bundle. P1.5 and P2 are where spectral gaps
become the natural technical language.

### 16.1 Central language hierarchy

Umbrella:

```text
mass as quadratic obstruction
```

Special cases:

```text
Pluecker mass      = state invariant / rest-frame obstruction
Yukawa mass        = chirality-flip spectral gap
W/Z mass           = condensate-holonomy stiffness / orbit obstruction
Higgs boson mass   = radial Hessian gap of the condensate
QCD hadron mass    = confined color-dynamics energy gap
neutrino mass      = tiny Dirac/Majorana/hidden-sector mass gap
```

Best manuscript sentence:

```text
Primitive spacetime transport is null. Effective mass appears when null-edge
dynamics fails to remain a single free gapless null mode: as a Pluecker
rest-frame invariant for finite null bundles, a chirality-flip gap for fermions,
a condensate-holonomy stiffness for W/Z bosons, a radial Hessian gap for the
Higgs amplitude mode, or a confined color-dynamics gap for hadrons.
```

For P1, lead with:

```text
finite invariant mass
quadratic Pluecker obstruction
rest-frame invariant of a null bundle
```

Do not headline P1 with `spectral gap`. Use spectral-gap language mainly in
P1.5 and P2.

### 16.2 Non-vacuous obstruction template

The template

```text
m^2 = B^dagger B
```

is useful only when `B` is a canonical map measuring failure to lie in a
null/gapless/symmetric subspace. Otherwise it is vacuous, because any positive
mass matrix can be written as `B^dagger B`.

Non-vacuous criterion:

```text
B must be geometrically or physically forced, not chosen after the fact.
```

Clean table:

```text
Mechanism           Canonical obstruction B                      Meaning of B^dagger B
------------------  -------------------------------------------  ------------------------------
Pluecker bundle     B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}        mass is failure of rank one
Yukawa fermion      B_Y = M : E_R -> E_L                         squared masses from singular values
W/Z bosons          B_H : X -> X H_0                             orbit directions moving H_0 are costly
Higgs boson         Hessian or radial derivative of V at H_0     radial scalar mass
Seesaw neutrino     Dirac/Majorana block matrix                  light gaps from Schur complement
QCD hadrons         no clean finite B yet                        use confinement/Hamiltonian gap language
```

The template is strongest for Pluecker, Yukawa, W/Z, and scalar-Higgs mass. It
is weakest for QCD until the program has an actual finite confinement or color
Hamiltonian theorem. For now, keep QCD language modest:

```text
QCD supplies confinement and dynamics; Pluecker supplies invariant accounting.
```

### 16.3 Pluecker obstruction map for P1

For P1, define the obstruction map explicitly. Let `Psi` be the `2 x n` spinor
matrix whose columns are the null spinors `psi_i`. Define:

```text
B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}.
```

Then:

```text
|B_Pl(Psi)|^2
  = sum_{i<j} |psi_i wedge psi_j|^2
  = det(sum_i psi_i psi_i^dagger).
```

The obstruction is failure of `Psi` to have rank one. The massless locus is the
rank-one/projectively collinear locus.

Use three equivalent readings, but lead technically with the Pluecker formula:

```text
rank-one failure: psi_i wedge psi_j != 0
Pluecker spread:  sum_{i<j} |psi_i wedge psi_j|^2
moment deficit:   m^2 = (E^2 - |C|^2) / 4
```

Do not make closure defect the primary obstruction. Zero momentum closure
`C = 0` is a rest-frame condition with maximal mass for fixed energy, not a
massless condition.

### 16.4 Abstract mass-shell schema

The abstract schema is useful as a pattern, not as the main theorem:

```text
Let K be a null-edge kinetic operator and B a geometrically defined obstruction
map whose kernel is the desired null/gapless sector. A massive mode satisfies
K psi = B^dagger B psi.
```

Finite spectral matching theorem target:

```text
K = sum_lambda lambda Pi_lambda,
B^dagger B = sum_mu mu P_mu,
A = -K tensor I + I tensor B^dagger B.
```

Then:

```text
ker A = direct_sum_{lambda = mu} E_lambda(K) tensor E_lambda(B^dagger B).
```

This is nontrivial only if:

- `K` is forced by a null-edge operator, not chosen after the fact;
- `B` is canonical, such as Pluecker minors, a Yukawa block, or a Higgs orbit
  map;
- the kernel, rank, or spectrum of `B^dagger B` has structural content;
- free parameters inside `B` are recorded in the moduli ledger;
- Pluecker kinetic mass and Higgs/Yukawa mass are not added as independent mass
  terms.

### 16.5 Revised P1 claim-boundary paragraph

Use this near the beginning of P1:

```text
This paper proves a finite kinematic theorem: a bundle of null spinor momenta
has invariant mass precisely to the extent that its null directions fail to
remain projectively collinear. It does not derive the Standard Model mass
spectrum, QCD confinement, electroweak symmetry breaking, or Yukawa couplings.
Those belong to later operator and dynamics layers. The theorem supplies the
square-level invariant that any null-edge dynamics must reproduce.
```

Also add an explicit scope exclusion:

```text
Throughout, "mass" means invariant particle or bound-state mass, or a spectral
mass parameter in a relativistic field theory. We do not address gravitational
source energy, ADM/Bondi mass, black-hole mass, or cosmological vacuum energy.
```

### 16.6 P1.5 toy theorem 1: finite Yukawa checkerboard, sharpened

State this first because it directly answers how an elementary fermion can have
mass if primitive spacetime motion is null.

Let `H_L` and `H_R` be finite-dimensional Hilbert spaces, and let

```text
M : H_R -> H_L
```

be a rectangular complex matrix. Let `nabla_+` and `nabla_-` be commuting null
finite-difference operators, and assume `M` commutes with the spacetime
differences. The finite chiral system is:

```text
i nabla_+ psi_L = M psi_R,
i nabla_- psi_R = M^dagger psi_L.
```

Define:

```text
K_L = -nabla_- nabla_+,
K_R = -nabla_+ nabla_-.
```

Then:

```text
K_L psi_L = M M^dagger psi_L,
K_R psi_R = M^dagger M psi_R.
```

This theorem needs no continuum analysis. It is finite algebra plus commuting
differences. It does not require unitarity, though it uses a Hilbert inner
product to define `M^dagger`. Lorentzian/Krein issues can be audited later for
the full operator.

Use this sign convention so the later super-Dirac square

```text
D^2 = -K + Phi_H^2
```

gives the on-shell condition:

```text
K = Phi_H^2.
```

Rectangular `M` is allowed. Zero modes are kernels and dimension-mismatch
remnants. Prove the singular-value theorem separately:

```text
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M).
```

Handle flavor abstractly. One Yukawa matrix gives mass eigenbases by SVD;
CKM/PMNS mixing appears only when different Yukawa sectors are diagonalized in
incompatible bases.

Majorana mass should not be called a chirality-flip gap. It is a
charge-conjugation/self-pairing obstruction. Algebraically, a Majorana mass
matrix is complex symmetric and uses Takagi factorization; squared masses still
come from `M^dagger M`, but the interpretation differs.

### 16.7 P1.5 toy theorem 2: Abelian Higgs link stiffness, sharpened

The exact finite theorem is gauge-invariant link stiffness, not yet a mass term.

Let `G = U(1)`. Let a finite directed graph have null-labeled edges
`e : s(e) -> t(e)`. Put:

```text
phi_v in C,
U_e in U(1).
```

Define:

```text
S_H(phi, U) = sum_e |U_e phi_t(e) - phi_s(e)|^2.
```

Under gauge transformations `g_v in U(1)`:

```text
phi_v -> g_v phi_v,
U_e   -> g_s(e) U_e g_t(e)^(-1),
```

`S_H` is invariant.

Assume `|phi_v| = v` and write:

```text
phi_v = v sigma_v,
sigma_v in U(1).
```

Then exactly:

```text
S_H = v^2 sum_e |w_e - 1|^2,
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Here `w_e` is gauge-invariant. This is the finite theorem.

It becomes a gauge-boson mass term only after a vacuum/small-holonomy expansion:

```text
w_e = exp(i epsilon A_e),
v^2 |w_e - 1|^2 = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The physical mass interpretation assumes:

- the Higgs modulus is frozen or expanded around `v`;
- the holonomy is close to identity;
- `A_e` has correct continuum scaling;
- scalar kinetic normalization is fixed;
- the null-edge quadrature/dual-soldering rule reconstructs the continuum
  kinetic term.

Safe wording:

```text
Exact theorem: gauge-invariant link stiffness.
Physical interpretation: quadratic gauge-boson mass after expansion around a
condensate.
```

### 16.8 P1.5 toy theorem 3: electroweak stabilizer, sharpened

Prove this in two stages: kernel/rank first, coefficient formulas second.

Let:

```text
G = SU(2)_L x U(1)_Y
```

act on the Higgs doublet `H in C^2`, with:

```text
Q = T_3 + Y/2,
Y(H) = 1,
H_0 = (0, v/sqrt(2)).
```

Define the orbit obstruction map:

```text
B_EW : su(2) plus u(1) -> C^2,
B_EW(X) = rho(X) H_0.
```

Let:

```text
q(X) = |B_EW(X)|^2.
```

First theorem:

```text
ker q = u(1)_em,
ker B_EW = span(Q),
rank q = 3.
```

This proves one massless gauge direction and three massive orbit directions,
given the Standard Model electroweak group and Higgs representation.

Second theorem adds normalizations. Include gauge couplings by evaluating:

```text
X = g(W^1 T_1 + W^2 T_2 + W^3 T_3) + g' B Y/2.
```

Then, up to kinetic-term normalization convention:

```text
q(X) = v^2/8 *
  (g^2 ((W^1)^2 + (W^2)^2) + (g W^3 - g' B)^2).
```

Physical basis:

```text
W^+ = (W^1 - i W^2) / sqrt(2),
W^- = (W^1 + i W^2) / sqrt(2),
Z   = (g W^3 - g' B) / sqrt(g^2 + g'^2),
A   = (g' W^3 + g B) / sqrt(g^2 + g'^2).
```

Mass pattern:

```text
m_W = g v / 2,
m_Z = sqrt(g^2 + g'^2) v / 2,
m_gamma = 0.
```

For P1.5, prioritize the rank/kernel theorem. The exact coefficient formulas
can be a second theorem or appendix because they depend on normalization
choices.

### 16.9 Gauge-invariant W/Z language and FMS target

Use gauge-invariant finite graph language first:

```text
S_H = sum_e |U_e H_t(e) - H_s(e)|^2.
```

If `H` is a covariant vacuum section, holonomies preserving it have zero edge
cost; holonomies moving it have positive quadratic cost.

Avoid:

```text
The gauge symmetry literally breaks.
```

Use:

```text
The Higgs field defines a covariant internal reference section. Gauge holonomies
that fail to preserve this section acquire a quadratic edge cost; stabilizer
directions remain gapless.
```

Positive FMS-style theorem target:

```text
Construct gauge-invariant edge-local composite operators from H_s, U_e, and H_t
whose leading expansion around a vacuum section is the usual W/Z field.
```

Schematic example to audit:

```text
O_e^a = H_s(e)^dagger tau^a U_e H_t(e).
```

The exact representation needs review, but the target is clear: physical W/Z-like
excitations should be represented by gauge-invariant link composites, not only by
bare gauge-variant fields.

### 16.10 Null edges versus ordinary lattice gauge theory

The Abelian Higgs edge theorem alone is close to standard lattice gauge-Higgs
theory. Null edges add real content only if the program proves:

- scalar/gauge kinetic terms reconstructed using only null-supported edge
  transports;
- fermion propagation on the same null-edge substrate;
- gauge holonomies on null edges;
- Higgs covariant differences on null edges;
- dual-soldered continuum symbol recovery;
- super-Dirac square with correct `-K + Phi_H^2` plus curvature/frame/Higgs
  terms.

Without this surrounding package, P1.5 is a graph discretization with null labels.
With it, P1.5 becomes part of a unified null-edge operator architecture.

### 16.11 QCD, Higgs boson, and neutrino scope

QCD belongs in P1 as motivation and boundary, not as a toy theorem unless there
is a real finite confinement result. Mention the trace anomaly only in technical
claim-boundary language, not in the popular exposition:

```text
We do not derive the QCD trace anomaly or the hadron spectrum; QCD dynamics is
an input/future layer.
```

Higgs boson mass belongs in P1.5 as a footnote or short appendix:

```text
V(H) = lambda (H^dagger H - v^2/2)^2,
H = (0, (v + h)/sqrt(2)),
V(H) = lambda (v h + h^2/2)^2 = lambda v^2 h^2 + O(h^3),
m_h^2 = 2 lambda v^2
```

with conventional kinetic normalization. Interpretation: radial
Hessian/stiffness of the condensate amplitude. This is compatible with scalar
fields living on vertices; null-edge dynamics enters through covariant
differences and operator/spectral action, not because the scalar value itself is
an edge.

Neutrinos are a stress test, not evidence. Prefer:

```text
Neutrinos are ultrarelativistic weakly detected states with tiny mass splittings;
in a null-edge model they are a stress test for how a nearly gapless weak
channel acquires a very small Dirac, Majorana, or hidden-sector mass.
```

A seesaw block is one possible toy obstruction, not a commitment to sterile
neutrinos or a specific mechanism.

### 16.12 Timelike worldlines from null primitive steps

Expected referee question:

```text
If every primitive step is null, why do massive particles follow timelike
worldlines?
```

Answer:

```text
The primitive transport steps are null, but the observed trajectory is a
coarse-grained or spectral object. A timelike momentum can be a sum or average of
null momenta; a massive mode can satisfy a null kinetic equation with an internal
obstruction K = m^2; and a bound state can have a rest frame even when its
constituents are massless or ultrarelativistic. Thus timelike propagation is not
a primitive step but an emergent invariant of coupled null transport.
```

P1 proves the kinematic instance: a finite bundle of null spinors can have
positive invariant mass while a projectively collinear bundle remains massless.

### 16.13 Minimum theorem package before stronger labels

Before calling the work a unified null-edge mass model, aim for:

1. P1 Pluecker theorem.
2. Yukawa checkerboard theorem.
3. Abelian Higgs link-stiffness theorem.
4. Electroweak stabilizer theorem.
5. Claim ledger labeling each item as representation, reconstruction, structural
   theorem, or prediction.

Before calling it candidate new dynamics, require:

1. dual-soldered super-Dirac square;
2. continuum symbol/scaling theorem;
3. anomaly/chirality audit;
4. finite spectral-action or moduli-rank result;
5. at least one codimension constraint on EFT parameters.

### 16.14 Four-way claim ledger

Use this ledger language:

```text
Representation:
  Standard physics data are placed on null-edge variables without reducing
  freedom.

Reconstruction:
  A theorem shows the standard mass mechanism emerges from null-edge primitives,
  but the Standard Model inputs remain free.

Structural theorem:
  A qualitative feature is forced by the finite algebra.

Prediction:
  The finite model fixes or restricts a parameter or structure that standard QFT
  leaves free.
```

Examples:

```text
Inserted M = y v / sqrt(2): representation.
Abelian Higgs link stiffness with input v: reconstruction.
ker B_EW = u(1)_em and rank B_EW = 3: structural theorem, given SM group and
Higgs representation.
Forced Yukawa rank, coupling relation, generation number, Higgs quartic relation,
or anomaly-selected representation: prediction.
```

Photon uniqueness is reconstruction/structural theorem **given** the Standard
Model electroweak group and Higgs representation. It becomes predictive only if
null-edge axioms force that group and representation.

### 16.15 Moduli-rank ledger, sharpened

Define:

```text
F : M_finite -> M_EFT.
```

`M_finite` includes:

```text
graph family,
null-frame/tetrad data,
dual-soldering normalization,
edge weights,
gauge group,
representations,
Higgs potential parameters,
Yukawa matrices,
Majorana/sterile blocks,
spectral function f,
cutoff Lambda,
allowed counterterms.
```

`M_EFT` includes:

```text
g_1, g_2, g_3,
v, lambda,
Y_u, Y_d, Y_e, Y_nu,
M_R,
CKM parameters,
PMNS parameters,
Lambda_QCD,
allowed EFT Wilson coefficients.
```

Prediction criterion:

```text
rank(dF) < dim M_EFT
```

or the image satisfies a nontrivial equation:

```text
R(theta_EFT) = 0.
```

Simple parameter counting is useful early, but codimension is the conceptual
criterion because field redefinitions and redundant coordinates can fake
parameter deficits.

### 16.16 Fast failure tests

The fastest serious failure tests are:

- Yukawa square sign failure: checkerboard or super-Dirac square has wrong sign
  or double-counts mass.
- Gauge-language failure: W/Z story relies on gauge-fixed `H_0` with no
  gauge-invariant link/composite formulation.
- Null-edge irrelevance: Higgs theorem works on any graph and no
  dual-soldered/null continuum theorem is provided.
- QCD overclaim: paper implies proton mass is derived while confinement and
  `Lambda_QCD` are not.
- Parameter full rank: finite model has enough free knobs to fit all Standard
  Model parameters.
- Chirality/anomaly failure: model cannot support observed chiral gauge
  structure.
- Continuum square failure: finite super-Dirac square does not converge to the
  correct Lichnerowicz/Dirac square.

Useful negative result:

```text
The quadratic-obstruction template is mathematically meaningful only when B is
canonical; otherwise it is a reparametrization.
```

### 16.17 Known-geometry positioning

Connect the obstruction-form view to standard geometry:

```text
Pluecker mass:       Gram determinant / Cauchy-Binet / Pluecker coordinates / rank-one cone
Yukawa mass:         singular values of a linear map
W/Z mass:            orbit-stabilizer geometry and quotient metric on G/Stab(H_0)
Higgs radial mass:   Hessian of a Morse-Bott potential transverse to vacuum manifold
Super-Dirac square:  Lichnerowicz/Weitzenbock square, kinetic Laplacian plus curvature/endormorphism
FMS/Higgs language:  gauge-invariant composites with leading vacuum expansion
```

This positioning helps the manuscript sound like disciplined geometry rather
than metaphor.

### 16.18 Strongest defensible thesis

Use this as the unified-plan opening thesis:

```text
We do not claim that all mass is literally the same Pluecker spread formula. We
claim that primitive spacetime transport can be organized as null-edge
transport, and that familiar mass mechanisms can be represented as quadratic
obstructions to remaining a single free gapless null mode. P1 proves the finite
kinematic prototype: a null-spinor bundle has invariant mass exactly equal to
its Pluecker spread. P1.5 shows, through finite toy theorems, how Higgs/Yukawa
fermion mass and W/Z gauge-boson mass fit the same obstruction pattern. P2 seeks
the common dual-soldered super-Dirac operator whose square separates null
kinetic shell, curvature, frame compatibility, and Higgs/Yukawa mass blocks
without double-counting.
```
## 17. Pro response refinement: roadmap v2 and theorem-order tightening

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment `9b346555-3b9f-4fea-942a-fcb14038e37a/pasted-text.txt`.

### 17.1 Front-page thesis language

The plan should promote `quadratic obstruction` from an addendum to the front-page organizing phrase.

Recommended thesis:

> We do not claim that all mass is literally the same Plucker spread formula. We claim that primitive spacetime transport can be organized as null-edge transport, and that familiar mass mechanisms can be represented as quadratic obstructions to remaining a single free gapless null mode. P1 proves the finite kinematic prototype: a null-spinor bundle has invariant mass exactly equal to its Plucker spread. P1.5 proves finite toy mechanisms for Higgs/Yukawa fermion mass and electroweak gauge-boson mass. P2 seeks the common dual-soldered super-Dirac operator whose square separates null kinetic shell, curvature, frame compatibility, and Higgs/Yukawa mass blocks without double-counting.

Use this hierarchy consistently:

```text
quadratic obstruction
> spectral gap
> mass-shell eigenvalue matching
```

Interpretation by mechanism:

- Plucker mass: rank-one/null-bundle obstruction.
- Yukawa mass: chirality-flip spectral gap.
- W/Z mass: Higgs-orbit or holonomy-stiffness obstruction.
- Higgs boson mass: radial Hessian gap.
- QCD/hadron mass: confined color-dynamics energy gap.
- Neutrino mass: tiny Dirac, Majorana, or hidden-sector gap.

Do not use `spectral gap` as the universal slogan. Use it only where an operator, Hessian, Hamiltonian, or square-spectrum statement is actually present. For P1, prefer `finite invariant mass`, `quadratic Plucker obstruction`, `rank-one obstruction`, and `rest-frame invariant of a null bundle`.

### 17.2 P1 claim boundary

P1 should open with the reader contract before the more public-facing exposition:

> This paper proves one exact finite mechanism: a finite bundle of null spinor momenta has invariant mass precisely to the extent that its directions fail to remain projectively collinear. We do not derive QCD confinement, electroweak symmetry breaking, Yukawa matrices, neutrino masses, or the observed mass spectrum. Those are later operator and dynamics layers.

This allows the draft to keep the motivating story while avoiding the impression that the Plucker theorem alone derives every mass mechanism.

Core P1 theorem:

```text
det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2
```

Core P1 criterion:

```text
m^2 = 0 iff all nonzero psi_i are projectively collinear
```

P1 should include the unified-mass program only as a table or outlook after the theorem and claim-boundary paragraph.

### 17.3 P1.5 theorem package

Rename the bridge paper around obstructions rather than gaps:

```text
Null-edge quadratic obstructions: finite toy theorems for Yukawa and Higgs mass mechanisms
```

The purpose is reconstruction and structural alignment, not new Standard Model dynamics.

#### Theorem A: Yukawa checkerboard / chiral null propagation

Finite-dimensional data:

```text
H_L, H_R finite-dimensional Hilbert spaces
M : H_R -> H_L
nabla_+, nabla_- commuting null finite-difference operators
M commutes with the relevant finite differences
```

Equations:

```text
i nabla_+ psi_L = M psi_R
i nabla_- psi_R = M^dagger psi_L
K_L = -nabla_- nabla_+
K_R = -nabla_+ nabla_-
```

Target conclusions:

```text
K_L psi_L = M M^dagger psi_L
K_R psi_R = M^dagger M psi_R
spec_{>0}(M M^dagger) = spec_{>0}(M^dagger M)
```

Meaning: fermion mass is reconstructed as a chirality-flip gap, including rectangular Yukawa blocks, zero modes, and rank deficiency. This theorem does not predict `M`.

#### Theorem B: Abelian Higgs gauge-invariant link stiffness

Finite graph data:

```text
G = U(1)
phi_v in C
U_e in U(1)
S_H(phi,U) = sum_e |U_e phi_{t(e)} - phi_{s(e)}|^2
```

Gauge transformation:

```text
phi_v -> g_v phi_v
U_e -> g_{s(e)} U_e g_{t(e)}^{-1}
```

Target conclusions:

```text
S_H is gauge-invariant
if phi_v = v sigma_v and sigma_v in U(1), then
S_H = v^2 sum_e |w_e - 1|^2
w_e = sigma_{s(e)}^{-1} U_e sigma_{t(e)}
```

Small-holonomy expansion:

```text
w_e = exp(i epsilon A_e)
v^2 |w_e - 1|^2 = v^2 epsilon^2 A_e^2 + O(epsilon^4)
```

Exact theorem: gauge-invariant link stiffness. Physical interpretation: a quadratic gauge-boson mass term appears after vacuum and small-holonomy expansion.

Important guardrail: this theorem is not null-specific by itself. It becomes null-edge-relevant only when the same graph is a null-tetrad graph and the scalar/gauge terms are tied to null-supported transport.

#### Theorem C: electroweak stabilizer and rank-three mass form

Split this into two stages.

Stage 1, robust structural theorem:

```text
G = SU(2)_L x U(1)_Y
H_0 = (0, v/sqrt(2))
Y(H) = 1
B_EW(X) = rho(X) H_0
q(X) = |B_EW(X)|^2
ker B_EW = u(1)_em
rank q = 3
```

Stage 2, normalization-dependent coefficient theorem:

```text
q(W,B) = v^2/8 * [g^2((W^1)^2 + (W^2)^2) + (g W^3 - g' B)^2]
m_W = g v / 2
m_Z = sqrt(g^2 + g'^2) v / 2
m_gamma = 0
```

Record the Hermitian versus anti-Hermitian Lie algebra convention explicitly before proving the coefficient theorem.

#### Theorem D: null scalar kinetic reconstruction

This is the missing theorem that prevents the Higgs edge story from looking like ordinary graph Higgs theory with null labels.

Target statement:

```text
Given a null-solder frame (ell_a, alpha^a), with inverse Gram data G^{ab},
g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b).
```

Gauge/scalar kinetic interpretation:

```text
< D H, D H >_g is reconstructed from weighted null-edge derivatives
sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>.
```

Guardrail: the positive sum `sum_a |nabla_a^A H|^2` is Euclidean/lattice-like by itself. Lorentzian scalar kinetic reconstruction needs the null quadrature and cross-term theorem.

### 17.4 P2a finite dual-soldered algebra package

Treat P2a as a finite algebra paper before making full continuum physics claims.

The theorem package should include:

- Simplex/tetrahedral null-solder frame, including the four-dimensional tetrahedral formula and the general simplex version.
- Diagonal null-symbol obstruction: the diagonal symbol cannot reconstruct the continuum Dirac symbol.
- Dual-soldered commutator theorem: `D_sol^h = sum_a c(alpha^a) (T_a - I)/h` has `[D_sol^h, M_f] -> c(df)`.
- Graded square theorem with fixed signs.
- Frame/tetrad-postulate theorem: if `[nabla_a, C_b] = 0`, then `T_frame = 0`.
- Mass-shell matching theorem for `ker(-K tensor I + I tensor M^2)`.

Normalize the super-Dirac square signs as follows:

```text
D_N = sum_a C_a nabla_a
D_N^2 = K_h + C_diamond + T_frame
D = i D_N + Gamma_s Phi_H
D^2 = -K_h - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

If a later draft wants plus signs for `C_diamond` or `T_frame` in the final square, it must define those terms with the opposite sign from their appearance in `D_N^2`. Do not mix both sign conventions.

### 17.5 P2b branch-count and scaling audit

Separate the flat-branch/doubling audit from the finite algebra theorem package.

For the flat symbol:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1)/h
```

Do not merely check whether the coefficient vector vanishes. In Lorentzian signature, a nonzero null Clifford vector can have zero determinant. The physical test is:

```text
det D_+(q) = 0
```

or the corresponding mass-shell equation.

Audit categories:

- Real branches.
- Complex branches.
- High-momentum null singularities.
- Multiplicities after Krein doubling.
- Chiral content.
- Whether unwanted branches decouple.

This is an early fatal-flaw detector and may become a valuable negative-result paper if the branch structure is constrained but not viable.

### 17.6 P3 prediction gate

Prediction should wait until P1, P1.5, P2a, and P2b have established reconstruction and scaling control.

Define:

```text
F : M_finite -> M_EFT
```

`M_finite` includes graph family, tetrad/null frame, edge weights, gauge group, representations, Higgs potential, Yukawa matrices, Majorana blocks, spectral function, cutoff, and counterterms.

`M_EFT` includes `g_1, g_2, g_3, v, lambda, Y_u, Y_d, Y_e, Y_nu, M_R, CKM angles, PMNS angles, Lambda_QCD`, and Wilson coefficients.

Prediction requires:

```text
rank(dF) < dim M_EFT
```

or a nontrivial relation:

```text
R(theta_EFT) = 0
```

Before this gate, use `representation`, `reconstruction`, or `structural theorem`, not `prediction`.

### 17.7 Nontriviality criterion for obstruction maps

The template `m^2 = B^dagger B` is meaningful only if `B` is natural or forced, not chosen after the target mass is known.

Examples:

- `B_Pl(Psi) = {psi_i wedge psi_j}_{i<j}` is canonical because it is the rank-one obstruction.
- `B_Y = M` is natural only once the Higgs/Yukawa block is given; it is not predictive unless `M` is constrained.
- `B_EW(X) = X H_0` is canonical given the gauge group, representation, and vacuum section; it is structural but not predictive unless those inputs are forced.
- `B_QCD` does not yet exist cleanly in this program. Until it does, QCD remains a conceptual bridge rather than a theorem target.

### 17.8 QCD, Higgs radial mass, and neutrino scope

QCD should remain a boundary case, not a P1.5 theorem, unless we obtain a finite confinement or color-Hamiltonian gap theorem.

Recommended wording:

> The Plucker theorem is not a derivation of the proton mass. It is the finite invariant that any null/relativistic constituent account must reproduce once a confined momentum distribution is given. QCD remains the dynamics that supplies confinement, running, Lambda_QCD, the trace anomaly, and the hadron spectrum.

Higgs radial mass fits the quadratic-obstruction umbrella as a radial Hessian or stiffness term, with conventional normalization `m_h^2 = 2 lambda v^2`, but it is vertex-potential physics rather than null-edge transport. Treat it as an appendix or boxed example.

Neutrinos should be treated as a stress test, not evidence. A seesaw block and Schur complement are useful algebraic templates, but the plan should not imply sterile neutrinos exist or choose Dirac versus Majorana without additional input.

### 17.9 Claim ledger for manuscripts

Use four labels consistently:

```text
Representation: standard data are placed on null-edge variables without reducing freedom.
Reconstruction: a theorem shows a known mechanism emerging from null-edge primitives, but inputs remain free.
Structural theorem: a qualitative feature is forced once specified algebraic inputs are assumed.
Prediction: a parameter or structure free in standard EFT is fixed or restricted.
```

Current classification:

```text
finite bundle mass equals Plucker spread: finite identity
massless iff projectively collinear: finite identity
QCD/hadron mass fits null-bundle accounting: conceptual bridge
Yukawa checkerboard mass: reconstruction theorem target
Abelian Higgs link stiffness: reconstruction theorem target
EW photon/W/Z rank split: structural theorem target given SM inputs
Higgs radial mass: scalar-potential reconstruction
neutrino seesaw block: optional algebraic appendix
observed mass values: not established
Yukawa hierarchy: not established
QCD scale: not established
generation number: not established
```

### 17.10 Highest-priority next jobs

Reordered job list:

1. Finalize P1 claim-boundary edits.
2. Prove or draft the Yukawa checkerboard theorem.
3. Prove or draft the Abelian Higgs link-stiffness theorem.
4. Prove or draft the electroweak stabilizer theorem.
5. Add the null scalar kinetic reconstruction theorem.
6. Normalize the super-Dirac square signs everywhere.
7. Start the dual-soldered operator finite core.
8. Run the flat determinant branch-count test.
9. Build the moduli ledger in parallel.

### 17.11 Stop rules and skeptical-referee answer

Clean stop rule:

```text
If the null-edge theorems do not reduce freedom, force structure, or control scaling,
the work is a null-edge reconstruction, not a new mass theory.
```

Specific stop rules:

- If the Yukawa checkerboard square has the wrong sign, the elementary-mass bridge fails.
- If the Abelian/WZ story cannot be phrased gauge-invariantly, the electroweak bridge fails.
- If scalar/gauge kinetics cannot be reconstructed from null-edge quadrature, the Higgs edge action is only ordinary graph discretization.
- If the super-Dirac square double-counts Plucker and `Phi_H^2`, the unified operator fails.
- If the flat branch-count test produces unavoidable physical doublers or complex instabilities, the Dirac operator branch needs redesign.
- If the finite-to-EFT map is full rank, there is no prediction.

Strong skeptical objection:

> This is mostly a disciplined rewriting of standard facts. Two null momenta can have invariant mass; Yukawa matrices give fermion masses; Higgs covariant derivatives give W/Z masses; QCD gives proton mass. The null-edge language is elegant, but where is the new constraint?

Best current answer:

> That is correct at the current stage. P1 and P1.5 are not advertised as numerical predictions. Their contribution is a finite theorem spine: a formal Plucker mass identity, a null L/R checkerboard square for fermion mass, gauge-invariant Higgs link stiffness, and the electroweak stabilizer mass-rank theorem, all organized so primitive spacetime transport remains null. This is reconstruction. It becomes candidate new dynamics only after the dual-soldered super-Dirac operator, continuum scaling, chirality/anomaly audit, and a moduli-codimension constraint are established.
## 18. Aristotle grand-strategy integration: canonical obstruction and proof-chain gates

Provenance: Aristotle no-build strategy job `87530423-050a-43be-80d1-1db49501ba81`, returned 2026-06-26. Full returned reports are preserved in:

- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md`
- `AgentTasks/null-edge-unified-mass-proof-chain.md`
- `AgentTasks/null-edge-unified-mass-aristotle-next-jobs.md`

### 18.1 Highest-level verdict

Aristotle endorses the current direction with one load-bearing refinement:

```text
mass as quadratic obstruction by a canonical obstruction map B
```

The word `canonical` is essential. The template `m^2 = B^dagger B` is vacuous unless `B` is geometrically or physically forced rather than chosen after the target mass is known.

Current status by obstruction map:

- `B_Pl(Psi) = {psi_i wedge psi_j}_{i<j}` is canonical as the rank-one obstruction for a finite null-spinor bundle.
- `B_Y = M` is natural once the Higgs/Yukawa block is given, but it is not predictive unless the null-edge architecture constrains `M`.
- `B_EW(X) = X H_0` is canonical given the SM electroweak group, Higgs representation, and vacuum section, but remains structural rather than predictive unless those inputs are forced.
- `B_QCD` is not yet cleanly identified in this program. QCD remains a conceptual bridge and boundary case, not a theorem target.

### 18.2 Claim-label discipline is now mandatory for manuscript architecture

Every paper in this line should carry the four-way label system:

```text
Representation: standard data are placed on null-edge variables without reducing freedom.
Reconstruction: a theorem recovers a known mechanism from null-edge primitives, with inputs still free.
Structural theorem: a qualitative feature is forced once specified algebraic inputs are assumed.
Prediction: a normally-free EFT parameter or structure is fixed or restricted.
```

This is not just a writing preference. Aristotle identifies unlabeled drift between these categories as the main execution risk. The program is strongest when it says openly:

```text
P1 and P1.5 are reconstruction/structural theorem papers, not prediction papers.
Prediction begins only at the moduli-rank/codimension gate.
```

### 18.3 P1 formal-paper posture

Aristotle recommends a strict split between the formal paper and the expository companion.

Formal P1 should use a title like:

```text
Invariant Mass from Finite Null-Spinor Bundles: A Frame-Audited Plucker Theorem
```

The more poetic `origin of mass` or `trapped, disagreeing light` language should be reserved for the expository companion.

Formal P1 should include:

- The finite Plucker determinant theorem.
- The massless iff projectively-collinear theorem.
- Frame-audited normalization, especially the distinction between invariant `det(P)` and frame-relative `det(rho_{p|u})` or `m/E`.
- The theorem-to-Lean crosswalk and trusted/draft/artifact/future status map.
- A short outlook to the unified-mass program, after the theorem and claim boundary.

Formal P1 should avoid:

- `spectral gap` in the abstract and introduction.
- Any implication that QCD confinement, electroweak symmetry breaking, Yukawa matrices, neutrino masses, or the observed mass spectrum are derived in P1.
- The claim that Plucker spread is the universal formula for all mass.

### 18.4 Proof-chain map to use as the project spine

Aristotle's proof-chain report organizes the program as T1 through T18. The actionable ordering is:

```text
P1 close-out:
T1 Plucker obstruction map / mass identity
T2 massless iff rank-one / projectively collinear
T3 celestial monopole/dipole and rest-frame closure guardrail

P1.5 finite mass mechanisms:
T5 Yukawa checkerboard square
T6 rectangular singular-value theorem
T8 Abelian Higgs link-stiffness identity
T9 electroweak stabilizer ker/rank

P1.5 appendices / bridge:
T12 Higgs radial Hessian
T10 electroweak coefficient theorem
T7 Majorana / Takagi / seesaw stress test
T4 abstract mass-shell matching theorem

P2 finite operator core:
T13 dual-soldered commutator/symbol theorem
T14 graded super-Dirac square
T15 frame/tetrad postulate and frame-term audit
T16 determinant branch-count / no-doubling audit

Later consistency and prediction:
T18 chirality / anomaly audit
T17 moduli-rank prediction ledger
```

Parallelizable first-wave finite algebra targets:

```text
T5 Yukawa checkerboard
T6 rectangular SVD / positive-spectrum equality
T8 Abelian Higgs link stiffness
T9 electroweak stabilizer
T12 Higgs radial Hessian
```

### 18.5 Hardest blockers, ranked

Aristotle ranks the blockers as follows:

1. Finite-to-continuum symbol and square limits. This is the master blocker for proving that null edges do real work beyond notation.
2. Super-Dirac grading and sign correctness. The `+Phi^2` sign depends on keeping `Gamma_s`, `chi_E`, and cochain degree separate.
3. Determinant-level no-doubling and branch count. Coefficient-zero tests are insufficient because nonzero null Clifford symbols can still have kernel.
4. Krein/Lorentzian self-adjointness versus physical stability. `J`-self-adjointness does not imply positivity, unitary evolution, real spectrum, or stability.
5. Electroweak stabilizer normalization and gauge-invariant composites. Kernel/rank is clean; coefficients and FMS composites require convention discipline.
6. Chirality and anomaly constraints. The finite construction must not force a vector-like spectrum if the goal is the chiral SM.
7. Spectral-action / moduli-rank constraints. This is the prediction gate.
8. QCD / confinement gap. Do not attempt this as a near-term theorem without an actual finite confinement or color-Hamiltonian gap statement.

### 18.6 Super-Dirac square and double-counting audit rule

Aristotle treats the sign and double-counting issue as the most dangerous internal consistency trap.

Use this convention unless explicitly replaced everywhere:

```text
D_N = sum_a C_a nabla_a
D_N^2 = K_h + C_diamond + T_frame
D = i D_N + Gamma_s Phi_H
D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]
D^2 = -K_h - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

Guardrail:

```text
The Plucker/null spread is the kinetic-symbol invariant.
Phi_H^2 is the zero-order internal mass block.
They are the two sides of one on-shell condition K_h(xi) = eigenvalue(Phi_H^2),
not two additive mass sources.
```

Any P2 statement that adds Plucker mass and `Phi_H^2` as independent mass contributions should be treated as suspect until audited.

### 18.7 Null-edge versus lattice-gauge-theory gate

Aristotle agrees that the Abelian Higgs link theorem is close to ordinary lattice gauge-Higgs theory by itself. The null-edge content only becomes substantive if the surrounding package succeeds:

- Null-supported kinetic terms.
- Dual-covector soldering `c(alpha^a)` rather than diagonal `c(ell_a^flat)`.
- Fermions, holonomies, and Higgs differences living on the same null substrate.
- A recovered continuum Dirac symbol.
- A determinant-level no-doubling test.
- A super-Dirac square with the correct kinetic, curvature, frame, and `Phi^2` terms.

Absent these, P1.5 should be described honestly as a graph discretization with null labels plus useful reconstruction theorems.

### 18.8 Referee-facing posture

The strongest skeptical objection remains:

> This is mostly a disciplined rewriting of standard facts. Two null momenta can have invariant mass; Yukawa matrices give fermion masses; Higgs covariant derivatives give W/Z masses; QCD gives proton mass. The null-edge language is elegant, but where is the new constraint?

Recommended answer:

> That is correct at the current stage. P1 and P1.5 are not advertised as numerical predictions. Their contribution is a finite theorem spine: a formal Plucker mass identity, a null L/R checkerboard square for fermion mass, gauge-invariant Higgs link stiffness, and the electroweak stabilizer mass-rank theorem, all organized so primitive spacetime transport remains null. This is reconstruction. It becomes candidate new dynamics only after the dual-soldered super-Dirac operator, continuum scaling, chirality/anomaly audit, and a moduli-codimension constraint are established.

Phrases to avoid in formal papers:

- `We explain the origin of all mass.`
- `All mass is Plucker spread.`
- `The Plucker theorem derives the proton mass.`
- `Gauge symmetry breaks`, when stated as an observable local-symmetry fact.
- `Spectral gap`, when applied to the P1 Plucker invariant.
- `Predicts` or `derives`, when the quantity is still an input.
- `Krein self-adjoint, therefore stable/unitary/real spectrum.`

Phrases to prefer:

- `mass as quadratic obstruction by a canonical B`
- `obstruction to remaining a single free gapless null ray`
- `finite kinematic core`
- `rest-frame invariant of a state`
- `QCD supplies confinement and dynamics; Plucker supplies invariant accounting`
- `covariant internal reference section`
- `reconstruction`, `representation`, `structural theorem`, `prediction`

### 18.9 Next Aristotle wave proposed by the strategy job

Aristotle proposes the following next wave:

1. Proof: Yukawa checkerboard square plus rectangular singular-value theorem.
2. Proof: electroweak stabilizer kernel and rank.
3. Proof: Abelian Higgs gauge-invariant link-stiffness identity.
4. No-build audit: super-Dirac grading/sign and `Phi_H^2` double-counting.
5. No-build audit: gauge-invariant phrasing and FMS pitfalls.
6. No-build audit: determinant-level branch-count/no-doubling protocol.
7. No-build strategy: continuum symbol and commuting-square plan.
8. Source/literature audit: prior-art and citation verification.
9. Prediction/moduli-rank job: the prediction gate ledger.
10. Proof: graded super-Dirac square, after the sign/double-counting audit.

Recommended launch order:

```text
First wave in parallel: J1, J2, J3, J5, J9, J10.
After J5: J4 super-Dirac square, then gauge/FMS audit.
Then: no-doubling protocol and continuum-symbol strategy.
```

### 18.10 Immediate integration decisions

The working plan should now treat the following as settled operating rules unless later evidence overturns them:

- The central slogan is `quadratic obstruction by a canonical B`, not universal `spectral gap`.
- P1 is a finite kinematic Plucker theorem paper, not an origin-of-all-mass paper.
- P1.5 is a reconstruction/structural theorem package, not a prediction paper.
- The super-Dirac square sign convention is `D^2 = -D_N^2 + Phi_H^2 - i Gamma_s C_a [nabla_a, Phi_H]` under the stated grading hypotheses.
- The branch-count audit must use determinant-level zeros, not only coefficient-vector zeros.
- QCD remains a boundary/motivation section until a real finite confinement or color-gap theorem exists.
- Prediction requires a moduli-rank or codimension result, not a clean representation of known SM data.
## 19. Pro response refinement: four principles and covariance discipline

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment `911d6b80-a00c-4248-8098-fe92653f6194/pasted-text.txt`. The FMS pointer in that note was checked against arXiv: `2305.01960`, Axel Maas, `The Frohlich-Morchio-Strocchi mechanism: A underestimated legacy`.

### 19.1 Use a four-principle front-door statement

This note is useful because it turns the plan into a compact principle set that can be placed near the beginning of the working plan, manuscript introductions, and Aristotle handoffs.

Principle I: null transport.

```text
All primitive spacetime propagation terms are supported on null edges.
```

Guardrail: this does not mean every internal field value is `made of light`. Higgs values can live on vertices, Yukawa maps can be local fiber maps, and gauge holonomies can live on edges. The null claim concerns spacetime transport.

Principle II: mass as canonical quadratic obstruction.

```text
A mass is the value, eigenvalue, or invariant norm of a canonical obstruction map
B : configuration space -> failure space,
with m^2 measured by B^dagger B.
```

Guardrail: the word `canonical` is essential. The map `B` must be geometrically or physically forced, not chosen after the desired mass is known.

Principle III: no double counting.

```text
K_null = Phi_H^2
```

is the operator-level on-shell relation. The Plucker term belongs to the kinetic/null-bundle side; the Higgs/Yukawa term belongs to the internal zero-order side. Do not write or imply:

```text
m_Plucker^2 + m_Higgs^2
```

as two additive explanations of the same elementary fermion mass.

Principle IV: gauge-invariant Higgs language.

```text
The Higgs field defines a covariant internal reference section.
Holonomies that fail to preserve it acquire quadratic cost.
Stabilizer directions remain gapless.
```

Avoid saying that a local gauge redundancy literally breaks as an observable fact. Use FMS-style gauge-invariant language when discussing physical W/Z excitations.

### 19.2 Central obstruction table, refined

Use this as the short table when introducing the program:

```text
Mechanism              Canonical obstruction B                  Meaning
finite null bundle     B_Pl = {psi_i wedge psi_j}_{i<j}          failure of rank-one/null collinearity
Dirac/Yukawa fermion   B_Y = M : E_R -> E_L                     chirality-flip gap between null Weyl channels
W/Z bosons             B_EW(X) = X H_0                          gauge direction moves Higgs reference section
photon                 B_EW(X) = 0                              stabilizer direction preserves H_0
Higgs boson            Hessian of V transverse to vacuum        radial stiffness of condensate
neutrino               Dirac/Majorana/seesaw block              tiny weak-sector gap or self-pairing obstruction
hadron/QCD mass        no clean finite B yet                    confined color dynamics; Plucker only accounts for given null/relativistic momenta
```

This table should be paired with claim labels. In particular, `B_Y = M` and `B_EW(X) = X H_0` are canonical only after the SM field content and vacuum data are supplied. They are reconstruction/structural statements unless the null-edge geometry forces those inputs.

### 19.3 Super-Dirac interpretation guardrail

The target operator remains:

```text
D_N(A) = sum_a C_a(x) nabla_a^A
C_a(x) = c(alpha^a(x))
D_h(A,H) = i D_N(A) + Gamma_s Phi_H
```

with target square:

```text
D_h^2 = -K_h(A) - C_diamond(A) - T_frame
        + Phi_H^2
        - i Gamma_s sum_a C_a [nabla_a^A, Phi_H]
```

Term interpretation:

```text
K_h(A): null-edge kinetic shell
C_diamond(A): curvature/Pauli diamond term
T_frame: frame/tetrad compatibility defect
Phi_H^2: fermion Higgs/Yukawa mass block
[nabla, Phi_H]: Higgs-gradient/Yukawa-variation term
```

Load-bearing separation:

```text
fermion masses live in Phi_H^2
W/Z masses live in |nabla^A H|^2
```

Do not put W/Z gauge-boson mass into the same block as the fermion Yukawa matrix. W/Z mass belongs to the Higgs covariant-derivative/link-stiffness sector, not the zero-order fermion mass block.

### 19.4 Null scalar kinetic reconstruction is essential, not optional

The Pro note independently confirms Aristotle's diagnosis: without a scalar/gauge kinetic reconstruction theorem, P1.5 risks becoming ordinary lattice gauge-Higgs theory with null labels.

The required theorem remains:

```text
g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)
```

and for Higgs/gauge-covariant derivatives:

```text
< D H, D H >_g
is reconstructed from
sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>.
```

The cross terms and Lorentzian inverse-Gram weights are not cosmetic. A simple positive sum over null-edge differences is Euclidean/graph-like; the inverse-Gram reconstruction is what makes the null substrate do mathematical work for scalar kinetics.

### 19.5 Covariance and local frame discipline

The strongest new warning in this note is covariance:

```text
A fixed null lattice is not relativistic enough.
```

The null frame and dual soldering data must be local:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature must enter through holonomy around finite null diamonds, and the continuum limit must recover the Lorentzian Dirac/Lichnerowicz structure with audited signs and normalizations.

Continue to reject the diagonal architecture:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

as the basic Dirac symbol. The active architecture is dual-soldered:

```text
sum_a c(alpha^a) nabla_{ell_a}
```

This covariance/local-frame point should be added to P2 handoffs and to any no-doubling or continuum-symbol Aristotle job. It is one of the cleanest lines between a suggestive fixed-null-lattice model and a viable relativistic finite geometry.

### 19.6 Manuscript opening sentence

Recommended protected opening for P1:

> This paper proves one exact finite mechanism: a finite bundle of null spinor momenta has invariant mass precisely to the extent that its null directions fail to remain projectively collinear. We do not derive QCD confinement, electroweak symmetry breaking, Yukawa matrices, neutrino masses, or the observed mass spectrum. Those belong to later operator and dynamics layers. The present theorem supplies the finite kinematic prototype for a broader null-edge program in which effective mass appears as a quadratic obstruction to remaining a single free gapless null mode.

This is compatible with the Aristotle claim-boundary paragraph and can be used as a shorter introduction-facing version.

### 19.7 Prediction candidates, restricted to real constraints

The note gives a useful shortlist of what would make the theory new rather than reconstructive:

- A forced Yukawa rank or texture.
- A relation among `g, g', g_s, lambda`.
- A forced Higgs representation or stabilizer.
- A finite-geometry reason for three generations.
- A forbidden Pauli or Lorentz-violating counterterm.
- A nontrivial dispersion correction.
- An anomaly-cancellation pattern forced by null-edge chirality.

Until one of these is proved, the correct claim remains:

```text
We reconstruct known mass mechanisms as finite quadratic obstructions inside a null-edge operator architecture.
```

That is a worthwhile structural result, but it is not yet a derivation of the mass spectrum.
## 20. Pro response refinement: blocker gates and canonical-obstruction definition

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment `14004817-5927-4a53-a6a7-b159e201e4df/pasted-text.txt`, responding to Aristotle's blocker list. Related source anchors verified during integration: Ackermann-Tolksdorf `arXiv:hep-th/9503153`, Chernodub `arXiv:1701.07426`, Maas `arXiv:2305.01960`, and Quigg `FERMILAB-PUB-07-002-T`.

### 20.1 Replace the flat blocker list with gates

The main improvement is to stop treating all blockers as if they belong at the same stage. The roadmap should resolve them through gates:

```text
definition gate
-> finite algebra gate
-> flat spectral/branch gate
-> continuum/prediction gate
```

Expanded operational gates:

```text
Gate A: convention freeze
Gate B: finite dual-soldered algebra
Gate C: flat branch and stability audit
Gate D: continuum square limit
Gate E: physics audits
Gate F: prediction gate
```

This ordering keeps hard continuum questions from swallowing the cheaper finite checks. It also lets us downgrade gracefully: if prediction fails but P1/P1.5/P2 finite algebra succeeds, the program remains a strong null-edge reconstruction program.

### 20.2 Blocker zero: canonical obstruction datum

Add this blocker above Aristotle's eight:

```text
0. Define canonical obstruction and enforce the claim ledger.
```

Formal working definition:

```text
Canonical obstruction datum:
A pair (S, B), where S is a finite geometric or internal structure and
B : configuration space(S) -> failure space(S)
is a functorial or natural map determined by S, not by fitted masses, such that
ker B is the massless/gapless/symmetric locus and B^dagger B gives the
quadratic obstruction away from that locus.
```

Every mass claim must state its `B` and its claim label.

Current assignments:

```text
B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}
  Status: finite identity / canonical rank-one obstruction.

B_Y = M : E_R -> E_L
  Status: reconstruction once the Yukawa block is given; predictive only if M is constrained.

B_EW(X) = X H_0
  Status: structural theorem given SM electroweak group, Higgs representation, and vacuum section.

B_Higgs = radial Hessian or d^2 V at H_0
  Status: scalar-potential reconstruction.

B_QCD
  Status: not yet available; QCD remains boundary/motivation until a finite color-gap theorem exists.
```

Claim labels remain:

```text
Plucker theorem: finite identity.
Yukawa checkerboard: reconstruction theorem unless M is constrained.
Abelian Higgs link stiffness: reconstruction theorem unless v or the representation is constrained.
Electroweak stabilizer: structural theorem given SM inputs.
QCD: motivation/boundary until finite confinement.
Super-Dirac square: finite operator reconstruction until continuum limit.
Spectral action/moduli rank: prediction gate.
```

### 20.3 Gate A: convention freeze

Deliverables:

- Glossary separating `Gamma_s`, `chi_E`, and `epsilon_form`.
- Mostly-minus metric convention.
- Definition of `K_null` as the kinetic mass-shell operator with symbol `p^2`.
- Pure algebra super-Dirac square theorem.
- Tiny sign-audit matrices showing the `+Phi^2` and `-Phi^2` cases.

Acceptance criterion:

```text
D^2 = -K - C - T + Phi^2 - Yukawa-gradient term
```

Failure criterion:

```text
The mass block sign flips, or form degree/internal grading is used to repair a spacetime chirality error.
```

Finite algebra sign theorem:

```text
D = i D_N + Gamma_s Phi
Gamma_s^2 = 1
{Gamma_s, C_a} = 0
[Gamma_s, nabla_a] = 0
[Gamma_s, Phi] = 0
[C_a, Phi] = 0

D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]
```

Crucial sign audit:

```text
(Gamma_s Phi)^2 = +Phi^2 iff [Gamma_s, Phi] = 0
(Gamma_s Phi)^2 = -Phi^2 iff {Gamma_s, Phi} = 0
```

Resolution task:

```text
superDirac_square_sign_audit
```

with four tiny test cases:

- `[Gamma_s, Phi] = 0` gives `+Phi^2`.
- `{Gamma_s, Phi} = 0` gives `-Phi^2`.
- `C_a Phi = Phi C_a` gives the intended gradient term.
- `C_a Phi != Phi C_a` produces extra terms and the theorem does not apply.

### 20.4 Gate B: finite dual-soldered algebra

The finite-to-continuum blocker should be decomposed rather than attacked as one theorem.

Finite algebra deliverables:

- Tetrahedral/simplex dual frame.
- Diagonal trace obstruction.
- Flat affine commutator symbol.
- Finite square decomposition.
- Finite tetrad-postulate theorem.
- Scalar/gauge null kinetic reconstruction.

#### Theorem B1: flat affine commutator symbol

On a flat decorated null-tetrad graph with mesh `h`:

```text
D_h = sum_a c(alpha^a) (T_a - I) / h
```

For multiplication by `f`:

```text
[D_h, M_f] psi(x)
= sum_a c(alpha^a) ((f(x + h ell_a) - f(x)) / h) T_a psi(x)
```

If `f` is affine and `T_a` is trivial, then exactly:

```text
[D_h, M_f] = c(df)
```

because:

```text
df = sum_a df(ell_a) alpha^a
```

This should be formalized before smooth asymptotics.

#### Theorem B2: smooth local symbol asymptotic

For smooth `f` under a smooth local trivialization:

```text
[D_h, M_f] = c(df) + O(h)
```

This is the first true continuum estimate and should wait until the affine finite theorem is settled.

#### Theorem B3: scalar/gauge null kinetic reconstruction

The scalar/gauge theorem is mandatory for Higgs/W/Z claims to be genuinely null-edge rather than graph-Higgs with null labels:

```text
g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)
G^{ab} = g^{-1}(alpha^a, alpha^b)
```

For a scalar or Higgs field:

```text
g^{-1}(D H, D H)
~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>
```

A positive sum over edges is not enough; the Lorentzian inverse-Gram cross terms are the point.

#### Theorem B4: finite square decomposition

Define:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
```

Prove exactly:

```text
D_N^2 = K_h + C_diamond + T_frame
```

with:

```text
K_h = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

This is finite algebra and does not yet prove the continuum limit.

#### Theorem B5: finite tetrad-postulate theorem

Target:

```text
[nabla_a, C_b] = 0 for all a,b implies T_frame = 0.
```

Acceptance for Gate B:

```text
The finite null-edge operator reconstructs Dirac and scalar symbols using null-supported transports.
```

Failure for Gate B:

```text
The construction remains graph discretization with null labels.
```

### 20.5 Gate C: flat branch and stability audit

Aristotle's determinant warning should become an explicit gate.

For the flat retarded operator:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q))
p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a
```

Coefficient-vector zero is not the physical branch test. The physical test is:

```text
det c(p(q)) = 0
```

or equivalently, in four-dimensional Dirac form:

```text
p(q)^2 = 0
```

because a nonzero null Clifford vector can have zero determinant in Lorentzian signature.

Tetrahedral warning example:

```text
u_a = exp(i q_a) - 1
p(q)^2 = h^{-2} u^T G^{-1} u
G^{-1} = -3/4 I + 1/4 J
q = (pi, pi, pi, 0)
u = (-2, -2, -2, 0)
u^T G^{-1} u = 0
```

Thus `p(q) != 0` but `p(q)^2 = 0`. This is a high-momentum null singularity candidate. It may be a doubler, cutoff artifact, or instability depending on the full operator and physical-sector projection.

Resolution tasks:

- Stop saying `retardedness avoids doublers` without qualification.
- Say `retardedness avoids coefficient-zero doublers, but determinant-level branches remain to be tested`.
- Implement a flat-periodic branch-count script for:

```text
det(i D_+(q) + Gamma_s Phi) = 0
```

Count:

- Real massless branches.
- Massive branches.
- High-momentum null branches.
- Complex-energy branches.
- Multiplicities after Krein doubling.
- Chirality on each branch.

Acceptance criterion:

- Exactly the desired continuum branch near `q = 0`.
- No extra stable low-energy or high-momentum physical branches.
- Any extra branches are gapped, projected out, nonphysical under the Krein constraint, or explicitly removed by a Wilson/Ginsparg-Wilson/domain-wall mechanism.

Failure criterion:

- Persistent high-momentum massless poles.
- Complex growing modes in the physical sector.

Source anchor: Chernodub `arXiv:1701.07426` is relevant as a non-Hermitian evasion example precisely because it also exhibits complex spectral branches. Use it as a warning, not as evidence that the present operator is safe.

### 20.6 Gate C addendum: Krein audit is necessary but not stability

Finite Krein algebra:

```text
J = J^dagger = J^{-1}
A^sharp = J A^dagger J
D_- = D_+^sharp
D_dbl = [[0, D_-], [D_+, 0]]
J_dbl = [[J, 0], [0, J]]
```

Target theorem:

```text
D_dbl is J_dbl-self-adjoint.
```

Non-claims:

- Real spectrum.
- Positivity.
- No growing modes.
- Unitary time evolution.
- Sensible spectral action.
- Anomaly safety.
- Chiral imbalance.

Minimal statement:

```text
Krein doubling repairs Lorentzian adjointness; chirality still requires an
index/domain-wall/overlap/anomaly mechanism.
```

Add a separate finite-box spectral stability audit:

- Are eigenvalues real on finite periodic boxes?
- Are nonreal eigenvalues paired and non-growing under the chosen evolution?
- Is `D_- D_+` positive or at least sectorial on the physical subspace?
- Is there a consistent projection to a Hilbert-positive observable sector?

### 20.7 Gate D: continuum square limit

Only after Gates A-C should the program attack the true master theorem.

Commuting-square target:

```text
D_h  --finite square-->  D_h^2
 |                       |
h -> 0                 h -> 0
 |                       |
D_cont --Lichnerowicz--> D_cont^2
```

The continuum target is the Lorentzian analogue of a Dirac-square/Lichnerowicz decomposition: connection Laplacian plus curvature and endomorphism terms. Ackermann-Tolksdorf `arXiv:hep-th/9503153` is a useful comparison class for generalized Lichnerowicz decomposition on Clifford modules, while the present construction remains finite and Lorentzian.

Acceptance criteria:

```text
K_h -> Lorentzian kinetic operator
C_diamond -> Clifford/gauge curvature term
T_frame -> 0 under finite tetrad postulate
```

or `T_frame` converges to a controlled spin-connection/torsion term if intentionally retained.

Failure criteria:

```text
T_frame = O(h^{-1})
wrong curvature coefficient
limiting square is not the intended Dirac/Lichnerowicz square
scalar/gauge kinetic limit is Euclidean rather than Lorentzian
```

### 20.8 Gate E: physics audits

Electroweak should be split into three results:

1. Exact rank/kernel theorem:

```text
B_EW(X) = X H_0
q(X) = |X H_0|^2
ker q = u(1)_em
rank q = 3
```

2. Normalization theorem after conventions are fixed:

```text
q(W,B) = v^2/8 [g^2((W^1)^2 + (W^2)^2) + (g W^3 - g' B)^2]
m_W = g v / 2
m_Z = sqrt(g^2 + g'^2) v / 2
m_gamma = 0
```

3. Gauge-invariant composite theorem target:

```text
O_e^a = H_s^dagger tau^a U_e H_t
```

or a corrected gauge-invariant variant, with a theorem that its vacuum/trivialization expansion has the usual W/Z field component as leading fluctuation.

FMS-style source anchor: Maas `arXiv:2305.01960` reinforces the need for gauge-invariant composite language. Quigg `FERMILAB-PUB-07-002-T` is a standard review anchor for the usual electroweak W/Z/photon mass pattern.

Chirality/anomaly should occur after branch count and before any Standard Model claim:

1. Flat branch count.
2. Choose a chirality mechanism: internal chiral representation, domain-wall/defect zero modes, overlap/Ginsparg-Wilson-like finite construction, or non-Hermitian/Krein chiral imbalance.
3. Finite anomaly audit:

```text
sum_left Weyl tr(T^a {T^b, T^c}) = 0
sum_i Y_i = 0
sum_i Y_i^3 = 0
```

with color and weak multiplicities.

4. Index/defect pilot, for example SSH/Jackiw-Rebbi or domain-wall Dirac toy model, if chirality is defect-based.

Do not claim Standard Model chirality until this audit passes.

### 20.9 Gate F: prediction gate

The moduli-rank work is not a near-term theorem. It is the prediction ledger.

```text
F : M_finite -> M_EFT
```

`M_finite` includes graph family, null-frame/tetrad data, dual-soldering normalization, edge weights, gauge group, representations, Higgs potential parameters, Yukawa matrices, Majorana/sterile blocks, spectral function, cutoff, counterterms, and finite-geometry constraints.

`M_EFT` includes `g_1, g_2, g_3, v, lambda, Y_u, Y_d, Y_e, Y_nu, M_R, CKM, PMNS, Lambda_QCD`, and Wilson coefficients.

Prediction criterion:

```text
rank(dF) < dim M_EFT
```

or a nontrivial relation:

```text
R(theta_EFT) = 0
```

Simple parameter counting is only a first screen because redundant coordinates, gauge choices, and field redefinitions can fake deficits.

Early structural prediction candidates:

- Forbidden Pauli terms.
- Restricted Yukawa rank or texture.
- Anomaly-selected representations.
- Forced Higgs representation or stabilizer.
- Spectral-action coupling relations.
- Generation number.
- Specific Lorentz-dispersion correction.

### 20.10 QCD boundary rule

Keep QCD out of P1.5 theorem claims.

Safe sentence:

```text
QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
```

Do not define `B_QCD` until there is an actual finite Hamiltonian or color-holonomy gap theorem. A valid future target would look like:

```text
H_color^finite restricted to singlets >= Delta > 0
```

under explicit finite graph and boundary assumptions.

Until then, QCD is a conceptual bridge, not a null-edge mechanism theorem.

### 20.11 Updated next-work order

Use this order for the next Aristotle and local work after the already-launched wave:

1. Write or integrate `superDirac_square_sign_audit`.
2. Write the flat determinant branch-count script.
3. Add the scalar/gauge null kinetic reconstruction theorem.
4. Prove the finite dual-soldered commutator theorem.
5. Prove the finite tetrad-postulate theorem.
6. Draft the P1.5 theorem note with Yukawa checkerboard, Abelian Higgs link stiffness, and electroweak stabilizer.
7. Create or integrate the moduli ledger.
8. Keep QCD as boundary.

### 20.12 Updated stop rules

Stop or downgrade the graph-operator branch if:

- No dual-soldered finite symbol exists.
- Null support and continuum scaling cannot coexist.
- The determinant branch count reveals unavoidable physical doublers.

Stop or downgrade `unified mass` if:

- The electroweak story cannot be phrased gauge-invariantly.
- QCD is being used as if confinement were derived.
- `Phi_H^2` double-counts Plucker mass.
- The finite-to-EFT map is full rank and no structural constraint is found.

Keep going under `finite reconstruction` if:

```text
P1, P1.5, and finite super-Dirac algebra work, but no codimension constraint appears.
```

That outcome is still valuable: it would be coherent null-edge reconstruction of known mass mechanisms, while prediction remains a later constraint problem.

## 21. Pro response refinement: integration freeze before further expansion

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`7881faf4-ad66-45f7-a25c-8aa908ea951c/pasted-text.txt`, responding to the
ambitious Aristotle job backlog.

### 21.1 Launch discipline

The next operational rule is:

```text
Integrate before expanding.
```

The currently submitted/returned Aristotle waves already stress-test the main
architecture. The highest-value next work is not another broad proof wave but an
integration freeze:

- Extract assumptions from returned proof and audit jobs.
- Normalize metric, sign, grading, kinetic, and frame conventions.
- Decide which returned statements become canonical and which remain local
  drafts.
- Prevent individually-compiling proof files from forming an inconsistent
  corpus.

Hard rule:

```text
No new broad Wave 4 proof jobs until returned assumptions are triaged.
```

### 21.2 Gate A is a hard prerequisite for finite square promotion

Gate A is no longer just a wave; it is a promotion gate.

```text
Gate A must pass before any finite square theorem is promoted.
```

Finite square work can proceed experimentally, but no trusted theorem should
depend on it until the following are settled:

- Super-Dirac square sign audit.
- Wrong-grading counterexamples.
- Convention integration audit.

Required convention:

```text
D = i D_N + Gamma_s Phi_H
D^2 = -K_null - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
[Gamma_s, Phi_H] = 0 for +Phi_H^2
```

`Phi_H` may be odd under internal grading `chi_E`, but not under spacetime
chirality `Gamma_s` in this convention.

### 21.3 Gate B ordering and `NullSolderFrame`

Use the stricter finite-core order:

```text
B1 -> B3 -> B2 -> B4
```

Meaning:

- B1: simplex/tetrahedral null-solder frame in general dimension.
- B3: explicit tetrahedral inverse-Gram calculation.
- B2: diagonal trace obstruction.
- B4: full finite square decomposition.

Add a new small prerequisite concept:

```text
B0: NullSolderFrame
```

`NullSolderFrame` should package:

- null directions `ell_a`;
- dual covectors `alpha^a`;
- Gram and inverse-Gram data;
- duality/reconstruction identity `xi = sum_a xi(ell_a) alpha^a`;
- Clifford coefficients `C_a = c(alpha^a)`.

This prevents repeated, drifting local definitions across scalar kinetic,
commutator, inverse-Gram, branch-count, and square-decomposition jobs.

Integration note:

```text
S8 scalar/gauge null kinetic reconstruction must be re-audited against B1/B3
before promotion.
```

### 21.4 Gate C as a kill switch

Branch count is a hard precondition for ambitious continuum and chirality work.

```text
Do not launch heavy D-continuum work until C1/C2 return.
```

Branch-count outputs should classify:

- coefficient-vector zeros;
- determinant zeros;
- mass-shell zeros;
- real versus complex branches;
- high-momentum branches;
- multiplicity after Krein doubling;
- whether massive `Phi_H` blocks lift or preserve unwanted branches.

Split branch-count work:

```text
C2a: implement script and output raw branch data.
C2b: interpret branches against acceptance/failure criteria.
```

Require a machine-readable table of high-symmetry branch candidates plus a
narrative classification:

- harmless cutoff artifact;
- physical doubler;
- complex instability;
- requires redesign.

Krein finite theorem and overclaim counterexample should travel together:

```text
C5 + C7
```

The theorem that the doubled operator is `J`-self-adjoint should be paired with
a counterexample showing `J`-self-adjointness does not imply real spectrum,
positivity, or physical stability.

### 21.5 Gate D, E, F scheduling refinements

Gate D:

```text
D2 estimate-framework selection before D1 smooth symbol asymptotic.
```

Most continuum jobs should wait until branch-count and finite-core risks are
clear. D2 can proceed early because it prevents later continuum proof attempts
from drowning in analytic infrastructure.

Gate E:

```text
S11 -> E1 -> E2 -> E3
```

Do not formalize an FMS composite before the FMS audit identifies the correct
gauge-invariant finite-link observable.

Gate F:

```text
F1 may rank candidate constraints.
F2 should be a parameter-audit template only.
```

Prediction language remains forbidden until a real codimension relation or rank
deficit survives redundancy and field-redefinition checks.

### 21.6 New integration-control jobs

Add the following to the Aristotle backlog:

- G0: dependency graph generator for all null-edge Aristotle jobs and
  assumptions.
- G1: trusted theorem promotion policy for `PhysicsSM/Draft/*`.
- G2: sign and normalization dashboard across returned files.
- G3: branch-count acceptance criteria before interpreting branch data.
- G4: null-edge specificity audit for every P1.5 theorem.

These are risk-reduction jobs, not small polish jobs. They are the right
immediate wave after a large set of returned Aristotle proofs/audits.

### 21.7 P1 should be made review-safe now

M1 should happen immediately:

```text
Formal P1 claim-boundary and title rewrite.
```

Additional constraint:

```text
Rewrite P1 so it does not depend on the success of P1.5 or P2.
```

P1 should be publishable as:

```text
finite kinematic theorem + formalization + carefully bounded origin-of-mass motivation
```

### 21.8 Integration invariant

Every trusted theorem must declare its:

- metric signature;
- grading conventions;
- kinetic-sign convention;
- frame/soldering normalization imports.

This invariant should be checked before moving anything from draft/handoff into
trusted namespaces or before using it as a manuscript theorem.

## 22. Furey internal-spectrum bridge and Gate H

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`ed7c2aa4-281b-4576-9f2c-b0d502052127/pasted-text.txt`, responding to
Codex's summary of the repo's Furey/anomaly work.

### 22.1 Clean division of labor

The Furey/anomaly work is useful, but not because it solves the null-edge
kinetic core. The right division is:

```text
Furey/formal anomaly work =
  internal Standard Model spectrum and anomaly gate.

Null-edge work =
  null kinetic geometry, Pluecker mass, dual soldering,
  and the super-Dirac square.
```

Do not say:

```text
Furey explains null-edge mass.
```

Use:

```text
The Furey formalization supplies a kernel-checked candidate internal fiber for
the null-edge super-Dirac operator: one Standard Model generation's chiral
charge table, anomaly cancellation, and legal Yukawa bookkeeping. The null-edge
program then asks whether its null kinetic operator and quadratic-obstruction
machinery can act on that internal fiber without sign, anomaly, or
gauge-consistency failures.
```

This is a meaningful connection because it prevents the internal `Phi_H` sector
from looking like arbitrary finite matrix storage.

### 22.2 Gate H: internal-spectrum and anomaly gate

Add a new gate to the mass-unification program:

```text
Gate H: internal-spectrum and anomaly gate.
```

Gate H sits beside the physics-audit gate. It does not displace Gates A-C,
which still control signs, finite dual soldering, branch counts, and stability.
Gate H asks whether the internal fiber coupled to the null-edge kinetic
operator is charge-correct, anomaly-safe, and compatible with legal
Higgs/Yukawa flips.

Gate H contributes directly to the current chirality/anomaly blocker. It gives a
ready-made anomaly certificate if the null-edge internal sector can be mapped to
the existing Standard Model one-generation anomaly table.

Minimal bridge theorem:

```text
NullEdgeInternalSpectrum.toChiralMultipletList =
  standardModelOneGeneration
```

Then anomaly freedom follows by reuse of the trusted anomaly package.

Stronger bridge theorem:

```text
FureyInternalSpectrum =
  NullEdgeInternalSpectrum.internalFiber
```

or, more implementation-safely:

```text
NullEdgeFureyInternalBlock.realizesOneGeneration :
  toChiralMultipletList internalBlock = standardModelOneGeneration
```

### 22.3 Suggested internal-spectrum API

Introduce a small bridge layer independent of any one Furey realization:

```text
structure NullEdgeInternalSpectrum where
  states             : Type
  toChiralMultiplets : List ChiralMultiplet
  internalGrading    : states -> Z2
  hypercharge        : states -> Rat
  weakRep            : states -> WeakRep
  colorRep           : states -> ColorRep
```

First target theorem:

```text
theorem furey_to_nullEdge_oneGeneration :
  FureyInternalSpectrum.toChiralMultiplets =
    standardModelOneGeneration
```

Inheritance theorems:

```text
theorem furey_nullEdge_anomalyFree :
  LocalAnomalyFree FureyInternalSpectrum.toChiralMultiplets

theorem furey_nullEdge_wittenFree :
  WittenSU2AnomalyFree FureyInternalSpectrum.toChiralMultiplets
```

This lets null-edge work reuse the existing anomaly theorems instead of
duplicating anomaly arithmetic.

### 22.4 Bridge to the Higgs/Yukawa block

The draft null-edge Yukawa files already check that one-generation Yukawa flips
are hypercharge-neutral after inserting the correct Higgs or conjugate-Higgs
factor, and that a toy chirality-flipping mass operator squares to a scalar
mass-square block. Gate H should turn that into an internal-block package.

Target form:

```text
Phi_H =
  sum over legal Yukawa flips of y_f Phi_f
```

where each `Phi_f` is a gauge-neutral map between the appropriate left and
right/conjugate sectors once the Higgs insertion is included.

Useful theorem package:

```text
theorem fureyNullEdgeInternalPackage :
  RealizesOneGeneration FureyInternalSpectrum
  and LocalAnomalyFree FureyInternalSpectrum.toChiralMultiplets
  and WittenSU2AnomalyFree FureyInternalSpectrum.toChiralMultiplets
  and LegalYukawaFlipSet FureyInternalSpectrum HiggsDoublet
```

Then:

```text
theorem fureyPhiHBlockPackage :
  PhiH_built_from_legal_furey_flips.isGaugeNeutral
  and PhiH_built_from_legal_furey_flips.isInternalOdd
  and PhiH_built_from_legal_furey_flips.square_is_massBlock
```

The grading rule must remain:

```text
Phi_H is odd under internal grading chi_E.
Phi_H commutes with spacetime chirality Gamma_s.
```

This keeps the sign convention

```text
D = i D_N + Gamma_s Phi_H
```

and the positive `Phi_H^2` mass block from being repaired by conflating
spacetime chirality with internal grading.

### 22.5 Claim-status ledger for Furey input

```text
Claim                                                           Status
--------------------------------------------------------------  -------------------------------
One-generation anomaly-free SM chiral table                     trusted finite theorem
Furey doublet sector matches Q_L and L_L table                  formal bridge / reconstruction
Right-handed singlet completion gives full one-generation table reconstruction unless forced
Three generations anomaly-free by replication                   finite closure theorem
Triality-labeled three copies anomaly-free                      packaging theorem, not prediction
Legal Yukawa flips are hypercharge/gauge neutral                relevant finite theorem target
Yukawa values or mass hierarchy are derived                     not established
Null-edge kinetic, symbol, square, or branch gates are solved   not addressed by Furey work
```

The right-handed singlet completion needs a specific audit. If the Furey
construction does not force the completion, then the bridge is reconstruction,
not prediction. That is acceptable, but it must be labeled.

### 22.6 Prediction-gate implications

Gate H is not automatically a G5 prediction. It becomes prediction-relevant only
if the internal construction reduces moduli.

Possible future codimension targets:

```text
Internal algebra axioms imply the SM chiral representation.
Furey/null-edge internal constraints restrict Yukawa texture or rank.
Some Yukawa entries are forced zero by internal grading or charge constraints.
```

Realistic first predictive upgrade:

```text
Only certain Yukawa blocks are allowed by the internal algebra and charge table.
```

This would be a structural codimension result, even without deriving numerical
fermion masses.

### 22.7 Paper-sequence placement

Use Furey sparingly in P1:

```text
P1: at most future-work context; the finite Pluecker theorem stands alone.
```

Use it carefully in P1.5:

```text
P1.5: legal Yukawa blocks may be formalized against an anomaly-safe internal
spectrum, but the theorem note should not require the Furey machinery.
```

Use it seriously in P2:

```text
P2: Furey may supply a principled internal fiber for the super-Dirac block
Phi_H.
```

Use it centrally only at the prediction gate if it constrains representations,
generations, or Yukawa textures.

### 22.8 Architecture guardrail

Keep the two stories connected by a tensor/product architecture:

```text
H_total =
  H_null/spin/graph tensor H_internal/Furey
```

Then:

```text
D_N acts on the graph/spacetime/spin factor.
Phi_H acts on the internal/Furey factor, with Higgs-dependent legal-sector maps.
```

This avoids mixing:

- spacetime chirality;
- internal grading;
- Furey particle/antiparticle bookkeeping;
- cochain degree;
- null-edge kinetic/soldering data.

### 22.9 Gate H jobs

Add the following jobs to the backlog:

```text
H1: NullEdgeInternalSpectrum record.
H2: Furey-to-SM one-generation bridge.
H3: anomaly inheritance theorem.
H4: legal Yukawa flip classification.
H5: Phi_H from legal flips.
H6: singlet-completion audit.
H7: triality/generation audit.
H8: prediction/codimension audit for internal-sector constraints.
```

These jobs should be treated as internal-sector support for P2/P3, not as a
replacement for the null-edge kinetic gates.

## 23. Gate C literature correction: determinant zeros, species, and counterterms

Provenance: integrated from Claude literature search results supplied
2026-06-26, plus Codex source-level spot checks of the cited arXiv records.

### 23.1 Revised Gate C object

Gate C is not a coefficient-zero test. It is a determinant/propagator-zero
classification problem.

The current flat retarded dual-soldered symbol has already shown the key
failure mode:

```text
p(q) != 0, but p(q)^2 = 0.
```

Therefore the physically meaningful object is:

```text
det(i D_+(q) + Gamma_s Phi) = 0
```

and, in the massless flat case,

```text
p(q)^2 = 0.
```

Gate C should classify every zero as one of:

```text
physical pole,
physical doubler,
kinematical propagator zero,
ghost-like singularity,
gapped taste/species partner,
projected or constrained artifact,
complex instability,
requires operator redesign.
```

The one-line correction is:

```text
No naive coefficient-vector doublers is not no-doubling.
No-doubling must be tested at the determinant/propagator-zero level.
```

### 23.2 Minimally doubled fermion comparison class

The closest literature comparison class is minimally doubled fermions, including
Boricci-Creutz-like and Karsten-Wilczek-like constructions. These are relevant
because they also trade ordinary lattice symmetries for reduced species counts,
nonstandard symmetry patterns, and counterterm obligations.

Key references to add to the Gate C source pack:

```text
Misumi 2025, arXiv:2512.22609:
  Minimal-doubling and single-Weyl fermion Hamiltonians. Use for nodal
  structure, single-Weyl targets, species-splitting masses, and
  Ginsparg-Wilson-type protection.

Golterman-Shamir 2025, arXiv:2505.20436:
  Propagator zeros as kinematical singularities and generalized no-go pressure
  for chiral spectra. Use for deciding whether branch zeros are physical.

Weber 2023, arXiv:2312.08526:
  Spin-taste structure of minimally doubled fermions, including Boricci-Creutz
  counterterm warnings. Use as a convention/counterterm hazard.

Weber 2025, arXiv:2502.16500:
  Karsten-Wilczek spin-taste and determinant-derived counterterm constraints.

Capitani-Weber-Wittig 2009, arXiv:0910.2597:
  One-loop counterterms and operator mixing for Boricci-Creutz and
  Karsten-Wilczek fermions on the hyperdiamond.
```

The null-edge flat operator should be compared to this literature before any
claim that the extra high-momentum null corners are benign or removable.

### 23.3 Counterterm and prediction warning

Minimally doubled actions often require counterterms because their symmetry
breaking permits radiative operator mixing. For the null-edge program this is a
Gate F hazard:

```text
If removing or controlling Gate C branches requires tunable counterterms, those
counterterms enter the finite-to-EFT moduli ledger.
```

This can demote a proposed prediction into reconstruction unless the
counterterms are fixed by null-edge structure, symmetry, or a natural
renormalization condition.

Add to the prediction-gate audit:

```text
counterterm-rank impact:
  list every branch-control counterterm;
  classify whether it is fixed, symmetry-forbidden, tuned, or free;
  add free/tuned counterterms to M_finite;
  recompute whether rank(dF) < dim M_EFT remains plausible.
```

### 23.4 Kähler-Dirac and form-degree anomaly lead

The Kähler-Dirac / symmetric-mass-generation literature is not a Gate C
solution, but it is a strong Gate H and chirality/anomaly lead.

Add to the source pack:

```text
Butt-Catterall-Pradhan-Toga 2021, arXiv:2101.01026:
  Anomalies and symmetric mass generation for Kähler-Dirac fermions. Use for
  form-degree Dirac structure, residual Z4 anomaly, and flavor-count
  constraints surviving discretization.

Li-Wang-You 2024, arXiv:2412.19691:
  C-R-T and internal anomaly constraints for symmetric mass generation. Use for
  minimal flavor-count and broken-reflection-symmetry comparisons.
```

Gate H question:

```text
Does the null-edge cochain/form-degree operator carry a Kähler-Dirac-like
anomaly or flavor-count constraint?
```

If yes, this could become an internal-sector codimension result. It should not
be advertised as a mass prediction until it restricts allowed representations,
Yukawa texture, rank, or generation/flavor count.

### 23.5 Krein and two-sheet references

Add these as support references, not gate solvers:

```text
Feinberg-Riser 2021, arXiv:2109.09221:
  Pseudo-Hermitian random matrix models. Use for the rule that spectra are real
  or complex-conjugate paired, with real/complex counts controlled by metric
  signature. Supports the caution that Krein self-adjointness is not stability.

Franco-Eckstein 2015, arXiv:1502.04683:
  Causality in two-sheeted Lorentzian spectral triples. Use for two-sheet
  causality and fluctuated Dirac-operator intuition, not for no-doubling.
```

### 23.6 Updated Gate C decision protocol

Gate C should now require:

```text
1. determinant/propagator-zero enumeration;
2. species/taste/nodal-structure classification;
3. energy-slice real/complex classification;
4. chirality and grading assignment at every zero;
5. Krein signature and doubled multiplicity;
6. mass-block lifting or preservation test;
7. counterterm inventory;
8. comparison against minimally doubled fermion literature;
9. one-line verdict:
   RELEASED, PENDING, FATAL-FOR-NAIVE-FLAT, or REDESIGN-REQUIRED.
```

Gate C remains unresolved until this protocol is complete.

## 24. Codex literature reconnaissance: DEC convergence, graph species, quiver spectral action

Provenance: Codex literature search on 2026-06-26. Direct Semantic Scholar use
was attempted but returned HTTP 429 in this session, so the concrete source list
below is based on arXiv/source-page confirmation rather than a completed
Semantic Scholar pass.

### 24.1 Gate D upgrade: Hodge-Dirac convergence is the right scaffold

The strongest new lead is that Gate D should not be framed as a bespoke
continuum-limit problem from scratch. There is now directly relevant
discretization literature for Hodge-Dirac and connection-Laplacian convergence.

Add these to the Gate D source pack:

```text
Dabetic-Hiptmair 2025/2026, arXiv:2507.19405:
  Convergence of Discrete Exterior Calculus for the Hodge-Dirac Operator.
  Use as the primary theorem-template for a cochain-level Hodge-Dirac
  convergence proof. It is especially relevant because the null-edge operator
  already uses cochain/form-degree data, dual structures, and square-to-Laplacian
  logic.

Zahariev 2006, arXiv:math/0609464:
  Discrete Connection Laplacians. Use for the gauge/holonomy part of Gate D:
  graph connection Laplacians converging toward continuum connection
  Laplacians.

Singer-Wu 2013, arXiv:1306.1587:
  Spectral convergence of the connection Laplacian from random samples. Use as
  a second connection-Laplacian convergence template, especially for sampling,
  boundary, and nonuniformity questions.

Boguna-Krioukov 2025, arXiv:2506.18745:
  Local d'Alembertian for causal sets. Use as a causal-set warning and
  constructive comparison. It sharpens the known risk that nonlocal causal-set
  d'Alembertians can fail basic continuum tests, while also providing a local
  alternative to compare against retarded/advanced null-edge scaling.
```

Gate D should now be split into two proof lanes:

```text
D-Hodge lane:
  translate the dual-soldered null-edge operator into a Hodge-Dirac/DEC-like
  cochain operator whenever possible;
  compare D_N^2 to the DEC Hodge Laplacian plus finite endomorphism terms;
  isolate exactly which null-edge terms are outside standard DEC/FEEC.

D-connection lane:
  treat gauge holonomy and Higgs covariant gradients through connection-Laplacian
  convergence rather than by informal graph-to-manifold analogy.
```

Acceptance for Gate D becomes more concrete:

```text
Gate D should either:
  inherit a known DEC/FEEC Hodge-Dirac convergence pattern after identifying the
  null-edge-specific perturbations;
or:
  explicitly prove why the null-edge retarded/advanced operator lies outside
  that convergence class and what replaces it.
```

### 24.2 Gate C upgrade: graph-native species classification

The Gate C literature list should add a graph-native branch-count lead:

```text
Yumoto-Misumi 2021/2022, arXiv:2112.13501:
  Lattice fermions as spectral graphs. Use for species/doubler counting as a
  spectral-graph nullity problem, especially away from regular torus lattices.
  This is a natural comparison class for the null-edge graph operator because it
  reframes species counting in graph-theoretic rather than purely momentum-space
  terms.

Basak-Chakrabarti-Kishore 2025, arXiv:2501.10336:
  Eigenspectra of minimally doubled fermions. Use for spectral-flow and
  index-theorem diagnostics in minimally doubled fermions, including the warning
  that ordinary chirality may be the wrong zero-mode diagnostic and that
  flavored or modified chirality can be essential.

Catterall 2023/2024, arXiv:2311.02487:
  Lattice regularization of reduced Kahler-Dirac fermions. Use for reduced
  Kahler-Dirac/chiral-fermion comparisons and for testing whether form-degree
  structure can help control mirrors without hiding a gauge-measure problem.
```

This strengthens the Gate C decision protocol:

```text
Do not classify branches only by solving the flat torus symbol.
Also classify the finite graph spectral matrix:
  nullity;
  topological dependence;
  boundary-condition dependence;
  chirality or flavored-chirality assignment;
  relation to determinant/propagator zeros.
```

### 24.3 Gate E and F upgrade: quiver spectral action as finite graph comparison

The closest new comparison for the finite graph plus Higgs story is:

```text
van Suijlekom et al. 2024, arXiv:2401.03705:
  Bratteli networks and spectral action on quivers. Use as a comparison model
  where quiver/graph data, spectral triples, Wilsonian lattice Yang-Mills, and a
  Higgs-like matrix field from self-loops have a smooth Yang-Mills-Higgs limit.
```

This paper should be used as a referee-facing comparison rather than as a claim
that null-edge dynamics has already been derived elsewhere:

```text
Quiver spectral action explains how finite directed graph data can reconstruct
Yang-Mills-Higgs terms.

Null-edge novelty must therefore be tested at:
  null-soldered kinetic reconstruction;
  determinant branch structure;
  Lorentzian/Krein causal support;
  prediction/counterterm-rank behavior.
```

For Gate F, quiver spectral-action parameter counting should be included in the
moduli ledger:

```text
If the null-edge finite action has the same free Dirac/Higgs/quiver moduli as a
generic finite spectral-action model, it is reconstruction, not prediction.

Any claimed prediction must survive comparison with the quiver spectral-action
parameter space.
```

### 24.4 Gate E upgrade: FMS remains the safe electroweak language

Add these FMS/electroweak source leads:

```text
Maas 2023, arXiv:2305.01960:
  Gauge-invariant perturbation theory and the FMS mechanism review. Use for the
  manuscript rule that physical electroweak states are gauge-invariant
  composites, with gauge-fixed W/Z/H fields appearing as leading terms.

Lattice weak/Higgs follow-up, arXiv:2603.12882:
  Use as a recent finite/lattice stress-test of weak-Higgs/FMS language. Treat
  it as support for finite composite-observable discipline, not as proof of the
  null-edge model.
```

This reinforces the existing convention:

```text
Do not say local gauge symmetry literally breaks.
Say the covariant internal reference section selects an orbit, stabilizer
directions remain gapless, and non-stabilizer holonomies acquire quadratic cost.
Physical W/Z/H language should be connected to gauge-invariant composites.
```

### 24.5 Gate H and super-Dirac source leads

Add these internal-sector and finite spectral-triple leads:

```text
Furey 2025, arXiv:2505.07923:
  A Superalgebra Within. Use as a current division-algebra/internal-spectrum
  comparison. It supports Gate H only: internal multiplets, gradings, and
  representation organization. It does not solve the null-edge kinetic core.

Cacic 2009, arXiv:0902.2068:
  Moduli spaces of Dirac operators for finite spectral triples. Use for the
  moduli-rank ledger and finite internal Dirac-operator parameter counting.

Bochniak-Sitarz 2018, arXiv:1804.09482:
  Finite pseudo-Riemannian spectral triples and the Standard Model. Use for
  finite indefinite/Krein-like internal spectral-triple conventions.
```

Add these generalized Dirac/super-Dirac square references:

```text
Ackermann-Tolksdorf 1995, arXiv:hep-th/9503153:
  Generalized Lichnerowicz formulas. Use as a theorem-template for
  Dirac-square equals connection-Laplacian plus curvature/endomorphism terms.

Tolksdorf 1996, arXiv:hep-th/9612149:
  Dirac-Yukawa operator and Einstein-Hilbert-Yang-Mills-Higgs action. Use for
  the high-level comparison between Higgs/Yukawa zero-order terms and the square
  of a generalized Dirac operator.
```

### 24.6 New near-term literature-derived jobs

Add these jobs to the backlog or next Aristotle source/strategy wave:

```text
D13: DEC Hodge-Dirac convergence adaptation strategy.
D14: Connection-Laplacian convergence audit for gauge holonomy.
D15: Causal-set d'Alembertian comparison and falsification probe.
C17: Spectral-graph species-count audit for the null-edge finite matrix.
C18: Modified/flavored chirality audit for Gate C zero modes.
E11: Quiver spectral-action comparison and novelty-boundary audit.
E12: FMS source pack and finite composite-observable theorem plan.
F12: Quiver/spectral-action parameter-count comparison for prediction gate.
H11: Finite spectral-triple moduli comparison for internal Dirac blocks.
D16: Generalized Lichnerowicz/super-Dirac square source pack.
```

## 25. Pro literature synthesis: gate tightening after the Codex search

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`492f4b4d-8bb9-45bc-a2d2-e0baf0513631/pasted-text.txt`, responding to the
Codex literature pass in Section 24.

### 25.1 High-level resolution

The literature pass does not close the hardest gates, but it substantially
sharpens the finite tests:

```text
DEC/Hodge-Dirac gives the continuum proof scaffold.
Golterman-Shamir makes determinant zeros a ghost/unitarity audit.
FMS makes gauge-invariant W/Z composite language mandatory.
Quiver/spectral-action work raises the novelty and prediction bar.
Furey/internal-spectrum work helps anomaly and legal-Yukawa bookkeeping,
not the null kinetic core.
```

The correct public framing remains:

```text
P1: finite Pluecker theorem.
P1.5: finite quadratic-obstruction toy mechanisms.
P2: dual-soldered finite super-Dirac algebra.
Later: prediction gate, only if codimension or a forced EFT relation survives.
```

### 25.2 Gate D split: positive DEC proxy before Lorentzian/null corrections

Gate D should be split into two layers rather than attacked as one direct
Lorentzian convergence theorem.

First prove a positive-metric proxy:

```text
Riemannian/Euclidean DEC proxy:
  decorated graph or order-complex operator;
  positive Hodge star;
  Whitney/de Rham reconstruction maps;
  mesh regularity, boundary conditions, and operator-norm estimates.
```

Then add corrections in a fixed order:

```text
1. connection/holonomy perturbation;
2. dual-soldered Clifford coefficients C_a = c(alpha^a);
3. leading commutator symbol [D_h,M_f] = c(df) + O(h);
4. Lorentzian/Krein signature audit;
5. retarded/advanced split as a non-self-adjoint perturbation.
```

This keeps the DEC/Hodge-Dirac scaffold honest: Dabetic-Hiptmair supports the
shape of a cochain convergence proof, but not a Lorentzian retarded/Krein theorem
for free.

The first continuum theorem should be modest:

```text
[D_h,M_f] = c(df) + O(h)
```

in one flat chart, with smooth `f`, fixed tetrahedral/null-solder frame, and
trivial transport. The scalar/gauge analogue should prove the inverse-Gram
quadrature identity

```text
g^{-1}(xi,eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)
```

and then the covariant Higgs-gradient reconstruction

```text
g^{-1}(D H,D H)
  ~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>.
```

This scalar/gauge null-quadrature theorem is the key bridge preventing the
Higgs/W/Z story from looking like ordinary graph Higgs theory with null labels.

### 25.3 Gate C: determinant zeros are branch singularities until classified

Gate C should now use the stronger rule:

```text
retardedness removes naive coefficient-zero sine doublers,
but determinant-level Lorentzian branches remain an open audit.
```

For the flat retarded symbol

```text
D_+(q) = sum_a C_a (exp(i q_a)-1)/h = c(p(q)),
```

the coefficient-zero equation `p(q)=0` is insufficient. In Lorentzian signature,
a nonzero null symbol gives a singular Clifford operator:

```text
p(q)^2 = 0 and p(q) != 0  implies  det c(p(q)) = 0.
```

Therefore the test is:

```text
det D_+(q) = 0,
```

or equivalently in the massless flat Clifford-symbol setting:

```text
p(q)^2 = 0.
```

The high-momentum warning point such as `q = (pi,pi,pi,0)` should be labelled
as:

```text
high-momentum determinant-zero, nonzero-symbol branch candidate.
```

Do not call it a physical doubler until the following audit is complete:

```text
1. coefficient-vector zeros p(q)=0;
2. determinant zeros p(q)^2=0;
3. nullity/kernel dimension of D_+(q);
4. dispersion after choosing an energy/momentum split;
5. Krein signature of branch eigenvectors;
6. response to gauge perturbations;
7. composite/interpolating-field enlargement test.
```

The Golterman-Shamir lesson is the decision rule:

```text
A determinant zero is not automatically fatal, but it is fatal unless
reinterpreted by a controlled physical-sector or composite-field theorem.
```

Classify every branch as one of:

```text
physical pole;
physical doubler;
kinematical zero;
ghost-like propagator zero;
Krein-negative artifact;
cutoff high-momentum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```

### 25.4 Super-Dirac square novelty boundary

Generalized Lichnerowicz and Dirac-Yukawa literature supports the shape

```text
D^2 = connection Laplacian + curvature + endomorphism/Higgs terms.
```

That shape is not the novelty. The finite null-edge novelty must be phrased as:

```text
a finite dual-soldered null-edge generalized Lichnerowicz formula.
```

The finite target is:

```text
D_N = sum_a c(alpha^a) nabla_{ell_a}
```

with primitive null directions `ell_a`, dual-soldered covectors `alpha^a`, and
primitive null-edge transports. Its square should decompose as:

```text
D_N^2 = K_null + C_diamond + T_frame
```

where

```text
K_null     = 1/4 sum_{a,b} {C_a,C_b} {nabla_a,nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a,C_b] [nabla_a,nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a,C_b] nabla_b.
```

With

```text
D = i D_N + Gamma_s Phi_H,
```

the trusted sign convention should be:

```text
D^2 =
  -K_null
  -C_diamond
  -T_frame
  + Phi_H^2
  - i Gamma_s sum_a C_a [nabla_a,Phi_H].
```

The Gate A grading hypotheses remain:

```text
Gamma_s^2 = 1
{Gamma_s,C_a} = 0
[Gamma_s,nabla_a] = 0
[Gamma_s,Phi_H] = 0
[C_a,Phi_H] = 0
```

The sign trap remains:

```text
[Gamma_s,Phi_H] = 0      gives (Gamma_s Phi_H)^2 = +Phi_H^2
{Gamma_s,Phi_H} = 0      gives (Gamma_s Phi_H)^2 = -Phi_H^2
```

Therefore `Phi_H` may be odd under internal grading `chi_E`, but not under the
same spacetime `Gamma_s` used in this convention.

### 25.5 Electroweak/FMS theorem target

The finite electroweak story should not be stated as literal local gauge-symmetry
breaking. The target is:

```text
S_H = sum_e |U_e H_{t(e)} - H_{s(e)}|^2
```

is gauge-invariant, and if `H` is a covariant vacuum/reference section, then
holonomies preserving that section have zero quadratic cost while holonomies
moving it have positive quadratic cost.

The electroweak rank theorem should be separated from coefficient normalization:

```text
B_EW(X) = X H_0
q(X)    = |X H_0|^2
ker q   = u(1)_em
rank q  = 3
```

Coefficient formulas such as `m_W = g v / 2` and
`m_Z = sqrt(g^2+g'^2) v / 2` belong in a later normalization theorem, because
they depend on generator and kinetic conventions.

A positive FMS-style finite target is a corrected gauge-invariant composite
observable, for example a variant of

```text
O_e^a = H_{s(e)}^dagger tau^a U_e H_{t(e)},
```

with a theorem that its vacuum/trivialization expansion has the usual W/Z field
as the leading fluctuation. If the composite theorem fails, keep only the
stabilizer/rank theorem.

### 25.6 Gate F parameter ledger

Quiver spectral-action and finite spectral-triple moduli make prediction harder,
not easier. A parameter ledger must count at least:

```text
graph family;
null/tetrad frame;
inverse-Gram or Hodge-star choices;
edge weights;
branch-control or Wilson-like counterterms;
gauge group;
representations;
finite Dirac/Yukawa block Phi_H;
Higgs self-loop or self-potential terms;
spectral function f;
cutoff Lambda;
allowed Pauli or irrelevant operators.
```

If these are free, the finite-to-EFT map is likely full rank and the result is
reconstruction, not prediction.

The first credible prediction should therefore be structural:

```text
forbidden operator;
restricted Yukawa rank or texture;
anomaly-selected representation;
chirality/flavor count;
generation constraint.
```

Coupling relations are plausible long-term but too sensitive to spectral-action
assumptions, thresholds, cutoff choices, and extra fields to be the first target.

### 25.7 Updated near-term order

The revised near-term theorem/audit order is:

```text
1. super-Dirac sign theorem and convention freeze;
2. flat determinant branch-count script/table;
3. tetrahedral high-momentum null-branch theorem;
4. scalar/gauge null kinetic reconstruction;
5. dual-soldered affine commutator theorem;
6. finite square decomposition;
7. Krein double self-adjointness plus the counterexample that J-self-adjointness
   does not imply real spectrum;
8. electroweak stabilizer rank theorem;
9. FMS finite link composite audit;
10. moduli ledger template.
```

Postpone:

```text
full continuum Lichnerowicz limit;
spectral-action coupling predictions;
QCD obstruction map;
generation-number claims;
numerical mass predictions.
```

The publishable near-term core should be:

```text
finite Pluecker theorem
+ dual-soldered affine symbol
+ finite square/sign theorem
+ scalar/gauge null quadrature
+ branch-count audit
+ claim/moduli ledger.
```


## 26. Pro follow-up after the literature pass: release criteria and next blockers

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`b0575fe8-3825-4615-90e4-d250135768b7/pasted-text.txt`, responding to the
Codex literature pass and the existing Gate C/D/E/F/H plan.

### 26.1 High-level update

The follow-up does not change the safe thesis. It sharpens the release criteria:

```text
null-edge reconstruction is plausible;
null-edge prediction requires branch control, continuum control, and codimension.
```

Use this roadmap correction:

```text
Gate C must pass before strong P2 physical-operator claims.
Gate D starts with a positive DEC/Hodge-Dirac proxy.
Gate E must be FMS/gauge-invariant-composite first.
Gate F/H must be treated as moduli-reduction and legality gates,
not as a slogan that spectral geometry explains masses.
```

This keeps the public claim boundary intact:

```text
P1: finite Pluecker theorem.
P1.5: finite quadratic-obstruction toy mechanisms.
P2: finite dual-soldered null-edge super-Dirac algebra.
Later: continuum and prediction only after the corresponding gates pass.
```

### 26.2 Gate C release checklist

Gate C is no longer a simple zero-count problem. A retarded operator should not
be called healthy merely because its coefficient vector has no extra zeros. For
the flat symbol

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q)),
```

distinguish:

```text
p(q) = 0              coefficient-vector zero
det D_+(q) = 0        determinant branch / propagator-pole candidate
p(q)^2 = 0            massless Clifford branch condition in the flat case
```

In Lorentzian signature, `p(q) != 0` can still be singular when `p(q)^2 = 0`.
Therefore every high-momentum branch must be classified at determinant level.

Gate C is released only after the following checklist is complete:

```text
1. determinant/nodal branch classification;
2. Gamma_f or an explicit theorem explaining why no flavored chirality exists;
3. flavored-mass or spectral-flow branch separation;
4. cutoff symmetry-breaking and counterterm audit;
5. gauge-coupled ghost / propagator-zero audit;
6. Krein signature and complex-branch audit.
```

Until then, avoid "no-doubling solved" language. The safe statement is:

```text
retardedness removes naive coefficient-vector sine doublers;
determinant-level Lorentzian branches remain an open audit.
```

Use the following singularity taxonomy:

| Object | Condition | Interpretation |
| --- | --- | --- |
| coefficient zero | `p(q) = 0` | algebraic zero of the vector symbol |
| Dirac branch / pole candidate | `det D(q) = 0` | propagator pole; possible physical branch or doubler |
| propagator zero | `det G(q) = 0` for an effective propagator `G` | possible mirror-removal artifact; ghost audit needed |
| kinematical zero | removable by enlarged interpolating fields | acceptable only with proof |
| ghost-like zero | gauge-coupled wrong-sign or anomaly pathology | fatal unless eliminated |

The Golterman-Shamir lesson should be used as a decision rule:

```text
A dangerous determinant/propagator singularity is acceptable only if a
controlled physical-sector or composite-field theorem removes it.
```

Otherwise it is a redesign trigger.

### 26.3 Flavored chirality must be derived from the actual symbol

Do not import the modified chirality of KW/BC fermions by analogy alone. The
null-edge `Gamma_f` must be derived from the actual dual-soldered symbol.

The construction target is:

```text
Gamma_f = sum_{rho in B} epsilon_rho P_rho Gamma_s P_rho
```

where `B` is the finite set of isolated determinant branches, `P_rho` are branch
projectors, and `epsilon_rho` are signs determined by the linearized symbol near
each branch.

This target is conditional. It makes sense only if the determinant-zero set is a
finite isolated branch set. If the actual symbol has extended nodal surfaces,
high-momentum null cones, or complex branch sheets, the minimally doubled
analogy is probably the wrong tool. Then the program needs a redesign, a
controlled branch-lifting mechanism, or a Wilson/overlap/domain-wall layer.

The highest-value Gate C theorem should therefore be split:

```text
1. Branch geometry:
   determine the determinant-zero / nodal structure of the actual
   dual-soldered symbol.

2. Flavored chirality:
   if the branches are finite and isolated, define Gamma_f and prove the
   branch signs.

3. Ghost/counterterm audit:
   couple weak gauge perturbations and classify zeros/branches as physical
   modes, kinematical artifacts, ghosts, or redesign triggers.
```

If the first step fails, stop the chirality job and redesign the operator.

### 26.4 Gate D0: positive Hodge-Dirac proxy

Gate D should begin with an explicit preliminary gate:

```text
D0: positive DEC/Hodge-Dirac proxy.
```

The staged continuum path is:

```text
positive DEC/Hodge-Dirac convergence
  -> connection/Clifford perturbation
  -> dual-soldered null quadrature
  -> Lorentzian/Krein audit
  -> retarded/advanced audit.
```

Do not attempt the full theorem

```text
D_h^{null,ret,Krein} -> D_Lorentz
```

in one step. The first honest continuum theorem remains the flat symbol theorem

```text
[D_h, M_f] = c(df) + O(h)
```

with smooth `f`, a flat frame, fixed dual-soldered null directions, and trivial
transport. The second continuum theorem should be scalar/gauge null quadrature:

```text
g^{-1}(xi,eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b),
```

followed by the covariant Higgs-gradient reconstruction.

The distinction to keep visible is:

```text
dual soldering reconstructs the first-order cotangent symbol;
the Hodge star / inverse Gram reconstructs scalar and form inner products.
```

Dabetic-Hiptmair supports the positive DEC/Hodge-Dirac scaffold, not the full
Lorentzian retarded/Krein theorem.

### 26.5 Lorentzian/Krein release language

Krein doubling should be described as an adjointness repair, not a stability
theorem:

```text
Krein doubling repairs Lorentzian adjointness;
it does not by itself prove physical stability.
```

The finite release criterion is:

```text
1. prove D_- := D_+^sharp and the doubled block operator are J-self-adjoint;
2. prove or exhibit that J-self-adjointness does not imply real spectrum;
3. compute finite-box spectra and branch Krein signatures;
4. identify conditions preventing complex physical branches;
5. only then discuss stability.
```

### 26.6 Gate E: FMS theorem target

FMS language should be theorem-level, not just citation-level. Begin with the
finite gauge-invariant edge functional

```text
S_H = sum_e |U_e H_{t(e)} - H_{s(e)}|^2.
```

Then prove the orbit-stiffness/rank result:

```text
holonomies preserving the Higgs reference section have zero quadratic cost;
holonomies moving the Higgs reference section acquire positive quadratic cost.
```

For electroweak algebra, separate the rank theorem from coefficient
normalization:

```text
B_EW(X) = X H_0
q(X)    = |X H_0|^2
ker q   = u(1)_em
rank q  = 3
```

Coefficient formulas such as `m_W = g v / 2` and
`m_Z = sqrt(g^2 + g'^2) v / 2` belong in a later normalization theorem.

A positive FMS-style finite target is a corrected gauge-invariant composite
observable, for example a variant of

```text
O_e^a = H_{s(e)}^dagger tau^a U_e H_{t(e)},
```

with a theorem that its vacuum/trivialization expansion has the usual W/Z field
as the leading fluctuation. Until this exists, W/Z claims should be labelled:

```text
gauge-invariant orbit-stiffness reconstruction,
not completed physical composite-spectrum theorem.
```

### 26.7 Gate F/H moduli and legality ledger

Quiver spectral-action and finite spectral-triple literature raise the novelty
bar. A finite graph/quiver reconstruction of Yang-Mills-Higgs is not enough for
prediction language unless null-edge-specific structure reduces moduli.

Every prediction or finite-to-EFT claim should count at least:

```text
graph family;
null/tetrad frame;
inverse-Gram or Hodge-star choices;
edge weights;
branch-control or Wilson-like counterterms;
gauge group;
representations;
finite Dirac/Yukawa block Phi_H;
Higgs self-loop or self-potential terms;
spectral function f;
cutoff Lambda;
allowed Pauli or irrelevant operators.
```

The first plausible prediction target is structural rather than numerical:

```text
forbidden operator;
restricted Yukawa rank or texture;
anomaly-selected representation;
forced chirality/flavor count;
generation constraint.
```

Gate H should be treated as internal legality and anomaly inheritance:

```text
H_total = H_null/spin/graph tensor H_internal
D_N acts on the null/spin/graph factor
Phi_H acts on the internal factor
```

Furey/internal-spectrum work can make `Phi_H` less arbitrary by supplying
charge, grading, anomaly, and legal-Yukawa data. It does not solve the null-edge
kinetic core or derive numerical Yukawa values by itself.

### 26.8 Demoted blocker: finite Markov-chain SLLN

Finite irreducible Markov-chain strong laws should not remain a major physics
blocker unless the process is nonstationary, nonirreducible, or has
time-dependent transition rules. Keep this as formalization/library work, not
as a null-edge mass gate.

### 26.9 Updated hard stop and downgrade rules

| Trigger | Action |
| --- | --- |
| determinant branches form unavoidable physical doublers | redesign operator or add controlled branch-lifting |
| determinant zeros become gauge-coupled ghost-like propagator singularities | fatal unless a composite-field theorem removes them |
| no viable `Gamma_f` or index/chirality mechanism exists | downgrade Standard Model chirality claim |
| DEC positive proxy fails | downgrade continuum claims to finite algebra |
| Lorentzian/Krein spectrum has unavoidable growing physical modes | redesign retarded/Krein layer |
| FMS composite cannot be made gauge-invariant | keep only stabilizer algebra, not physical W/Z composite claim |
| finite Dirac/quiver moduli absorb all EFT parameters | reconstruction, not prediction |
| no `B_QCD` theorem exists | QCD remains motivation and boundary |


## 27. Gate C spin-taste correction after targeted literature search

Provenance: Claude literature-search results supplied 2026-06-26 in attachment
`99aecf52-9edf-412e-a01a-0e30d2ed2fe2/pasted-text.txt`, followed by Codex
source checks on arXiv/web sources the same day.

### 27.1 Literature result

The new literature search sharpens Gate C in a very specific way. The blocker is
not just to count determinant branches. It is to decide whether the branch
chirality used by the C19 flavored-index theorem is:

```text
1. an ordinary chirality of the raw Clifford-symbol kernel; or
2. a spin-taste / species-projected chirality after point splitting or a
   species-splitting mass term.
```

The relevant sources point strongly toward the second interpretation.

Source pack:

```text
Durr-Weber 2021, arXiv:2108.11766:
  In two-dimensional KW/BC tests, the bare minimally doubled operators are
  topology-blind until a suitable species-splitting term is added.

Creutz 2010, arXiv:1009.3154:
  Point splitting isolates the specific modes created by one minimally doubled
  local field. This is the operational analogue of branch projectors P_a.

Kimura-Creutz-Misumi 2011, arXiv:1110.2482, and the related JHEP version
arXiv:1011.0761:
  Point splitting and flavored mass terms give Hermitian spectral-flow
  operators whose index detects the would-be zero modes and topology.

Weber 2023/2025, arXiv:2312.08526 and arXiv:2502.16500:
  Spin-taste decomposition is the first-principles machinery for assigning
  taste/chirality data in minimally doubled fermions; cutoff symmetries and
  counterterms matter.

Kishore-Basak-Chakrabarti 2025/2026, arXiv:2501.10336 and arXiv:2602.19767:
  Four-dimensional KW/BC index diagnostics use flavored mass terms and modified
  chirality operators, not naive ordinary chirality alone.

Drissi-Saidi 2011, arXiv:1103.1316:
  Hyperdiamond/4D-graphene zero modes are a direct tetrahedral cousin of the
  current setting and should be used as comparison data, not as a proof of Gate
  C.
```

### 27.2 Raw-kernel warning

At a high-momentum null branch, the flat symbol has the schematic form

```text
c(p)^2 = p^2 = 0.
```

For a nonzero null covector, `c(p)` is nilpotent. In a four-component Dirac
representation the raw kernel is expected to be two-dimensional, and ordinary
spacetime chirality is expected to be mixed on that kernel. Therefore the naive
statement

```text
branch a has ordinary chirality g5_a
```

is likely false at the raw Dirac-symbol level.

The C19 hypothesis `OperatorForcesAlignment` should be reinterpreted as a fork:

```text
Route A, bare-symbol release:
  Pker Gamma_s Pker is scalar on each raw branch kernel, with sign g5_a.
  Then the bare operator discharges OperatorForcesAlignment.

Route B, literature-favored species-split release:
  Pker Gamma_s Pker is mixed or traceless on the raw branch kernel.
  Then the bare operator is chirality-degenerate, and the aligned sign g5_a is
  meaningful only after point splitting / spin-taste decomposition / flavored
  mass / species splitting.
```

Route B is not a failure of the program. It changes the release theorem from

```text
bare retarded tetrahedral operator releases Gate C
```

to

```text
null-edge operator plus controlled species-splitting or spin-taste projection
releases Gate C.
```

That is weaker, but it is much closer to the established minimally doubled
fermion literature.

### 27.3 Decisive finite computation

The next Lean module should make the fork mechanical:

```text
PhysicsSM/Draft/NullEdgeTetrahedralCliffordSymbol.lean
```

Minimum theorem package:

```text
1. Define explicit 4 x 4 gamma matrices for the tetrahedral inverse-Gram
   Clifford relation {Gamma^a, Gamma^b} = 2 G^{-1}_{ab}.

2. Define the branch symbol
   cliff(q) = sum_a u_a(q) Gamma^a.

3. Prove nilpotency at each known three-pi branch:
   cliff(branch a)^2 = 0.

4. Prove or compute the raw branch kernel dimension.
   Expected result: finrank ker(cliff(branch a)) = 2.

5. Compute the decisive chirality compression:
   Pker Gamma_s Pker.
```

Interpretation:

```text
If Pker Gamma_s Pker = g5_a Pker:
  Route A holds and C19's OperatorForcesAlignment may be discharged.

If Pker Gamma_s Pker has eigenvalues +1 and -1 or trace zero:
  Route B holds; the bare operator does not force the C19 signs, and the next
  theorem must add species splitting / point splitting / spin-taste projectors.
```

### 27.4 Updated Gate C release statement

Gate C should now be stated as:

```text
Gate C is released only after either:

A. the actual bare tetrahedral Clifford symbol forces the aligned branch signs;

or

B. a controlled point-split / spin-taste / species-splitting operator forces the
   aligned branch signs, with every added counterterm or lifting term recorded
   in the prediction/moduli ledger.
```

Do not treat Route B as an afterthought. The literature makes it the more likely
outcome for the bare operator.

### 27.5 New Pro question cluster

Questions to send to a frontier model or Pro if the Lean computation confirms
Route B:

```text
1. What is the minimal species-splitting term for the tetrahedral null-edge
   symbol that isolates the four high-momentum branches without spoiling the
   low-energy physical branch?

2. Is the correct analogue KW-like, BC-like, hyperdiamond-like, or genuinely new
   because the null-edge symbol is Lorentzian/dual-soldered?

3. Can the point-splitting projectors be defined directly from the branch
   corners, or must they be derived from a taste symmetry of the full lattice
   action?

4. Does the species-splitting term count as an allowed counterterm, a Wilson-like
   lifting, a physical internal structure, or a new free parameter in the
   prediction ledger?

5. After species splitting, what is the right modified chirality operator:
   Gamma_s times a taste involution, spectral-flow sign, or projector-weighted
   branch sum?
```


## 28. Gate C release theorem v2 after Pro spin-taste response

Provenance: ChatGPT Pro response supplied 2026-06-26 in attachment
`eb7adca4-b47f-4874-9135-8aa1fa43f553/pasted-text.txt`, responding to the
Gate C Route A/Route B prompt.

### 28.1 Route B is now the default expectation

Treat Route A as possible but unlikely for a full four-component Dirac slash.
For a chiral block form

```text
c(p) = [[0, p.sigma],
        [p.barsigma, 0]],
Gamma_s = [[-I, 0],
           [ 0, I]]
```

up to convention. If

```text
p^2 = 0 and p != 0,
```

then each Weyl block is generically rank one. Therefore

```text
ker c(p) = ker(p.barsigma) direct_sum ker(p.sigma)
```

is expected to be two-dimensional, with one left and one right Weyl solution.
Thus the raw compression

```text
Pker Gamma_s Pker
```

should normally have eigenvalues `+1` and `-1`, not be a scalar multiple of
`Pker`.

If Aristotle proves

```text
Pker Gamma_s Pker = g5_a Pker
```

for a nonzero null branch in the full four-component symbol, audit whether the
"kernel" is actually a projected Weyl/taste/Krein subspace, whether an energy
projection was already applied, or whether the gamma-symbol convention differs
from the usual four-component Clifford slash.

Safe wording if the expected mixed result occurs:

```text
The raw Dirac-spin kernel is chiral-paired and has no scalar ordinary chirality.
A branch/taste sign can still be assigned after point-split projection,
spin-taste decomposition, or flavored-mass splitting.
```

Unsafe wording:

```text
Branch a has ordinary chirality g5_a.
```

### 28.2 Minimum Gate C fork computation

The fastest Route A/Route B computation remains:

```text
Pker Gamma_s Pker.
```

But the real minimum for a Gate C decision is:

```text
Pker Gamma_s Pker
+
local nodal dimension of det D_+(q) = 0 near each high-momentum branch.
```

The extra nodal-dimension test is essential because the scalar condition

```text
det c(p(q)) = 0,
```

or equivalently `p(q)^2 = 0` in the massless flat Clifford case, may define an
extended curve or sheet rather than isolated branch points. A minimally doubled
or flavored-chirality picture only applies cleanly if the high-momentum zeros
are finite isolated branches, or if a later projection/splitting reduces them to
such a branch set.

Ask the finite Clifford-symbol module to compute, for each branch candidate:

```text
rank c(p_a);
dim ker c(p_a);
dim(ker c(p_a) cap H_+);
dim(ker c(p_a) cap H_-);
trace(Pker Gamma_s Pker);
spectrum(Pker Gamma_s Pker), or a finite equivalent;
local dimension of {q : p(q)^2 = 0} near q_a.
```

Expected outcomes:

```text
Route A:
  Pker Gamma_s Pker = g5_a Pker.
  This discharges the C19 chirality-alignment hypothesis for the bare symbol,
  but does not by itself release all of Gate C.

Route B:
  Pker Gamma_s Pker is mixed or traceless.
  The bare symbol fails raw ordinary chirality, and the correct branch sign must
  be point-split / taste / flavored-mass chirality.
```

### 28.3 Point-split projector model

If the four high branches are indexed by

```text
q^(a)_a = 0,
q^(a)_b = pi for b != a,
```

then a free-field momentum-space point-split projector candidate is

```text
P_a(q) = ((1 + cos q_a) / 2)
         * product_{b != a} ((1 - cos q_b) / 2).
```

It satisfies

```text
P_a(q^(b)) = delta_ab,
P_a(0,0,0,0) = 0.
```

This is a projector model, not a physical release theorem. In position space it
is a finite Laurent polynomial in shifts. It is local in the finite-range sense,
but because it uses cosines it naturally involves forward and backward shifts.
A strictly retarded analogue would be non-Hermitian and requires a separate
Krein audit.

Given modeled taste signs

```text
s = (+,+,-,-),
```

define on the high-branch subspace:

```text
tau(q) = sum_a s_a P_a(q),
Gamma_f(q) = Gamma_s tau(q).
```

This reproduces the modeled flavored-index pattern:

```text
sum_a s_a = 0,
sum_a s_a^2 = 4.
```

To become a Gate C release theorem, the projectors must be made gauge-covariant
or replaced by link-dressed position-space analogues, and the resulting
spin-taste/counterterm behavior must be audited.

### 28.4 Species-splitting classification

If Route B holds, the splitting or flavored-mass term should be introduced
abstractly as

```text
M_split(q) = r tau(q)
```

or, for lifting selected branches,

```text
M_lift(q) = r sum_a m_a P_a(q).
```

For index diagnostics, pair flavored mass and modified chirality rather than
choosing them independently. A schematic target is a Hermitian or Krein-Hermitian
spectral-flow operator such as

```text
H(m) = Gamma_f (D_split - m),
```

with the precise adjointness convention determined by the retarded/advanced
Krein setup.

Classification table:

| Splitting behavior | Classification |
| --- | --- |
| fixed by tetrahedral symmetry, gauge covariance, locality, null support, and minimality | benign branch-control counterterm |
| required but tunable | new finite modulus; weakens prediction claims |
| uses finite polynomials in null-edge shifts only | preserves primitive-null transport but may represent composite multi-hop paths |
| requires direct non-null edges | violates primitive-null architecture unless reinterpreted or redesigned |
| uses backward shifts | violates strict retardedness unless confined to the Krein spectral double |
| creates ghost/propagator-zero pathology after gauge coupling | fatal unless a composite-field theorem removes it |

Route B preserves the core null-edge claim only if:

```text
1. the splitting is finite-range in null-edge shifts;
2. advanced/backward shifts, if used, live in the spectral/Krein double rather
   than the causal update block;
3. coefficients are canonical or counted as new moduli.
```

### 28.5 Gate C release theorem v2

Let `D_+(q)` be the flat tetrahedral null-edge symbol on the Brillouin torus, and
let `D_phys` be either the bare operator or a specified point-split/species-split
modification. Gate C releases for `D_phys` only if all the following are
controlled.

Bare symbol facts:

```text
There is a finite branch set B = {b_1,...,b_N}.
The determinant-zero set near the physical/cutoff region consists only of
controlled branch neighborhoods U_a, with no unclassified sheets, curves, or
complex-growth branches.
At each branch, dim ker D_+(b_a) and Pker Gamma_s Pker are explicitly computed.
If the compression is not scalar, ordinary branch chirality is declared absent
at the raw level.
```

Branch projector facts:

```text
There are finite-range, gauge-covariant branch projectors P_a(q), or
link-dressed position-space analogues, with
P_a P_b = delta_ab P_a,
sum_a P_a = Pi_B
on the branch subspace.
```

Spin-taste / flavored chirality facts:

```text
tau = sum_a s_a P_a,
s_a in {+1,-1},
Gamma_f = Gamma_s tau,
Gamma_f^2 = Pi_B
on the branch subspace.
```

A flavored mass or spectral-flow operator must detect the desired branch index,
and unwanted branches must be separated, lifted, or physically interpreted.

Krein/stability facts:

```text
The retarded/advanced double is J-self-adjoint.
Branch modes have acceptable Krein signatures.
There are no unpaired complex physical eigenvalue branches or growing modes in
the physical sector.
```

Gauge/ghost facts:

```text
Weak gauge coupling does not turn determinant branches or propagator zeros into
ghost-like mirror artifacts. If propagator zeros appear, they are proven
kinematical by an explicit enlarged elementary-plus-composite interpolating
field basis.
```

Counterterm/moduli facts:

```text
All branch-control terms are either fixed by tetrahedral symmetry, gauge
covariance, null-edge locality, and minimality, or recorded as free moduli in
the prediction ledger.
```

Conclusion:

```text
If D_phys = D_+, the bare operator releases Gate C.
If D_phys != D_+, Gate C releases only for the modified operator, and the bare
operator is recorded as failing raw branch chirality.
```

### 28.6 Publication-safe claims

Route A claim:

```text
For the explicit flat tetrahedral symbol, the high-momentum branch kernels carry
the modeled aligned ordinary chirality signs. This discharges the finite
chirality-alignment hypothesis used in the conditional Gate C theorem. The
remaining Gate C audits are determinant-zero completeness, Krein stability, and
gauge-coupled ghost/counterterm behavior.
```

Route B claim:

```text
The bare tetrahedral Clifford symbol has determinant-level high-momentum
branches whose raw Dirac kernels are chiral-paired. Therefore the modeled signs
(+,+,-,-) cannot be interpreted as ordinary spacetime chiralities of the raw
branch kernels. They must be interpreted, if at all, as flavored/taste signs
defined by point-split branch projectors or a species-splitting mass term.
```

This is a publishable branch-audit result and should not be framed as a failure.
It is the honest upgrade from modeled branch signs to the correct mathematical
object carrying branch chirality.


## 29. Gate C Route B hand-proof package: nilpotent null slash and nodal-line audit - 2026-06-26

Provenance: ChatGPT Pro response supplied in attachment
`5e70b9a3-b369-4973-80bc-a41be4c54d7c/pasted-text.txt`. This section sharpens
Sections 27-28 into a concrete hand-proof package for the next Lean/Aristotle
work.

### 29.1 Bottom-line update

Treat Route B as the default expectation unless the explicit Lean computation
surprises us.

For the actual four-component flat tetrahedral Clifford symbol, each high
three-pi branch is expected to be a nonzero null Dirac slash. Such a slash is
nilpotent of rank two, with a two-dimensional kernel containing one left Weyl
line and one right Weyl line. Therefore the raw compression

```text
Pker Gamma_s Pker
```

should be mixed/traceless, not a scalar sign `g5_a Pker`.

Expected fork:

```text
Bare OperatorForcesAlignment is false for the four-component symbol.

The signs g5 = (+,+,-,-) are taste/species signs obtained only after
point-splitting, spin-taste decomposition, species splitting, or a flavored
chirality operator Gamma_f = Gamma_s T.
```

This is not a failure of the program. It is a more accurate Gate C target: the
bare operator supplies determinant branches, while a controlled Route B
construction supplies the branch-resolved taste/chirality diagnostic.

### 29.2 Exact branch covector identity

Use mostly-minus signature and tetrahedral spatial unit vectors

```text
n1 = ( 1,  1,  1) / sqrt(3)
n2 = ( 1, -1, -1) / sqrt(3)
n3 = (-1,  1, -1) / sqrt(3)
n4 = (-1, -1,  1) / sqrt(3)
```

with future null directions

```text
ell_a = (1, n_a).
```

The dual-soldering covectors `alpha^a` satisfy

```text
alpha^a(ell_b) = delta_ab,
sum_a alpha^a = dt,
G^{aa} = -1/2,
G^{ab} = 1/4 for a != b.
```

For a flat periodic mode, set

```text
u_a(q) = exp(i q_a) - 1,
D_+(q) = sum_a u_a(q) C_a = c(p(q)),
p(q) = sum_a u_a(q) alpha^a.
```

Then

```text
p(q)^2 = -3/4 sum_a u_a(q)^2 + 1/4 (sum_a u_a(q))^2.
```

The determinant condition for the four-component slash is

```text
det D_+(q) = 0 iff p(q)^2 = 0,
```

not `p(q) = 0`.

At the high branch

```text
q^(a)_a = 0,
q^(a)_b = pi for b != a,
```

we have

```text
u_a(q^(a)) = 0,
u_b(q^(a)) = -2 for b != a.
```

Therefore

```text
p(q^(a)) = -2 sum_{b != a} alpha^b
          = -3/2 ell_a^flat.
```

So the high-branch symbol is a nonzero null slash:

```text
D_+(q^(a)) = c(-3/2 ell_a^flat),
D_+(q^(a))^2 = 0,
D_+(q^(a)) != 0.
```

This is the first Lean target because it converts the scalar branch result into
an operator-level branch statement.

### 29.3 Exact nodal curve through each high branch

The high three-pi branch is not merely an isolated formal corner. For each
branch `a`, define the line

```text
q_a = 0,
q_b = pi + t for b != a.
```

Along this line,

```text
u_a = 0,
u_b = -exp(i t) - 1 for b != a,
p(q) = s(t) sum_{b != a} alpha^b
     = (3/4) s(t) ell_a^flat,
```

with `s(t) = -exp(i t) - 1`. Hence

```text
p(q)^2 = 0
```

for all `t`. At `t = 0` this is the high branch; at `t = pi` it reaches the
origin.

Gate C must therefore classify the determinant-zero nodal set before treating
the high branches as isolated species. If this exact nodal curve survives in the
full operator, then minimally doubled branch-count language is incomplete until
a branch-control or species-splitting term is introduced.

### 29.4 Kernel and ordinary chirality of a nonzero null slash

For a nonzero null covector `p`, the four-component Weyl/chiral gamma block form
gives

```text
c(p) = [ 0    A(p) ]
       [ B(p) 0    ],

A(p) = p_0 I + p_i sigma_i,
B(p) = p_0 I - p_i sigma_i.
```

At a high branch, `p = s ell_a^flat = s (1, -n_a)` with `s != 0`, so

```text
A(p) = s (I - n_a.sigma),
B(p) = s (I + n_a.sigma).
```

Since `n_a.sigma` has eigenvalues `+1` and `-1`, both `A(p)` and `B(p)` have
rank one. Thus

```text
rank c(p) = 2,
dim ker c(p) = 2.
```

Moreover the kernel splits as one Weyl line of each ordinary chirality:

```text
dim(ker c(p) cap H_+) = 1,
dim(ker c(p) cap H_-) = 1.
```

Consequently

```text
trace(Pker Gamma_s Pker) = 0,
Pker Gamma_s Pker has eigenvalues +1 and -1 on the two kernel lines,
Pker Gamma_s Pker != +Pker,
Pker Gamma_s Pker != -Pker.
```

This is the core Route B hand proof. If the Lean representation is the usual
four-component Clifford slash, this proves that raw ordinary branch chirality is
not scalar and that bare `OperatorForcesAlignment` should fail.

### 29.5 Point-split taste operators

For the four high branches, a momentum-space point-split projector candidate is

```text
P_a(q) = ((1 + cos q_a) / 2)
         * product_{b != a} ((1 - cos q_b) / 2).
```

It satisfies

```text
P_a(q^(b)) = delta_ab,
P_a(0,0,0,0) = 0.
```

Given taste signs

```text
s = (+,+,-,-),
```

define

```text
T(q) = sum_a s_a P_a(q),
Gamma_f = Gamma_s T.
```

A lower-range taste function with the same branch values is

```text
T_lin(q) = 1/2 (cos q_1 + cos q_2 - cos q_3 - cos q_4).
```

More generally, if `sum_a s_a = 0`, then

```text
T_lin(q) = 1/2 sum_a s_a cos q_a
```

satisfies

```text
T_lin(q^(a)) = s_a.
```

On the exact nodal curve for branch `a`,

```text
q_a = 0,
q_b = pi + t for b != a,
```

the Pro analysis gives

```text
T_lin(q) = s_a (1 + cos t) / 2.
```

Thus a species-splitting term

```text
M_split(q) = r T_lin(q)
```

can potentially gap the high-momentum nodal line while leaving the origin
unlifted. This is a promising Route B mechanism, but it is a branch-control term,
not a prediction unless its coefficient and sign partition are forced.

### 29.6 Cost ledger for Route B

Route B preserves the primitive null-edge architecture only in the following
sense:

```text
primitive transport generators remain null-edge shifts;
species-splitting may use finite composites of those shifts.
```

The cosine terms use both forward and backward shifts. They are acceptable in
the retarded/advanced Krein spectral double only if the advanced terms are kept
out of the strictly retarded causal update block.

Route B costs to record:

| Feature | Consequence |
| --- | --- |
| cosine point splitting | finite-range but uses forward and backward shifts |
| backward shifts | require Krein/spectral-double placement, not strict retarded update |
| sign pattern `(+,+,-,-)` | breaks full tetrahedral symmetry unless selected by internal/taste structure |
| coefficient `r` | new modulus unless fixed |
| branch lifting | Wilson-like or flavored-mass branch-control term |
| gauge coupling | requires ghost/propagator-zero audit |
| counterterms | must enter the moduli ledger before prediction language |

### 29.7 Revised Gate C publication verdict

Do not claim that the bare operator forces the aligned signs unless Lean proves a
nonstandard surprise.

Publication-safe Route B wording:

```text
The bare tetrahedral null-edge Clifford symbol has determinant-level
high-momentum null branches. At each such branch the raw four-component Dirac
kernel is chiral-paired, so ordinary spacetime chirality does not assign the
modeled signs (+,+,-,-). Those signs are instead interpreted as taste/species
signs defined by a point-split projector, spin-taste decomposition, species
splitting, or flavored chirality operator.
```

Then Gate C can release only for a specified physical branch operator
`D_phys`, not automatically for the bare `D_+`, after:

```text
1. determinant/nodal-set classification;
2. branch projectors or point-split filters;
3. flavored chirality or spectral-flow diagnostic;
4. species-splitting/counterterm ledger;
5. Krein signature and stability audit;
6. gauge-coupled ghost/propagator-zero audit.
```

### 29.8 Next Lean theorem targets

Ask Aristotle or Lean work to prove these in order:

```text
p_threePiBranch_eq_nullCovector:
  p(q^(a)) = -3/2 ell_a^flat.

pSq_threePiBranch_eq_zero:
  p(q^(a))^2 = 0.

pCoeff_threePiBranch_ne_zero:
  p(q^(a)) != 0.

branchLine_pSq_eq_zero:
  p(q_a = 0, q_b = pi + t)^2 = 0.

slash_nonzero_null_rank_eq_two:
  rank c(p) = 2 for p nonzero null.

slash_nonzero_null_ker_dim_eq_two:
  dim ker c(p) = 2 for p nonzero null.

slash_nonzero_null_chiral_kernel_dims_eq_one_one:
  the kernel contains one plus-chiral and one minus-chiral line.

branch_gammaS_compression_trace_zero:
  trace(Pker Gamma_s Pker) = 0 on each high branch.

branch_gammaS_compression_not_scalar:
  Pker Gamma_s Pker is not +/- Pker on the raw branch kernel.

not_operatorForcesAlignment_bare:
  the bare four-component symbol does not satisfy the C19 alignment hypothesis.
```

Then launch the Route B module:

```text
highBranchProjector_at_branch:
  P_a(q^(b)) = delta_ab.

tasteLin_g5_at_branch:
  T_lin(q^(a)) = g5_a.

speciesSplit_lifts_branchLine_except_origin:
  M_split = r T_lin gaps the high nodal curve except where it reaches the
  origin, under the chosen branch model.
```

The fastest fork decision remains `Pker Gamma_s Pker`. The fastest honest Gate C
decision is `Pker Gamma_s Pker` plus the determinant-zero nodal-set
classification.


## 30. Gate C Route B literature addendum: spectral graphs, flavored QCD, and ghost zeros - 2026-06-26

Provenance: Claude literature review supplied in chat on 2026-06-26, mapping the
Gate C / Route B analysis against the null-edge literature collection.

### 30.1 Collection status

The collection already contains most of the literature needed for the Route B
turn:

| Route B role | In-collection lead |
| --- | --- |
| point splitting | Creutz, `1009.3154`, minimal doubling and point splitting |
| bare topology-blindness | Durr-Weber, `2108.11766`; Kimura-Creutz-Misumi, `1110.2482` and `1011.0761` |
| spin-taste / flavored chirality | Weber, `2502.16500` and `2312.08526` |
| single-Weyl and extra-node warning | Misumi et al., `2512.22609` |
| hyperdiamond geometry | `1103.1316`; `0907.3774` |
| eigenspectrum and branch structure | `2501.10336`; `1706.07104`; `1006.2009`; `0910.2597` |
| nodal-set classification method | Yumoto-Misumi, `2112.13501` |

The most important overlooked in-collection tool is Yumoto-Misumi `2112.13501`,
which treats lattice fermions as spectral graphs and uses DFT-style methods to
count zero-eigenvalue loci on arbitrary lattices and topologies. This is directly
relevant to the new Gate C question:

```text
Are the determinant zeros isolated branch points, exact nodal lines, or higher
dimensional nodal sheets?
```

This should be used as a proof-strategy source for the local nodal-dimension
work, not merely as background literature.

### 30.2 Two genuine literature gaps to add

Two cited papers are not yet in the collection and should be added to Zotero and
Neo4j before the next serious Gate C writeup:

```text
2311.12790
Golterman-Shamir, Propagator Zeros and Lattice Chiral Gauge Theories.

1611.08388
Weber, QCD with Flavored Minimally Doubled Fermions.
```

Golterman-Shamir `2311.12790` is the source for the ghost-zero warning. Claude's
review reports that propagator zeros can behave as coupled ghost states after
gauge fields are turned on, including wrong-sign beta-function effects and
unitarity trouble despite anomaly-like behavior. Gate C must therefore include a
gauge-coupled ghost audit; flavored signs alone cannot release the gate.

Weber `1611.08388` may materially improve the Route B cost ledger. The paper
introduces a non-singlet flavored mass term for Karsten-Wilczek fermions,
identifies the finite-lattice-spacing flavor representation, and argues that
taste-breaking can be avoided without fine-tuning by a C/reflection-symmetry
argument on the quark determinant.

This is potentially important for our species-splitting term:

```text
M_split = r T
```

or

```text
M_split = r T_lin.
```

If an analogous symmetry argument fixes the splitting structure, coefficient, or
2+2 partition, then Route B is not merely adding a free modulus. It could become
a symmetry-forced branch-control structure. If no such argument adapts, the
splitting term remains a new modulus and prediction language stays off.

### 30.3 Actionable Route B update

The literature now supports the following division of labor:

```text
Bare symbol:
  prove determinant branches, nodal geometry, and chiral-paired raw kernels.

Point-split / spin-taste layer:
  define branch projectors and taste signs.

Species-splitting layer:
  lift or classify unwanted branches and nodal lines.

Gauge/Krein layer:
  rule out ghost zeros and unstable Krein sectors.

Moduli/prediction layer:
  decide whether splitting/counterterm data are symmetry-forced or tunable.
```

The next Lean and Aristotle work should not try to prove bare
`OperatorForcesAlignment` unless the actual Clifford calculation unexpectedly
forces it. The honest target is:

```text
not_operatorForcesAlignment_bare
  plus
Route B point-split / taste / species-splitting lemmas.
```

### 30.4 Revised Gate C release language

Gate C release now requires two independent successes:

```text
1. Mathematical branch control:
   determinant-zero set classified, raw kernels computed, point-split or
   spin-taste branch operators defined.

2. Physical branch safety:
   species-splitting terms are either symmetry-forced or counted as moduli, and
   gauge-coupled zeros are proven not to become ghost-like mirror artifacts.
```

If Weber `1611.08388` supplies an adaptable no-fine-tuning argument, Route B can
be promoted from "controlled reconstruction" toward "symmetry-forced branch
control." If Golterman-Shamir-style ghost behavior cannot be excluded, Gate C
does not release even if the flavored index computes correctly.

### 30.5 Immediate documentation and ingestion tasks

```text
1. Add Golterman-Shamir 2311.12790 to Zotero/Neo4j with tags:
   gate-c, ghost-zero, chiral-gauge, propagator-zero, smg.

2. Add Weber 1611.08388 to Zotero/Neo4j with tags:
   gate-c, route-b, species-splitting, flavored-mass, no-fine-tuning,
   minimally-doubled.

3. Attach Yumoto-Misumi 2112.13501 explicitly to the nodal-set classification
   jobs as the spectral-graph/DFT method source.

4. Attach Weber 1611.08388 to species-splitting jobs before deciding whether
   `r` and the 2+2 taste partition are free moduli.

5. Attach Golterman-Shamir 2311.12790 to every Gate C release theorem and
   require an explicit gauge-coupled ghost-zero clause.
```


## 31. Post-C21 Gate C theorem architecture after Gemini review - 2026-06-26

Provenance: Gemini Deep Research report supplied in attachment
`dd68f951-5bd4-4377-bb31-12b20bda5a05/pasted-text.txt`, filtered against the
kernel-checked C21 and C22 results reported by Claude.

### 31.1 What to keep from Gemini

Gemini's report is most useful as a theorem-architecture memo, not as a gate
closure. The durable pieces are:

```text
1. Bare Route A is no longer the right target after C21.
2. Gate C now needs an explicit projected/taste/flavored physical branch sector.
3. Ghost-zero safety is a hard release condition, not a follow-up polish task.
4. Krein positivity must be proved for the surviving projected sector, not
   inferred from chirality or J-self-adjointness.
5. Species-splitting and point-splitting terms must be classified as
   symmetry-forced, constrained, tunable, or fatal.
```

The pieces not to import as claims:

```text
1. Do not assert that a stable C-symmetry exists for our operator.
2. Do not assert that C-symmetry automatically gives Krein positivity.
3. Do not assert the spectral-graph/Betti-number interpretation applies until
   the tetrahedral determinant-zero locus is actually matched to that framework.
4. Do not state a broad existence theorem for ghost-safe branch projectors
   without constructing the projectors and checking the ghost/Krein clauses.
```

### 31.2 Post-C21 target: alignment after projection

C21 refutes bare single-sign assignment for the actual four-component symbol:

```text
no_full_symbol_single_chirality :
  not exists epsilon, BareOperatorAssignsSingleSign epsilon.
```

Therefore replace the old bare alignment target with:

```text
OperatorForcesAlignmentAfterProjection.
```

This should mean that a specified physical-sector projector, taste projector, or
species-splitting construction cuts each two-dimensional bare branch kernel to a
controlled one-dimensional survivor with the desired chirality/taste sign.

The target should be decomposed into independent predicates:

```text
NodalSetControlled:
  determinant zeros are classified, including exact high-branch nodal curves.

BranchProjectorsControlled:
  branch projectors or filters isolate the intended branch sectors and have a
  finite-range, gauge-covariant or link-dressed realization.

ProjectedKernelOneDim:
  the projected branch kernel is one-dimensional.

ProjectedChiralityAligned:
  Gamma_s, or Gamma_f = Gamma_s T where appropriate, has sign g5_a on the
  projected survivor.

ProjectedKreinPositive:
  the surviving physical branch sector has positive Krein norm or belongs to a
  separately justified positive physical quotient/subspace.

GhostZeroSafe:
  gauge coupling does not turn lifted branches or propagator zeros into
  Golterman-Shamir ghost-like states.

SpeciesSplittingAudited:
  splitting coefficients, sign partitions, and counterterms are either forced
  by symmetry/locality/gauge covariance/null support or recorded as moduli.
```

Only the conjunction should count as a Gate C release theorem.

### 31.3 Theorem template

Publication-safe Route B theorem schema:

```text
Given the actual tetrahedral symbol D_+(q), whose high-branch kernels are
two-dimensional and chirality-balanced, suppose there is a finite-range,
gauge-covariant branch-control construction P_a/T/M_split satisfying:

1. NodalSetControlled;
2. BranchProjectorsControlled;
3. ProjectedKernelOneDim;
4. ProjectedChiralityAligned;
5. ProjectedKreinPositive;
6. GhostZeroSafe;
7. SpeciesSplittingAudited.

Then Gate C releases for the projected or species-split physical operator
D_phys, not for the bare D_+.
```

This keeps the post-C21 claim honest:

```text
The bare symbol supplies determinant branches but no raw ordinary branch
chirality. The physical branch index, if it exists, is a projected
flavored/taste index.
```

### 31.4 Lean-facing module split

Do not formalize the broad existence theorem first. Split it into smaller
modules:

```text
NullEdgeProjectedGateCRelease.lean
  defines the post-C21 release predicates and proves the conjunction implies a
  named Gate C release result.

NullEdgeProjectedBranchChirality.lean
  proves ProjectedKernelOneDim and ProjectedChiralityAligned for a concrete
  point-split/taste projector, if such a projector is available.

NullEdgeKreinPositiveReleaseCriterion.lean
  proves sufficient conditions for ProjectedKreinPositive without contradicting
  C22's negative-branch facts.

NullEdgeGateCGhostZeroSafety.lean
  defines GhostZeroSafe and separates physical poles, physical doublers,
  kinematical zeros, composite-field removable zeros, Krein artifacts, and fatal
  ghost zeros.

NullEdgeSpeciesSplittingModuliLedger.lean or an AgentTasks audit
  classifies splitting terms as forced, constrained, tunable, or fatal.
```

### 31.5 Ghost safety is now a hard gate

Gemini's strongest warning matches the Golterman-Shamir literature:

```text
flavored signs + lifted branches != Gate C release.
```

If a projection or splitting term creates inverse-propagator zeros, then each
zero must be classified as:

```text
physical pole;
physical doubler;
kinematical zero;
composite/interpolating-field removable zero;
Krein artifact;
fatal gauge-coupled ghost zero.
```

Unclassified zeros block Gate C. Gauge-coupled ghost zeros are fatal unless a
composite/interpolating-field theorem removes them from the physical gauge
sector.

### 31.6 Krein positivity caution

Gemini's stable-C-symmetry language is useful only as a possible theorem target.
It is not an assumption we should build into claims. C22 already shows:

```text
modeled chirality pattern != modeled Krein signature pattern;
aligned chirality does not imply Krein positivity;
J-self-adjointness alone does not imply stability.
```

Therefore any stable-C-symmetry or positive-sector projector must be constructed
and checked explicitly, or else recorded as an open analytic/Krein assumption.
