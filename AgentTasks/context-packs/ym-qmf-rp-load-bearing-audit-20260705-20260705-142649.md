# Aristotle semantic context pack

Generated: 2026-07-05T14:27:02
Query: `QMF compact Haar SU(N) gauge reflection invariance reflection positivity load bearing audit`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/model-calls/claude/2026-06-24-round-015-adversarial-next-job.md` [Adversarial Critique: Two-Reflection Invariant Job  ## Verdict **Conditionally yes, but Gemini's framing is too loose and will silently drift into Mathlib's complex spectral theory.** The right job ex]

Score: `0.769`

```text
lines). Re-using the name "reflection" without auditing P2's existing `branchReflection` definition risks a silent mismatch. - **Signature / J-convention.** Mostly-plus vs mostly-minus flips signs in every identity. Pin in the docstring. - **Branch label vs orientation.** P2 has open tasks `branch-orientation`, `branch-resolution`, `positive-branch-projector`. Whether `R₁` and `R₂` are same-branch or opposite-branch changes whether their product is in SO or in a coset. - **Order matters for the matrix but not the trace.** Tempting to "prove" `R₂R₁ = R₁R₂` from `tr` equality — don't. - **Pairing operator.** Whether the invariant is a function of `⟨n₁,n₂⟩_J`, `⟨n₁,n₂⟩_Euclid`, or a Plücker pairing — all three are floating around in the P1 tasks.  ## Duplicate risks  - **`p2-reflection-product-det-parity`** (just landed): covers `det = +1`. Do not re-prove. - **`p2-branch-reflection`**, **`p2-positive-branch-projector`**, **`p2-chiral-projector-coherence`**: any of these may have already exposed `R * R = I` or `tr R = 0`, which are lemmas you'll want. Audit before writing. - **`p2-p9-reflection-screen-variance`** and **`p2-p9-reflection-iteration-variance`**: iteration-variance work might already pin a trace lemma in disguise. Check. - **`p1-su2-normalized-det-invariance`**: if reflections are SU(2) involutions there, the trace formula already lives there as `Re tr = 2 cos(θ/2)`. High duplicate risk.  ## Sharpened job (single focused Aristotle target)  **Title:** `null-edge-p2-two-reflection-trace-invariant`  **Smallest publication-worthy theorem set** (finite-dimensional, real, no spectral theory, no arccos):  ```lean -- Setup: assume branchReflection : NullDir → Matrix (Fin 2) (Fin 2) ℝ --        is the existing P2 construction with det = -1 and R*R = I.  /-- Trace of a
```

### 2. `AgentTasks/model-calls/claude/2026-06-24-round-015-adversarial-next-job.md` [Adversarial Critique: Two-Reflection Invariant Job  ## Verdict **Conditionally yes, but Gemini's framing is too loose and will silently drift into Mathlib's complex spectral theory.** The right job ex]

Score: `0.760`

```text
(g : SOSubgroup) (n₁ n₂ : NullDir) :     tauTwoReflection (g • n₁) (g • n₂) = tauTwoReflection n₁ n₂ ```  That is six theorems, all proved by **direct 2×2 entry expansion + `ring` / `nlinarith`**, no `Matrix.charpoly`, no `Complex`, no `Real.arccos`.  ## Why this is the right one-job target  - It is the **unique scalar** left after your det guardrail killed the parity invariant. Non-duplicative by construction. - It is **finite real Lean**: no spectral theory, no transcendentals. - It **gives the path-product program its first nontrivial conserved quantity**, which is what P2 needs to advance to P3/P4 mass extraction (`p4-mass-from-normalized-readout` is downstream of having a real-valued composite invariant). - The `|τ| ≤ 1` bound is the honest, Lean-friendly stand-in for "this is a cosine" — it preserves the physics intuition without committing to `Real.cos` in the statement.  ## What to drop from Gemini's proposal  - Drop the word "phase." - Drop "eigenspectrum." - Drop any plan to extract a real `θ` via `arccos`. If you need an angle, define it downstream in a separate job, gated behind `τ ∈ [-1,1]`.  ## One pre-flight check before opening the job  Grep `branchReflection`, `Matrix.trace`, and the existing P2 task ledgers for `trace`. If `trace_branchReflection = 0` or `tauTwoReflection_self = 1` already exists under a different name in `p2-branch-reflection` or `p1-su2-normalized-det-invariance`, refactor instead of duplicate.
```

### 3. `AgentTasks/model-calls/gemini/2026-06-24-round-021-adversarial-next-target.md` [Current integrated theorem state]

Score: `0.758`

```text
## Current integrated theorem state

Recent P2 branch-reflection results in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`:

- one branch reflection is trace zero;
- determinant products of branch reflections carry only reflection-count parity;
- two-reflection trace:
  `trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`;
- three-reflection trace is zero;
- four-reflection trace has an explicit scalar formula in the current
  `h,p,m,E` API;
- concrete witnesses prove unconstrained four-reflection trace is not constant:
  `trace(A A A A)=2` and `trace(B A B A)=-2` for
  `A = branchReflection 1 1 0 1`,
  `B = branchReflection 1 0 1 1`.

Recent P2/P3 super-Dirac gate:

- `PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature` proves finite scalar
  identities relating additive one-diamond defect and multiplicative holonomy
  defect:
  `left - right = (left / right - 1) * right` when `right != 0`;
  multiplicative triviality is equivalent to additive defect zero.

Recent P9 source-visibility results:

- `PhysicsSM.Draft.NullEdgeP9DiamondScreenVisibility` proves exact local screen
  bookkeeping pairs to zero with closed tests, rank-one exact-source noise also
  vanishes, and any source with nonzero closed-test response cannot be exact.
- `PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound`,
  `NullEdgeP9ScreenVarianceBound`, and P2/P9 reflection-screen variance modules
  provide screen-cardinality and variance support.

Recent P1 observer-normalization support:

- fixed observer/rest Hermitian data leaves residual `SU(2)` spin-frame
  freedom;
- two-null observer-axis scalar bridge relates unnormalized mass square and
  trace-normalized determinant;
- residual unitary determinant-one congruence preserves the trace-normalized
  determinant;
- normalized readout can recover `m^2` when
```

### 4. `AgentTasks/model-calls/context-packs/2026-06-24-round-021-context.md` [Current integrated theorem state]

Score: `0.758`

```text
## Current integrated theorem state

Recent P2 branch-reflection results in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`:

- one branch reflection is trace zero;
- determinant products of branch reflections carry only reflection-count parity;
- two-reflection trace:
  `trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`;
- three-reflection trace is zero;
- four-reflection trace has an explicit scalar formula in the current
  `h,p,m,E` API;
- concrete witnesses prove unconstrained four-reflection trace is not constant:
  `trace(A A A A)=2` and `trace(B A B A)=-2` for
  `A = branchReflection 1 1 0 1`,
  `B = branchReflection 1 0 1 1`.

Recent P2/P3 super-Dirac gate:

- `PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature` proves finite scalar
  identities relating additive one-diamond defect and multiplicative holonomy
  defect:
  `left - right = (left / right - 1) * right` when `right != 0`;
  multiplicative triviality is equivalent to additive defect zero.

Recent P9 source-visibility results:

- `PhysicsSM.Draft.NullEdgeP9DiamondScreenVisibility` proves exact local screen
  bookkeeping pairs to zero with closed tests, rank-one exact-source noise also
  vanishes, and any source with nonzero closed-test response cannot be exact.
- `PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound`,
  `NullEdgeP9ScreenVarianceBound`, and P2/P9 reflection-screen variance modules
  provide screen-cardinality and variance support.

Recent P1 observer-normalization support:

- fixed observer/rest Hermitian data leaves residual `SU(2)` spin-frame
  freedom;
- two-null observer-axis scalar bridge relates unnormalized mass square and
  trace-normalized determinant;
- residual unitary determinant-one congruence preserves the trace-normalized
  determinant;
- normalized readout can recover `m^2` when
```

### 5. `AgentTasks/model-calls/claude/2026-06-24-round-021-constructive-next-target.md` [Current integrated theorem state]

Score: `0.758`

```text
## Current integrated theorem state

Recent P2 branch-reflection results in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`:

- one branch reflection is trace zero;
- determinant products of branch reflections carry only reflection-count parity;
- two-reflection trace:
  `trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`;
- three-reflection trace is zero;
- four-reflection trace has an explicit scalar formula in the current
  `h,p,m,E` API;
- concrete witnesses prove unconstrained four-reflection trace is not constant:
  `trace(A A A A)=2` and `trace(B A B A)=-2` for
  `A = branchReflection 1 1 0 1`,
  `B = branchReflection 1 0 1 1`.

Recent P2/P3 super-Dirac gate:

- `PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature` proves finite scalar
  identities relating additive one-diamond defect and multiplicative holonomy
  defect:
  `left - right = (left / right - 1) * right` when `right != 0`;
  multiplicative triviality is equivalent to additive defect zero.

Recent P9 source-visibility results:

- `PhysicsSM.Draft.NullEdgeP9DiamondScreenVisibility` proves exact local screen
  bookkeeping pairs to zero with closed tests, rank-one exact-source noise also
  vanishes, and any source with nonzero closed-test response cannot be exact.
- `PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound`,
  `NullEdgeP9ScreenVarianceBound`, and P2/P9 reflection-screen variance modules
  provide screen-cardinality and variance support.

Recent P1 observer-normalization support:

- fixed observer/rest Hermitian data leaves residual `SU(2)` spin-frame
  freedom;
- two-null observer-axis scalar bridge relates unnormalized mass square and
  trace-normalized determinant;
- residual unitary determinant-one congruence preserves the trace-normalized
  determinant;
- normalized readout can recover `m^2` when
```

### 6. `PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean` [trace2_mul_four_branchReflections_formula]

Score: `0.757`

```text
theorem trace2_mul_four_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real) :
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      2 * ((((h1 * p1) * (h2 * p2) + m1 * m2) *
            ((h3 * p3) * (h4 * p4) + m3 * m4)) -
          ((m1 * (h2 * p2) - (h1 * p1) * m2) *
            (m3 * (h4 * p4) - (h3 * p3) * m4))) /
        (E1 * E2 * E3 * E4) := by
  unfold branchReflection trace2 chiralHamiltonian
  norm_num [Matrix.mul_apply]
  ring

/-- The diagonal four-reflection witness has trace `2`. -/
```

### 7. `AgentTasks/model-calls/claude/2026-06-24-round-015-adversarial-next-job.md` [Adversarial Critique: Two-Reflection Invariant Job  ## Verdict **Conditionally yes, but Gemini's framing is too loose and will silently drift into Mathlib's complex spectral theory.** The right job ex]

Score: `0.756`

```text
al, no spectral theory, no arccos):  ```lean -- Setup: assume branchReflection : NullDir → Matrix (Fin 2) (Fin 2) ℝ --        is the existing P2 construction with det = -1 and R*R = I.  /-- Trace of a single branch reflection vanishes. -/ theorem trace_branchReflection     (n : NullDir) :     Matrix.trace (branchReflection n) = 0  /-- The two-reflection invariant: a single scalar τ ∈ ℝ,     defined as half the trace of the composite. -/ def tauTwoReflection (n₁ n₂ : NullDir) : ℝ :=   Matrix.trace (branchReflection n₂ * branchReflection n₁) / 2  /-- τ is bounded: |τ| ≤ 1 (so it lives in the same range     as cos, without invoking cos). -/ theorem tauTwoReflection_abs_le_one     (n₁ n₂ : NullDir) :     |tauTwoReflection n₁ n₂| ≤ 1  /-- τ is symmetric in its arguments (cyclic trace). -/ theorem tauTwoReflection_symm     (n₁ n₂ : NullDir) :     tauTwoReflection n₁ n₂ = tauTwoReflection n₂ n₁  /-- τ collapses on the diagonal: a reflection composed with itself is I. -/ theorem tauTwoReflection_self     (n : NullDir) :     tauTwoReflection n n = 1  /-- τ is a polynomial in the chosen pairing of n₁ and n₂.     State the explicit formula. This is THE publication-worthy line. -/ theorem tauTwoReflection_formula     (n₁ n₂ : NullDir) :     tauTwoReflection n₁ n₂ = 1 - 2 * (branchPairing n₁ n₂)^2     -- exact form depends on the existing branchReflection definition;     -- derive by direct 2x2 expansion, no eigenvalues.  /-- Conjugation invariance: τ is unchanged under simultaneous     SO(·) action (the orientation-preserving stabilizer). -/ theorem tauTwoReflection_conj_invariant     (g : SOSubgroup) (n₁ n₂ : NullDir) :     tauTwoReflection (g • n₁) (g • n₂) = tauTwoReflection n₁ n₂ ```  That is six theorems, all proved by **direct 2×2 entry expansion + `ring` / `nlinarith`**, no
```

### 8. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [44. Integrated Aristotle update: C194-C203 after C193]

Score: `0.756`

```text
weight.
```

A mismatch in any one field blocks the reference import. It also reconstructs
the C193-style uniqueness theorem at the signature level:

```text
mu_ref(n,ell) < 0 iff (n,ell) = (0,0).
```

C197 supplies the `SMActsInternally` audit framework. The branch data used by
`J`, `Gamma_K`, `R`, and `W_CKM` must sit in the centralizer of all SM gauge
generators, or be handled by an explicit gauge-dressed replacement. The hard
warning is:

```text
if gauge generators mix the branch parity used by the CKM selector, native C1
branch selection fails.
```

C198 supplies the multi-stage homotopy fallback:

```text
H_Wilson+CKM -> H_abs.block -> H_ne.
```

The composition theory is useful, but it leaves one documented analytic
eigenvalue-continuity/signature-preservation obligation. Treat C198 as a
scaffold, not a closed theorem.

C199 strategy audit recommends making the kappa mismatch bound the critical
path. C193 should be packaged as a reusable gap lemma, while `SMActsInternally`
and source certificates remain required but off the immediate proof bottleneck.

C200 attempted a project draft port of C193 but did not have the actual C193
Lean artifact available in its request project. It reconstructed parts of the
source and reported non-matching concrete choices. Therefore:

```text
do not promote the C200 port;
use the actual C193 artifact instead.
```

C201 supplies the `gamma_free` sign-stability theorem. In scalar form:

```text
m(phys) <= -gamma;
m(s) >= gamma for s != phys;
|delta(s)| < gamma for all s
  implies
m(phys)+delta(phys) < 0
and
m(s)+delta(s) > 0 for s != phys.
```

It also gives an operator-style homotopy theorem assuming a Weyl/Lipschitz drift
certificate. This is exactly how C193 feeds the kappa/alpha/beta budget.

C202 supplies the branch-line lift s
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.741`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Comment on 'Gauge networks in noncommutative geometry'

Score: `0.737`
Zotero key: `Q55ZUJSZ`
arXiv: `2508.17338`
DOI: `10.48550/arXiv.2508.17338`
URL: https://arxiv.org/abs/2508.17338

Abstract:

A critique of the gauge-network spectral-action construction arguing that the continuum limit is pure Yang-Mills without a Higgs scalar.

### 3. An invitation to higher gauge theory

Score: `0.736`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.735`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. Gauged twistor formulation of a massive spinning particle in four dimensions

Score: `0.729`
Zotero key: `arxiv:1512.07740`
arXiv: `1512.07740`
DOI: `10.1103/PhysRevD.93.045016`
URL: http://arxiv.org/abs/1512.07740

Abstract:

Gauged generalized Shirafuji action for a massive spinning particle with local U(1) and SU(2) symmetries, constraints, and Penrose transform to massive spinor fields.
