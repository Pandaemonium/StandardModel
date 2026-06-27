# Aristotle semantic context pack

Generated: 2026-06-27T12:17:20
Query: `Gate C direct overlap singular crossing scalar Wilson C0 gap branch involution T_br release datum ghost safety domain wall projected overlap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `NULL_EDGE_RESULTS.md` [5. The sharply isolated blocker: Gate C]

Score: `0.849`

```text
ctor cannot rescue a balanced external
  origin (C87). Origin polarization needs a genuine spinor-line construction
  (projected Weyl / domain-wall / overlap / branch involution `T_br`), not a
  taste-only one.

A hard ghost rule governs any release: **no gauge-charged branch may be removed
solely by a propagator zero** (Golterman-Shamir) -- removal must come from a true
inverse-propagator mass gap.

Current posture: the bare operator is labeled **FATAL-FOR-NAIVE-FLAT, not fatal
for the program**. Release, if it happens, is for a specified regulated/projected
`D_phys`, not for `D_+`.

Pro Gate C refinement (2026-06-27): treat C0 as the clean species-health theorem
and C1 as a separate **release datum** problem. If the doubled external symbol is
anti-Hermitian and the scalar Wilson weight satisfies `W(q) >= 0`, then
`A(q) + r W(q) I` has a quantitative gap bounded by `r W(q)`; this can gap
non-origin real-torus zeros without classifying the full branch locus. That is
C0 evidence only. C1 requires additional data:

```text
(D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)
```

with a one-Weyl-line origin sector, true inverse-propagator gaps on mirror or
unwanted branch components, locality or controlled quasi-locality, ghost-zero
safety, anomaly accounting, and positive physical residues. Direct unprojected
overlap on the full bare `D_+` is now a risk to test, not a default route: if an
unwanted zero branch germ reaches the origin and crosses the shifted Wilson mass
shell, the overlap sign kernel becomes singular. The null-edge-native C1 route
is therefore either a genuine branch classifier/projector (`T_br` or `Pi_br`) or
a controlled domain-wall/projected-overlap construction after that branch split.

---
```

### 2. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [30.4 Revised Gate C release language]

Score: `0.813`

```text
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
```

### 3. `NULL_EDGE_RESULTS.md` [5. The sharply isolated blocker: Gate C]

Score: `0.805`

```text
## 5. The sharply isolated blocker: Gate C

The honest hard problem. The bare retarded null-edge symbol `D_+` does **not**
release as a physical chiral operator. What is now *proved* (not merely
suspected):

- **Bare alignment fails** (C21): the four-component symbol does not force
  aligned chirality. Each nonzero null branch carries a two-dimensional,
  chirality-balanced kernel (one left + one right Weyl line).
- **The determinant-zero locus is larger than the modeled branches**: there are
  off-branch zeros (e.g. `q_star`) and a cyclotomic/S4 orbit of extra zeros
  (C43/C44, C64, C66). A naive `g5` split does not control them.
- **Scalar Wilson lifting cannot release Gate C** (C88, taste no-go): a term
  that is scalar on the origin corner and vanishes quadratically at the origin
  cannot turn the balanced origin kernel into a single chirality, and cannot
  separate an unwanted branch germ reaching the origin.

This produced a clean **C0 / C1 split**:

- **Gate C0 (external species health)** -- plausibly reachable. An
  anti-Hermitian operator plus a positive scalar Wilson mass has a quantitative
  norm lower bound and no kernel (C85/C86, abstract linear algebra, kernel-clean
  draft). On the real torus `W(q) = sum_a (1 - cos q_a)` vanishes only at the
  origin, so it gaps every non-origin determinant zero -- including unknown ones
  -- *without* classifying the full locus.
- **Gate C1 (physical chiral release)** -- still open, and **mandatory** for the
  Standard-Model-facing claim. Because the total chiral index factorizes over
  `H_N tensor H_F`, a chiral internal sector cannot rescue a balanced external
  origin (C87). Origin polarization needs a genuine spinor-line construction
  (projected Weyl / domain-wall / overlap / branch involution `T_br`), not a
  taste
```

### 4. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [35.5 Missed returned results: C63 and K3]

Score: `0.801`

```text
### 35.5 Missed returned results: C63 and K3

A follow-up Aristotle sweep found two completed results beyond the earlier
integration note.

C63 (`NullEdgeProjectedGhostSafety.lean`) sharpens Gate C rather than closing it
unconditionally. It proves that residue control is equivalent to spectrum-level
ghost-zero safety for the projected sector, and that the C59 projected release
follows from the other six clauses plus this residue-control clause. It also
proves the important negative guardrail: projected chirality, nonzero flavored
index, and gauge covariance still do not imply ghost safety. Thus the open Gate C
operator obligation is now exactly the actual post-gauge residue/`PostGaugeGhostSafe`
condition.

K3 (`NullEdgeKreinLockOrigin.lean`) proves the Krein-lock no-go. The retained
sector is canonical only after the Krein/sign orientation is locked. From the
currently formalized data, every branch sign pattern is compatible with the
abstract fundamental-symmetry axioms, and the global orientation flip exchanges
the retained sector. The safe interpretation is that Gate C may consume the
Krein lock as an explicit sheet/causal orientation convention, while Gate F must
not treat the literal retained branch labels as predicted.
```

### 5. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [28.5 Gate C release theorem v2]

Score: `0.799`

```text
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
All branch-
```

### 6. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [31.5 Ghost safety is now a hard gate]

Score: `0.797`

```text
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
```

### 7. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [34.1 Gate C after the Route-B integration]

Score: `0.796`

```text
### 34.1 Gate C after the Route-B integration

The Gate C story is now much cleaner.

| Result | Status | Meaning |
|---|---|---|
| Bare symbol chirality | Refuted as a release route | The actual Clifford symbol has a two-dimensional chirality-balanced kernel on each null branch, so the bare operator cannot assign a single branch chirality. |
| Projected chirality | Proved in the modeled projection | `NullEdgeProjectedBranchChirality.lean` constructs the branch projection that keeps the `gamma5 = g5 a` line. This supplies the Route-B chirality clause. |
| Nodal-line lifting | Proved for a splitting term | `NullEdgeSpeciesSplitNodalLine.lean` shows a species-splitting term can lift the high-momentum nodal line away from the origin. The coefficient remains free. |
| Gauge covariance | API/proof scaffold integrated | `NullEdgeGaugeCovariantBranchProjectors.lean` gives link-dressed projectors, but gauge covariance is not ghost safety. |
| Composite-zero escape | Formal distinction integrated | `NullEdgeCompositeZeroEscape.lean` distinguishes removable composite zeros from fatal propagator zeros. Projection/enlargement can remove zeros; an invertible basis change cannot. |

The remaining Gate C release theorem should therefore be phrased as a projected,
post-splitting, post-gauge safety theorem. A flavored index by itself is not
enough. A successful Gate C closeout must combine:

1. the projected chirality clause,
2. Krein-positive physical-sector selection,
3. post-gauge ghost-zero clearance,
4. a clear account of the nodal line lifted by the splitting term,
5. an honest statement that the split coefficient is a modulus unless further
   symmetry or dynamics fixes it.

This is a good result, not a disappointment. It replaces a vague doubler problem
with a precise Route-B pr
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [27.4 Updated Gate C release statement]

Score: `0.783`

```text
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
```

## Scoped paper hits

### 1. An invitation to higher gauge theory

Score: `0.705`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 2. Index Theorem and Overlap Formalism with Naive and Minimally Doubled Fermions (JHEP)

Score: `0.695`
Zotero key: `72HIN3TA`
arXiv: `1011.0761`
URL: https://www.zotero.org/19894138/items/72HIN3TA

Abstract:

Theoretical foundation for the index theorem in naive and minimally doubled lattice fermions via the spectral flow of a Hermitean Dirac operator with flavored mass terms. The spectral flow detects the index of would-be zero modes determined by gauge field topology. Obtains a single-flavor naive overlap fermion that maintains hypercubic symmetry.

### 3. A Lattice Formulation of Weyl Fermions on a Single Curved Surface

Score: `0.694`
Zotero key: `4JMA4Q3S`
arXiv: `2402.09774`
DOI: `10.1093/ptep/ptae041`
URL: https://www.zotero.org/19894138/items/4JMA4Q3S

Abstract:

In the standard lattice domain-wall fermion formulation, one needs two flat domain-walls where both of the left- and right-handed massless modes appear. In this work we investigate a single domain-wall system with a nontrivial curved background. Specifically we consider a massive fermion on a 3D square lattice, whose domain-wall is a 2D sphere. In the free theory, we find that a single Weyl fermion is localized at the wall and it feels gravity through the induced spin connection. With a topologically nontrivial U(1) link gauge field, however, we find a zero mode with the opposite chirality localized at the center where the gauge field is singular. In the latter case, the low-energy effective theory is not chiral but vectorlike. We discuss how to circumvent this obstacle in formulating lattice chiral gauge theory in the single domain-wall fermion system.

### 4. Index Theorem and Overlap Formalism with Naive and Minimally Doubled Fermions

Score: `0.691`
Zotero key: `QB6UXK3U`
arXiv: `1110.2482`
URL: https://www.zotero.org/19894138/items/QB6UXK3U

Abstract:

A theoretical foundation for the index theorem in naive and minimally doubled lattice fermions by studying the spectral flow of a Hermitean version of Dirac operators, using point-splitting to implement flavored mass terms. The spectral flow correctly detects the index of the would-be zero modes determined by gauge field topology and the number of species doublers. Presents new overlap fermions from naive fermion kernels with a flavor number depending on the mass terms.

### 5. From Twistor-Particle Models to Massive Amplitudes

Score: `0.690`
Zotero key: `NVT2C7IF`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: https://www.zotero.org/19894138/items/NVT2C7IF

Abstract:

In his twistor-particle programme of the 1970's, Roger Penrose introduced a representation of the massive particle phase space in terms of a pair of twistors subject to an internal symmetry group. Here we use this representation to introduce a chiral string whose target is a complexification of this space, extended so as to incorporate supersymmetry. We show that the gauge anomalies associated to the internal symmetry group vanish only for maximal supersymmetry, and that correlators in these string models describe amplitudes involving massive particles with manifest supersymmetry. The models and amplitude formulae exhibit a double copy structure from gauge theory on the Coulomb branch to gravity, although the graviton remains massless. The formulae are closely related to those obtained earlier by the authors expressed in terms of the polarised scattering equations.
