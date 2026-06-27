# D15 — Causal-set d'Alembertian comparison and falsification probe

Status: Audit, no-build. Date: 2026-06-26.

Scope: compare the null-edge retarded/advanced scaling against the known
causal-set d'Alembertian failure modes (Aslanbeigi–Saravani–Sorkin
*Generalized causal-set d'Alembertians*, arXiv:1403.1622, already curated;
Boguñá–Krioukov *local causal-set d'Alembertian*, arXiv:2506.18745), and define
explicit, fast falsification probes for the causal-support half of Gate D.

Companion document: `null-edge-connection-laplacian-convergence-audit.md` (D14).

---

## 0. Executive summary

- The **causal-set d'Alembertian literature is a falsification asset, not a
  template**. The canonical (Sorkin–Henson / BLMS / generalized ASS) causal-set
  box `B_ρ φ(x) = (4/√6) [ −φ(x) + Σ_y layered-weights · φ(y) ]` is **nonlocal**:
  it sums over a growing causal past with alternating-sign layer coefficients,
  and its *mean* converges to `□φ + (1/2) Rφ` only after an ensemble average; the
  *fluctuations* do not vanish without smearing, and in **d = 4 the operator is
  unstable / has a problematic spectrum** (ASS). This is the documented warning
  the project already carries.
- Boguñá–Krioukov's *local* causal-set d'Alembertian is the contrasting positive
  example: a genuinely **local**, primitive-null-supported operator that avoids
  the nonlocal layered sum. It is the model the null-edge retarded kernel should
  be benchmarked against, **not** the Sorkin-style nonlocal box.
- The null-edge retarded operator `D_+ = Σ_a C_a (T_a − I)/h` is **already
  local** (nearest null-edge differences only). That is its main advantage over
  Sorkin-type boxes and the reason the project should *not* import the nonlocal
  layered construction at all. The risk is different: whether the
  **retarded/advanced Krein doubling** reintroduces, in the doubled square
  `D_dbl² = diag(D_-D_+, D_+D_-)`, the same indefinite-spectrum / runaway
  instabilities that plague the d=4 causet box.
- Bottom line on question 6: **yes, the comparison argues for finalizing the
  retarded kernel design (locality + a stable doubled symbol) before any
  continuum-limit proof attempt.** Proving convergence of an operator whose
  doubled symbol is unstable would be wasted effort.

---

## 1. The three operators side by side

| Property | Sorkin/ASS nonlocal causet box `B_ρ` | Boguñá–Krioukov local box | Null-edge retarded `D_+` / Krein double `D_dbl` |
|---|---|---|---|
| Support | nonlocal: causal past, many layers | local (bounded causal neighborhood) | local: nearest null-edge shifts `T_a` |
| Coefficients | layered, alternating sign, dimension-dependent | local stencil | `C_a` Clifford/soldering coefficients |
| Symbol (continuum) | `□` only after ensemble mean | `□` directly | `D_+` symbol `Σ_a C_a (e^{ik_a h}−1)/h ≈ iΣ C_a k_a` |
| Self-adjointness | symmetric but **unstable in d=4** | designed stable | `D_+` non-Hermitian; `D_dbl` `J_0`-self-adjoint (Krein) |
| Fluctuations | large; need smearing / mean | controlled | finite-graph exact; continuum open |
| Covariance | covariant in law (ensemble) | local + covariant target | regular-graph: no exact Lorentz symmetry |

The decisive structural point: the null-edge operator sits in the **local
column** with Boguñá–Krioukov, *not* with the nonlocal Sorkin box. The
falsification probes below are designed to confirm it stays there and that the
Krein doubling does not smuggle in the nonlocal box's instability.

---

## 2. Known causet-d'Alembertian failure modes (the things to test against)

From ASS arXiv:1403.1622 and the W14 property matrix in the roadmap:

- **FM1 — d=4 instability / spectrum problem.** The 4D nonlocal box has
  eigenvalues/poles that render the operator unstable (no good positive-frequency
  decomposition; runaway modes). *This is the headline warning.*
- **FM2 — Nonlocal tails / slow fluctuation decay.** Without smearing over a scale
  `≫ ℓ_planck`, the discrete operator's fluctuations do not converge to the
  continuum `□`; only the mean does.
- **FM3 — Mean-vs-pointwise gap.** Convergence is in *expectation over the
  sprinkling ensemble*, not pathwise. A deterministic regular graph has no such
  ensemble to average over — so it must converge *pointwise* or not at all.
- **FM4 — Dimension-dependent retuning.** The layer coefficients must be retuned
  per spacetime dimension; a wrong dimension gives the wrong symbol.
- **FM5 — Curvature term sign/coefficient.** The `+½ Rφ` term has a fixed
  coefficient; a kernel that produces a different coefficient is not the
  d'Alembertian.
- **FM6 — Lorentz-covariance vs. discreteness tension.** Exact Lorentz symmetry
  forces nonlocality (the W14 "do not encode a blanket no-go, but test it"
  matrix). Regular layered graphs break Lorentz symmetry, trading covariance for
  locality.

---

## 3. How retarded/advanced doubling might avoid or reproduce these (question 4)

**Mechanisms by which doubling *avoids* the failures:**

- A1 (vs FM2/FM3): the retarded kernel is **already local and deterministic**, so
  there is no nonlocal layered tail and no ensemble average to rely on — it must
  be judged by *pointwise* consistency (good: removes FM2/FM3 by construction,
  but raises the bar — see probe P15.2).
- A2 (vs FM1): the **Krein structure** `D_dbl² = diag(D_-D_+, D_+D_-)` keeps the
  square formally `J_0`-self-adjoint, providing a *controlled indefinite* setting
  (Krein space) rather than an uncontrolled non-self-adjoint one. Stability is to
  be decided by the *symbol*, not by Hilbert-space self-adjointness.
- A3 (vs FM6): the program *explicitly accepts* breaking exact Lorentz symmetry on
  regular graphs (W14) and recovers covariance only in the continuum limit — so
  it does not pay the FM6 nonlocality tax.

**Mechanisms by which doubling *reproduces* the failures (the real risks):**

- R1 (FM1 redux): the doubled square's symbol
  `σ(D_+^♯ D_+)(ω,k)` may have the **wrong sign structure** (e.g. `−ω² − k²`
  Euclidean rather than `ω² − k²` Lorentzian, or vice versa, or a complex/
  indefinite spectrum with growing modes). If `det D_+(ω,k)=0` has roots in the
  wrong half-plane, the doubled operator is unstable exactly like the d=4 box.
- R2: **retarded determinant branch count** (roadmap finite-core test) may reveal
  extra zeros = doublers / runaway branches, the discrete echo of FM1.
- R3: the curvature coefficient (FM5) emerging from the doubled square may not be
  `+½` — a fixed, checkable number.

So: doubling **does not automatically inherit** the causet instability (it is
local and Krein-controlled), but it **can reproduce it through the symbol**.
The symbol/branch tests below are the arbiter.

---

## 4. Causal d'Alembertian falsification checklist (the deliverable)

Finite, mostly symbolic, decisive. Each has explicit accept/fail criteria. Order
by cost (cheapest first); a single failure in P15.1–P15.4 kills the Lorentzian
continuum claim for the current kernel.

| # | Probe | What it tests | Accept | Fail ⇒ |
|---|---|---|---|---|
| P15.0 | **Locality audit** | Is `D_+` supported on a bounded causal neighborhood (no growing layered sum)? | nearest-null-edge stencil only | if nonlocal layered ⇒ inherits FM2/FM3, **redesign** |
| P15.1 | **Symbol sign structure** | `σ(D_+)(ω,k) = Σ_a C_a (e^{i k_a·h}−1)/h`; leading symbol `≈ i Σ_a C_a k_a`. Square ⇒ mass-shell `P²`? | leading symbol of `D_dbl²` `= ω²−|k|²` (mostly-minus) up to one positive constant | wrong sign / Euclidean signature / anisotropy ⇒ **not a d'Alembertian**, kill |
| P15.2 | **Pointwise (not ensemble) consistency** | On a fixed regular null graph, `D_dbl² φ = □φ + O(h)` pointwise for smooth `φ` | bounded `O(h)` truncation error, no ensemble averaging needed | needs averaging ⇒ FM3 ⇒ regular-graph route fails |
| P15.3 | **Retarded determinant branch count** | zeros of `det D_+(ω,k)=0` in the BZ; doubled branches `det D_dbl²` | exactly the physical branches, no runaway/wrong-half-plane roots | extra zeros = doublers (Gate C) or runaway = FM1 redux ⇒ **redesign kernel** |
| P15.4 | **Doubled-square stability / spectrum** | spectrum of `D_+^♯ D_+`: real? bounded below? | real, bounded-below (Krein-positive) physical sector | indefinite-with-growing-modes ⇒ FM1 ⇒ kill |
| P15.5 | **Curvature coefficient** | coefficient of `R φ` from `D_dbl²` (Lichnerowicz/ASS comparison) | matches the fixed continuum value (`+½` ASS / Lichnerowicz `+¼R`-type per convention) | wrong coefficient ⇒ not the geometric d'Alembertian (downgrade to "kinetic only") |
| P15.6 | **Dimension consistency** | does the symbol give the right `□` in the intended dimension without per-d retuning artifacts? | clean across the intended d | dimension-fragile ⇒ FM4 caution flag |
| P15.7 | **Covariance-in-law check** | how badly is Lorentz symmetry broken at finite `h`; does it restore as `h→0`? | anisotropy `→0` with `h` | persistent O(1) anisotropy ⇒ no covariant limit (FM6) |

Probes P15.0–P15.4 are finite and several are `decide`/`native_decide`-able on a
small graph or symbolic BZ stencil; they should be run before any analytic work.

---

## 5. Should the retarded kernel be redesigned before continuum proofs? (question 6)

**Recommendation: settle the kernel's symbol-level stability (P15.1, P15.3,
P15.4) before attempting any continuum-limit proof.** Rationale:

- The d=4 causet instability (FM1) is a *symbol-level* pathology. It is cheap to
  detect on the discrete operator (branch count, doubled-square spectrum) and
  ruinous to discover *after* investing in convergence analysis.
- The null-edge operator's advantage over causet boxes is **locality** (P15.0),
  which it already has. The open question is purely whether the **Krein doubling
  produces a stable, correctly-signed mass-shell symbol**. That is decided by
  P15.1/P15.3/P15.4, all finite.
- If P15.3/P15.4 fail, the fix is a kernel redesign (different `C_a` soldering,
  different shift combination, or a different doubling `J_0`), not a different
  proof. So redesign must logically precede proof.

Concrete gate: **do not open the Lorentzian continuum-proof job until
P15.1 + P15.3 + P15.4 all pass on the finite operator.** This mirrors the D14
rule (settle the symmetric elliptic limit first) and the roadmap's own
"finite-core pressure suite" (assumption ledger, retarded branch count, doubled
branch count, anomaly/index test).

---

## 6. Separating scalar/gauge kinetics from full Lorentzian dynamics (question 7)

Two-track architecture, kept in separate Lean files and separate manuscript
sections:

- **Track K (kinetic, Euclidean, inheritable):** scalar covariant gradient and
  gauge kinetic terms via the *symmetric* connection Laplacian — the entire D14
  program. Provable-finite core + inherited Singer–Wu/Ramanan convergence.
  Independent of causal support. **This is where reconstruction credit is safe.**
- **Track L (Lorentzian, causal, falsification-gated):** retarded/advanced Krein
  doubling, causal support, mass-shell d'Alembertian — the D15 program. Gated by
  §4 probes; no convergence theorem available; downgrade-ready.

Firewall rule (load-bearing): **a Track-K convergence result must never be cited
as evidence for Track-L causal dynamics.** The convergence theorems certify the
elliptic/symmetric content only (D14 §3). Conversely a Track-L probe failure does
*not* invalidate Track-K — the scalar/gauge kinetic reconstruction stands on its
own. This separation is what lets a partial success (Track K) survive a Track-L
failure.

---

## 7. Safe ordering of D14/D15 relative to D13 and Gate C (deliverable, combined)

(Consistent with D14 §6; repeated here for the causal half.)

1. **Gate C doubler/branch audit (S7)** — prerequisite for P15.3 (branch count
   reuses the doubler classification) and D14 H10.
2. **D14-finite + D14 symbol probes (P14.x)** — establish the symmetric elliptic
   limit first.
3. **D15 symbol/stability probes (P15.0–P15.4)** — decide kernel viability;
   *redesign here if needed* before any proof.
4. **D13 (DEC Hodge–Dirac scaffold)** — shared hypothesis ledger; supplies
   curvature-term convergence used by both D14 (A3) and D15 (P15.5).
5. **Lorentzian continuum proof (Track L)** — only after 1–4 pass.

Never attempt step 5 before step 3 passes; never let step 2's success be reported
as step 5's.

---

## 8. Downgrade plan if causal support fails

Strongest-first, non-silent:

- **DG-A (preferred):** keep Track K (scalar/gauge kinetic reconstruction, D14)
  as the result; report Lorentzian causal dynamics as **open**, with the specific
  failing probe (P15.x) named. Manuscript: "kinetic reconstruction established;
  causal d'Alembertian not yet realized — fails probe P15.x."
- **DG-B (if P15.0/P15.2 fail — nonlocality/ensemble dependence):** adopt the
  **Boguñá–Krioukov local kernel** as the replacement retarded kernel and re-run
  P15.1–P15.4. This is a redesign, not an abandonment.
- **DG-C (if P15.3/P15.4 fail — FM1 instability redux):** redesign the **Krein
  doubling** (`J_0`, soldering `C_a`) and re-run; if no stable doubling exists,
  state a *negative result*: "no stable local retarded null-edge d'Alembertian in
  this class" — a genuine, publishable no-go aligned with ASS d=4.
- **DG-D (if P15.5 fails — wrong curvature coefficient):** downgrade the claim
  from "geometric d'Alembertian `□+½R`" to "flat kinetic mass-shell operator
  only"; geometry/curvature reconstruction surrendered.
- **DG-E (if P15.7 fails — no covariant limit):** surrender Lorentz covariance;
  reposition as a Euclidean/lattice effective model (consistent with W14's refusal
  to claim a blanket covariance theorem).

Floor that always survives: the finite **Krein-double square identity** and the
**exact link-stiffness / connection-Laplacian quadratic forms** (D14 F1–F4) are
unaffected by every Track-L failure. They are the durable artifact; protect them.

---

## 9. One-line answers to the prompt's analysis questions (causal half)

- **Q3 (causal vs elliptic):** direct conflict — see D14 §3; resolved by
  converging the symmetric square, not `D_+`.
- **Q4 (doubling avoids/reproduces instabilities):** avoids FM2/FM3/FM6 by
  locality + accepted symmetry breaking + Krein control; can still reproduce FM1
  through a bad doubled symbol — decided by P15.1/P15.3/P15.4.
- **Q5 (fast falsification):** §4 P15.0–P15.7, finite and largely `decide`-able.
- **Q6 (redesign kernel first?):** **yes** — settle symbol stability (P15.1/3/4)
  before any continuum proof; instability is a cheap-to-detect, expensive-to-
  discover-late pathology.
- **Q7 (separate scalar/gauge from Lorentzian):** §6 two-track firewall —
  Track K (kinetic, safe) vs Track L (causal, gated); never cross-cite.
