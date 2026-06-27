# Null-edge chiral mechanism: decision strategy

**No-build strategy/audit deliverable. Generated 2026-06-26.**

This report answers the question posed in `PROMPT.md`: which chiral mechanism
should the null-edge program try first, and what is the smallest pilot
theorem/audit that would show it is viable. No Lean, Lake, pre-commit, or build
command was run.

Context sources consulted:

- `docs/CONVENTIONS.md`, "Still not fully locked" list (chiral mechanism is
  explicitly unlocked), plus the locked branch-count, Krein, and grading
  guardrails.
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, Sections 18-20 (the
  gate ladder A-F, blocker ranking, Gate E physics audit, and the explicit list
  of four chirality mechanisms in 20.8).
- `AgentTasks/null-edge-unified-mass-proof-chain.md`, entries T16 and T18.
- `docs/NULLSTRAND.md`, no-doubling/branch-count and Krein double guardrails.

Status of this document: **physics-model choice, not locked.** Every conclusion
below is a working recommendation, labeled as strategy/audit, and is gated on
the finite checks it names. Nothing here claims Standard Model chirality. Per
the guardrail, that claim requires branch count (T16), a chosen and validated
chiral mechanism (T18 reps), and the anomaly audit (T18 sums) to all pass.

---

## 0. Where chirality sits in the program

From the gate ladder (Working Plan 20.1) and the proof chain
(T13 -> T14 -> T15,T16 -> T17,T18):

```text
Gate A convention freeze        (Gamma_s / chi_E / epsilon_form separation, sign audit)
Gate B finite dual-soldered algebra (T13 commutator, T14 square, T15 frame)
Gate C flat branch / stability audit (T16 determinant branch count; Krein double)
Gate D continuum square limit
Gate E physics audits           <-- chirality + anomaly live here (T18)
Gate F prediction gate          (T17 moduli rank)
```

Two locked guardrails frame the entire chirality question:

1. **Branch count is determinant-level, not coefficient-level** (CONVENTIONS
   "Branch-count / no-doubling test"; NULLSTRAND "No-doubling"). A nonzero
   Lorentzian null Clifford symbol `p(q)` can still satisfy `p(q)^2 = 0` and
   carry a Clifford kernel. The tetrahedral example in Working Plan 20.5
   (`q = (pi,pi,pi,0)`, `u = (-2,-2,-2,0)`, `u^T G^{-1} u = 0`) is a concrete
   high-momentum null-singularity candidate. **Any chiral-spectrum claim built
   before T16 is unsupported.**

2. **Krein self-adjointness is not stability and not chiral imbalance**
   (CONVENTIONS "Krein / Lorentzian adjointness"; NULLSTRAND "Krein double").
   `J`-self-adjointness does not by itself imply real spectrum, positivity,
   unitarity, anomaly safety, or a chiral SM sector. So a chiral mechanism that
   *only* leans on Krein structure is, by the project's own locked rule,
   insufficient on its own.

These two facts already pre-shape the mechanism comparison below.

### 0.1 Nielsen-Ninomiya assumptions stated explicitly (not handwaved)

The fermion-doubling no-go (Nielsen-Ninomiya) forbids a single chiral Weyl
fermion on a lattice when **all** of the following hold simultaneously:

```text
(NN1) a Hermitian, local (exponentially bounded) one-particle Hamiltonian/Dirac op;
(NN2) exact translation invariance on a regular periodic lattice;
(NN3) a conserved, locally defined chiral charge (exact U(1) chiral symmetry);
(NN4) correct continuum dispersion near the physical pole.
```

The conclusion under (NN1)-(NN4) is: net chirality summed over the Brillouin
zone is zero, i.e. doublers of opposite chirality must appear. Every viable
lattice chirality mechanism evades the theorem by **explicitly breaking exactly
one hypothesis**, and must say which. The null-edge program has two structural
features that bear directly on these hypotheses and must be tracked, not assumed
away:

- The active operator `D_+^h = sum_a c(alpha^a)(T_a - I)/h` is **retarded /
  non-Hermitian** as written; the Krein double restores a *Lorentzian*
  adjointness, not Euclidean Hermiticity. This touches (NN1).
- The intended substrate is a **decorated null-tetrad graph with local frame
  data** `ell_a(x), alpha^a(x)` and holonomy around null diamonds (CONVENTIONS
  "Local frame and covariance"; NULLSTRAND "Universal null frames"). A generic
  causal poset is **not exactly translation invariant**, touching (NN2). But the
  *flat fixed periodic patch* used for the branch-count audit (T16) **is**
  translation invariant, so on that patch NN applies in full force.

The discipline this report enforces: **on the flat patch, assume NN holds and
audit doubling honestly; only invoke translation-non-invariance as an evasion
for the curved/full construction, and only after naming it.**

---

## 1. Mechanism comparison against the current null-edge architecture

The current architecture (locked pieces) is: dual-soldered Dirac symbol
`D_N = sum_a c(alpha^a) nabla_{ell_a}`; super-Dirac `D = i D_N + Gamma_s Phi_H`
with the graded `+Phi_H^2` square; three separated gradings `Gamma_s`
(spacetime chirality), `chi_E` (internal), `epsilon_form` (form degree); a Krein
retarded/advanced double for Lorentzian adjointness; and a determinant-level
branch-count protocol still to be discharged.

Candidate mechanisms from Working Plan 20.8 and the CONVENTIONS unlocked list:

### 1.A Internal chiral representation

Put left and right Weyl channels in **different internal representations** of the
gauge group, with the mass/`Phi_H` block as the only object connecting them
(`B_Y = M : E_R -> E_L`, the chirality-flip gap). Chirality is then a property of
the *internal* index space `chi_E`, carried alongside the spacetime symbol.

- Fit to architecture: **excellent.** The Yukawa checkerboard (T5/T6) already
  models exactly this: null L/R propagation + a constant chirality-flip `M`
  gives `K_L = M M^dagger`, `K_R = M^dagger M`. The graded square (T14) keeps
  `Gamma_s` and `chi_E` separate, which is precisely what a chiral rep needs.
- NN status: does **not** by itself evade doubling. It assigns reps to whatever
  modes the kinetic operator produces; if the kinetic operator doubles (T16
  finds extra branches), this mechanism faithfully reproduces a **vector-like**
  doubled spectrum. It is a *labeling* layer, not a *doubler-removal* layer.
- Verdict: necessary bookkeeping for any chiral SM claim, but **not a standalone
  doubling solution.** It is the representation/anomaly side of T18, not the
  Nielsen-Ninomiya side of T16.

### 1.B Domain-wall / defect zero modes

Introduce a defect (a wall in an extra coordinate or in an internal/mass
parameter that changes sign); a single chiral zero mode localizes on the wall
(Jackiw-Rebbi / Kaplan domain-wall fermions; SSH in 1D). The bulk stays gapped
and effectively vector-like; the **boundary** carries the net chirality.

- Fit to architecture: **good and low-risk to pilot.** It does not require
  rebuilding the dual-soldered symbol. It only requires a position-dependent
  `Phi`/mass term `m(x)` that changes sign — i.e. a spatially varying internal
  block, which the architecture already permits (`Phi_x` is local data on the
  decorated graph; `[nabla_a, Phi_H]` already appears in the square).
- NN evasion: **explicit and standard.** Domain-wall fermions evade NN by
  breaking (NN2)/(NN3): the chiral charge is not conserved in the bulk; the wall
  hosts an exact zero mode by an **index theorem** (number of zero modes = sign
  change of the mass profile), so it is robust rather than fine-tuned.
- Krein interaction: the localized zero mode lives in the physical sector; the
  Krein double must be checked to not pair the wall mode with an anti-wall mode
  of opposite chirality (the doubler reappears at the opposite wall under
  periodic boundary conditions — a known feature that must be audited, not
  hidden).
- Verdict: **the most testable mechanism with a genuinely finite, decisive pilot
  theorem** (a 1D SSH or Jackiw-Rebbi zero-mode count). It produces a hard,
  index-type yes/no that does not depend on the unfinished continuum limit.

### 1.C Overlap / Ginsparg-Wilson-like finite construction

Construct a finite Dirac operator `D` satisfying a Ginsparg-Wilson relation
`{D, Gamma_s} = D Gamma_s D` (or the overlap form `D = 1 + Gamma_s sgn(H)`).
This yields an exact lattice chiral symmetry (a modified `Gamma_s'`) and a
genuine index, evading NN by replacing exact chiral symmetry (NN3) with the
modified GW symmetry.

- Fit to architecture: **poor in the near term.** The overlap operator needs a
  sign function `sgn(H)` of a Hermitian kernel `H`. The null-edge operator is
  **retarded/non-Hermitian** with only a *Krein* (Lorentzian) adjoint, not a
  Euclidean Hermitian structure. Defining `sgn(H)` requires either a positive
  Hermitian `H = D^dagger D`-type object or a spectral projection that the Krein
  setting does not hand you for free. This collides directly with the locked
  Krein non-overclaim rule.
- NN evasion: cleanest in principle (exact GW chiral symmetry + index), but
  **the construction cost is highest** and it presumes spectral machinery the
  program has not built.
- Verdict: **strong long-term target, wrong first pilot.** Revisit only after a
  Hermitian (or `J`-positive physical-sector) kernel is established at Gate C.

### 1.D Non-Hermitian / Krein chiral imbalance

Use the non-Hermitian retarded operator (or a `PT`/Krein-structured operator) to
produce a chiral imbalance directly from complex spectral branches.

- Fit to architecture: superficially natural (the operator is already retarded),
  but **flatly blocked by the locked Krein rule.** CONVENTIONS and NULLSTRAND
  both state Krein self-adjointness does not imply chiral imbalance, real
  spectrum, or stability. Working Plan 20.5 explicitly cites Chernodub
  `arXiv:1701.07426` as a **warning**: a non-Hermitian evasion that exhibits
  complex spectral branches is exactly the failure mode (complex growing modes
  in the physical sector) the branch-count audit is designed to catch.
- NN evasion: would break (NN1) (Hermiticity), but at the cost of complex
  energies / loss of unitarity in the physical sector unless a positive
  observable subsector is constructed — which is itself an open Gate C item.
- Verdict: **highest risk, do not pilot.** Treat as a hazard to audit against,
  not a mechanism to adopt. If T16 finds complex growing physical-sector
  branches, that is a failure signal (Section 5), not a chirality feature.

### 1.E Summary table

```text
mechanism                 architecture fit   NN evasion route          near-term pilot   risk
internal chiral rep       excellent          none (labeling only)      indirect (T5/T6)  low but insufficient alone
domain-wall / defect      good               breaks NN2/NN3, index     YES, decisive     low-medium
overlap / GW finite       poor (needs H)     modified chiral sym       no (needs Gate C) medium-high
non-Hermitian / Krein     blocked by rule    breaks NN1, complex E     no                high / hazard
```

---

## 2. What each mechanism requires from branch count, Krein stability, anomaly

Stated as explicit preconditions so nothing is handwaved.

### 2.1 Internal chiral representation requires

- **Branch count (T16):** that the kinetic operator produce the *intended*
  number of low-energy Weyl branches with *definite* chirality per branch, with
  no extra physical doublers. A chiral rep on a doubled (vector-like) branch set
  cannot give a chiral SM. So this mechanism is **downstream of, and conditional
  on, a clean T16 result.**
- **Krein:** the rep assignment must be compatible with the Krein inner product
  (left/right channels must sit in a `J`-consistent decomposition); otherwise
  the "chirality" is not a stable observable.
- **Anomaly (T18 sums):** the assigned hypercharges/reps must satisfy, per
  generation, `sum_L Weyl tr(T^a {T^b,T^c}) = 0`, `sum_i Y_i = 0`,
  `sum_i Y_i^3 = 0`, plus the mixed gauge-gravitational `sum_i Y_i = 0` with
  color and weak multiplicities. This is the numeric anomaly check (low
  difficulty, Lean-provable).

### 2.2 Domain-wall / defect zero modes require

- **Branch count (T16):** that the *bulk* spectrum is gapped (massive branches
  only) so the wall zero mode is isolated, and that periodic boundary conditions
  do not silently reintroduce an opposite-chirality mode at the anti-wall
  without it being accounted (the lattice domain-wall "mirror" mode). The
  determinant branch count is what certifies bulk gapping.
- **Krein stability:** the localized zero mode must lie in the `J`-positive
  physical sector; the Krein double must not pair the wall mode with a growing
  complex partner. Finite-box spectral stability audit (Working Plan 20.6
  questions: real eigenvalues? paired non-growing nonreal modes? `D_- D_+`
  positive on the physical subspace?).
- **Anomaly:** same numeric anomaly sums as 2.1 once the surviving boundary reps
  are read off. The index of the wall operator must reproduce the chiral
  multiplet content whose anomalies then cancel.

### 2.3 Overlap / GW-like requires

- **Branch count:** GW guarantees a correct index, but a **Hermitian (or
  `J`-positive) kernel `H`** must first exist so that `sgn(H)` is well defined;
  this is a Gate C deliverable not yet met.
- **Krein:** the locked rule means a Euclidean-Hermitian `H` is not available
  directly; one needs a positive physical-sector projection first. **Hard
  precondition.**
- **Anomaly:** GW reproduces the continuum anomaly automatically (this is a
  strength), but only once the operator exists.

### 2.4 Non-Hermitian / Krein imbalance requires

- **Branch count:** would need T16 to show that complex branches produce a
  *stable, projectable* chiral imbalance — but complex growing physical-sector
  modes are the **failure** criterion, so this requirement is in tension with
  the audit's pass condition.
- **Krein:** explicitly insufficient by locked rule.
- **Anomaly:** undefined until a real, projectable chiral spectrum exists.

---

## 3. Recommendation: pilot domain-wall / defect zero modes first

**Recommended first mechanism: domain-wall / defect zero modes (1.B), piloted on
a finite SSH / Jackiw-Rebbi toy, with the internal chiral representation (1.A)
carried alongside as the representation/anomaly bookkeeping layer.**

### 3.1 Reasons

1. **Decisive finite pilot exists.** A 1D SSH chain or a discretized
   Jackiw-Rebbi mass kink gives an exact, finite, index-type zero-mode count
   that is provable in Lean *without* the unfinished continuum limit (Gate D) or
   the full curved construction. This matches the project preference for cheap
   finite checks before expensive continuum theorems (Working Plan 20.1).
2. **Explicit, honest NN evasion.** Domain-wall fermions break (NN2)/(NN3) in a
   named, standard way and protect the zero mode by an index theorem. This
   satisfies the guardrail "keep Nielsen-Ninomiya assumptions explicit."
3. **Architecture-compatible.** It uses the already-permitted local internal
   block `Phi_x` and the `[nabla_a, Phi_H]` term already present in the
   super-Dirac square; it does not require revoking any locked convention.
4. **Does not depend on Krein doing impossible work.** Unlike 1.D, it does not
   ask Krein self-adjointness to manufacture chirality; Krein is used only for
   its sanctioned role (Lorentzian adjointness) and is *audited*, not relied on.
5. **Internal chiral rep (1.A) is complementary, not competing.** Run it as the
   labeling layer (T5/T6 Yukawa checkerboard already prototypes it) and as the
   home of the anomaly sums (T18). It is cheap and necessary, but it cannot
   remove doublers, so it is not the *mechanism* under test — the wall is.

### 3.2 Why not the others first

- **Overlap/GW (1.C):** best evasion in principle, but needs a Hermitian /
  `J`-positive kernel the program has not built; piloting it now would front-load
  the hardest unbuilt machinery.
- **Non-Hermitian/Krein (1.D):** blocked by the locked Krein non-overclaim rule
  and flagged by the Chernodub warning; treat as a hazard, not a candidate.
- **Internal chiral rep alone (1.A):** insufficient by itself (labeling, not
  doubler removal); promoted to co-pilot, not lead.

### 3.3 Risks of the recommendation

- **Mirror-mode risk.** On a finite/periodic lattice the wall is accompanied by
  an anti-wall hosting the opposite-chirality mode. The pilot must *count both*
  and show the intended net chirality is obtained by the chosen boundary
  conditions (open vs periodic), not by hiding the mirror. If the mirror cannot
  be separated or gapped, this is a partial failure (Section 5).
- **Extra-dimension cost.** Kaplan domain-wall fermions live in one higher
  dimension; the program must decide whether the "wall coordinate" is a genuine
  extra null/internal direction or an internal parameter. The 1D SSH /
  Jackiw-Rebbi pilot sidesteps this by using an internal mass profile, but the
  embedding into the full d = s+1 null-tetrad architecture remains an open design
  question to flag.
- **Krein-sector placement risk.** The zero mode must be shown to live in the
  `J`-positive physical sector; if the finite-box stability audit (20.6) shows
  it pairs with a growing complex mode, the mechanism is not yet viable.
- **Branch-count dependence.** The bulk-gapping claim ultimately needs T16; the
  pilot can be done first in isolation, but the SM-chirality claim cannot be
  asserted until T16 passes on the relevant patch.

---

## 4. Smallest finite toy theorem to test the chosen mechanism

**Pilot P-DW: a finite SSH / Jackiw-Rebbi domain-wall localized zero mode with
an index count.** This is the smallest decisive test and is pure finite linear
algebra (Lean-provable under the pinned toolchain with `Mathlib`).

### 4.1 Primary target (1D SSH, fully finite)

Take a finite 1D bipartite chain of `2N` sites with a real hopping pattern that
changes dimerization across one bond (one domain wall) — the SSH model with a
defect. Build the single-particle Hamiltonian/Dirac matrix `H_SSH` in chiral
(sublattice) basis:

```text
H_SSH = [[0, Q], [Q^dagger, 0]],   Gamma_s = diag(+I, -I),   {H_SSH, Gamma_s} = 0
```

Theorem shape (kernel-clean, no `sorry`):

```text
theorem ssh_domain_wall_zero_mode :
    -- with a single sign-changing mass/dimerization defect,
    -- H_SSH has exactly one zero-energy eigenvector,
    -- and it is a +1 eigenvector of Gamma_s (definite chirality),
    -- localized (amplitude decays away from the wall).
    Module.finrank K (LinearMap.ker H_SSH) = 1
      ∧ (zero_mode ∈ chiralEigenspace Gamma_s (+1))
      ∧ (localization bound on the wall site amplitudes)
```

Companion index/counting lemma (the NN-evasion content):

```text
theorem ssh_index_eq_wall_count :
    -- net chirality of the kernel = number of sign changes of the mass profile
    chiralIndex H_SSH = numberOfWalls m_profile
```

### 4.2 Mirror-mode honesty lemma (required, not optional)

```text
theorem ssh_periodic_mirror :
    -- under periodic BC a second, opposite-chirality zero mode appears at the
    -- anti-wall; under open BC with one wall it does not.
    (periodic →  finrank ker = 2 ∧ net chirality = 0)
      ∧ (openWall →  finrank ker = 1 ∧ net chirality = ±1)
```

This lemma is the load-bearing honesty check: it states *where the doubler goes*
and *which boundary condition* yields net chirality, so the pilot cannot
accidentally overclaim a chiral mode it did not isolate.

### 4.3 Why this is the right smallest test

- It is finite, exactly diagonalizable in closed form, and needs no continuum
  limit, no curved frame, and no scalar-kinetic reconstruction.
- It exercises exactly the mechanism under test: a localized definite-chirality
  zero mode protected by an index, with the doubler explicitly accounted.
- It reuses the existing chiral/`Gamma_s` separation convention and the
  checkerboard structure already prototyped in T5/T6.
- Success or failure is unambiguous and kernel-checkable.

### 4.4 Acceptance / failure for the pilot

```text
PASS:  ssh_domain_wall_zero_mode + ssh_index_eq_wall_count + ssh_periodic_mirror
       all compile with no sorry, net chirality is ±1 under the open-wall BC,
       and the zero mode is localized.
FAIL:  no robust zero mode; or the zero mode has indefinite chirality; or the
       mirror cannot be separated from the physical wall mode under any
       admissible BC (doubler is inescapable in the physical sector).
```

---

## 5. What would count as failure -> downgrade to vector-like reconstruction

Per the locked stop rules (Working Plan 20.12) and the Krein/branch-count
guardrails, the program must **downgrade the chiral-SM ambition to a
vector-like / non-chiral null-edge reconstruction** if any of the following
hold. (Downgrade means: keep P1, P1.5, and the finite super-Dirac algebra as a
legitimate finite reconstruction program, but stop asserting that the
construction yields the chiral Standard Model.)

```text
F1. Branch count (T16) shows unavoidable physical doublers of opposite
    chirality on the flat patch that cannot be gapped, projected out via the
    Krein constraint, or removed by the chosen wall/overlap mechanism. (This is
    the direct Nielsen-Ninomiya outcome: with the assumptions in force, net
    chirality is zero.)

F2. The domain-wall pilot's mirror mode cannot be separated under any admissible
    boundary condition, i.e. the physical sector always contains the
    opposite-chirality partner -> the realized spectrum is vector-like.

F3. The Krein finite-box stability audit (20.6) shows the would-be chiral zero
    mode lives outside the J-positive physical sector, or pairs with a growing
    complex mode -> no stable chiral observable.

F4. The only way to get a chiral imbalance is the non-Hermitian/Krein route
    (1.D) and it produces complex growing modes in the physical sector
    (the Chernodub failure mode) -> not a physical chiral spectrum.

F5. A consistent chiral content can be placed by reps but the per-generation
    anomaly sums (sum Y = 0, sum Y^3 = 0, tr T^a{T^b,T^c} = 0, mixed
    gauge-gravitational) cannot be satisfied with the multiplicities the
    construction forces -> the construction cannot host the SM chiral structure.
```

Downgrade posture on failure (this is an acceptable, labeled outcome, not a
collapse): "The null-edge construction is a finite, frame-audited reconstruction
of vector-like fermion mass via the Plucker/`Phi_H^2` obstruction; it does not,
at this stage, realize a chiral gauge spectrum. Chirality remains an open
mechanism problem." This is consistent with the locked claim-label discipline
and the "keep going under finite reconstruction" clause of 20.12.

---

## 6. Exact next Aristotle job prompts

These are ready-to-dispatch job specifications. They mirror the format used in
`AgentTasks/null-edge-unified-mass-aristotle-next-jobs.md`. Job types: **Proof**
(Lean kernel target) and **No-build audit** (written analysis).

### Job C1 (Proof, recommended pilot): SSH / Jackiw-Rebbi domain-wall zero mode

```text
Type: Lean proof/formalization job.
Title: Finite SSH domain-wall localized chiral zero mode with index count.
Target file: PhysicsSM/Draft/NullEdgeDomainWallZeroMode.lean  (import Mathlib).
Goal: Prove the pilot theorems of strategy Section 4:
  (a) ssh_domain_wall_zero_mode: for a finite 2N-site SSH chain with one
      sign-changing dimerization defect, in chiral basis
      H = [[0,Q],[Q^dagger,0]], Gamma_s = diag(+I,-I):
        finrank (ker H) = 1, the zero mode is a +1 eigenvector of Gamma_s, and
        its site amplitudes are bounded by a geometric decay away from the wall.
  (b) ssh_index_eq_wall_count: the chiral index of ker H equals the number of
      sign changes of the mass/dimerization profile.
  (c) ssh_periodic_mirror: under periodic BC a second opposite-chirality zero
      mode appears (net chirality 0); under the open single-wall BC it does not
      (net chirality +-1).
Conventions to honor: keep Gamma_s (spacetime/sublattice chirality) distinct
  from any internal grading; document the mass profile and the BC explicitly;
  define chirality via the +-1 eigenspaces of Gamma_s.
Expected output: kernel-clean Lean theorems, no sorry.
Success criteria: all three compile under the pinned toolchain; the mirror lemma
  is present so net chirality is not overclaimed.
Risk: Low-Medium (finite explicit linear algebra; the decay/localization bound
  is the main bookkeeping).
Guardrail reminder in the handoff: this is a reconstruction/structural pilot, NOT
  a Standard Model chirality claim; NN is evaded by breaking translation
  invariance / exact chiral symmetry at the wall, which must be stated.
```

### Job C2 (Proof, co-pilot anomaly bookkeeping): SM one-generation anomaly sums

```text
Type: Lean proof/formalization job (T18 numeric part).
Title: One-generation Standard Model gauge anomaly cancellation.
Target file: PhysicsSM/Draft/NullEdgeAnomalyCancellation.lean  (import Mathlib).
Goal: With the standard one-generation hypercharge assignments (Q_L, u_R, d_R,
  L_L, e_R, with color factor 3 and weak-doublet factor 2), prove:
    sum_i Y_i = 0           (mixed gauge-gravitational / U(1)-grav),
    sum_i Y_i^3 = 0         (U(1)^3),
    SU(2)^2 x U(1) sum = 0  (sum over left doublets of Y),
    SU(3)^2 x U(1) sum = 0  (sum over colored left fermions of Y),
  using physics-Hermitian normalization Q = T_3 + Y/2, Y(H) = 1 (CONVENTIONS).
Expected output: a single theorem sm_anomaly_cancellation conjoining the sums,
  kernel-clean, no sorry; hypercharges given as explicit rationals.
Success criteria: compiles; the multiplicities (color 3, weak 2) are explicit;
  labeled as a structural consistency check given SM hypercharges (not a
  derivation of the hypercharges).
Risk: Low (finite rational arithmetic; decide/native_decide or norm_num).
```

### Job C3 (No-build audit): domain-wall mechanism vs Krein double and branch count

```text
Type: No-build strategy/audit job.
Title: Domain-wall chirality compatibility with the Krein double and T16.
Goal: Written audit answering:
  (1) Does the wall zero mode lie in the J-positive physical sector of the Krein
      double D_dbl = [[0,D_-],[D_+,0]]? Set up the finite-box spectral stability
      questions of Working Plan 20.6 for the SSH/Jackiw-Rebbi pilot.
  (2) How does the lattice mirror mode interact with the determinant branch
      count (T16)? Specify which periodic-patch determinant zeros correspond to
      the anti-wall mode and whether they are gapped/projected.
  (3) State precisely which Nielsen-Ninomiya hypothesis (NN1-NN4 of this report)
      the embedded-in-full-architecture construction breaks, separating the
      flat-patch case (NN holds) from the curved local-frame case.
Deliverable: AgentTasks/null-edge-domain-wall-krein-branch-audit.md.
Guardrails: do not claim Krein self-adjointness implies chiral imbalance or
  stability; treat Chernodub arXiv:1701.07426 as a warning, not evidence.
Risk: Low (analysis only). Run before scaling the pilot toward the full operator.
```

### Job C4 (No-build audit, contingency): overlap/GW feasibility once a kernel exists

```text
Type: No-build strategy/audit job (defer until Gate C delivers a J-positive or
  Hermitian kernel).
Title: Feasibility of an overlap / Ginsparg-Wilson finite operator on the
  null-edge substrate.
Goal: Determine what Hermitian or J-positive kernel H would be needed to define
  sgn(H) / the overlap operator D = 1 + Gamma_s sgn(H) compatibly with the Krein
  structure, and whether the GW relation {D,Gamma_s} = D Gamma_s D can hold for
  any candidate built from D_+ and its Krein adjoint D_- = D_+^sharp.
Deliverable: AgentTasks/null-edge-overlap-feasibility.md.
Trigger: only after the finite-box stability audit (Job C3 / 20.6) yields a
  positive physical-sector projection. Otherwise mark as blocked.
Risk: Medium (depends on unbuilt spectral machinery; explicitly contingent).
```

### Sequencing

```text
Now (parallel):   C1 (pilot proof)  ||  C2 (anomaly proof)  ||  C3 (audit)
After C1+C3 pass: revisit T16 on the relevant flat patch; then decide on C4.
```

C1 and C2 are independent finite-algebra proof jobs and can run concurrently. C3
is analysis and can run alongside. C4 is contingent on a Gate C positive-sector
result and should be marked blocked until then.

---

## 7. Guardrail compliance checklist

```text
[x] Treated chiral mechanism as a not-yet-locked physics-model choice (Sec 0,3).
[x] Did not claim Standard Model chirality; conditioned it on T16 branch count +
    chosen mechanism + anomaly audit all passing (Sec 0, 2, 5).
[x] Kept Nielsen-Ninomiya assumptions explicit (NN1-NN4, Sec 0.1) and named the
    evaded hypothesis for each mechanism rather than handwaving (Sec 1, 6/C3).
[x] Honored the locked determinant-level branch-count rule (Sec 0, 2, 5).
[x] Honored the locked Krein non-overclaim rule; rejected the pure
    non-Hermitian/Krein chirality route as a hazard (Sec 1.D, 2.4, 5).
[x] Kept Gamma_s / chi_E / epsilon_form separation in all theorem shapes (Sec 4).
[x] Stated an explicit downgrade-to-vector-like failure path (Sec 5).
[x] No Lean/Lake/build command was run; this is a written strategy report only.
```
