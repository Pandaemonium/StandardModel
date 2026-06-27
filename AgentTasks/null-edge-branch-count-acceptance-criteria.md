# Branch-count acceptance criteria (Gate C, job G3)

Type: no-build audit / criteria document. This document defines the
success/failure categories for determinant-level branch-count data **before**
any raw branch numbers are interpreted. It is a precondition for branch-count
interpretation (C2b), not itself a proof that the operator is safe.

Hard sequencing rule (Working Plan 21.6, job G3; 21.4 Gate C kill switch):

```text
G3: branch-count acceptance criteria before interpreting branch data.
C2a: implement script and output raw branch data.
C2b: interpret branches against acceptance/failure criteria.
```

This file is the G3 artifact. C2b may not begin until the categories below are
frozen. Reclassifying a determinant-zero branch after seeing the raw data,
without an entry in this document, is forbidden (see Section 6 guardrails).

Claim label (Working Plan 18.2 four-way system): this is a **consistency
check / no-go criteria (S)** document. It specifies what would pass or fail; it
certifies nothing.

Provenance and program anchors:

- `docs/CONVENTIONS.md`, "Branch-count / no-doubling test" (Locked audit rule),
  "Krein / Lorentzian adjointness" (Locked non-overclaim rule), "Metric
  signature" (mostly-minus, Locked), "Gradings" (`Gamma_s` / `chi_E` /
  `epsilon_form` separation, Locked).
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 20 (gates,
  canonical-obstruction datum, Gate A sign audit) and Section 21 (integration
  freeze, 21.4 Gate C kill switch, 21.6 job G3).
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md` Gate C
  (C1-C12) and the "Gate C is a possible kill switch" note.
- Companion protocol and oracle:
  `AgentTasks/null-edge-flat-branch-count-protocol.md` and
  `Scripts/experiments/null_edge_branch_count.py` (oracle, not a trusted proof;
  AGENTS.md "CAS and oracle policy").
- `AgentTasks/null-edge-krein-stability-audit.md` for Krein-sign data.

Convention lock (carried from CONVENTIONS.md, used throughout):

```text
mostly-minus metric:  g = diag(+,-,-,-),  null modes p^2 = 0,  massive p^2 = m^2.
flat retarded symbol: D_+(q) = sum_a C_a (exp(i q_a) - 1)/h = c(p(q)),
                      C_a = c(alpha^a)  (dual-covector soldering).
massive operator:     D = i D_+ + Gamma_s Phi_H,  [Gamma_s, Phi_H] = 0 (+Phi_H^2).
branch test:          det c(p(q)) = 0  (massless),
                      det(i D_+(q) + Gamma_s Phi_H) = 0  (massive).
```

---

## 0. Scope and the determinant-level premise

The categories classify points `q` on the Brillouin torus `T^4` at which the
branch determinant vanishes:

```text
massless:  det c(p(q)) = (p(q).p(q))^2 = 0   <=>   p(q)^2 = 0
massive:   det(i c(p(q)) + Gamma_s Phi_H) = 0
           reduces (scalar block Phi_H = m, Gamma_s = gamma_5) to (m^2 - p(q)^2)^2 = 0
           <=>  p(q)^2 = m^2
```

Premise (CONVENTIONS.md Locked audit rule; protocol Section 0): the object being
classified is a **determinant zero**, never a coefficient-vector zero. Because
the `alpha^a` form a basis, `p(q) = 0` holds only at `q = 0`. A nonzero
Lorentzian null `p(q)` still has `det c(p(q)) = 0` and a nontrivial Clifford
kernel. Coefficient-zero no-doubling (`p(q) = 0 iff q = 0`) is therefore **not
sufficient** input for any category below; every classification must start from
the determinant/mass-shell condition.

Every determinant-zero point gets exactly one **primary category** from
Section 1. The fatal categories (1.6, 1.7) and the meta-category (1.8) trigger
the stop/downgrade actions of Section 4.

---

## 1. Category definitions

The four passing/benign categories (1.1-1.5) describe branches compatible with
Gate C acceptance. The three fatal categories (1.6-1.8) describe Gate C
failures. A branch is classified by the data columns of Section 2 against the
decision tree of Section 3.

### 1.1 Physical continuum branch

Definition. A determinant-zero component connected to `q = 0` (the continuum
point) whose energy is **real** (propagating, `|z| = 1` on the energy-slice
quadratic of protocol Section 6), whose Clifford kernel has the intended
dimension and chirality content (a single Dirac cone: 2-dim massless kernel, the
L+R Weyl pair, with the correct `Gamma_s` decomposition), and whose `h`-scaling
keeps it at **finite physical energy** as `h -> 0`.

Acceptance role. This is the one branch the construction is *supposed* to carry.
Exactly one such component (per generation/flavor as designed) must be present.
Its absence is itself a failure (the operator reconstructs no physical mode).

Massive case. Under `+ Gamma_s Phi_H` the continuum branch shifts from the null
cone `p^2 = 0` to the mass-shell `p^2 = m^2`, staying real and finite-energy.
This is the desired massive Dirac mode.

### 1.2 Lifted / gapped cutoff branch

Definition. A determinant-zero point of the **finite-`h`** operator whose energy
**diverges like `1/h`** (gaps off to the cutoff) as `h -> 0`, so it is absent
from the continuum theory. Equivalently, a branch that exists only because of the
lattice and is removed in the scaling limit (protocol step 5 / Open Questions
6.13.9 scaling step 2).

Benign role. A high-momentum determinant zero that *provably* gaps off is
harmless: it is not a continuum doubler. Distinguish from 1.5 (artifact that is
benign for a different reason) and from 1.6 (doubler that does *not* gap off).

Massive note. If a massive block `Phi_H` raises a branch's energy to `~ 1/h`
scaling, that branch is lifted/gapped — this is the *good* outcome of a mass
block (it lifts an otherwise unwanted branch). See Section 5.

### 1.3 Pure gauge / constraint branch

Definition. A determinant-zero point whose kernel lies entirely in a
gauge/constraint direction — i.e. the kernel vector is annihilated by the
physical (gauge-invariant) projection, or is a pure-gauge / first-class
constraint mode rather than a propagating degree of freedom. Such a zero is a
redundancy of the description, not a physical state.

Benign role. Pure gauge/constraint zeros are expected and are projected out by
the gauge-invariant (or BRST/constraint) reduction. They must be tagged so they
are not miscounted as physical doublers. Tagging requires the kernel's
gauge/constraint content, not just its dimension.

Separation rule (CONVENTIONS.md Gradings, Locked). Do not use form-degree
grading `epsilon_form` or internal grading `chi_E` to relabel a spacetime
chirality mode as "pure gauge". A constraint branch must be a genuine
gauge/constraint direction, established independently of the spacetime chirality
`Gamma_s`.

### 1.4 Krein-negative nonphysical branch

Definition. A determinant-zero point whose Clifford (or doubled) kernel has
**indefinite or negative `J`-norm** under the Krein inner product `J`. Such a
branch is not in the physical positive-`J` sector and is projected out by the
Krein selection.

Benign role. Krein-negative zeros may legitimately be removed by the Krein-sign
projection (protocol step 8). They are benign *as long as* the projection is part
of the defined dynamics and the physical sector is left with the correct content.

Non-overclaim guardrail (CONVENTIONS.md Krein rule, Locked; backlog C5+C7).
Krein `J`-self-adjointness is a necessary Lorentzian-adjointness audit, **not** a
stability theorem. A Krein-negative tag licenses *projecting out* a branch; it
does **not** by itself certify real spectrum, positivity, unitary evolution, or
absence of growing modes. In particular a complex-energy branch in the physical
(positive-`J`) sector is fatal (1.7) regardless of any `J`-self-adjointness
result.

### 1.5 Harmless high-momentum artifact

Definition. A determinant-zero point at high momentum (away from `q = 0`) that is
benign for a reason **other** than gapping off (1.2), gauge-redundancy (1.3), or
Krein-negativity (1.4): for example, a complex-energy zero off any real energy
slice that is never excited by the (causal, retarded) evolution, or a
measure-zero coincidence that carries no propagating kernel in the physical
sector.

Benign role. Catches high-momentum determinant zeros that are real artifacts of
the finite/retarded construction and demonstrably do not produce a physical
propagating or growing mode. Use only with an explicit reason recorded in the
`benign_reason` column; never as a default "looks harmless" bucket.

Caution. A real-energy, positive-`J`, finite-`h`-surviving high-momentum branch
is **not** a harmless artifact — it is a fatal doubler (1.6). The warning corner
family `(pi,pi,pi,0)` and permutations are *candidates* that must be classified,
not pre-declared harmless (protocol Section 3).

### 1.6 Fatal doubler

Definition. A determinant-zero point **not** connected to `q = 0`, whose energy
is **real** (propagating), whose kernel carries a propagating physical
(positive-`J`, non-gauge) degree of freedom, and which **does not gap off**
(stays at finite physical energy as `h -> 0`). This is a genuine surviving
fermion doubler.

Fatal role. Surviving physical doublers violate the no-doubling requirement and
the intended chiral/anomaly content. Triggers the Section 4 stop/downgrade
action. The flat tetrahedral retarded operator has four high-momentum corner
null branches `(pi,pi,pi,0)` + permutations that are real propagating branches
(protocol Sections 5-6); each is a fatal-doubler candidate until shown to gap
off (1.2), to be Krein-negative (1.4), or to be removed by an explicit
Wilson / Ginsparg-Wilson / domain-wall term.

### 1.7 Fatal complex instability

Definition. A determinant-zero point in the **physical (positive-`J`) sector**
with **complex energy** (`|z| != 1` on the energy-slice quadratic), i.e. a
growing or decaying mode `log|z| != 0` that is not projected out. A growing mode
(`log|z| > 0`) in the physical sector is the dangerous case (Chernodub-style
non-Hermitian instability, `arXiv:1701.07426`).

Fatal role. Complex growing physical modes break unitarity/stability and cannot
be repaired by `J`-self-adjointness alone (CONVENTIONS.md Krein rule). Triggers
the Section 4 stop/downgrade action. Protocol Section 6 finds **pervasive**
complex-energy branches on generic real spatial slices; whether any lies in the
physical sector after Krein projection is the decisive C2b question.

### 1.8 Requires redesign

Definition (meta-category). The branch-count data, taken as a whole, shows that
**no admissible projection or doubler-removal term** within the current
architecture can simultaneously (a) keep exactly one physical continuum branch
(1.1), (b) remove or gap all fatal doublers (1.6), and (c) remove all fatal
complex instabilities (1.7) from the physical sector — or doing so destroys the
intended chirality/anomaly content.

Trigger role. This is assigned to the *operator/architecture*, not to a single
point, when the per-branch fatal categories cannot be jointly cured. It is the
Gate C kill-switch outcome (Working Plan 21.4): the construction must be
redesigned (different soldering frame, explicit Ginsparg-Wilson / overlap /
domain-wall mechanism, or a different operator) before continuum work resumes.

---

## 2. Required data columns for branch-count scripts

Every row of the branch-count table (C2a output, consumed by C2b) must carry the
following columns. A branch with missing classification-relevant columns is
"classification pending", never benign.

| Column | Meaning | Used by category |
| --- | --- | --- |
| `q` | Edge-phase point on `T^4` (the branch location). | all |
| `u = exp(i q) - 1` | Retarded phase vector (regression input). | all |
| `p_mu` | Symbol covector `p(q)_mu = sum_a u_a alpha^a_mu`. | all |
| `p_sq` | `p(q)^2` under mostly-minus `g` (complex in general). | all |
| `m_sq` | Mass-shell target (`0` massless, `m^2` massive). | 1.1, 1.2 |
| `det` | Branch determinant value (regression vs scalar reduction). | gate |
| `is_coeff_zero` | Whether `p(q) = 0` (flag; never sufficient alone). | guardrail |
| `connected_to_origin` | Is the component connected to `q = 0`? | 1.1 vs 1.6 |
| `energy_real` | `|z| = 1` (real/propagating) vs `|z| != 1` (complex). | 1.1, 1.6, 1.7 |
| `growth_rate` | `log|z|` (0 real; >0 growing; <0 decaying). | 1.7 |
| `ker_dim` | `dim ker(i c(p) + Gamma_s Phi_H)`. | all |
| `chirality` | Kernel decomposition under `Gamma_s` (L/R content). | 1.1, 1.6 |
| `internal_grading` | Kernel decomposition under `chi_E` (kept separate). | 1.3 |
| `gauge_content` | Physical vs pure-gauge/constraint content of kernel. | 1.3 |
| `krein_sign` | `J`-norm sign on kernel (+ / - / indefinite). | 1.4, 1.6, 1.7 |
| `doubled_mult` | Multiplicity after Krein doubling `D_dbl`. | 1.4, Section 5 |
| `h_scaling` | physical (finite) / gapped (`~1/h`) / divergent / artifact. | 1.2, 1.6 |
| `removal_term` | Wilson / GW / domain-wall term that removes it, if any. | 1.2, 1.6 |
| `benign_reason` | Explicit reason for a 1.5 tag (required if 1.5). | 1.5 |
| `category` | Primary category 1.1-1.7 (or "pending"). | output |
| `provenance` | Script run id, grid `N`, tolerances, `h`. | audit |

Hard requirements:

- `energy_real`, `krein_sign`, `gauge_content`, and `h_scaling` are jointly
  load-bearing for separating benign (1.2-1.5) from fatal (1.6-1.7). A branch
  missing any of these is "pending", not benign (protocol Section 3).
- `chirality` and `internal_grading` must be reported in **separate** columns
  (CONVENTIONS.md Gradings, Locked); do not collapse `Gamma_s` and `chi_E`.
- Regression columns (`det`, `is_coeff_zero`, `p_sq` vs the inverse-Gram form
  `h^{-2} u^T G^{-1} u`) must agree with the direct spacetime build, or the row
  is rejected as a script error before any classification.

---

## 3. Decision tree for classifying determinant-zero points

Apply per determinant-zero point `q` after the regression checks pass. The tree
yields a primary category 1.1-1.7; the meta-category 1.8 is assigned to the
operator after all points are classified (Section 3.1).

```text
START: q with det = 0 (mass-shell condition met).  [coeff-zero alone is NOT enough]

1. gauge_content = pure gauge / constraint?
     YES -> [1.3 pure gauge / constraint branch]   (project out; not a dof)
     NO  -> go to 2.

2. krein_sign = negative or indefinite (kernel outside positive-J sector)?
     YES -> [1.4 Krein-negative nonphysical branch]  (projected out by Krein)
     NO  (positive-J physical sector) -> go to 3.

3. energy_real?  (|z| = 1)
     NO (complex energy in physical sector):
         growth_rate > 0  (or not provably non-growing under the evolution)?
             YES -> [1.7 fatal complex instability]
             NO  (decaying / never excited by causal evolution, with reason)
                 -> [1.5 harmless high-momentum artifact]  (record benign_reason)
     YES (real / propagating) -> go to 4.

4. connected_to_origin?
     YES -> ker_dim / chirality the intended single Dirac cone, h_scaling physical?
                YES -> [1.1 physical continuum branch]
                NO  -> anomaly: wrong continuum content -> escalate to 1.8 review
     NO (high momentum) -> go to 5.

5. h_scaling = gapped (~1/h) OR removed by an explicit removal_term?
     YES -> [1.2 lifted / gapped cutoff branch]
     NO  (stays at finite physical energy, positive-J, real, non-gauge)
         -> [1.6 fatal doubler]
```

Notes on the order (matches protocol Section 3, items 1-4):

- Gauge/constraint and Krein filters come first because they remove a kernel
  from the physical sector outright; only physical-sector branches can be fatal.
- `energy_real` separates the complex-instability axis (1.7/1.5) from the
  doubler axis (1.6); `connected_to_origin` then isolates the intended continuum
  branch (1.1) from high-momentum branches; `h_scaling`/`removal_term`
  separates benign lifted branches (1.2) from surviving doublers (1.6).
- A 1.5 tag requires an explicit `benign_reason`; "looks harmless" is not a
  reason. The warning corner family is never auto-1.5.

### 3.1 Operator-level rollup to 1.8 (requires redesign)

After all points are classified, assign the operator to **1.8 requires
redesign** if any holds:

```text
- zero branches in category 1.1 (no physical continuum mode reconstructed); or
- one or more category 1.6 (fatal doubler) remains with NO admissible
  removal_term / Krein projection that removes it without also removing 1.1; or
- one or more category 1.7 (fatal complex instability) remains in the physical
  sector under the chosen evolution; or
- the only way to clear 1.6/1.7 destroys the intended chirality/anomaly content
  of the 1.1 branch.
```

Otherwise, if exactly one 1.1 branch survives and all 1.6/1.7 are absent or
cured by an explicit, defined mechanism, the operator **passes Gate C**.

---

## 4. Stop / downgrade actions for fatal categories

These actions are mandatory and are triggered by the categories, not by
discretion after seeing the data.

### 4.1 Fatal doubler (1.6)

```text
STOP: do not promote any continuum/chirality theorem that assumes no-doubling.
```

- Halt heavy Gate D continuum work that depends on a clean spectrum (Working
  Plan 21.4: "Do not launch heavy D-continuum work until C1/C2 return").
- Downgrade the no-doubling claim to: "retardedness removes coefficient-zero
  doublers only; high-momentum determinant-level doublers survive and require an
  explicit removal mechanism."
- Required next step (not optional): specify and audit an explicit
  Wilson / Ginsparg-Wilson / overlap / domain-wall `removal_term` (backlog C9,
  C10), then re-run branch count and re-classify. Only a defined, kernel-checked
  mechanism may move a 1.6 branch to 1.2.
- If no admissible removal term exists without destroying the 1.1 branch's
  chirality, escalate the operator to 1.8.

### 4.2 Fatal complex instability (1.7)

```text
STOP: do not claim stability, real spectrum, or unitary evolution.
```

- Record the Chernodub-style warning explicitly (protocol Section 6): complex
  branches are pervasive on generic real spatial slices.
- A `J`-self-adjointness result (C5) does **not** clear a 1.7 branch
  (CONVENTIONS.md Krein rule). Pair any Krein theorem with the counterexample
  (C7) that `J`-self-adjoint does not imply real spectrum.
- Required next step: show the physical-sector complex branches are either absent
  after Krein projection or non-growing under the defined (retarded/causal)
  evolution. Until then, downgrade all stability language to "Lorentzian
  adjointness audited; spectral stability open."
- A growing physical-sector mode that cannot be projected out escalates the
  operator to 1.8.

### 4.3 Requires redesign (1.8)

```text
STOP: Gate C kill switch engaged. Freeze the architecture.
```

- Do not promote any finite-square, continuum, or chirality theorem that depends
  on this operator (Working Plan 21.2 Gate A / 21.4 Gate C ordering).
- Downgrade the program statement to the honest fallback (Working Plan 20.1,
  21.7): "finite kinematic / reconstruction theorems hold; the relativistic
  continuum Dirac claim is not supported by this operator as-is."
- Required next step: redesign — change the soldering frame, adopt an explicit
  Ginsparg-Wilson/overlap/domain-wall construction, or replace the operator —
  and restart Gate C (C1/C2) from scratch. Record the redesign trigger in the
  dependency graph (job G0).

### 4.4 Benign categories

Categories 1.2-1.5 carry no stop action **provided** their distinguishing column
(`h_scaling`, `gauge_content`, `krein_sign`, or `benign_reason`) is filled with
an explicit, audited justification. A benign tag without its justifying column is
treated as "pending" and blocks Gate C passage until resolved.

---

## 5. Interaction with massive `Phi_H` blocks and Krein doubling

### 5.1 Massive `Phi_H` blocks

Convention (CONVENTIONS.md super-Dirac signs; Working Plan 21.2):

```text
D = i D_+ + Gamma_s Phi_H,   [Gamma_s, Phi_H] = 0  =>  (Gamma_s Phi_H)^2 = +Phi_H^2.
scalar block Phi_H = m, Gamma_s = gamma_5:
  det(i c(p) + m gamma_5) = (m^2 - p^2)^2,   branch <=>  p^2 = m^2.
```

Classification consequences (protocol Section 4):

- A mass block **shifts** the null cone `p^2 = 0` to the mass-shell `p^2 = m^2`;
  it does **not**, by itself, remove branches. Each massless branch becomes a
  massive branch at shifted `q`. So `Phi_H` alone is *not* a no-doubling
  mechanism: a 1.6 fatal doubler of the massless operator generically maps to a
  1.6 fatal doubler of the massive operator.
- The *good* outcome (1.2) is when a massive block raises an unwanted branch's
  energy to `~1/h` scaling (it lifts/gaps it). The branch-count script must test
  this per branch via the `h_scaling` column for the massive operator, not assume
  it.
- `Box_null` and `Phi_H^2` are two sides of one on-shell condition, not two
  additive mass sources (Working Plan 18.6 guardrail). Do not double-count a
  mass contribution when deciding whether a branch is lifted.
- Sign hygiene (CONVENTIONS.md Gradings/super-Dirac, Locked): `Phi_H` may be odd
  under internal grading `chi_E` but must commute with spacetime chirality
  `Gamma_s` for the `+Phi_H^2` convention. Do not use `chi_E` or `epsilon_form`
  to repair a `Gamma_s` sign error when arguing a branch is lifted.

Required massive-branch audit (backlog C4): for each massless branch, record
whether the `Phi_H` block lifts it (-> 1.2), preserves it at the shifted shell
(-> stays 1.6/1.1 as before), or introduces a new complex branch (-> 1.7).

### 5.2 Krein doubling

Construction (protocol step 8):

```text
D_dbl = [[0, D_-], [D_+, 0]],   D_- = J D_+^dagger J,
det D_dbl = (+/-) det D_+ . det D_-   =>  each branch multiplicity doubles
(a 2-dim massless Clifford kernel becomes 4-dim).
```

Classification consequences:

- Krein doubling **doubles `doubled_mult`** on every branch; it does not create
  or remove branches by itself. Do not read the multiplicity doubling as new
  doublers (that would be a counting error) nor as doubler removal.
- The Krein inner product supplies `krein_sign`, which is the *only* legitimate
  basis for the 1.4 (Krein-negative) tag. Compute the `J`-norm on each (doubled)
  kernel.
- Non-overclaim (CONVENTIONS.md Krein rule; backlog C5+C7): `D_dbl` being
  `J`-self-adjoint is Lorentzian-adjointness data, **not** a stability
  certificate. It licenses projecting out 1.4 branches; it does not clear 1.6 or
  1.7. Pair the C5 self-adjointness theorem with the C7 counterexample whenever
  Krein data is cited in a classification.
- Interaction with `Phi_H`: apply the mass shift (5.1) first, then double; the
  Krein partner `D_- = J D_+^dagger J` must be built from the *same* mass block,
  so the mass-shell condition is consistent across the doubled operator.

---

## 6. Guardrails (carry verbatim into C2b and any P2 text)

- Coefficient-zero no-doubling is **not sufficient**. The classifiable object is
  a determinant / mass-shell zero (`det c(p(q)) = 0`, massless `p(q)^2 = 0`),
  never `p(q) = 0`. A nonzero Lorentzian null `p(q)` has a Clifford kernel.
- Do not reinterpret determinant-zero branches after seeing the raw data without
  this criteria document. Every classification cites a category (1.1-1.8) and
  the columns (Section 2) that justify it. New categories require editing this
  file *before* re-reading the data, not after.
- A branch missing `energy_real`, `krein_sign`, `gauge_content`, or `h_scaling`
  is "classification pending" — never "harmless" and never "doubler" by default.
- Krein `J`-self-adjointness is a Lorentzian-adjointness audit, not stability,
  real spectrum, positivity, unitary evolution, anomaly safety, or chirality. It
  may remove 1.4 branches; it never clears 1.6 or 1.7.
- A mass block `Phi_H` shifts the shell `p^2 = 0 -> p^2 = m^2`; it lifts a branch
  only when the data show `~1/h` gapping (1.2). It is not a no-doubling
  mechanism on its own.
- Keep `Gamma_s` (spacetime chirality), `chi_E` (internal grading), and
  `epsilon_form` (form degree) in separate columns; never use one to repair a
  sign or relabel a branch under another.
- This is an acceptance-criteria / audit document, not a proof that the operator
  is safe. Passing Gate C requires the data plus the cures (removal terms,
  Krein/gauge projections) to be defined and kernel-checked, not merely tagged.
