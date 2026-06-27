# Null-edge moduli-rank prediction ledger and codimension gate

Type: no-build strategy/prediction-gate deliverable (written ledger only; no
Lean, Lake, or build commands were run).

Scope: this document builds the reconstruction/prediction map
`F : M_finite -> M_EFT` as a careful ledger, computes a naive parameter count as
a first screen only, states the true prediction criterion (codimension /
`rank(dF) < dim M_EFT`), ranks structural prediction candidates each with a
smallest-useful theorem or audit target, and gives a failure-mode section
explaining how the program survives as reconstruction even if `F` is full rank.

Source anchors:
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md`, Sections C.7,
  D.7, E.4, F.
- `AgentTasks/null-edge-unified-mass-proof-chain.md`, entry T17.
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, Sections 15.12, 16.15,
  16.16, 17.6, 17.7, 19.7.
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` (theorem inventory,
  generation/internal-Jordan layer, finite-valency caveat).

Status banner (read first): **The current honest label is reconstruction (and
partly representation), not prediction.** Nothing below promotes the program to
"derivation of the mass spectrum." The deliverable is the gate itself: an
explicit, falsifiable test for when the program *would* cross from
reconstruction to prediction, plus the cheap first-screen count that almost
certainly will *not* by itself establish prediction.

---

## 0. The map, stated precisely

```text
F : M_finite -> M_EFT,   theta_EFT = F(theta_finite).
```

- `M_finite` is the moduli space of finite null-edge data: the discrete/algebraic
  inputs of the construction (graph family, frames, soldering, edge weights,
  gauge/representation/Higgs/Yukawa/Majorana data, spectral function, cutoff,
  counterterms), modulo the redundancies that act on those data.
- `M_EFT` is the moduli space of low-energy effective-theory observables: the
  measured Standard Model + neutrino parameters and the allowed higher-dimension
  Wilson coefficients, modulo field redefinitions and basis choices.
- `F` is the reconstruction map: take finite data, build the (dual-soldered
  super-Dirac / spectral-action) operator, extract its low-energy couplings.

The prediction question is *not* "does `F` exist?" (it is the reconstruction map,
assumed to exist once T5/T9/T10/T14 supply the per-mechanism reconstructions).
The prediction question is **"what is the image of `F`, and is it a proper
subvariety of `M_EFT`?"**

Guardrail in force throughout: *do not call reconstruction a prediction.* `F`
producing the right couplings from chosen inputs is reconstruction. `F` being
unable to reach a generic point of `M_EFT` (low rank, or image inside `R = 0`)
is prediction.

---

## 1. Coordinate ledger

Both columns list *coordinates* (candidate local parameters), with an explicit
note on the redundancy group that must be quotiented before any count is
meaningful. Dimensions are written as symbolic counts because several blocks are
size-parametric (number of generations `n_g = 3`, gauge group rank, graph size).

### 1.1 `M_finite` coordinates (domain)

| # | Block | Coordinate content | Continuous / discrete | Redundancy acting on it |
|---|-------|--------------------|-----------------------|--------------------------|
| F1 | Graph family | choice of finite causal graph / poset; valency profile; null-step incidence | discrete (a family label) | graph isomorphism; coarse-graining equivalence (finite valency is *effective*, not fundamental) |
| F2 | Local null-frame / tetrad | per-vertex/edge null tetrad `e_a`, soldering of internal Clifford index to null direction | continuous | local Lorentz/frame `SO(1,3)` (or `SL(2,C)`) rotations |
| F3 | Dual-soldering normalization | scale/convention of `c(alpha^a)` on the dual covector (determinant-vs-trace normalization) | continuous (few params) | overall rescaling; convention fixing |
| F4 | Edge weights | corner/transfer weights on null edges (checkerboard amplitudes) | continuous | reparametrization of path-sum normalization; gauge of the transfer operator |
| F5 | Gauge group | choice of compact `G` (e.g. `SU(3)xSU(2)xU(1)`) | discrete | group isomorphism; choice of normalization of generators |
| F6 | Representations | matter/Higgs rep assignment per multiplet | discrete | equivalence of reps; relabelling of multiplets |
| F7 | Higgs potential | `mu^2`, quartic `lambda` (and any portal/extra-scalar couplings) | continuous | field rescaling of `H` |
| F8 | Yukawa matrices | `Y_u, Y_d, Y_e (, Y_nu)`, each `n_g x n_g` complex | continuous | flavor basis changes `U(n_g)^5` acting on left/right multiplets |
| F9 | Majorana / sterile blocks | `M_R` (sterile mass matrix), Dirac-vs-Majorana choice, number of steriles | continuous + discrete | sterile-basis `O(n_R)/U(n_R)` rotations |
| F10 | Spectral function `f` | moments of the cutoff/spectral profile entering the spectral action | continuous (a few moments `f_0, f_2, f_4, ...`) | reparametrization of `f` preserving the relevant moments |
| F11 | Cutoff `Lambda` | UV scale of the spectral action / finite truncation | continuous (1) | overall units; trades against `f` moments |
| F12 | Counterterms | allowed finite local counterterms (incl. would-be Pauli, Lorentz-violating terms) | continuous | renormalization-scheme redefinitions |

Redundancy note (load-bearing). The *raw* coordinate list above massively
overcounts. The honest dimension is

```text
dim M_finite = (sum of raw block dims) - dim(redundancy group orbit),
```

where the redundancy group includes: graph isomorphism + coarse-graining (F1),
local frame/Lorentz (F2), convention/normalization (F3, F11), transfer-operator
gauge (F4), rep/flavor/sterile basis changes (F6, F8, F9), field rescalings
(F7), and scheme redefinitions (F12). Beware fake parameter deficits produced by
*failing* to quotient, and fake parameter surpluses produced by double-counting
a single physical knob across F3/F10/F11.

### 1.2 `M_EFT` coordinates (codomain)

| # | Block | Coordinate content | Physical count (n_g = 3) | Notes |
|---|-------|--------------------|--------------------------|-------|
| E1 | Gauge couplings | `g_1, g_2, g_3` | 3 | at a fixed reference scale |
| E2 | Higgs sector | `v, lambda` (equiv. `m_h^2, v`) | 2 | `mu^2` traded for `v` at the minimum |
| E3 | Up Yukawa | `Y_u` -> 3 quark masses | 3 | masses only after flavor rotation |
| E4 | Down Yukawa | `Y_d` -> 3 quark masses | 3 | |
| E5 | Charged-lepton Yukawa | `Y_e` -> 3 lepton masses | 3 | |
| E6 | CKM | 3 angles + 1 phase | 4 | quark mixing, after basis fixing |
| E7 | Strong CP | `theta_QCD` | 1 | physical only mod chiral rotations |
| E8 | Neutrino Dirac Yukawa | `Y_nu` -> Dirac masses | (see E10) | not separately physical from E10 |
| E9 | Majorana scale | `M_R` | (see E10) | |
| E10 | Light-neutrino observables | 3 masses + PMNS (3 angles + 1 Dirac phase + 2 Majorana phases) | 9 (Majorana) / 7 (Dirac) | from seesaw of E8+E9 |
| E11 | `Lambda_QCD` | confinement scale | 0 *independent* | **derived** from `g_3` + reference scale by dimensional transmutation; not a free coordinate |
| E12 | Wilson coefficients | allowed dim>=5 operators (Weinberg op, dipole ops, etc.) | (open, large) | the EFT tower; usually treated as the prediction battleground |

EFT-side redundancy note. `M_EFT` coordinates are themselves only defined modulo
field redefinitions and flavor-basis choices. The "physical count" column
already applies these quotients (this is why `Y_u` contributes 3, not 18). Two
traps to record explicitly:
- `Lambda_QCD` (E11) is **not** an independent target. Counting it as one would
  manufacture a spurious target dimension and invite a QCD overclaim.
- `theta_QCD` (E7) is physical only modulo chiral rotations that also move the
  Yukawa phases; it must be counted once, in a fixed convention.

---

## 2. Naive parameter count (FIRST SCREEN ONLY -- not the criterion)

> Warning label, repeated from the grand-strategy report C.7 and Working Plan
> 16.15: simple parameter counting is the cheap first pass. **Codimension is the
> real criterion.** Field redefinitions and redundant coordinates can fake a
> parameter deficit, and gauge redundancy can fake a parameter surplus. Treat
> every number below as a screen, never as a result.

### 2.1 Target dimension `dim M_EFT` (renormalizable core)

```text
gauge couplings        g_1,g_2,g_3            3
Higgs                  v, lambda              2
quark masses           (Y_u,Y_d)              6
charged-lepton masses  (Y_e)                  3
CKM                    3 angles + 1 phase     4
strong CP              theta_QCD              1
-------------------------------------------------
SM core (no nu)                              19
neutrino sector (Majorana seesaw)            +9   (3 masses + 3 PMNS angles + 3 phases)
-------------------------------------------------
dim M_EFT (renormalizable, Majorana nu)      28
```

`Lambda_QCD` adds 0 (derived from `g_3`). The Wilson-coefficient tower (E12) is
deliberately excluded from this finite screen; it is the place where a *forbidden
counterterm* result lives (Section 4), not a counting line.

### 2.2 Domain dimension `dim M_finite` (after redundancy quotient -- sketch)

```text
Yukawa data Y_u,Y_d,Y_e (,Y_nu)   : 3 (or 4) complex 3x3 matrices, minus U(n_g)^5
                                     flavor redundancy  ->  reproduces exactly the
                                     E3-E6,E10 physical count by construction
Higgs potential F7                 : 2 (mu^2,lambda) -> matches E2
gauge/rep data F5,F6               : discrete; fixes the *form*, not real moduli
edge weights / frame / soldering   : F2-F4, continuous, large but mostly
   F2,F3,F4                          redundant under frame/convention quotient
spectral function + cutoff F10,F11 : few moments; in spectral-action models these
                                     are exactly what could relate g_1,g_2,g_3,lambda
counterterms F12                   : as many as the symmetries allow
```

### 2.3 Honest reading of the screen

- **Generic expectation: full rank.** Because the Yukawa block F8 is, by
  construction, a free complex matrix in each sector, the reconstruction map can
  hit every physical mass and mixing in E3-E6 and E10 independently. So on the
  flavor sub-block, `F` is generically *onto* and the screen predicts **nothing**
  there. This is the failure mode the program already names (Working Plan 16.16
  "Parameter full rank"): the finite model has enough knobs to fit all SM
  parameters.
- **Where a deficit could appear is not flavor but the F10/F11 spectral block.**
  If the gauge couplings and `lambda` all descend from the *same* spectral
  function moments `f_0, f_2, f_4` and a single cutoff `Lambda` (Chamseddine-
  Connes spectral-action pattern), then E1+E2 (5 targets) are fed by far fewer
  than 5 independent finite knobs, and the image satisfies relations among
  `g_1, g_2, g_3, lambda, v`. That is the one structurally promising deficit, and
  it is a *codimension* statement, not a count.
- **Do not subtract naively.** `dim M_finite - dim M_EFT` is meaningless before
  the redundancy quotient, because raw F2-F4 and F12 are almost entirely gauge.
  A negative or zero difference computed from raw coordinates would be a *fake*
  deficit.

Conclusion of the screen: the count *alone* is consistent with full-rank
reconstruction. The only place the count even hints at prediction is the spectral
block, and that hint must be confirmed as an actual codimension relation, not a
counting artifact.

---

## 3. The true prediction criterion

The program predicts (rather than reconstructs) at a generic finite point
`theta_finite` iff one of the following holds:

```text
(A)  rank(d F)|_{theta_finite}  <  dim M_EFT        (generic rank drop)
```

or equivalently the image is a proper subvariety, certified by a nontrivial
relation on observables:

```text
(B)  R(theta_EFT) = 0   for all theta_EFT in image(F),   with R not identically 0
     on M_EFT  (a codimension >= 1 constraint, e.g. a coupling relation).
```

### 3.1 Why codimension, not counting

- A rank drop `(A)` is a statement about the *differential* `dF`, robust to
  reparametrization: ranks are invariant under diffeomorphisms of domain and
  codomain, so they survive the field-redefinition and basis quotients that
  corrupt raw counts.
- A relation `(B)` is the integrated form: `image(F)` lies in the zero set of
  `R`. The relation `R` is what a referee can test against data.
- The naive count is only a *necessary* heuristic: `dim M_finite(mod redundancy)
  < dim M_EFT` is required for a global deficit, but is neither sufficient (the
  image could still be full-dimensional on a subset) nor necessary for a local
  relation (a relation can hold even when the raw count is large, if `dF` is
  degenerate).

### 3.2 Redundancy hygiene (mandatory before claiming `(A)` or `(B)`)

Before reporting any rank drop or relation, the following must be checked, or the
"prediction" is fake (Working Plan 16.15; grand-strategy D.7, guardrails):

1. **Gauge redundancy.** Quotient F2 (local Lorentz/frame), F4 (transfer gauge),
   F5/F6 (group & rep relabelling). A deficit that disappears after this quotient
   was a gauge artifact.
2. **Basis choices.** Quotient flavor `U(n_g)^5` on F8 and sterile basis on F9. A
   Yukawa "texture zero" that can be rotated away is not a constraint.
3. **Field redefinitions.** Quotient Higgs/field rescalings (F7) and EFT-side
   redefinitions on E12. A Wilson-coefficient relation that is a basis choice is
   not a prediction.
4. **Convention/units collapse.** F3/F10/F11 partly trade against each other; fix
   a convention so the same physical scale is not counted three times.

Only a relation `R` (or rank drop) that *survives all four quotients* counts.

### 3.3 Formalizable fragments (per proof-chain T17)

T17 is primarily a ledger/analysis, but two fragments are theorem-shaped:

```text
-- first screen, honest count
theorem moduli_count :
  dim_finite_mod_redundancy = N  /\  dim_EFT = K
-- the real prize, only if a relation is actually found
theorem coupling_relation :
  forall theta_finite, R (F theta_finite) = 0
```

`moduli_count` is a bookkeeping lemma (safe, low value on its own).
`coupling_relation` is the genuine prediction and must include the `R not
identically zero` nondegeneracy clause, or it is vacuous.

---

## 4. Ranked structural prediction candidates

Each candidate is ranked by *plausibility of yielding a real, redundancy-robust
constraint in the near term*, and paired with the **smallest useful theorem or
audit target** that would either establish it or cleanly kill it. All candidates
are *structural* (texture / forbidden term / representation / relation), not
numerical mass predictions -- consistent with Working Plan 15.12 and 19.7.

### Rank 1 -- Forbidden / restricted counterterms (most likely to be real)

- **Claim shape:** the dual-soldered null-edge geometry forbids a specific local
  counterterm that a generic EFT allows (e.g. an anomalous Pauli moment term, a
  Lorentz-violating dispersion operator, or a particular dim-5/6 operator),
  i.e. a Wilson coefficient is forced to zero by the construction's symmetry.
- **Why plausible:** symmetry-forced vanishing is robust under field
  redefinitions (it is a statement about which operators the construction can
  generate at all), so it survives the Section 3.2 hygiene checks more easily
  than any numerical relation.
- **Smallest useful target (audit + Lean):** enumerate the operators the finite
  dual-soldered symbol can generate at the relevant dimension; prove a
  *generation lemma* `theorem no_pauli_counterterm : c_Pauli (F theta) = 0`
  (or the analogous Lorentz-violating-operator coefficient) from the soldering
  symmetry, with the nondegeneracy note that a generic EFT has this coefficient
  free. Audit half: confirm the forbidden term is not merely basis-removable.

### Rank 2 -- Spectral-action coupling relation among `g_1, g_2, g_3, lambda, v`

- **Claim shape:** if E1+E2 all descend from the same spectral moments
  `f_0,f_2,f_4` and one cutoff, the image satisfies a Chamseddine-Connes-style
  relation, e.g. a fixed `g_1:g_2:g_3` ratio or `lambda`-`g` relation at the
  cutoff scale (`R(theta_EFT)=0` of codimension >= 1).
- **Why plausible/risky:** this is the *only* block where the naive count even
  hints at a deficit (Section 2.3); but in NCG such relations hold at the cutoff
  and run, so the constraint is scale-dependent and must be stated at `Lambda`.
- **Smallest useful target (Lean):** in the finite spectral-action model, prove
  the heat-kernel/moment identity that expresses `g_1,g_2,g_3,lambda` in terms of
  `f_0,f_2,f_4,Lambda` and derive one elimination relation
  `theorem spectral_coupling_relation : R(g_1,g_2,g_3,lambda) = 0 at Lambda`.
  Audit: verify the relation is not an artifact of the chosen generator
  normalization (F3/F5).

### Rank 3 -- Anomaly-forced representation class

- **Claim shape:** null-edge chirality + anomaly cancellation forces the matter
  content into a specific representation class (a discrete prediction: which
  reps can appear), narrowing F6.
- **Why plausible:** anomaly sums are exact, finite, and basis-independent; this
  is the most "provable" item, but it constrains the *discrete* rep choice rather
  than continuous `M_EFT` coordinates, so it sharpens the model rather than
  dropping `rank(dF)`.
- **Smallest useful target (Lean, low difficulty):** the T18 anomaly sums
  `theorem sm_anomaly_cancellation : sum Y^3 = 0 /\ sum Y = 0 /\ mixed grav = 0`
  over one generation's hypercharges, plus an audit note that the null-edge
  chirality realizes (does not obstruct) this assignment.

### Rank 4 -- Restricted Yukawa rank / texture / zero pattern

- **Claim shape:** the flavor-overlap (Gram-weighted hidden-label) mechanism
  forces a texture zero or a rank constraint on `Y_u/Y_d/Y_e` that is *not*
  removable by `U(n_g)^5`.
- **Why hard:** most textures are basis artifacts (Section 3.2 item 2). A real
  result must be stated as a basis-invariant (e.g. a vanishing flavor invariant /
  Jarlskog-type quantity, or a forced rank).
- **Smallest useful target (Lean + audit):** build on the existing
  `NullEdgeGramWeightedMassAristotle` Cauchy-Binet result; prove that the
  internal-coherence structure forces a *basis-invariant* relation
  `theorem yukawa_invariant_zero : J_inv(F theta) = 0` (a weak-basis invariant),
  and audit that it cannot be rotated away.

### Rank 5 -- Finite-geometry reason for the generation number (n_g = 3)

- **Claim shape:** the internal exceptional-Jordan / triality layer (`H_3(O)`,
  Spin(8) triality) singles out exactly three families.
- **Why deferred:** the Strengthened Program is explicit that this is a *lead,
  not a handle*: exact triality lives at Spin(8) and the SM embedding breaks it;
  the Pluecker visible geometry is generation-blind. Counting "three" is
  representation-organization, not a mass theorem.
- **Smallest useful target (audit, then Lean):** a source-backed note stating the
  composite-system (Barnum-Graydon-Wilce) obstruction precisely, plus a Lean
  lemma on the existing Albert-algebra substrate that the off-diagonal
  octonionic entries carry the three inequivalent `8`s of Spin(8); demote the
  branch if SM-embedding breaking does not single out three usable families.

### Rank 6 -- Specific Lorentz-dispersion correction

- **Claim shape:** the null-edge substrate predicts a particular sign/form of a
  dispersion modification (a higher-derivative kinetic correction), testable in
  principle.
- **Why lowest:** strongly tied to the continuum-limit/no-doubling theorems
  (T13/T16) not yet in hand; without a controlled continuum symbol, any
  dispersion claim is premature.
- **Smallest useful target (audit):** specify, conditional on the dual-soldered
  continuum symbol, the leading dispersion operator and its coefficient sign as a
  *conditional* statement; no numerical claim until the no-doubling determinant
  test exists.

Ranking rationale: items robust under the Section 3.2 quotients (forbidden
counterterms, anomaly sums, basis-invariant Yukawa relations, spectral relations)
rank above items that are discrete-organizational (generations) or
continuum-dependent (dispersion).

---

## 5. Failure modes -- and why the program stays valuable as reconstruction

### 5.1 The headline failure mode: `F` is generically full rank

If, after honest redundancy quotients, `rank(dF) = dim M_EFT` at a generic point
and no nontrivial `R` exists, then the finite model has enough free knobs (chiefly
the free Yukawa block F8) to fit every SM parameter, and it **predicts nothing
numerical**. This is the expected outcome of the Section 2 screen and must be
stated plainly. Do not relabel this as prediction.

### 5.2 Fake-deficit failure modes (must be excluded before any claim)

- **Gauge-redundancy deficit:** a parameter shortfall that vanishes after
  quotienting local frame (F2), transfer gauge (F4), or rep relabelling
  (F5/F6) -- not a constraint.
- **Basis-choice deficit:** a Yukawa texture or zero pattern removable by
  `U(n_g)^5` -- not a constraint.
- **Field-redefinition deficit:** a Wilson-coefficient relation that is a basis
  choice on E12 -- not a constraint.
- **Convention collapse:** treating `Lambda_QCD` (E11) as independent, or
  triple-counting a single scale across F3/F10/F11 -- a manufactured target or a
  manufactured deficit.

Any candidate in Section 4 that survives only because one of these checks was
skipped is rejected.

### 5.3 Why reconstruction is still a real result even at full rank

Even if `F` is full rank and no `R` is found, the program retains genuine value
(grand-strategy F.5; Working Plan 14, 15.14):

1. **A disciplined unification of mechanism, not of numbers.** A machine-checked
   demonstration that distinct SM mass mechanisms (Pluecker kinematic invariant,
   Higgs/Yukawa singular values, electroweak orbit-stabilizer mass, Higgs-radial
   Hessian, seesaw Schur complement) all instantiate one quadratic-obstruction
   template `m^2 = B^dagger B` on a common null-edge substrate is a structural
   result independent of parameter fixing.
2. **A clean separation of invariants from spectra.** It sharpens what "origin of
   mass" can mean by separating state invariants (`det P = m^2`) from operator
   spectra (Yukawa/EW/Higgs masses), preventing the D.1/D.5/D.6 conflations.
3. **An explicit, falsifiable gate.** This very ledger defines the moduli-rank /
   codimension test, so the program states *in advance* exactly what would count
   as crossing from reconstruction to prediction -- a falsifiable posture, which
   is itself a scientific contribution.
4. **Representation value.** Even at full rank, exhibiting the SM mass data inside
   a single null-edge operator architecture is a representation theorem (the
   construction *can host* the chiral SM), which is a nontrivial existence
   statement when paired with the anomaly/no-doubling audits.

### 5.4 Stop rule (carried over)

If no finite null-edge theorem does more than repackage standard mass terms, the
correct label is **"null-edge representation / unified reconstruction,"** not
"unified origin-of-mass theory." The program becomes predictive only when one
Section-4 candidate is proved as a redundancy-robust `rank(dF) < dim M_EFT` or
`R(theta_EFT) = 0`.

---

## 6. Guardrail compliance checklist

- [x] Reconstruction is not called prediction: status banner (Section 0),
      criterion (Section 3), and failure mode 5.1 all keep the labels separate.
- [x] Fake parameter deficits from gauge redundancy / basis choices / field
      redefinitions are flagged: redundancy notes in 1.1/1.2, hygiene rules 3.2,
      failure modes 5.2.
- [x] QCD scale and Yukawa hierarchy treated as not yet derived: `Lambda_QCD` is
      a derived non-coordinate (E11, 5.2); Yukawa hierarchy is left to the
      Rank-4 candidate as an *unproved* basis-invariant target, not a result.
- [x] First-screen vs real-criterion separation is explicit (Section 2 warning
      label; Section 3.1).
- [x] All prediction candidates are structural, each with a smallest-useful
      theorem/audit target (Section 4).

---

## 7. Cross-references

- Decision tree (reconstruction vs prediction) and fast-failure checklist:
  Working Plan 16.16; grand-strategy E.4 ("Key figures/tables").
- Per-mechanism canonical `B` and nontriviality criterion (template is empty
  unless `B` is forced): Working Plan 17.7; grand-strategy D.6.
- Dependencies feeding `F` (reconstruction maps): T5, T9, T10, T14
  (proof-chain). T17 is the gate that consumes them.
- Anomaly audit companion: proof-chain T18 (feeds Rank-3 candidate).
