# D14 — Connection-Laplacian convergence audit for null-edge gauge/Higgs terms

Status: Audit, no-build. Date: 2026-06-26.

Scope: map the finite null-edge gauge holonomy and Higgs covariant-gradient /
link-stiffness terms to the convergence hypotheses of discrete connection
Laplacians (Ramanan, arXiv:math/0609464) and their spectral convergence from
random samples (Singer–Wu, arXiv:1306.1587), and decide what is finitely
provable now versus analytic/continuum versus manuscript interpretation.

Companion document: `null-edge-causal-dalembertian-falsification-probe.md` (D15).

---

## 0. Executive summary (read this first)

- The **gauge/Higgs kinetic sector is the part of Gate D most likely to have a
  genuine continuum path**, and it is the part for which off-the-shelf
  convergence theory (Singer–Wu vector-diffusion / connection-Laplacian spectral
  convergence) is closest to directly applicable. This is good news and should be
  exploited *before* attempting anything Lorentzian.
- The applicability is **conditional and elliptic**. Singer–Wu/Ramanan convergence
  is a statement about a **symmetric, positive, second-order, elliptic**
  connection Laplacian on a **compact Riemannian** base with a **principal/vector
  bundle and a compact structure group**, sampled by an i.i.d. point cloud. The
  null-edge program's distinctive features — null (lightlike) edge labels,
  retarded directionality, indefinite/Krein structure — are **exactly the
  hypotheses these theorems do not cover**.
- Therefore the honest split is:
  - **D14-Euclidean (provable / inheritable):** freeze the causal direction, treat
    the Higgs link-stiffness form `S_H` and the gauge holonomy as a connection
    Laplacian on an *undirected, symmetrized, Euclidean* graph, and inherit
    Singer–Wu convergence. This reconstructs the **scalar covariant-gradient and
    gauge kinetic terms** (`|∇^A H|²`, Yang–Mills curvature-square at leading
    order) and is the safe scalar/gauge half of question 7.
  - **D14-Lorentzian (open / falsifiable):** the null/retarded structure must be
    reintroduced *after* the symmetric limit, and there is **no theorem here** —
    only the falsification probes of D15.
- The single most important structural finding: **null-edge causal directionality
  is in tension with the symmetric elliptic structure that all the cited
  convergence theorems require** (question 3). Connection Laplacians converge
  because they are graph Laplacians twisted by a *unitary* (Hermitian-adjacency)
  cocycle; the retarded null block `D_+ = Σ_a C_a (T_a − I)/h` is deliberately
  **non-Hermitian**. You cannot have both the standard convergence guarantee and
  primitive causal support from the *same* operator. The viable route is to get
  convergence from the symmetric square and recover causal support as extra
  structure, not to converge the retarded operator directly.

---

## 1. The finite objects and their target continuum operators

### 1.1 Higgs link stiffness (exact finite theorem, working plan §16.7)

For `G = U(1)`, finite directed graph with edges `e : s(e) → t(e)`,
`φ_v ∈ ℂ`, `U_e ∈ U(1)`:

```
S_H(φ, U) = Σ_e | U_e φ_{t(e)} − φ_{s(e)} |² .
```

This is gauge invariant under `φ_v → g_v φ_v`, `U_e → g_{s(e)} U_e g_{t(e)}^{-1}`.
Frozen-modulus form: `S_H = v² Σ_e |w_e − 1|²` with gauge-invariant
`w_e = σ_{s(e)}^{-1} U_e σ_{t(e)}`.

**Continuum target.** This is *exactly* a discrete covariant Dirichlet energy.
Its symmetric part is the quadratic form of a **connection Laplacian**
`Δ^A = (d^A)* d^A` acting on sections of an associated line/vector bundle:

```
S_H(φ) = ⟨ φ , Δ^A_graph φ ⟩ ,   Δ^A_graph = (D^A)* D^A,
```

where `D^A` is the covariant difference (coboundary twisted by the holonomy
cocycle `U_e`). In the continuum the target is `∫ |∇^A φ|²` and after vacuum
expansion `v² ε² Σ_e A_e²` is the gauge-boson mass / Yang–Mills mass term.

### 1.2 Gauge holonomy / curvature (working plan §15.6, §16)

Plaquette holonomies `U_∂f = Π_{e∈∂f} U_e` give, at leading order in the lattice
spacing, the **curvature** `F = dA + A∧A`; the plaquette energy
`Σ_f |U_∂f − 1|²` is the discrete Yang–Mills action whose continuum target is
`∫ |F|²`. Singer–Wu/Ramanan address the *connection Laplacian* (second-order,
on sections); the Yang–Mills curvature term needs the *companion* discrete
exterior calculus convergence (the D13 / Dabetic–Hiptmair DEC Hodge–Dirac
scaffold). Keep these two convergence claims separate (see ordering, §6).

### 1.3 Singer–Wu / Ramanan object

Singer–Wu's vector diffusion maps / connection Laplacian: a point cloud
`{x_i} ⊂ M` (compact Riemannian, dim `d`), bundle `O(d)` (or compact `G`) with a
discrete connection `O_{ij}` (orthogonal/unitary parallel-transport matrices
between nearby points), kernel weight `w_{ij} = K(‖x_i − x_j‖/√ε)`. The graph
connection Laplacian

```
(L_ε s)_i = (1/ε) [ s_i − (Σ_j w_{ij} O_{ij} s_j) / (Σ_j w_{ij}) ]
```

converges (spectrally, with rates) to the **Bochner / connection Laplacian**
`∇*∇` (Ramanan's discrete connection Laplacian is the deterministic-mesh
analogue). This is the theorem we want to inherit for §1.1.

**The map is:** `O_{ij} ↔ U_e` (holonomy cocycle), `w_{ij} ↔` edge weight,
`L_ε ↔ Δ^A_graph` from `S_H`. The match is structurally exact **once the graph is
made symmetric and the bundle/group made compact.**

---

## 2. Convergence-hypothesis checklist (the deliverable)

Each row: hypothesis required by Singer–Wu/Ramanan; null-edge status; what to do.
Acceptance = "can be arranged or proved"; Failure = "blocks the inherited
theorem and forces a downgrade."

| # | Hypothesis | Why the theorem needs it | Null-edge status | Action / acceptance test |
|---|---|---|---|---|
| H1 | **Compact Riemannian base** `M`, smooth, bounded geometry | Heat-kernel / Bochner Laplacian convergence; rates from injectivity radius & curvature bounds | Null-edge base is Lorentzian/causal, *not* Riemannian | **Euclidean detour:** prove convergence on a Riemannian (Wick-rotated or "frozen-time slice") base; record that Lorentzian base is out of scope. FAIL if no Riemannian base can be defined. |
| H2 | **Sampling / mesh regularity:** i.i.d. (Singer–Wu) or quasi-uniform mesh with shrinking fill distance (Ramanan) | Empirical operator → integral operator (LLN); discretization error control | Null-edge graphs are *engineered layered/regular* graphs, not i.i.d. samples | Use **Ramanan deterministic-mesh** form, not Singer–Wu random form. Acceptance: fill distance `h → 0`, mesh ratio bounded. |
| H3 | **Bandwidth scaling** `ε = ε(n) → 0`, `n ε^{(d/2)+1} → ∞` (Singer–Wu) | Bias–variance balance for spectral convergence | Lattice spacing `h` is the analogue; need `A_e = O(h)` scaling (working plan §16.7) | Acceptance: a single consistent scaling makes both `S_H` and the gauge term converge; FAIL if scalar and gauge demand incompatible powers of `h`. |
| H4 | **Compact structure group** `G` (`O(d)`, `U(k)`, `SU(N)×U(1)`) | Transport matrices are *unitary/orthogonal* ⇒ `L_ε` self-adjoint, spectrum real, perturbation theory applies | SM gauge group `SU(3)×SU(2)×U(1)` **is compact** ✓ | **PASS** — this is the one big hypothesis the program satisfies natively. Keep `U_e ∈ G` unitary. |
| H5 | **Connection regularity:** discrete connection `O_{ij}` consistent with a smooth connection `A ∈ C^{1,1}`, with `O_{ij} = I + A(x_i)(x_j−x_i) + O(h²)` | Consistency (truncation) error of the twisted Laplacian | Requires `U_e = exp(i ε A_e)`, `A_e` from a smooth background — the §16.7 "small-holonomy expansion" | Acceptance: the expansion `w_e = exp(iεA_e)` is uniform with bounded `A`. FAIL if holonomies are O(1) (deep nonperturbative regime — then no connection-Laplacian limit, only lattice gauge theory). |
| H6 | **Bundle trivialization / cocycle consistency:** `O_{ij}` is (approximately) a cocycle of a genuine bundle; obstruction (discrete curvature) `→ 0` in the right norm | Otherwise the limit is not `∇*∇` of any connection | Plaquette defect `U_∂f − 1 = O(h²)` controls this | Acceptance: discrete curvature bounded and scaling as `h²`; ties to D13. FAIL if frustration/curvature is O(1) (topologically nontrivial, no trivialization). |
| H7 | **Boundary conditions** | Spectral convergence theorems are cleanest on closed `M`; boundary needs Neumann/Dirichlet handling | Finite graphs have boundary; layered graphs have temporal boundary | Acceptance: closed/periodic spatial slice (torus) removes boundary issue. Otherwise prove Neumann convergence separately (harder). |
| H8 | **Normalization:** density-corrected (α-normalized) graph Laplacian to kill sampling-density bias; correct `1/ε` and degree normalization | Singer–Wu/Coifman–Lafon: only the normalized operator converges to the clean Bochner Laplacian | `S_H` as written is the *unnormalized* Dirichlet form | **Critical:** decide the normalization once and prove `S_H`'s symmetric part equals the α=1 (or degree-normalized) connection Laplacian up to controlled lower order. Mismatch here silently changes the continuum operator. |
| H9 | **Symmetry / ellipticity of the operator being converged** | All cited rates are for self-adjoint elliptic `L_ε`; spectral perturbation needs real spectrum & spectral gap | **Null-edge retarded `D_+` is non-Hermitian by design** (roadmap §"Retardedness") | **Convergence applies to the symmetric square, NOT to `D_+`.** See §3. This is the load-bearing caveat. |
| H10 | **Spectral gap / no spectral pollution** | To match eigenvalues/eigenspaces, need gaps and absence of spurious modes (cf. DEC eigenvalue convergence) | Doublers / flat branches (Gate C) are exactly spurious-mode risks | Acceptance: Gate C doubler audit shows the low-lying spectrum is clean; reuse S7/Gate C results. FAIL ⇒ spectral convergence is meaningless even if norm-resolvent holds. |

**Verdict.** H4 passes natively; H1, H9 are the structural blockers (Lorentzian
base, non-Hermitian retarded operator); H2, H5, H6, H8 are arrangeable
engineering conditions with explicit acceptance tests; H10 ties to existing Gate
C work.

---

## 3. Causal directionality vs. symmetric elliptic structure (question 3)

This is the central no-go pressure point. State it sharply:

- A connection Laplacian converges **because** its off-diagonal blocks are a
  *Hermitian* twist of a symmetric graph Laplacian: `(L_ε)_{ij} = w_{ij} O_{ij}`
  with `O_{ji} = O_{ij}^†` and `w_{ji}=w_{ij}`. Self-adjointness ⇒ real spectrum,
  spectral theorem, and the entire perturbation/convergence machinery.
- The null-edge retarded operator is `D_+ = Σ_a C_a (T_a − I)/h` with `T_a` a
  one-sided (future) shift. It is **deliberately non-Hermitian**: non-Hermiticity
  is presented in the roadmap as *a consequence of causal support*, not a bug.
- **These two demands are mutually exclusive for one operator.** You cannot ask
  the same operator to (a) be the self-adjoint elliptic object whose convergence
  Singer–Wu/Ramanan prove, and (b) carry primitive one-sided causal support.

Resolution (the only viable architecture):

1. **Converge the symmetric square, not the retarded operator.** The Lorentzian
   audit object is already the **Krein double**
   `D_dbl = [[0, D_-],[D_+,0]]`, `D_- = D_+^♯`, with
   `D_dbl² = diag(D_- D_+, D_+ D_-)`. The diagonal blocks `D_- D_+` and
   `D_+ D_-` are the candidates for a **second-order, formally self-adjoint**
   operator to which an elliptic-convergence statement *might* apply after Wick
   rotation / on a Riemannian slice.
2. **Recover causality as extra data after the limit**, via the retarded/advanced
   doubling, not from the convergence theorem itself.
3. Accept that **the convergence theorem certifies the kinetic/elliptic content
   only.** Causal support is a *separate* property to be tested by the D15 probes.

Practical consequence for D14: the inheritable theorem is for
`Δ^A = (D^A)* D^A` (the symmetric Higgs/gauge Dirichlet Laplacian), i.e. the
**scalar/gauge kinetic reconstruction**, and explicitly *not* for the Lorentzian
d'Alembertian. This is the clean separation demanded by question 7.

---

## 4. What is finitely provable now vs. analytic vs. interpretation

Triage for Lean staging (matches the project's "finite-now / continuum-later"
discipline):

**Finitely provable now (Lean, Gate-D-finite):**

- F1. `S_H` gauge invariance and the frozen-modulus identity
  `S_H = v² Σ_e |w_e−1|²` (working plan §16.7) — already an S3 proof target
  (`NullEdgeAbelianHiggsLink.lean`); reuse, do not re-derive.
- F2. `S_H` = quadratic form of a Hermitian graph connection Laplacian:
  `S_H(φ) = ⟨φ, Δ^A_graph φ⟩`, `Δ^A_graph ⪰ 0`, kernel = covariantly constant
  sections. Pure finite linear algebra. **New Lean lemma worth adding.**
- F3. Small-holonomy expansion bound: `| v²|w_e−1|² − v² ε² A_e² | ≤ C ε⁴`,
  finite/elementary.
- F4. Krein-double square identity `D_dbl² = diag(D_-D_+, D_+D_-)` and
  self-adjointness of `D_dbl` w.r.t. `J_0` — finite linear algebra (Gate C/D-finite).
- F5. Consistency (truncation) estimate on a *fixed* mesh:
  `Δ^A_graph s = Δ^A_cont s + O(h)` pointwise for smooth `s` — a finite Taylor
  estimate, *not* the full spectral convergence.

**Analytic / continuum (cite, scaffold, do NOT claim as proved):**

- A1. Full spectral / norm-resolvent convergence `Δ^A_graph → ∇*∇` (Singer–Wu /
  Ramanan). This is heavy analysis (heat kernel, concentration, spectral
  perturbation). Treat exactly as D13 treats Dabetic–Hiptmair: inherit as an
  external scaffold, state the hypotheses (§2), do not reprove in Lean.
- A2. Eigenvalue/eigenspace convergence with rates (needs H10 spectral gap).
- A3. Convergence of the Yang–Mills curvature term `Σ_f|U_∂f−1|² → ∫|F|²`
  (DEC, ties to D13).

**Manuscript interpretation only (flag, do not formalize as theorem):**

- M1. "Therefore W/Z masses are reconstructed in the continuum." This is the
  *physical reading* of F2+F3+A1 under the §16.7 assumption ledger (frozen
  modulus, small holonomy, correct scaling, fixed kinetic normalization). It is
  not a theorem; it is the conclusion of a chain whose analytic link (A1) is
  inherited, not proved.
- M2. Any statement that the *Lorentzian* gauge dynamics converges. Out of scope
  for D14; routed to D15.

---

## 5. D14 falsification probes (finite, fast, decisive)

These are cheap symbolic/numerical checks that would *kill* the continuum claim
without doing any analysis. Run before investing in A1.

- P14.1 **Normalization sanity (H8).** On a 1D and 2D periodic lattice with
  trivial `A`, compute the symmetric part of `Δ^A_graph` from `S_H` and compare
  its symbol to `k²` (continuum Laplacian) at leading order. If the leading
  symbol is not `c·|k|²` with a *single* constant for all directions ⇒ anisotropy
  ⇒ no rotation-invariant continuum Laplacian ⇒ **falsified**. Lean: `decide`/
  `native_decide` on the finite difference stencil symbol.
- P14.2 **Scaling-compatibility (H3).** Symbolically require the scalar term and
  the plaquette/gauge term to share one power of `h`. If the exponents differ,
  no joint continuum limit exists ⇒ **falsified or forces sector split**.
- P14.3 **Cocycle/curvature defect (H6).** On a small frustrated graph (nonzero
  discrete curvature O(1)) verify that `Δ^A_graph`'s low spectrum does *not*
  approach any `∇*∇` spectrum. Confirms convergence genuinely needs `F → 0`.
- P14.4 **Hermiticity probe (H9/§3).** Compute `D_+` on a tiny graph; verify it is
  non-normal (`D_+ D_+^† ≠ D_+^† D_+`). Confirms the retarded operator is *not*
  in the convergence class and that only the doubled square can be. This is a
  *positive* design check, not a falsification — it certifies the §3 split.
- P14.5 **Doubler/spectral-pollution probe (H10).** Reuse Gate C doubler count;
  if spurious near-zero modes persist under refinement, spectral convergence is
  vacuous ⇒ **falsified at the spectral level even if norm convergence holds**.

A single failure in P14.1, P14.2, P14.3, or P14.5 is sufficient to abandon the
inherited-convergence route for that sector.

---

## 6. Safe ordering relative to D13 and Gate C (deliverable)

Recommended dependency order (earliest first):

1. **Gate C doubler/branch audit (S7, existing)** — *prerequisite* for H10/P14.5.
   Without a clean low spectrum, no convergence claim means anything.
2. **D14-finite (F1–F5)** — finite Lean lemmas; can run in parallel with D13.
   Lowest risk, highest certainty, immediately durable.
3. **D13 (DEC Hodge–Dirac convergence strategy)** — supplies the exterior-calculus
   convergence scaffold needed for the *curvature* term (A3) and shares H1/H2/H6
   hypotheses with D14. D14's connection-Laplacian claim (A1) and D13's
   Hodge–Dirac claim should be stated against **one common hypothesis ledger**
   (this document's §2) to avoid divergent assumption sets.
4. **D14-analytic inheritance (A1, A2)** — only after D13 fixes the DEC/mesh
   conventions, so the two convergence statements are mutually consistent.
5. **D15 (causal d'Alembertian probe)** — *after* D14 establishes the symmetric
   limit, because D15 asks whether causal support can be reintroduced on top of a
   limit that D14 certifies only in the symmetric/elliptic sector.

Rule: **never start D15 or the Lorentzian claim before the Euclidean symmetric
limit (D14) is either proved-finite or inherited.** Doing so risks proving
convergence of an operator (`D_+`) for which no convergence theorem exists (§3).

---

## 7. Downgrade plan if convergence fails

Ordered fallbacks, strongest first. Each is a *safe, non-silent* downgrade.

- **D-A (preferred downgrade):** Drop the Lorentzian/continuum gauge-mass claim;
  keep **F1–F4 as exact finite theorems** ("gauge-invariant link stiffness" +
  "connection-Laplacian quadratic form" + "Krein-double square"). Manuscript
  language: *exact finite link stiffness; continuum mass is interpretation under
  a stated assumption ledger.* This is the wording the working plan §16.7 already
  endorses and costs nothing.
- **D-B (if H1 Riemannian base is unavailable):** Restrict all convergence claims
  to a **fixed spatial slice / Wick-rotated Euclidean model**; state Lorentzian
  reconstruction as open. Keeps the scalar/gauge kinetic reconstruction (question
  7's scalar half) while explicitly surrendering Lorentzian dynamics.
- **D-C (if H5/H6 fail — deep nonperturbative holonomies / O(1) curvature):**
  Abandon the connection-Laplacian limit entirely; reposition the gauge sector as
  **lattice gauge theory** with confinement supplied by QCD (consistent with the
  COMMON_CONTEXT guardrail "QCD supplies confinement and dynamics; Plücker
  supplies invariant accounting"). No continuum-limit theorem is claimed.
- **D-D (if H3 scaling-incompatible, P14.2 fails):** Split scalar and gauge
  sectors into *separate* limits with *different* scalings; report that there is
  no single joint continuum theory — a genuine (publishable) negative result.
- **D-E (if H10/P14.5 fails — irremovable spectral pollution):** Downgrade from
  spectral convergence to *form/quadratic* convergence only; state that
  eigenvalue matching (hence mass-spectrum reconstruction) is not available.

Floor that always survives: the **exact finite gauge-invariant link-stiffness and
connection-Laplacian quadratic-form theorems (F1–F4)** stand regardless of every
continuum failure above. Protect these as the durable artifact.

---

## 8. One-line answers to the seven analysis questions

1. **Mapping:** `S_H`/holonomy = quadratic form of a Hermitian graph connection
   Laplacian `Δ^A=(D^A)*D^A`; `U_e ↔` Singer–Wu transport cocycle `O_{ij}`,
   edge weight `↔ w_{ij}`, so the continuum target is the Bochner Laplacian
   `∇*∇` (§1, §2).
2. **Required assumptions:** H1–H10 of §2 — Riemannian compact base, regular
   mesh/i.i.d. sampling, bandwidth scaling, **compact group (satisfied)**,
   `C^{1,1}` connection regularity, bundle trivialization / curvature `→0`,
   boundary handling, density normalization, symmetry/ellipticity, spectral gap.
3. **Causal vs. elliptic:** **Yes, direct conflict** (§3). Retarded `D_+` is
   non-Hermitian by design; convergence theorems are for self-adjoint elliptic
   operators. Resolution: converge the symmetric **square** `D_+^♯ D_+`, recover
   causality separately.
4. **Retarded/advanced doubling:** the Krein double `D_dbl` makes the *square*
   self-adjoint and is the only object with a chance of inheriting convergence;
   whether doubling avoids the causet-d'Alembertian instabilities is the subject
   of D15 (see companion).
5. **Fast falsification:** §5 P14.1–P14.5 (symbol anisotropy, scaling
   incompatibility, curvature-defect, non-normality, spectral pollution) — all
   finite, several `decide`-able.
6. **Redesign the retarded kernel first?** Treated in D15; D14's finding is that
   the *symmetric* sector should be settled first so the kernel redesign is judged
   against a known-good elliptic limit.
7. **Separation:** scalar/gauge kinetic reconstruction = D14 symmetric elliptic
   limit (inheritable, partly finite); full Lorentzian causal dynamics = D15
   (open, falsification-gated). Keep them in different documents and different
   Lean files; never let the convergence theorem be cited as evidence for
   Lorentzian dynamics.
