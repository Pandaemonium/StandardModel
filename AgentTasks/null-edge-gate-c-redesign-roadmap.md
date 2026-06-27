# Gate C branch-count postmortem and operator-redesign roadmap

**Type: no-build strategy / audit job (Wave 6).** No Lean, Lake, pre-commit, or
build command was run to produce this document. It reconciles four already-banked
artifacts and lays out a redesign roadmap. It certifies nothing about operator
safety; it renders a Gate C verdict and a forward plan only.

Operator under audit (mostly-minus signature `g = diag(+,-,-,-)`, lattice spacing
`h`, flat tetrahedral retarded dual-soldered construction):

```text
D      = i D_N + Gamma_s Phi          (super-Dirac form)
D_N    = sum_a C_a nabla_a            C_a = c(alpha^a) dual-soldered Clifford symbols
D_+(q) = sum_a C_a (exp(i q_a) - 1)/h = c(p(q))    (retarded flat symbol)
G^{-1} = -3/4 . I + 1/4 . J           (tetrahedral inverse Gram, d=4)
p(q)^2 = h^{-2} u^T G^{-1} u,  u_a = exp(i q_a) - 1   (forward/retarded difference)
mass block: Gamma_s Phi_H = m gamma_5  shifts the shell p^2 = 0 -> p^2 = m^2
```

Sources reconciled (the four named in the job, plus the locked rules they cite):

- `materials/null-edge-branch-count-interpretation.md` (C2b interpretation).
- `materials/null-edge-high-momentum-branch-proof-report.md` (C1/T16 finite,
  kernel-checked branch identities).
- `materials/null-edge-krein-double-counterexample-report.md` (C5 + C7 Krein
  honesty pair).
- `materials/null-edge-next-wave-strategy.md` (kill-switch decision tree and
  downgrade fallbacks).
- `materials/CONVENTIONS.md` "Branch-count / no-doubling test" and "Krein /
  Lorentzian adjointness" (both **Locked**).

---

## 1. Executive verdict

### 1.1 Gate C status (one category, with reason)

**Gate C status: FATAL-FOR-NAIVE-FLAT (settled), with the per-branch physical
classification PENDING and a formal REDESIGN-REQUIRED (1.8) escalation not yet
provable.**

Read operationally: the kill switch **stays engaged**, the naive no-doubling
claim is **dead now**, and no flat-operator-as-is path to Gate C release exists.
A removal/redesign mechanism is required even to *attempt* passage. The four
candidate categories resolve as follows.

| Category | Resolves to | Why |
| --- | --- | --- |
| **RELEASED** | **NO** | Release requires exactly one surviving 1.1 continuum branch and all 1.6/1.7 absent or cured by a defined mechanism. None of those conditions hold: the 1.1 origin is only a candidate, four 1.6 corner candidates plus a positive-dimensional null variety survive, complex-energy branches are pervasive, and no cure has been computed. |
| **PENDING** | **PARTIALLY (per-branch only)** | The *physical* fatal-vs-benign classification of each surviving branch is genuinely pending the missing load-bearing columns (`krein_sign`, `gauge_content`, `h_scaling`, `growth_rate`, `chirality`/`internal_grading`). But "pending" is not the headline: the headline coefficient-zero claim is already refuted, so the gate is not in a clean wait state. |
| **FATAL-FOR-NAIVE-FLAT** | **YES (settled, kernel-checked)** | The coefficient-zero no-doubling argument (`p(q)=0 iff q=0`) is refuted by hard, kernel-checked finite identities: four high-momentum corners with `p(q) != 0` yet `p(q)^2 = u^T G^{-1} u = 0` and `dim ker = 2`, plus a positive-dimensional (2-real-dim) determinant-zero variety. Retardedness removes only coefficient-zero doublers; determinant-level doublers survive. |
| **REDESIGN-REQUIRED (1.8)** | **NOT YET PROVABLE (operationally indicated)** | Formal 1.8 requires showing *no* admissible projection or removal term can jointly cure 1.1/1.6/1.7 without destroying the intended cone. That impossibility has not been demonstrated — the candidate cures (Wilson / Ginsparg-Wilson / overlap / domain-wall / Krein-sign projection) have not been computed and ruled out. So redesign is the indicated direction but is not yet a proven necessity. |

**Exact reason for the verdict.** Two facts are kernel-checked and jointly fatal
to the naive claim: (a) `corner_qform : u^T G^{-1} u = k^2 - 3k` gives `p^2 = 0`
at the four `k = 3` corners with `u != 0` (`threePi_null`,
`cornerU_eq_zero_iff`), so a nonzero Lorentzian-null Clifford vector with kernel
exists at high momentum; and (b) the oracle finds a 2-real-dimensional null
variety (201 grid points at `N = 12`), so the null set is not the single point
`q = 0`. The Locked branch-count rule forbids inferring no-doubling from
coefficient-vector zeros; the determinant-level test is the binding one and it
fails. Hence FATAL-FOR-NAIVE-FLAT is settled. Whether *those* surviving branches
are physical doublers (1.6), benign gapped (1.2), Krein-nonphysical (1.4), or
pure gauge (1.3) cannot be decided without the missing columns, so the
per-branch verdict is PENDING and a clean RELEASE is impossible.

### 1.2 Reconciliation of the four reports (no conflicts found)

The four artifacts are mutually consistent and stack into a single story; none
contradicts another.

- **High-momentum branch proof (C1/T16) — the settled floor.** Finite,
  kernel-checked identities (axioms `propext, Classical.choice, Quot.sound`
  only; no `native_decide`). Establishes the *existence* of determinant-level
  high-momentum null corners and the Minkowski identity
  `mink(pCov u) = qform u`. Explicitly labelled **finite branch data, NOT a
  physical doubler theorem** — necessary but not sufficient for a doubler. This
  is the hard evidence that kills the coefficient-zero claim.
- **Branch-count interpretation (C2b) — the gate ruling.** Takes the C1 data
  plus the C2a oracle (energy-slice and grid scans) and classifies against the
  frozen G3 categories. Renders "Gate C NOT passed; fails as-stated; final
  category (pending vs 1.8) pending." Identifies the eight missing load-bearing
  columns. Fully consistent with C1: it treats the corners as **1.6
  fatal-doubler candidates (pending)**, not as proven doublers, exactly because
  C1 is explicit that a quadratic-form null is not yet a physical doubler.
- **Krein counterexample (C5 + C7) — the honesty pair.** Proves
  `Ddbl_kreinSelfAdjoint` (the doubled operator is `J_dbl`-self-adjoint for
  *every* `D_+`, hence hygiene not stability) and three finite counterexamples:
  `J`-self-adjoint with eigenvalue `i` (no real spectrum), with eigenvalue
  `1+2i` (growing mode), and a Hermitian retarded block whose double has
  `D_- D_+ = -I` and `D_dbl^2 = -I` (negative energy form, spectrum `{+-i}`).
  This is the in-spec `K.pass-but-nonstable` outcome. It directly enforces the
  guardrail "do not use Krein self-adjointness as a stability theorem": the
  pervasive complex-energy branches found by C2b cannot be cleared by the C5
  theorem.
- **Next-wave strategy — the routing.** Treats Gate C as a kill switch with
  branches `C.pass / C.pending / C.fatal`. The reconciled state above maps to
  **`C.fatal` for the coefficient-zero/continuum claim** (downgrade fallbacks in
  §4 of that memo apply) **simultaneously with `C.pending` for the per-branch
  cure question** (data-completion jobs in §6.1 of C2b apply). Both routes are
  live and non-contradictory: publish the structural no-go while computing the
  columns that decide whether any flat-frame cure survives.

### 1.3 Guardrail compliance (carried verbatim)

- **No no-doubling claim is made.** Strongest sayable phrasing: "retardedness
  avoids coefficient-zero doublers; determinant-level high-momentum branches and
  a positive-dimensional null variety survive and require an explicit removal
  mechanism."
- **Krein is not used as stability.** `J`-self-adjointness is Lorentzian
  hygiene; it may remove a 1.4 (Krein-negative) branch and nothing else. It
  never clears a positive-`J` 1.6 doubler or a 1.7 complex instability. The C5
  theorem travels only paired with the C7 counterexamples.
- **Finite reconstruction value is kept distinct from continuum viability.** The
  C1 corner identities and the P1 finite Plucker theorem retain their value as
  finite results regardless of this gate; the failure here is a *continuum-
  operator* failure, not a refutation of the finite algebra.
- **This is a structural no-go, not a refutation of the null-edge program.** The
  result is "*this* flat tetrahedral retarded operator fails the determinant
  branch test," which is useful structural information that directs the
  redesign. It is not "null-edge is impossible."

---

## 2. Physical classification checklist for every branch candidate

The G3 hard requirement: a branch missing any of `energy_real`, `krein_sign`,
`gauge_content`, or `h_scaling` is "classification-incomplete" and may **not** be
tagged benign. The checklist below is the full eight-column ledger required per
branch; computed columns are marked, missing columns are the work to be done.

### 2.1 Per-branch ledger (the eight columns)

For each branch candidate, record:

1. **Determinant null** — is `det c(p(q)) = 0` / `p(q)^2 = 0` (massless), as
   opposed to merely `p(q) = 0` (coefficient-zero)? This is the only
   classifiable object; coefficient-zero is not.
2. **Energy real/complex** — `energy_real`: is `|z| = 1` (real propagating) or
   `|z| != 1` (complex energy)? Routes a branch to the doubler axis (real) vs
   the complex-instability axis (complex).
3. **Cutoff / high-momentum behaviour** — `connected_to_origin`? high-momentum
   (corner / generic torus point) vs the physical continuum branch at `q ~ 0`.
4. **Krein sign** — `krein_sign`: the `J`-inner-product sign on the (doubled)
   kernel. Positive-`J` = physical sector; negative-`J` = removable as 1.4. The
   *only* legitimate basis for a 1.4 benign tag.
5. **Doubled multiplicity** — `dim ker` for the massless symbol, the massive
   `+ m gamma_5` symbol, and the Krein-doubled operator. (Computed by C1/C2a.)
6. **Chirality / internal grading content** — `chirality` under `Gamma_s`
   (spacetime L/R) and, in a **strictly separate** column, `internal_grading`
   under `chi_E`. Decides whether the origin is the intended single Dirac cone
   (2-dim L+R) and whether corners are vector-like or chiral. Grading-separation
   guardrail (criteria 1.3): never substitute `chi_E` for `Gamma_s`.
7. **Mass-block lifting** — does `+ Gamma_s Phi_H = m gamma_5` remove the branch?
   Known from C2b: it shifts `p^2 = 0 -> p^2 = m^2` but maps each massless corner
   to a massive corner at shifted `q`; it does **not** by itself remove the
   corners. The "good" outcome (branch lifted to `~1/h`) is an `h_scaling`
   datum, not delivered by the mass block alone.
8. **h-scaling** — `h_scaling`: physical (finite energy as `h -> 0`) / gapped
   (`~1/h`, decouples in the continuum) / divergent / artifact, computed for
   both the massless and the massive operator. This is what splits a corner into
   benign-1.2 (gaps off) vs fatal-1.6 (survives).

Auxiliary columns that the tree also needs: `growth_rate = log|z|` (signed, under
the chosen retarded/causal evolution; decides growing-1.7 vs decaying/marginal),
conjugate-pair structure (nonreal eigenvalues must pair), `gauge_content`
(physical dof vs pure-gauge/constraint, projected out before any 1.7 call), and
`removal_term` (the explicit defined cure, if any).

### 2.2 Branch-classification table

| Branch / object | Det null | Energy | Cutoff / momentum | Krein sign | Doubled mult. | Chirality / internal | Mass-block lift | h-scaling | Category verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Origin `q=(0,0,0,0)`** | yes, but coeff-zero (`u=0`, `p=0`) | real (continuum line) | connected to origin | **not computed** | ker 4 massless / 4 massive / 8 doubled | **not computed** (asserted single Dirac cone by design) | shifts to `p^2=m^2` (intended Dirac mode) | **not computed** | **1.1 candidate — PENDING** (cone chirality + h-scaling unverified) |
| **`(pi,pi,pi,0)` + 3 perms** (`k=3`) | **yes**, `p!=0`, `p^2=0`, `det=0` | **real / propagating** (measure-zero real locus) | high-momentum, not origin-connected | **not computed** | ker 2 massless / 2 massive / 4 doubled | **not computed** (vector-like vs chiral open) | does **not** remove (corner -> shifted massive corner) | **not computed** | **1.6 fatal-doubler candidate — PENDING** (real -> doubler axis; never auto-1.5) |
| **Positive-dim null variety** (201 pts, 2-real-dim) | **yes** (`p^2=0` surface) | mostly complex off corners; measure-zero real sub-locus | spans the torus | **not computed** | varies (2 at corners) | **not computed** | not removed by mass block | **not computed** | **Fatal to coeff-zero no-doubling — SETTLED; physical status PENDING (not artifact)** |
| **Complex-energy branches** (414/432 roots) | det-zero shell, complex `p^2` | **complex** (`|z|!=1`) | pervasive on generic spatial slices | **not computed** | — | **not computed** | n/a | **not computed** | **1.7 fatal-complex candidate — PENDING** (no `benign_reason`, so never 1.5) |
| **Gate C (operator)** | — | — | — | — | — | — | — | — | **NOT PASSED; FATAL-FOR-NAIVE-FLAT; per-branch + 1.8 PENDING** |

Three corner facts from C1/T16 to keep visible (kernel-checked): only the origin
is coefficient-zero (`cornerU_eq_zero_iff`); `corner_qform : u^T G^{-1} u = k^2 -
3k` gives `0 / -2 / +4` at `k in {0,3} / {1,2} / {4}`; and the genuine spacetime
covector is nonzero at the corners (`threePi_pCov_ne_zero`, `p_0 = -3/2`), so the
"coefficient nonzero, form null" statement is about the real covector, not a
coordinate artifact.

---

## 3. Redesign families (ranked, with falsification tests)

Each family is a candidate **removal mechanism** that must (i) gap or project out
the four corners *and the whole 2-real-dim null variety* (not just a finite
corner list), (ii) leave exactly the single 1.1 cone at `q ~ 0`, and (iii)
preserve the cone's intended chirality/anomaly content. **None is assumed to
work.** Ranking is on two axes — mathematical cleanliness (rigor, standard
theory available) and null-edge specificity (does it exploit the null-edge frame
rather than override it). A family that scores low on null-edge specificity may
still be the right engineering choice if it is the only one that passes its
falsifier.

### 3.1 Ranking

| Rank | Family | Cleanliness | Null-edge specificity | One-line risk |
| --- | --- | --- | --- | --- |
| **1** | Domain-wall / SSH chiral projection (C9) | high (Jackiw-Rebbi/SSH index is rigorous) | **high** (chiral zero mode from a null-edge defect; uses the frame) | bulk doublers may not gap; zero-mode count may be 0 or >1 |
| **2** | Overlap / Ginsparg-Wilson projection (C10) | **highest** (cleanest chirality theory) | low-medium (imported, not intrinsic to null-edge) | `sign(H)` likely **ill-defined** on the positive-dim null variety; GW relation may be incompatible with retarded/Krein structure |
| **3** | Wilson-like lifting | high (standard, well understood) | **low** (breaks chirality explicitly, generic mass to doublers) | a finite corner-tuned term may not lift a *whole* variety; explicitly spoils the cone's chirality |
| **4** | Krein-sign projection onto the positive-`J` sector | medium | medium (uses the existing `J`) | C7 shows the energy form can be negative-definite (`D_- D_+ = -I`); projection may delete the physical cone or fail to be positive on it |
| **5** | Branch-selective internal blocks (`chi_E`-graded mass) | medium | high (intrinsic internal grading) | the corners and origin share the same Clifford/`C_a` structure, so an internal block likely acts identically on both -> cannot separate them |
| **6** | Modified retarded/advanced pairing (symmetric/mixed difference) | high | medium | symmetric difference *re-introduces* coefficient-zero doublers at `q=pi`; likely strictly worse |

Rationale for the top of the ranking: domain-wall is ranked first because it is
both rigorous *and* null-edge-specific (it produces chirality from a defect in
the null frame rather than importing an external construction) and because it is
the cheapest concrete pilot. Overlap/GW is the cleanest chirality theory in the
abstract but is ranked second because its very first compatibility check
(well-definedness of `sign(H)`) is at acute risk from the already-established
positive-dimensional null variety — the cleanliness is theoretical, not yet
realizable here. Wilson is dependable but scores lowest on null-edge specificity
and is the most likely to spoil the intended cone, so it is a fallback, not a
flagship.

### 3.2 Falsification test per family (first finite calculation that kills it)

Each test is a **finite, oracle- or kernel-checkable** computation that can fail
fast. A failing test removes the family from contention before any heavy
investment.

1. **Domain-wall / SSH (rank 1).** *Test:* build the finite 1D (or `1+1`)
   null-edge retarded hopping chain with a sign defect in the mass profile;
   compute the zero-mode count and its `Gamma_s` chirality, and the bulk
   spectrum gap. *Falsified if:* the bound zero-mode count is `0` or `> 1`, or
   the localized mode is not a definite-chirality eigenstate, or the bulk
   doublers do not gap. *Go if:* exactly one chiral zero mode localizes on the
   wall and the bulk is gapped.
2. **Overlap / Ginsparg-Wilson (rank 2).** *Test:* form `H = gamma_5 D_+(q)` (or
   the Krein analogue) and check whether `H` has any zero eigenvalues on the
   2-real-dim null variety, i.e. whether `sign(H)` / the overlap operator is even
   well-defined. *Falsified if:* `H` is singular on a positive-measure-zero but
   nonempty subset of the torus (which the existing null-variety data already
   strongly suggest), so `sign(H)` is ill-defined and the overlap construction
   does not exist for this symbol; or if the finite GW relation
   `{D, gamma_5} = a D gamma_5 D` cannot be satisfied by any retarded-compatible
   `D`. *Go if:* `H` is invertible off `q=0` and a GW-compatible `D` exists.
3. **Wilson-like lifting (rank 3).** *Test:* add a Wilson term
   `r . Box_null` (or `r . C_diamond`) and re-run the corner scan *and* the
   `N=12` grid null-variety scan; compute `h_scaling` and `dim ker` at the four
   corners and at sampled variety points. *Falsified if:* any non-origin null
   branch retains `dim ker > 0` (the term fails to gap the *whole* variety), or
   the origin cone's `dim ker` drops below 2 / loses its L+R chirality (the term
   spoils the physical mode). *Go if:* every non-origin null branch gaps as
   `~1/h` while the origin stays at `p^2 = m^2` with intact chirality.
4. **Krein-sign projection (rank 4).** *Test:* compute the `J`-signature ledger
   (`krein_sign`) on the origin cone and on the four corners / sampled variety
   points (the C7 / Krein-audit step-8 calculation). *Falsified if:* the origin
   cone is itself negative-`J` (projection deletes the physical mode), or any
   corner / complex branch is positive-`J` (projection cannot remove it — recall
   C7's `D_- D_+ = -I` shows the form can go negative-definite even on innocent
   blocks). *Go if:* the origin cone is positive-`J` and all surviving doublers
   are negative-`J`.
5. **Branch-selective internal blocks (rank 5).** *Test:* check whether any
   `chi_E`-graded internal mass block can anticommute with the corner kernel
   directions while commuting with (or sparing) the origin cone — a finite
   linear-algebra compatibility check on `[C_a, Phi]` and the corner vs origin
   kernel projectors. *Falsified if:* because the corners and origin share the
   same `C_a` Clifford action, every admissible internal block acts identically
   on both kernels (cannot separate them). *Go if:* an internal block exists that
   gaps corners but not the origin.
6. **Modified retarded/advanced pairing (rank 6).** *Test:* replace
   `u_a = exp(i q_a) - 1` by a symmetric/mixed difference and re-run the
   `{0,pi}^4` corner scan and the grid scan; count null corners and
   coefficient-zero points. *Falsified if:* the null-corner count rises (e.g.
   symmetric difference makes `q=pi` coefficient-zero), i.e. the pairing
   re-introduces doublers. *Go if:* the null set strictly shrinks toward
   `{q=0}` without losing causal/retarded structure.

---

## 4. Recommended next Aristotle jobs (with go/no-go criteria)

The work splits into a **precondition layer** (compute the missing columns; until
these land, every benign tag is forbidden and no cure can be evaluated) and a
**cure-pilot layer** (the per-family falsifiers, run cheapest-first). The kill
switch stays engaged throughout; heavy Gate-D continuum and chirality promotion
remain locked.

### 4.1 Precondition layer — data-completion jobs (top priority)

| Job | Computes | Go criterion (proceed) | No-go criterion (stop / downgrade) |
| --- | --- | --- | --- |
| **T16-chirality** (step-7) | `chirality` (`Gamma_s` L/R) and, separately, `internal_grading` (`chi_E`) per branch | origin confirmed as a single 2-dim L+R Dirac cone | origin is not a clean single cone -> the 1.1 branch is absent -> Section-3.1 "no physical mode" failure; escalate toward 1.8 |
| **C5+C7 step-8 `J`-ledger** | `krein_sign` on every (doubled) kernel | a coherent positive-`J` physical sector containing the origin cone exists | origin negative-`J`, or corners/complex branches positive-`J` -> Krein projection cannot be the cure |
| **C4 h-scaling** | `h_scaling` (physical / gapped `~1/h` / divergent / artifact), massless and massive | all four corners + the variety gap as `~1/h` -> they are benign-1.2 after the mass block | any corner / variety component stays at finite physical energy -> confirmed 1.6 surviving doubler |
| **C2a-growth** | signed `growth_rate = log|z|` + conjugate-pair audit on complex branches | all complex branches decaying/marginal, or provably outside the physical sector | a growing mode in the positive-`J` physical sector -> confirmed 1.7; stability is dead |
| **gauge-content** | `gauge_content` (physical dof vs pure-gauge/constraint) | corners/complex branches that are pure gauge can be projected before the 1.7 question | none are pure gauge -> no gauge exit |

After all five land, **re-run C2b** (re-interpret with complete columns) before
recording any Gate C verdict beyond the present one. Per the criteria, any new
category or reclassification requires editing the frozen G3 criteria file
*before* re-reading the data.

### 4.2 Cure-pilot layer — run the §3.2 falsifiers, cheapest-first

Launch order by cost and fan-out: **(1) Wilson corner+variety re-scan** (cheapest
oracle re-run; immediately tells us whether a generic gapping term even lifts the
whole variety), **(2) overlap `sign(H)` well-definedness check** (a fast
singularity scan on the already-computed null variety; high chance of a quick
no-go), **(3) Krein `J`-ledger** (shared with §4.1), **(4) domain-wall/SSH
zero-mode pilot C9** (a focused finite proof job; the flagship if it survives),
then **(5) internal-block compatibility** and **(6) modified-pairing re-scan** as
quick eliminations.

| Pilot job | Go criterion | No-go criterion |
| --- | --- | --- |
| Wilson re-scan | every non-origin null branch gaps `~1/h`; origin cone intact | a branch survives, or the cone loses chirality -> Wilson rejected for this frame |
| Overlap `sign(H)` check | `H` invertible off `q=0`; GW-compatible `D` exists | `H` singular on the variety -> overlap construction does not exist here |
| Krein `J`-ledger | positive-`J` cone, negative-`J` doublers | mixed signs as above -> projection rejected |
| Domain-wall C9 pilot | exactly one chiral zero mode; bulk gapped | zero-mode count `!= 1` or bulk ungapped -> domain-wall rejected |
| Internal-block check | a block separates corners from origin | acts identically on both -> rejected |
| Modified-pairing re-scan | null set strictly shrinks | null-corner count rises -> rejected |

### 4.3 Escalation / downgrade gates

- **Engage formal 1.8 (REDESIGN-REQUIRED) only if:** after §4.1 + §4.2, a real
  positive-`J` non-gauge corner (or variety component) survives without gapping
  *and* no admissible removal term clears it without destroying the 1.1 cone's
  chirality/anomaly content; *or* a growing physical-sector mode cannot be
  projected out. Then change the soldering frame / adopt an explicit
  overlap-domain-wall construction / replace the operator and restart Gate C
  (C1/C2) from scratch.
- **Downgrade publication fallback (already licensed now, in parallel):** the
  FATAL-FOR-NAIVE-FLAT result is publishable immediately as a **structural no-go
  / branch-count audit** (the flat tetrahedral retarded operator carries
  surviving determinant-level branches the mass block does not remove), paired
  with the Krein honesty pair (C5+C7). The **P1 finite Plucker** paper and the
  **finite-reconstruction** paper stand entirely independent of this gate and
  remain the program's guaranteed positive deliverables.
- **Standing lockouts (unchanged):** no Gate-D continuum beyond framework
  selection / target audit; no chirality promotion; no no-doubling or
  continuum-viability claim; no Krein -> stability/real-spectrum/positivity/
  unitarity claim (ever); the mass block is not a no-doubling mechanism on its
  own.

---

## 5. One-line gate line

**Gate C: FATAL-FOR-NAIVE-FLAT (coefficient-zero no-doubling refuted, settled);
per-branch physical classification and formal 1.8 escalation PENDING the
`krein_sign` / `gauge_content` / `h_scaling` / `growth_rate` / `chirality`
columns; kill switch ENGAGED; redesign (domain-wall first, overlap second,
Wilson fallback) required to attempt passage.**

---

## 6. Branch-topology reframing (2026-06-27 lateral analysis)

This section reframes the redesign as a branch-topology / algebraic-geometry
problem rather than an operator-coefficient search. It records design hypotheses
only; it certifies nothing and runs no build. Convention/claim-label backing is
in `docs/NULLSTRAND.md` (lateral-analysis guardrails) and
`AgentTasks/null-edge-decision-log-2026-06-27.md` (D25).

### 6.1 Branch locus and kernel sheaf as first-class objects

Define the branch locus `Z = { q : det D_+(q) = 0 }` and study the kernel sheaf
over `Z` (the kernels of `D_+(q)` as `q` ranges over `Z`). The known structure to
encode: balanced origin kernel, off-branch zeros, and the `S_4` / cyclotomic
orbit of extra zeros (C21/C43/C88; the C66 cyclotomic nodal-set report). Gate C1
then reads:

> Does there exist a gauge-safe, Krein-safe, equivariant spinor-line subbundle
> over the physical branch germ, with all other germs receiving true
> inverse-propagator gaps?

This is a line-bundle / index / equivariance question, not a coefficient tweak.

### 6.2 Branch involution as more than bookkeeping

Promote the branch involution `T_br` to the object that defines the split between
the physical line and the mirror line, so that a release is the choice of a
`T_br`-equivariant physical sheet, not a global scalar deformation.

### 6.3 Matrix-valued (branch-equivariant) Wilson lift

Since the scalar Wilson no-go is sharp, the next object is not a better scalar
Wilson. Consider `D_phys(q) = D_+(q) + W(q) . Pi_bad(q)` where `Pi_bad` is a
branch-equivariant spinor-line projector (not taste-only, not internal-only). The
hard part is making `Pi_bad` local or acceptably quasi-local, gauge-covariant,
Krein-safe, and smooth near the origin. Target design hypothesis:

> Scalar Wilson cannot polarize chirality, but a branch-equivariant line Wilson
> can, provided it is a true inverse-propagator gap and not a propagator zero.

Every candidate must pass the three-line branch audit (see
`AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`).

### 6.4 C1-alternatives classification (prove before tuning)

Rather than trying projected-Weyl / domain-wall / overlap variants one at a time,
first attempt a classification:

> Under locality, covariance, branch symmetry, and ghost safety, a release must
> use one of: boundary inflow, overlap / sign projection, non-ultralocality,
> matrix-valued spinor-line Wilson mass, or explicit branch involution.

Even a partial classification narrows the redesign and tells us which lattice
lesson applies (Kaplan's domain-wall/overlap/Ginsparg-Wilson framing).

### 6.5 Lower-dimensional toy zoo as stress-test laboratories

Build a small "null-edge C1 zoo" in 1+1D or 2+1D and ask which failure modes
reproduce the C21/C43/C88 pattern. If the same obstruction pattern appears in
toy systems, Gate C is less idiosyncratic and more publishable. Use the
symmetric-mass-generation and reduced Kahler-Dirac literature (already in the
`literature-queue.md`, plus the 2606.24713 one-dimensional SMG addition) as
controlled mirrors, not as solutions.
