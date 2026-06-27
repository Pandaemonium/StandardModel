# E11/F12 audit: quiver spectral-action novelty boundary, FMS electroweak language, and the Gate-F parameter-count ledger

**Type:** no-build mathematical / physical / strategy audit (Wave 7).
**Scope:** position the null-edge finite-graph + Higgs/super-Dirac mass program against
(i) quiver / network spectral-action reconstruction, (ii) finite spectral-triple moduli
theory, and (iii) the FMS gauge-invariant-composite literature, so that novelty and
prediction claims can be stated without overclaiming.

Primary literature anchors (as supplied):

- van Suijlekom et al., **arXiv:2401.03705**, Bratteli networks and spectral action on quivers.
- Maas, **arXiv:2305.01960**, FMS mechanism review.
- **arXiv:2603.12882**, weak and Higgs physics from the lattice.
- Cacic, **arXiv:0902.2068**, moduli spaces of Dirac operators for finite spectral triples.
- Bochniak–Sitarz, **arXiv:1804.09482**, finite pseudo-Riemannian spectral triples and the SM.
- Ackermann–Tolksdorf, **arXiv:hep-th/9503153**; Tolksdorf, **arXiv:hep-th/9612149**
  (generalized Lichnerowicz / Dirac–Yukawa square).
- Existing null-edge guardrails (`COMMON_CONTEXT.md`) on gauge language, `Phi_H^2`,
  W/Z masses, and the prediction gate `rank(dF) < dim M_EFT`.

The bottom-line verdict is stated first, then the seven analysis points, then the four
deliverables (novelty-boundary table, Gate-F ledger template, manuscript paragraph,
prediction-target verdict).

---

## 0. Bottom line

1. **The reconstruction layer of the program is, in its present form, a special case of
   already-published finite-graph / quiver spectral-action and finite spectral-triple
   theory.** A first-order operator on a finite graph whose square produces a kinetic
   Laplacian + zero-order endomorphism block + curvature/connection terms is exactly the
   content of the spectral-action-on-quivers and finite-spectral-triple programs. Putting
   it on null edges and relabeling the kinetic block "Plücker spread" does **not** by
   itself create novelty.

2. **There is a small, genuinely null-edge-specific residue** that is *not* covered by the
   Riemannian quiver / Euclidean finite-spectral-triple literature: (a) Lorentzian **null
   soldering** of the first-order symbol; (b) **causal retarded/advanced support** of the
   discrete propagator; (c) **determinant-branch / mass-shell** behavior of a *null*
   Clifford symbol (a nonzero null vector with `det = 0`); (d) **Krein / indefinite-inner-
   product** structure forced by Lorentzian signature; and (e) the resulting
   **moduli-rank restrictions** if any of (a)–(d) forbid otherwise-free operator data.
   Items (a)–(d) are structural; only (e) can become a *prediction*, and only if proved.

3. **Electroweak mass language must be expressed through FMS gauge-invariant composites**
   (`Phi_H^2`, `|nabla^A H|^2`, link/holonomy–condensate mismatch), never through literal
   "local gauge symmetry breaking." The FMS review (2305.01960) and the lattice weak/Higgs
   work (2603.12882) give the correct vocabulary and the correct caveat: perturbative W/Z
   mass terms are the *leading vacuum expansion* of gauge-invariant composite correlators.

4. **The parameter-count ledger shows the program is currently reconstruction-only.** A
   generic finite quiver spectral triple has *more* free operator moduli than the SM has
   EFT parameters; the null-edge constraints (null soldering, Krein reality, causal
   support, no-doubling determinant branch control, forbidden Pauli/counterterm set) are
   the *only* way the finite moduli dimension can drop below `dim M_EFT`. The ledger must
   therefore be a **deficit ledger**: count finite operator moduli, subtract the
   dimensions killed by each null-edge constraint, and compare to `dim M_EFT`. A prediction
   exists iff `rank(dF) < dim M_EFT` after those subtractions.

5. **First realistic prediction targets are structural, not numerical.** The credible
   near-term targets are: a *forbidden counterterm* class (e.g. an excluded Pauli /
   anomalous-moment or Lorentz-dispersion term forced by null soldering + Krein reality),
   a *Yukawa rank/texture/zero-pattern* restriction from the checkerboard square, and a
   *gauge–Higgs coupling relation* of Chamseddine–Connes type if a spectral-action
   normalization is actually imposed. Numerical mass values, the Yukawa hierarchy,
   `Lambda_QCD`, and the generation number are **not** realistic near-term targets.

---

## 1. What quiver / spectral-action constructions already achieve for finite-graph YMH reconstruction

The quiver / network spectral-action and finite-spectral-triple programs already deliver,
as published reconstruction theory, essentially the entire "reconstruction" column of the
null-edge plan:

- **Finite first-order operator → YMH action via the spectral action.** Given a finite
  spectral triple `(A, H, D)` (or a quiver/network with a Bratteli-type algebra as in
  2401.03705), the fluctuated Dirac operator `D_A = D + A + JAJ^{-1}` and the spectral
  action `Tr f(D_A/Lambda)` produce, after heat-kernel / moment expansion, a finite-graph
  Yang–Mills–Higgs functional: gauge kinetic terms, a Higgs (zero-order endomorphism)
  potential, and Yukawa couplings. This is exactly the null-edge "operator unification"
  target `D_h^2 = -K_h + Phi_H^2 + curvature + frame + Higgs-gradient`.

- **The graded square is the standard Lichnerowicz / Weitzenböck identity.** The split of
  `D^2` into a connection Laplacian plus a zero-order endomorphism plus curvature is the
  content of Ackermann–Tolksdorf (hep-th/9503153) and Tolksdorf (hep-th/9612149). The
  null-edge "checkerboard square" and "super-Dirac square" are discrete instances of this
  identity, not new identities.

- **Higgs as the inner fluctuation / off-diagonal part of `D`.** The identification of the
  scalar/Higgs field with the off-diagonal (finite, internal) part of the Dirac operator —
  so that `Phi_H^2` is a zero-order block of `D^2` — is the standard NCG result. The
  null-edge guardrail "`Phi_H^2` is the internal zero-order block, not a second additive
  Plücker mass" is precisely the NCG statement, restated.

- **Gauge bosons as inner fluctuations; W/Z mass from the Higgs vev.** Inner fluctuations
  of `D` give the gauge potential; the Higgs vev gives the gauge-boson mass matrix as the
  orbit-stabilizer obstruction `X -> X H_0`. The photon = stabilizer direction, W/Z = three
  massive orbit directions split is the standard `G/Stab(H_0)` quotient-metric statement.

- **Quiver/network generality.** 2401.03705 specifically extends the spectral-action
  machinery from a single finite algebra to *networks/quivers* of algebras (Bratteli
  diagrams), i.e. to genuine finite-graph data with edges carrying maps between vertex
  algebras. This is the closest published analogue to "a finite graph whose edges carry
  the first-order operator," and it already does finite-graph YMH reconstruction.

**Consequence.** Any null-edge theorem whose statement is "on a finite graph, a first-order
operator squares to kinetic + `Phi_H^2` + curvature, and the spectral action yields YMH"
is, up to the Lorentzian/null decorations of §3, an instance of this published body of
work. The plan's own §15.11 / §17.11 stop rules already anticipate this ("with only a graph
discretization this is a representation"). The audit confirms that judgement and sharpens
it: it is not merely "a representation," it is *a special case of a known reconstruction
theorem class*.

---

## 2. Which null-edge claims are merely instances of known quiver / spectral-action reconstruction

Classifying the plan's own theorem spine against the published reconstruction layer:

| Null-edge claim | Status vs. known quiver / spectral-action / finite-triple theory |
| --- | --- |
| Finite Plücker identity `det P = Σ_{i<j} |ψ_i∧ψ_j|²` (P1) | **Not** a spectral-action claim. It is a finite linear-algebra identity (Cauchy–Binet / Gram determinant). Genuinely a clean finite theorem, but it is classical linear algebra, not new NCG. |
| Massless ⇔ projectively collinear (rank-one locus) | Same: classical rank-one / Plücker geometry. Clean, but standard. |
| Yukawa checkerboard square (fermion mass = chirality-flip gap, `Phi_H²` block) | **Instance** of the finite-triple off-diagonal-Higgs / Lichnerowicz square. Reconstruction-only unless the *null L/R soldering* (§3a) does real work in the square's sign/structure. |
| Abelian/nonabelian Higgs link stiffness (`|∇^A H|²`) | **Instance** of inner-fluctuation gauge kinetic + covariant-derivative Higgs term. Reconstruction-only. |
| Electroweak stabilizer: photon = stabilizer, W/Z = 3 orbit directions, `ker B_EW = u(1)_em`, `rank B_EW = 3` | **Instance** of the `G/Stab(H_0)` quotient-metric / orbit-stabilizer obstruction. Structural theorem *given* the SM group + Higgs rep; not predictive (the group and rep are inputs). |
| Higgs radial mass `m_h² = 2λv²` | Standard Morse–Bott Hessian transverse to the vacuum manifold. Reconstruction/representation. |
| Super-Dirac graded square `D_h² = -K_h + Phi_H² + C_◇ + T_frame + ...` | **Instance** of generalized Lichnerowicz (Ackermann–Tolksdorf / Tolksdorf), discretized. Reconstruction unless the curvature/frame terms carry null-specific content. |
| Spectral action ⇒ YMH on the finite graph | **Instance** of quiver/network spectral action (2401.03705). Reconstruction. |

**Net:** the entire "operator unification" column (Yukawa, Higgs link, stabilizer, graded
square, spectral-action YMH) is *reconstruction that is a special case of known theory*,
absent the null/Lorentzian decorations. Only the Plücker finite identities (P1/P1.5) stand
apart, and they are classical linear algebra rather than novel spectral-action results.

---

## 3. Which claims, if any, are genuinely null-edge-specific

The published quiver / finite-spectral-triple reconstruction is **Riemannian / Euclidean**
(positive-definite Hilbert space, elliptic Dirac, real even spectral triple). The
following are the only places where the null-edge program lives *outside* that theory, and
therefore the only candidates for genuine novelty. Each is tagged with its honest claim
class and a falsifiable acceptance criterion.

**(a) Null soldering of the first-order symbol.** *Genuinely outside* the standard finite
even spectral triple, because the soldering form is a *degenerate (null) tetrad*, not a
Riemannian frame. Claim class: **structural / definitional novelty**, conditional on a
clean dual-soldered finite operator existing. Acceptance: a finite `D_h` whose principal
symbol is a null (rank-deficient) Clifford vector and whose square still reproduces the
correct continuum Lichnerowicz limit. Failure mode: if the only way to get the right square
is to re-add a non-degenerate metric, the null soldering is cosmetic.

**(b) Causal retarded/advanced support.** *Genuinely outside* the elliptic/Euclidean
spectral-action setting, which has no causal support notion. Claim class: **structural**.
Acceptance: a discrete support-transfer lemma showing the finite propagator has
retarded/advanced (lightcone) support, with a controlled continuum limit (cf. Gate-D causal
d'Alembertian leads, Boguña–Krioukov 2506.18745 — and its explicit warning that *naive
nonlocal* causal-set d'Alembertians may fail to converge). Failure mode: the nonlocality
needed for convergence destroys strict causal support.

**(c) Determinant-branch / mass-shell behavior of a null Clifford symbol.** *Genuinely
outside* the Euclidean program, where `det D(q) = 0` only at `q = 0`. In Lorentzian/null
signature a **nonzero** null Clifford vector can have `det D_+(q) = 0`, producing extra
mass-shell branches / doublers that the coefficient-vanishing test (`C_a = 0`) cannot see.
Claim class: **structural, and a fatal-flaw detector**. Acceptance: a full determinant /
mass-shell branch count (real branches, complex branches, high-`q` null singularities,
multiplicities after Krein doubling, chiral content, decoupling of unwanted branches).
This is the single most important null-specific technical item and overlaps Gate C
(see §7). Failure mode: unavoidable physical doublers or complex instabilities ⇒ the
operator branch must be redesigned (a publishable negative result).

**(d) Krein / indefinite-inner-product structure.** *Genuinely outside* the real *even
Riemannian* spectral triple; the relevant framework is the **pseudo-Riemannian / Krein**
finite spectral triple (Bochniak–Sitarz 1804.09482). Claim class: **structural**.
Acceptance: a consistent Krein-space adjoint and `KO`-type sign/grading algebra (Gate A)
under which the graded square and reality conditions hold. Novelty is *relative to the
Euclidean Connes–Chamseddine model*, but **not** relative to the existing pseudo-Riemannian
spectral-triple literature — so claim it as "Lorentzian/Krein instance," not as new.

**(e) Moduli-rank restriction.** This is where (a)–(d) *could* convert into the only kind of
claim that is novel relative to *all* of the above: a **codimension constraint**. If null
soldering + Krein reality + causal support + no-doubling determinant control jointly forbid
operator moduli that a generic Riemannian finite triple would allow, then the finite-to-EFT
map `F` loses rank, and `rank(dF) < dim M_EFT` becomes provable. Claim class: **prediction,
only if proved**. Acceptance: an explicit moduli computation (Cacic 0902.2068 style) showing
the constrained moduli dimension is strictly below `dim M_EFT`, or an explicit relation
`R(θ_EFT) = 0`. This is the program's actual novelty bet.

**Summary of §3.** Items (a)–(d) are *structurally* null-edge-specific relative to the
Euclidean spectral-action mainstream but are individually within or adjacent to existing
Lorentzian/Krein and causal-set literature, so they should be claimed as *Lorentzian
instances with finite-graph control*, not as inventions. Item (e) is the only route to a
claim that is novel against the *entire* comparison set, and it is currently unproved.

---

## 4. Electroweak mass language via FMS / gauge-invariant composites

The guardrail "do not say local gauge symmetry literally breaks" is exactly the FMS
(Fröhlich–Morchio–Strocchi) posture reviewed in Maas 2305.01960 and used in the lattice
weak/Higgs work 2603.12882. Recommended phrasing rules for Gate E:

1. **Physical states are gauge-invariant composites.** The physical W/Z/Higgs are
   composite, gauge-invariant operators built from the Higgs doublet and the gauge fields
   (e.g. `H†H` for the scalar, `H† D_μ H`-type bilinears for the vector channel). The
   elementary, gauge-variant fields are *not* the asymptotic states.

2. **Perturbative masses are the leading term of an FMS expansion.** Expanding the
   gauge-invariant composite correlator around the vacuum value of `H` (a fixed
   trivialization / unitary-gauge section `H_0`) reproduces, at leading order, the
   conventional W/Z/Higgs propagators and masses. The FMS statement is that the composite
   spectrum *matches* the perturbative spectrum in the SM, not that gauge symmetry breaks.

3. **Null-edge translation, gauge-invariant.** State W/Z mass as: *holonomies / link
   variables that fail to preserve a Higgs reference section acquire quadratic edge cost;
   the stabilizer direction (photon) remains gapless.* The mass term appears only after a
   vacuum/trivialization expansion of a gauge-invariant link–condensate mismatch
   functional `‖U_e·H − H‖²`-type object, never from a gauge-fixed `H_0` taken as physical.

4. **What to avoid.** Do not write "the Higgs vev breaks `SU(2)×U(1)`." Do not treat
   unitary-gauge `H_0` as a physical state. Do not call the photon "the unbroken
   generator"; call it "the stabilizer direction of the reference section, which stays
   gapless." Do not claim the composite/elementary spectrum match is itself a null-edge
   result — it is an FMS result the program *inherits*.

5. **Lattice anchor.** 2603.12882 (weak and Higgs physics from the lattice) is the right
   citation for the statement that this gauge-invariant composite picture is the
   *non-perturbatively correct* one on a lattice/graph, which is precisely the null-edge
   setting. Use it to justify that the finite-graph electroweak mass story is legitimate
   only in gauge-invariant composite form.

---

## 5. The parameter-count ledger (generic quiver vs. finite spectral triple vs. null-edge constrained)

The ledger must be a **moduli-deficit ledger**, comparing the *dimension of free operator
data* in three columns against `dim M_EFT`. Counts below are template slots, not asserted
numbers: each must be filled by an explicit moduli computation (Cacic 0902.2068 for the
finite-triple column) before being quoted in a manuscript. Symbols, not values, are used
where a value is not yet derived.

### 5.1 Three model spaces

```
M_quiver   : generic Bratteli/quiver spectral-action data (2401.03705)
M_finite   : finite (real, even, possibly Krein) spectral triple Dirac moduli (0902.2068 / 1804.09482)
M_null     : M_finite intersected with the null-edge constraints (null soldering,
             Krein reality, causal support, no-doubling determinant control,
             forbidden counterterm set)
```

with maps `M_null ↪ M_finite ↪ (data feeding) M_quiver` and the EFT map
`F : M_null -> M_EFT`.

### 5.2 Ledger template (fill the dimension column by explicit computation)

| Data block | dim in `M_quiver` | dim in `M_finite` | dim killed by null-edge constraint | dim in `M_null` |
| --- | --- | --- | --- | --- |
| Graph / quiver / Bratteli combinatorics | `q_graph` | fixed graph (0) | — | 0 |
| Vertex algebra / rep content (gauge group + reps) | `q_rep` | `r_rep` | anomaly + null-soldering selection | `n_rep` |
| Null-frame / tetrad / soldering data | n/a (Riemannian) | metric frame `r_frame` | **null degeneracy** removes timelike-frame moduli | `n_frame` |
| Edge weights / link stiffness | `q_w` | `r_w` | causal-support normalization | `n_w` |
| Higgs / off-diagonal block (Yukawa `Y_u,Y_d,Y_e,Y_ν`) | `q_Y` | `r_Y` | checkerboard rank/texture restriction | `n_Y` |
| Majorana / sterile block `M_R` | `q_M` | `r_M` | Krein reality / chirality | `n_M` |
| Higgs potential params (`λ`, and `v` via normalization) | `q_V` | `r_V` | spectral-action normalization (if imposed) | `n_V` |
| Gauge couplings `g_1,g_2,g_3` | via spectral norm. | via spectral norm. | Chamseddine–Connes-type relation (if imposed) | `n_g` |
| Spectral function `f` moments / cutoff `Λ` | `q_f` | `r_f` | — | `n_f` |
| Allowed counterterms / Wilson coeffs (Gate C set) | `q_ct` | `r_ct` | **null soldering + Krein forbid Pauli/dispersion subset** | `n_ct` |
| **Total** | `dim M_quiver` | `dim M_finite` | `Δ_null` | `dim M_null` |

### 5.3 The comparison that decides reconstruction vs. prediction

```
dim M_quiver  ≥  dim M_finite  ≥  dim M_null  =  dim M_finite − Δ_null
```

- **Reconstruction-only iff** `rank(dF) = dim M_EFT` (the constrained finite data still has
  at least as many independent knobs as the SM has EFT parameters, and they map onto them
  surjectively-on-tangent). Then every SM input is freely stored, nothing is forced.
- **Prediction iff** `rank(dF) < dim M_EFT`, i.e. `Δ_null` is large enough that the image
  `F(M_null)` has positive codimension in `M_EFT`, **or** an explicit relation
  `R(θ_EFT) = 0` holds on the image.

The conceptual warning from the plan (§16.15) must be kept in the ledger: **count
codimension, not raw parameters.** Field redefinitions and redundant operator coordinates
(unitary equivalences of the finite triple, basis changes, gauge redundancies) can fake a
parameter deficit. The honest invariant is `rank(dF)`, computed modulo the equivalence
group acting on `M_null`.

### 5.4 Why the generic columns are reconstruction-only by construction

`M_quiver` and `M_finite` are *designed* to be expressive enough to host the SM, so they
generically satisfy `rank(dF) = dim M_EFT` (they fit, they don't predict). Therefore **the
only column that can yield a prediction is `M_null`, and only through `Δ_null`.** This is
the single most important structural fact for Gate F: novelty lives entirely in the size
and codimension-character of `Δ_null`.

---

## 6. Is the unified mass plan reconstruction-only, or can it produce codimension constraints?

**Current honest status: reconstruction-only.** As written, the operator-unification layer
is a Lorentzian/Krein instance of finite-spectral-triple / quiver spectral-action
reconstruction (§§1–2), and no `Δ_null` term has yet been *proved* to lower
`rank(dF)` below `dim M_EFT`.

**Plausible (not yet established) routes to a codimension constraint**, in rough order of
credibility:

1. **Forbidden-counterterm codimension (most credible).** If null soldering + Krein reality
   provably forbid a class of operator perturbations (e.g. a Pauli / anomalous-magnetic-
   moment term, or a specific Lorentz-dispersion counterterm), then the image of `F` lies in
   the hypersurface `{that Wilson coefficient = 0}` — a genuine codimension-≥1 constraint.
   This is structural and finitely checkable. **Best near-term bet.**

2. **No-doubling determinant constraint.** If the determinant-branch audit (§3c, §7) shows
   that absence of doublers forces a relation among edge weights / soldering data, that
   relation descends to a relation among kinetic normalizations in `M_EFT`.

3. **Spectral-action gauge–Higgs relation.** *If* a spectral-action normalization is
   actually imposed (not just "a YMH action emerges"), the Chamseddine–Connes-type relation
   among `g, g', g_s, λ` (and the associated `v`) is a codimension constraint — but it is
   **inherited from the spectral action, not from null edges**, and it is RG-scale
   dependent and historically not phenomenologically exact. Claim with care.

4. **Anomaly-/representation-selection.** If null-edge axioms + anomaly cancellation force a
   representation class or the generation number, that is a discrete prediction. This is the
   most ambitious and least supported route.

**Stop rule (from plan §17.11, endorsed):** *if the null-edge theorems do not reduce
freedom, force structure, or control scaling, the work is null-edge reconstruction, not a
new mass theory.* The audit adds: reconstruction here is specifically *a special case of
published quiver / finite-triple reconstruction*, so the manuscript must not present the
reconstruction layer as the novelty — only `Δ_null`-based structural/codimension results
may carry the novelty claim.

---

## 7. Gate-C counterterms and branch-control parameters that must enter the ledger

Gate C (flat branch count, determinant/propagator-zero classification, species/doublers,
Krein, chirality) supplies the operator-data moduli that the Euclidean spectral-action
literature does *not* track, and these are exactly the entries whose removal builds
`Δ_null`. The ledger's "allowed counterterms / branch-control" rows must include:

1. **Determinant-branch data.** Number and type of solutions of `det D_+(q) = 0` (real
   branches, complex branches, high-`q` null singularities) — each spurious branch is
   either a doubler to be killed (reducing physical content) or an instability (fatal).
   Source leads: Yumoto–Misumi 2112.13501 (lattice fermions as spectral graphs),
   Basak–Chakrabarti–Kishore 2501.10336 (minimally-doubled spectra, flavored-chirality
   diagnostics), Catterall 2311.02487 (reduced Kähler–Dirac mirror/chiral issues).

2. **Doubler multiplicity after Krein doubling.** Krein/indefinite structure can *double*
   the state count; the net physical multiplicity (and its chiral content) is a ledger
   entry, and any constraint forcing decoupling of unwanted branches is a `Δ_null`
   contribution.

3. **Chirality / flavored-chirality diagnostic.** Whether the operator supports the
   observed chiral gauge content, and at what cost in extra (mirror) states. A forced
   absence of mirror states would be a strong structural constraint.

4. **Forbidden Pauli / anomalous-moment / dimension-5–6 counterterms.** The subset of EFT
   Wilson coefficients that null soldering + Krein reality set to zero. **This is the most
   promising single codimension source (see §6.1).** Each forbidden term is one unit of
   codimension in `M_EFT`.

5. **Lorentz-dispersion counterterm.** Presence/absence of a specific higher-order
   dispersion correction from the discrete null symbol (Gate-D continuum-symbol audit;
   Boguña–Krioukov 2506.18745 convergence caveats). A forced dispersion relation, or its
   forced absence, is a falsifiable structural prediction.

6. **Branch-decoupling / weight-normalization relations.** Any relation among edge weights
   or soldering normalizations required for no-doubling — these become relations among
   kinetic normalizations downstream.

**Ledger instruction:** every Gate-C item above appears twice — once as a *free modulus* in
the `M_finite` column (generic finite triples allow it) and once in the `dim killed`
column for `M_null` (null/causal/Krein control removes or constrains it). The signed sum of
the "dim killed" column is `Δ_null`, the program's entire prediction budget.

---

## Deliverable A — Novelty-boundary table (known vs. null-edge-specific)

| Item | Known quiver / spectral-action / finite-triple | Null-edge-specific residue | Honest claim class |
| --- | --- | --- | --- |
| Finite YMH from a first-order operator on a graph | **Yes** (2401.03705 quiver spectral action) | — | Reconstruction (special case of known) |
| Graded square `D² = -K + Φ_H² + curvature + frame` | **Yes** (Lichnerowicz; hep-th/9503153, hep-th/9612149) | Null/Krein signature of the square | Reconstruction; signature is a Lorentzian instance |
| Higgs = off-diagonal block, `Φ_H²` zero-order block | **Yes** (NCG inner fluctuation) | — | Reconstruction |
| Gauge bosons = inner fluctuations; W/Z = orbit, photon = stabilizer | **Yes** (`G/Stab(H_0)` quotient metric) | — | Structural, given SM group + rep |
| FMS gauge-invariant composite W/Z/Higgs spectrum | **Yes** (2305.01960, 2603.12882) | — | Inherited; not null-edge novelty |
| Higgs radial mass `m_h²=2λv²` | **Yes** (Morse–Bott Hessian) | — | Representation/reconstruction |
| Plücker identity `det P = Σ|ψ_i∧ψ_j|²`, massless ⇔ collinear | Classical linear algebra (not spectral action) | — | Finite identity (clean, but classical) |
| **Null soldering** of first-order symbol | No (Euclidean frames) | **Yes** | Structural / definitional (conditional) |
| **Causal retarded/advanced support** of discrete propagator | No (elliptic) | **Yes** | Structural (conditional; convergence caveat) |
| **Determinant-branch behavior of null Clifford symbol** (nonzero null vector, `det=0`) | No (Euclidean: `det=0` only at `q=0`) | **Yes** | Structural + fatal-flaw detector |
| **Krein / indefinite-inner-product** structure | Partly (1804.09482 pseudo-Riemannian triples) | Finite-graph Krein instance | Lorentzian instance (not new vs. pseudo-Riem. lit.) |
| **Moduli-rank restriction** `rank(dF) < dim M_EFT` | No (generic triples fit, don't predict) | **Yes, if proved** | **Prediction** (currently unproved) |

---

## Deliverable B — Gate-F parameter / moduli ledger template

Use the table in §5.2 with the three columns `M_quiver / M_finite / M_null`, plus a
`dim killed` column whose signed sum is `Δ_null`, and the decision rule of §5.3:

```
dim M_null = dim M_finite − Δ_null
reconstruction-only  ⇔  rank(dF) = dim M_EFT
prediction           ⇔  rank(dF) < dim M_EFT   (codimension > 0)   OR   ∃ R: R(θ_EFT)=0 on image
```

Mandatory rows (the Gate-C / branch-control block from §7): determinant-branch count,
Krein-doubling multiplicity, chirality diagnostic, **forbidden Pauli/anomalous-moment
counterterms**, Lorentz-dispersion counterterm, branch-decoupling weight relations.

Mandatory discipline: compute `rank(dF)` **modulo the equivalence group** (unitary
equivalence of triples, basis/gauge redundancy), because raw parameter counting overstates
deficits. A deficit survives only if it is a genuine codimension of the image.

Fill instruction: each `dim` cell stays symbolic until backed by an explicit moduli
computation (Cacic 0902.2068 for `M_finite`; the constraint analyses of §3 and §7 for
`Δ_null`). Do not quote numeric parameter counts in the manuscript until those computations
exist.

---

## Deliverable C — Manuscript paragraph: why this is not generic lattice gauge theory with null labels

> The reconstruction layer of this program — a first-order operator on a finite graph whose
> square yields a covariant Laplacian, a zero-order Higgs block `Φ_H²`, and
> curvature/connection terms, with the spectral action delivering a Yang–Mills–Higgs
> functional — is deliberately *not* claimed as new. It is a Lorentzian instance of the
> finite-spectral-triple and quiver/network spectral-action reconstruction theory
> (Chamseddine–Connes; van Suijlekom et al.), and the electroweak mass content is stated in
> the gauge-invariant composite (FMS) language whose non-perturbative validity is
> established on the lattice. What is specific to the present construction is confined to
> four Lorentzian/finite-graph features absent from that Euclidean theory: the primitive
> transport symbol is a *degenerate null* soldering form rather than a non-degenerate frame;
> the discrete propagator carries *retarded/advanced causal support*; the *determinant of
> the null Clifford symbol can vanish on a nonzero mass shell*, so doublers must be
> controlled at the determinant level rather than by checking that a coefficient vector is
> nonzero; and the Hilbert space carries a *Krein/indefinite* inner product with the
> attendant reality and chirality algebra. These features are individually adjacent to
> existing pseudo-Riemannian-triple, causal-set, and lattice-fermion literature, so we claim
> them as a *coherent finite-graph package*, not as inventions. The program rises above
> "generic lattice gauge theory with null labels" only to the extent that this package
> *reduces operator freedom*: if null soldering, Krein reality, causal support, and
> no-doubling jointly forbid operator moduli that a generic finite triple would allow, the
> finite-to-EFT map loses rank and a codimension constraint on Standard-Model inputs
> follows. We state explicitly that, at present, only the structural pieces are
> established; the codimension claim is a target, and until it is proved the work is honest
> null-edge reconstruction, not a derivation of the mass spectrum.

---

## Deliverable D — Verdict on first realistic prediction targets

**Realistic near-term (structural, finitely checkable):**

1. **A forbidden-counterterm codimension result** — null soldering + Krein reality provably
   set a specific Wilson coefficient (Pauli / anomalous-moment, or a named Lorentz-
   dispersion term) to zero. This is the single best first prediction target: it is
   structural, finite, and directly yields `codim ≥ 1` in `M_EFT`. (§6.1, §7.4–7.5.)

2. **A Yukawa rank / texture / zero-pattern restriction** from the checkerboard / super-
   Dirac square — e.g. a forced rank deficiency or forbidden entry pattern in the Yukawa
   block. Structural; predictive only if it constrains `M_EFT` beyond field redefinition.

3. **A no-doubling determinant relation** among edge weights / soldering normalizations,
   descending to a kinetic-normalization relation. (§3c, §7.6.)

**Possible but caveated:**

4. **A spectral-action gauge–Higgs coupling relation** (Chamseddine–Connes type) — only if
   a spectral-action normalization is actually imposed; it is inherited, RG-scale dependent,
   and not historically exact. Claim only with these caveats.

**Not realistic near-term (do not advertise):**

- Numerical particle mass values; the Yukawa hierarchy; `v`, `λ` numbers; `Λ_QCD`; the
  proton mass (QCD supplies confinement/running; Plücker supplies only invariant
  accounting); the generation number from anomaly selection.

**Single recommended first target:** prove a **forbidden-counterterm codimension theorem**
(target 1). It is the only candidate that is simultaneously (a) genuinely outside the
quiver / Euclidean-finite-triple reconstruction class, (b) finitely / machine-checkable,
and (c) a true codimension constraint satisfying `rank(dF) < dim M_EFT`. Everything else is
either reconstruction (already known) or long-horizon.
