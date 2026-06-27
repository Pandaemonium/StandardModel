# Branch-count interpretation against the G3 categories (Gate C, job C2b)

Type: no-build audit / interpretation job. No Lean, Lake, pre-commit, or build
command was run. The standalone branch-count oracle
`Scripts/experiments/null_edge_branch_count.py` was re-run (stdout only, no repo
build artifacts touched) to reproduce the raw numbers interpreted below.

This is the **C2b** artifact. It interprets the raw branch data (C2a output,
`AgentTasks/null-edge-branch-script-report.md`) against the **frozen G3
acceptance/failure categories** in
`AgentTasks/null-edge-branch-count-acceptance-criteria.md` (Sections 1-6), using
the determinant-level protocol
`AgentTasks/null-edge-flat-branch-count-protocol.md` and the Krein data status in
`AgentTasks/null-edge-krein-stability-audit.md`. Gate C context is carried from
`AgentTasks/aristotle-wave-integration-triage.md` Sections 2.2, 5, 6.

Claim label (Working Plan 18.2): **consistency check / no-go interpretation
(S)**. This document classifies branches and renders a Gate C verdict; it
certifies nothing about operator safety. Per the criteria document, no category
is reclassified after seeing the data without a prior edit to the G3 criteria
file; every classification below cites a category (1.1-1.8) and the Section-2
columns that justify it.

---

## 0. The single most important fact about this dataset

The C2a oracle implements protocol steps 1-6 and the multiplicity part of step 8.
It does **not** compute the four columns that the G3 criteria (Section 2, "Hard
requirements") declare jointly load-bearing for separating benign (1.2-1.5) from
fatal (1.6-1.7):

| Required column (Section 2) | Computed by C2a? | Consequence for classification |
| --- | --- | --- |
| `energy_real` (`|z|=1` vs `!=1`) | **Yes** (energy-slice scan) | usable |
| `growth_rate` (`log|z|`, sign) | **No** (only real/complex tag) | 1.7 vs 1.5 undecided |
| `chirality` (`Gamma_s` L/R) | **No** (kernel dim only) | 1.1 cone content unconfirmed |
| `internal_grading` (`chi_E`) | **No** | 1.3 separation impossible |
| `gauge_content` (phys vs gauge) | **No** | tree step 1 cannot run |
| `krein_sign` (`J`-norm sign) | **No** (only `doubled_mult`) | tree step 2 cannot run |
| `h_scaling` (physical/gapped) | **No** | 1.2 vs 1.6 undecided |
| `removal_term` | **No** | 1.2 cure unconfirmed |

Per the criteria document's hard requirement and Section 6 guardrails, **a branch
missing `energy_real`, `krein_sign`, `gauge_content`, or `h_scaling` is
"classification pending" — never "harmless" and never "doubler" by default.**
`gauge_content`, `krein_sign`, and `h_scaling` are missing for *every* branch in
this dataset. Therefore:

- No determinant-zero branch in this dataset may be assigned a benign category
  (1.2-1.5) here. Doing so would violate the Section 6 guardrail directly.
- The high-momentum real branches may not be downgraded below "fatal-doubler
  **candidate** (1.6), pending the missing columns."
- The pervasive complex branches may not be downgraded below "fatal-complex
  **candidate** (1.7), pending the missing columns."

This is the governing constraint on everything below. The interpretation is
therefore mostly a **pending-with-a-hard-stop** verdict, not a clean per-branch
acquittal. That is the honest reading the guardrails require.

---

## 1. Classification of the origin branch `q = (0,0,0,0)`

Raw data (reproduced): `u = (0,0,0,0)`, `p(q) = 0`, `p^2 = 0`,
`is_coeff_zero = true`, `connected_to_origin = true`, massless Clifford kernel
dim = 4, massive-operator kernel dim = 4, Krein-doubled kernel dim = 8.

Decision-tree pass (criteria Section 3):

1. `gauge_content`: **not computed** -> step 1 cannot be discharged.
2. `krein_sign`: **not computed** -> step 2 cannot be discharged.
3. `energy_real`: the continuum line `(q2,q3,q4) = (0,0,0)` through the origin is
   an explicitly **real** branch (protocol Section 6, script check). PASS toward
   the physical axis.
4. `connected_to_origin`: **yes** -> candidate **1.1 physical continuum
   branch**. The tree then requires "`ker_dim` / `chirality` the intended single
   Dirac cone, `h_scaling` physical".

Classification verdict. **Origin = the category-1.1 candidate (the one branch the
construction is supposed to carry), but its 1.1 status is PENDING confirmation,
not established.** Two specific gaps block promotion to confirmed 1.1:

- Kernel content. At exactly `q = 0` the symbol is `c(0) = 0`, so the reported
  kernel dimension is the full 4 (massless) / 8 (doubled), not the intended
  2-dim L+R Weyl pair. The "single Dirac cone, 2-dim kernel, correct
  `Gamma_s` decomposition" required by 1.1 is a statement about the branch
  *approached as a null direction* (protocol Section 2), and the chirality
  decomposition under `Gamma_s` (kept separate from `chi_E`) is **not computed**
  (step 7 deferred). So "intended single Dirac cone" is asserted by design, not
  verified by this data.
- `h_scaling`. The 1.1 definition requires the branch to stay at finite physical
  energy as `h -> 0`. `h_scaling` is **not computed**. The massive shift to
  `p^2 = m^2` (the desired Dirac mode) is likewise unverified per-branch.

Acceptance-role note (criteria 1.1): exactly one 1.1 branch *must* be present;
its absence is itself a failure. The data are consistent with the origin being
that branch (a real branch connected to `q = 0` exists), so the "no physical mode
reconstructed" failure trigger of Section 3.1 is **not** indicated. But "consistent
with" is not "confirmed"; the cone-content and `h_scaling` checks (step 7,
scaling step 2) are required to bank 1.1.

---

## 2. Classification of the four high-momentum three-pi corners

Raw data (reproduced): the discrete corner scan over `q_a in {0,pi}^4` gives
exactly **5** massless null corners = 1 origin + the **4** permutations of three
`pi` and one `0`. The warning corner `q = (pi,pi,pi,0)`:

```text
u = (-2,-2,-2,0),  p(q) != 0  (is_coeff_zero = false),
S1 = -6, S2 = 12,  u^T G^{-1} u = -3/4*12 + 1/4*36 = 0,
p^2 = 0  (massless null),  Clifford kernel dim = 2,
massive-op kernel dim = 2,  Krein-doubled kernel dim = 4.
```

The other three corners `(pi,pi,0,pi)`, `(pi,0,pi,pi)`, `(0,pi,pi,pi)` are
symmetric and carry identical data (the script confirms `(0,1,1,1)` with
`p^2 = 0`, kernel dim 2). The remaining 11 corners are non-null (`p^2 = -2` at
the 10 one-/two-`pi` corners; `p^2 = +4` at `(pi,pi,pi,pi)`).

Decision-tree pass for each three-pi corner:

1. `gauge_content`: **not computed** -> step 1 not discharged.
2. `krein_sign`: **not computed** -> step 2 not discharged.
3. `energy_real`: the warning-corner family `(q2,q3,q4) = (pi,pi,0)` and its
   permutations lie on the **measure-zero real propagating locus** (protocol
   Section 6, explicit script check; energy-slice scan finds real roots only on a
   measure-zero locus, 18 of 432 sampled roots). So these corners are **real /
   propagating**, not complex artifacts. This is the decisive fact: it routes
   them down the **doubler axis (1.6)**, not the complex-instability axis.
4. `connected_to_origin`: **no** (high momentum, `u != 0`, `p != 0`).
5. `h_scaling` / `removal_term`: **not computed** -> the 1.2-vs-1.6 split cannot
   be made.

Classification verdict. **Each of the four three-pi corners, including
`q = (pi,pi,pi,0)`, is a category-1.6 FATAL-DOUBLER CANDIDATE, classification
PENDING the missing `gauge_content`, `krein_sign`, and `h_scaling` columns.**
Explicitly, per criteria 1.5 "Caution" and 1.6, and the protocol Section 3:

- They are genuine determinant-level null branches (`det c(p) = 0`,
  `dim ker = 2`), **not** coefficient-zero artifacts (`p != 0`). This is the
  concrete, finite refutation of any no-doubling claim resting on
  `p(q) = 0 iff q = 0` (criteria Section 6 guardrail; triage Section 5 hard
  stop).
- They are **real / propagating** (energy_real), so the 1.5 "harmless complex
  artifact" exit is **closed** for them. They are **not** auto-1.5; the criteria
  forbid a "looks harmless" tag, and the warning corner family is "never
  auto-1.5".
- They are high-momentum (not connected to origin), so they are not the 1.1
  continuum branch.
- Whether they gap off (-> 1.2 benign), are Krein-negative (-> 1.4 benign), are
  pure gauge (-> 1.3 benign), or survive as real positive-`J` non-gauge poles
  (-> 1.6 fatal) **cannot be decided from this dataset**. Until then the honest
  label is exactly the protocol's: "determinant-level null branch, classification
  pending", carried at **fatal-doubler-candidate (1.6)** severity for gating
  purposes (a pending high-momentum real branch may not be treated as benign).

Massive-block note (criteria Section 5.1). The massive-operator kernel dim is
also 2 at each corner: the `+ Gamma_s Phi_H = m gamma_5` block shifts the shell
`p^2 = 0 -> p^2 = m^2` but does **not** remove these corners (each massless
corner maps to a massive corner at shifted `q`). So `Phi_H` alone is not a cure;
a 1.6 candidate of the massless operator maps to a 1.6 candidate of the massive
operator. The "good" 1.2 outcome (mass block lifts the branch to `~1/h`) is
exactly the `h_scaling` datum that is **not computed**.

---

## 3. The positive-dimensional null variety: fatal, pending, or artifact?

Raw data (reproduced): grid scan `N = 12` (20736 points) finds **201** massless
null grid points, with `max |Im p^2| ~ 3.23`. Because `p^2` is complex-valued on
the real torus, `p^2 = 0` is one complex = two real equations on `T^4`, so `Z_0`
is generically a **2-real-dimensional variety**, not a finite point set; the 201
points scale like a surface, and the 5 corners are special points on it.

Interpretation against the categories:

- **What is settled (and it is fatal to one specific claim).** The existence of a
  positive-dimensional determinant-zero set is a hard, regression-checked fact.
  It **definitively refutes** the coefficient-zero no-doubling argument
  (`p(q) = 0 iff q = 0`), which would predict the null set to be the single point
  `q = 0`. Per the criteria Section 6 guardrail and protocol Section 8 "Failure",
  "a no-doubling claim resting only on coefficient-zero analysis" is a Gate C
  failure condition, and this variety realizes it. So this result is **fatal to
  the naive no-doubling claim** and to any continuum/chirality theorem that rests
  on it (triage Section 5 hard stop stands).

- **What is NOT settled (and may not be called an artifact).** Whether the
  variety as a *physical* object is fatal (contains surviving 1.6 doublers
  and/or 1.7 instabilities in the physical sector) or benign (every component
  off the origin gaps off / is Krein-negative / is pure gauge / is a genuine
  harmless artifact) is **PENDING**. The per-component classification needs, for
  each connected component: `energy_real` (most of the variety lies off the
  measure-zero real locus and is therefore complex-energy, routing to the
  1.7/1.5 axis; a measure-zero sub-locus is real, routing to the 1.6 axis),
  plus `krein_sign`, `gauge_content`, and `h_scaling` — **none of which are
  computed**.

Verdict. **The positive-dimensional null variety is FATAL to the coefficient-zero
no-doubling claim (settled), and its physical-branch status is PENDING (not
artifact).** Per the guardrail "If data are insufficient for classification, say
pending rather than safe," and "Do not call a determinant-zero branch harmless
without the required columns," it is explicitly **not** an artifact at this stage.
A positive-dimensional null set is also a strong structural warning: it means
there are infinitely many determinant-zero branches to classify, so any cure must
act on a whole variety, not a finite corner list.

---

## 4. The complex-energy branch result and what data are still needed

Raw data (reproduced): energy-slice scan (slice grid 6, 216 spatial points, 432
roots) -> **18 real propagating roots (`|z1| = 1`)** vs **414 complex-energy
roots (`|z1| != 1`)**. Complex branches are pervasive on generic real spatial
slices; real propagating roots live on a measure-zero locus. This is the
Chernodub-style non-Hermitian warning (`arXiv:1701.07426`).

Interpretation against the categories. A complex-energy branch routes through the
tree as: (step 1) gauge? (step 2) Krein-negative? (step 3) `energy_real = no`,
then `growth_rate > 0` (or not provably non-growing) -> **1.7 fatal complex
instability**, else decaying/never-excited-with-reason -> 1.5 harmless artifact.
The data give the `energy_real = no` branch but **none** of the gates that decide
1.7 vs 1.4 vs 1.5:

Verdict. **The pervasive complex-energy branches are category-1.7 FATAL-COMPLEX
CANDIDATES, classification PENDING.** They may **not** be called 1.5 harmless
artifacts: the 1.5 tag requires an explicit `benign_reason` (e.g. decaying and
demonstrably never excited by the causal/retarded evolution), and "pervasive
complex branches" is a warning, not a benign reason (criteria 1.5 Caution;
protocol Section 6). Equally, 1.7 cannot yet be *confirmed* because the
physical-sector membership and growth sign are not computed.

Data still needed to classify (criteria Section 2; protocol steps 6-8;
Krein-audit Section 3):

- **Krein sign (`krein_sign`)** — the `J`-inner-product sign on each (doubled)
  kernel. This is the *only* legitimate basis for a 1.4 tag and decides
  physical-sector membership (positive-`J`) before any 1.7 call. Compute via
  protocol step 8 / Krein-audit step 4 (the `J`-signature ledger). **Decisive
  C2b question** (criteria 1.7): whether any complex branch lies in the physical
  positive-`J` sector after Krein projection.
- **Gauge content (`gauge_content`)** — physical vs pure-gauge/constraint, with
  `Gamma_s`/`chi_E`/`epsilon_form` kept strictly separate (criteria 1.3
  Separation rule). A complex branch that is pure gauge is projected out before
  the 1.7 question arises.
- **`h`-scaling (`h_scaling`)** — physical / gapped (`~1/h`) / divergent /
  artifact, per branch, for both the massless and the massive (`+ m gamma_5`)
  operator (criteria Section 5.1; protocol step 5; Open Questions 6.13.9 scaling
  step 2). Distinguishes a complex pole that gaps off (cutoff) from one that
  survives in the continuum.
- **Growth rate (`growth_rate = log|z|`) and conjugate-pair structure** — the
  sign of `log|z|` under the *chosen* (retarded/causal) evolution law decides
  growing (dangerous, 1.7) vs decaying/marginal; nonreal eigenvalues must appear
  in complex-conjugate pairs (Krein-audit step 4-5). The current scan reports
  only real-vs-complex, not the signed growth rate.

Non-overclaim guardrail (criteria 1.4 / 1.7; Krein-audit Sections 2, 4). A Krein
`J`-self-adjointness result (C5) does **not** clear a 1.7 branch and does **not**
certify real spectrum, positivity, or unitary evolution. The Krein-audit's
Section 2.3 counterexample (a `J`-self-adjoint operator with purely imaginary
spectrum and `D_- D_+ = -I`) must be paired with any Krein theorem (C5 + C7).
A complex growing mode in the physical positive-`J` sector is fatal regardless of
`J`-self-adjointness.

---

## 5. Gate C verdict: passed, failed, or pending

**Gate C is NOT passed. It is FAILED as-stated for any no-doubling / continuum /
stability promotion (the hard stop stands), with the precise per-branch
fatal-vs-benign categorization PENDING the missing load-bearing columns. The
final 1.8 (requires-redesign) determination is itself pending those columns.**

Reasoning against the acceptance criteria Section 3.1 rollup:

- **Passage is impossible from this dataset.** Passage requires "exactly one 1.1
  branch survives and all 1.6/1.7 are absent or cured by an explicit, defined
  mechanism." Here (a) the 1.1 origin branch is only a *candidate* (cone content
  and `h_scaling` unverified, Section 1); (b) there are four 1.6 fatal-doubler
  candidates and a positive-dimensional null variety, none shown to gap off, be
  Krein-negative, be pure gauge, or be removed by any defined `removal_term`
  (Sections 2-3); (c) there are pervasive 1.7 fatal-complex candidates, none
  shown to be outside the physical sector or non-growing (Section 4); and (d) the
  `krein_sign`, `gauge_content`, `h_scaling`, `growth_rate`, and `chirality`
  columns required to cure any of these are **not computed**. Passage cannot be
  claimed.

- **Definitive 1.8 kill-switch cannot yet be engaged either.** 1.8 requires
  showing that *no* admissible projection or doubler-removal term can jointly
  cure 1.1/1.6/1.7. That impossibility has not been demonstrated — the cures
  (Krein-sign projection, Wilson/Ginsparg-Wilson/overlap/domain-wall removal
  term) have not been computed and ruled out. So the architecture is not yet
  *proven* to require redesign.

- **Honest current status.** This matches the protocol Section 8 "Current
  status": the flat tetrahedral retarded operator has (i) 4 high-momentum corner
  null branches plus a positive-dimensional null variety, and (ii) pervasive
  complex-energy branches; neither the unmodified massless operator nor the
  `+ Gamma_s Phi_H` mass block removes them. Therefore the operator **does not
  pass Gate C as-is**; passage would require a Krein-sign projection and/or an
  explicit doubler-removal term plus the `h`-scaling and chirality
  classification — i.e. exactly the missing columns. The naive no-doubling claim
  is **refuted now** (Section 3); the question of whether a *defined cure* exists
  is **pending**.

Mandatory stop/downgrade actions now in force (criteria Section 4; triage
Section 5):

- **1.6 (fatal-doubler candidates):** STOP — do not promote any
  continuum/chirality theorem that assumes no-doubling. Downgrade the no-doubling
  claim to the mandatory wording: "retardedness removes coefficient-zero doublers
  only; high-momentum determinant-level doublers survive and require an explicit
  removal mechanism." Halt heavy Gate D continuum work (Working Plan 21.4).
- **1.7 (fatal-complex candidates):** STOP — do not claim stability, real
  spectrum, or unitary evolution. Record the Chernodub-style warning explicitly;
  downgrade all stability language to "Lorentzian adjointness audited; spectral
  stability open." Any C5 Krein theorem must be paired with the C7 counterexample.
- A definitive escalation to **1.8** is triggered later if, after the missing
  columns are computed, a real positive-`J` non-gauge corner survives without
  gapping and no admissible removal term clears it without destroying the 1.1
  cone's chirality, or a growing physical-sector mode cannot be projected out.

---

## 6. Recommended next proof/audit jobs and operator-redesign requirements

### 6.1 Data-completion jobs (compute the missing load-bearing columns) — top priority

These are the precondition for *any* final per-branch classification; until they
land, every benign tag is forbidden.

1. **Step-7 kernel chirality decomposition (job T16 / C3 input).** For each
   branch (origin continuum, the four three-pi corners, sampled points on the
   null variety) decompose `ker(i c(p) + m gamma_5)` under `Gamma_s` (spacetime
   chirality, L/R) and, in a **separate** column, under `chi_E` (internal
   grading). Confirm or refute the "single Dirac cone, 2-dim, correct L+R" content
   of the origin branch (Section 1) and the vector-like-vs-chiral signature of the
   corners (Section 2). Honor the grading separation guardrail (criteria 1.3).
2. **Step-8 explicit Krein `J`-sign per kernel (jobs C5 + C7, paired).** Compute
   the `J`-inner-product sign on every (doubled) kernel -> `krein_sign`, the only
   legitimate basis for a 1.4 tag and for physical-sector membership. Bank the
   finite Krein-double self-adjointness theorem (`Ddbl_kreinSelfAdjoint`,
   Krein-audit Section 5.1) **only** alongside the C7 counterexample that
   `J`-self-adjoint does not imply real spectrum/stability.
3. **`h`-scaling classification (Gate D input; Open Questions 6.13.9 scaling
   step 2).** For each branch, for both the massless and the `+ m gamma_5`
   massive operator, classify `h_scaling` as physical / gapped (`~1/h`) /
   divergent / artifact. This is what splits the four corners and the null variety
   into benign-1.2 vs fatal-1.6, and the complex branches into cutoff vs surviving
   (criteria Section 5.1 massive-branch audit, backlog C4).
4. **Signed growth rate and conjugate-pair audit (C2a extension / Krein-audit
   steps 4-5).** Extend the energy-slice scan to report `growth_rate = log|z|`
   (signed) per root and verify conjugate-pair structure; flag any growing
   physical-sector mode. This is what splits the 1.7 candidates into confirmed
   1.7 vs decaying/marginal.
5. **`gauge_content` determination.** Establish, independently of `Gamma_s`,
   whether any branch kernel is a genuine pure-gauge/constraint direction (-> 1.3)
   rather than a propagating dof. Required before any branch can be projected out
   as gauge.

After 1-5, **re-run C2b** (re-interpret with the now-complete columns) before any
Gate C verdict beyond the present "not passed / pending" is recorded. Per the
criteria, new categories or reclassifications require editing the G3 criteria file
*before* re-reading the data.

### 6.2 Operator-redesign / removal-mechanism requirements

Triggered now because the 1.6/1.7 candidates are real/pervasive and the mass
block does not cure them:

6. **Explicit doubler-removal term (backlog C9/C10; chiral-mechanism strategy).**
   Specify and kernel-check a Wilson / Ginsparg-Wilson / overlap / domain-wall
   `removal_term` and re-run the branch count. Only a *defined, kernel-checked*
   mechanism may move a three-pi corner (or a real component of the null variety)
   from 1.6 to 1.2. The chiral-mechanism strategy's recommendation (pilot
   domain-wall / SSH zero-mode first, internal chiral rep as co-pilot) is the
   right first pilot — but only after the Section 6.1 evidence exists.
7. **Krein-sign projection as a candidate cure.** If `krein_sign` data show the
   corners or complex branches are Krein-negative, define the projection and
   verify the physical sector retains exactly the 1.1 cone with correct chirality
   (criteria 1.4 non-overclaim: projection licenses removal of 1.4 only; it never
   clears a positive-`J` 1.6 or 1.7).
8. **Architecture redesign trigger (1.8) if cures fail.** If, after 6-7, a real
   positive-`J` non-gauge corner survives without gapping and no admissible
   removal term clears it without destroying the 1.1 cone's chirality/anomaly
   content, or a growing physical-sector mode cannot be projected out, engage the
   Gate C kill switch (criteria 1.8 / Section 4.3): change the soldering frame,
   adopt an explicit Ginsparg-Wilson/overlap/domain-wall construction, or replace
   the operator, and restart Gate C (C1/C2) from scratch (record in job G0 DAG).

### 6.3 Standing hard stops (carry verbatim; criteria Section 6; triage Section 5)

- Coefficient-zero no-doubling is **not sufficient** and is **refuted** by the
  positive-dimensional null variety; only "retardedness avoids coefficient-zero
  doublers; determinant-level branches remain to be tested" is sayable.
- Do not call any determinant-zero branch harmless without its `energy_real`,
  `krein_sign`, `gauge_content`, and `h_scaling` columns. A 1.5 tag needs an
  explicit `benign_reason`; the three-pi corner family is never auto-1.5.
- Krein `J`-self-adjointness is a Lorentzian-adjointness audit, not stability,
  real spectrum, positivity, unitary evolution, anomaly safety, or chirality. It
  may remove 1.4 branches; it never clears 1.6 or 1.7.
- The `+ Gamma_s Phi_H` mass block shifts the shell `p^2 = 0 -> p^2 = m^2`; it
  lifts a branch only where `h_scaling` data show `~1/h` gapping. It is not a
  no-doubling mechanism on its own, and `Box_null`/`Phi_H^2` must not be
  double-counted.
- No Gate D / continuum-square / chirality / dynamical promotion until Gate C
  clears.

---

## 7. Classification summary table

| Branch / object | Raw data | Category verdict | Why pending / settled |
| --- | --- | --- | --- |
| Origin `(0,0,0,0)` | `p=0`, real, ker 4 (8 doubled), connected to origin | **1.1 candidate (PENDING)** | real & origin-connected, but cone chirality (step 7) and `h_scaling` unverified |
| `(pi,pi,pi,0)` + 3 perms | `p!=0`, `p^2=0`, ker 2 (4 doubled), real propagating, high-momentum | **1.6 fatal-doubler candidate (PENDING)** | real -> doubler axis; not auto-1.5; `gauge_content`/`krein_sign`/`h_scaling` missing |
| Positive-dim null variety (201 pts, 2-real-dim) | `p^2=0` surface, mostly complex-energy off corners | **Fatal to coeff-zero no-doubling (SETTLED); physical status PENDING (not artifact)** | refutes `p=0 iff q=0`; per-component energy/Krein/gauge/h-scaling missing |
| Complex-energy branches (414/432 roots) | `|z1|!=1`, pervasive | **1.7 fatal-complex candidate (PENDING)** | not 1.5 (no `benign_reason`); `krein_sign`/`gauge_content`/`growth_rate`/`h_scaling` missing |
| **Gate C (operator)** | above | **NOT PASSED; fails as-stated; final category (pending vs 1.8) PENDING** | no confirmed single 1.1 + uncured 1.6/1.7 candidates; cure columns not computed |

This document is an interpretation/no-go audit, not a proof that the operator is
safe or that it definitively requires redesign. Gate C passage requires the
completed columns of Section 6.1 plus defined, kernel-checked cures of
Section 6.2 — not the present tags.
