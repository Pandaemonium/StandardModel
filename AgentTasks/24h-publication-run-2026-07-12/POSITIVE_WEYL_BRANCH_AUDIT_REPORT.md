# Adversarial Audit — Positive Weyl Branch Completeness

**Target:** `AgentTasks/aristotle-targets/codex_24h_b_positive_weyl_branch_completeness.lean`
**Scope:** independent, adversarial verification of the seven `sorry`-carrying
statements *before* any proof is accepted. No Lean files were edited.

## Verdict

**All seven statements are TRUE as written.** No counterexamples exist. The two
biconditionals `weylStep_eq_one_iff` / `weylStep_eq_neg_one_iff` are genuine,
complete classifications (not one-way implications and not weakened to a sampled
list). `ZeroBranchData` / `PiBranchData` are exhaustive and mutually disjoint;
the Jacobian nondegeneracy and rank-deficient control claims hold. A proof
blueprint using existing repository declarations is given below.

Confidence basis:
- Exact quaternion/Pauli algebra worked out by hand (below), *and*
- an independent brute-force torus sweep (180³ ≈ 5.8M points): the SU(2) norm
  identity `u0² + w0² + w1² + w2² = 1` held to `7.8e-16`, and **zero**
  off-list near-solutions were found (any point with `|u0|=1`, `w≈0` had either
  all `cos²≈1` or all `cos≈0`).

---

## Exact structure used throughout

`weylStep q = pauliForm q` is already proved (`LiveWeylJacobian.weylStep_eq_pauliForm`).
Writing `cᵢ = cos(qᵢ)`, `sᵢ = sin(qᵢ)`,
```
u0 = c0 c1 c2 − s0 s1 s2
w0 = s0 c1 c2 + c0 s1 s2
w1 = c0 s1 c2 − s0 c1 s2
w2 = c0 c1 s2 + s0 s1 c2
```
`pauliForm q = u0·I − i(w0 σ1 + w1 σ2 + w2 σ3)`, which as a 2×2 complex matrix is
```
        ⎡ u0 − i·w2      −w1 − i·w0 ⎤
        ⎣ w1 − i·w0       u0 + i·w2 ⎦
```
with `u0, w0, w1, w2 ∈ ℝ`.

**Key algebraic fact (SU(2) norm).** `weylStep q` is a product of three unit
factors `weylFactor(qⱼ, σⱼ)`, each of quaternion norm `cⱼ²+sⱼ²=1`; hence
`u0² + w0² + w1² + w2² = 1` identically. (Confirmed to machine precision in the
numeric sweep.) This is *not even needed* for the two biconditionals below,
because matrix equality gives all four scalar equations directly, but it
explains why "`cos²=1` plus a product sign" is sufficient.

### Corner (⇔ real matrix) equality ⇒ four scalar equations
`pauliForm q = I` (entrywise) ⇔ `u0 = 1 ∧ w0 = 0 ∧ w1 = 0 ∧ w2 = 0`
(real part of (0,0) gives `u0=1`, imaginary part gives `w2=0`; off-diagonal
(0,1) `= −w1 − i·w0 = 0` gives `w0=w1=0`). Likewise `pauliForm q = −I`
⇔ `u0 = −1 ∧ w0 = w1 = w2 = 0`. No periodicity subtlety arises: the whole
system is phrased in `cos`/`sin`, so it is automatically `2π`-periodic in each
`qⱼ` and the classification is over the full torus.

### Solving `u0=1, w=0` (quaternion form `F1 F2 F3 = 1`)
`F1⁻¹F3⁻¹ = (c0c2; −c2 s0, −s0 s2, −c0 s2)` must equal `F2 = (c1; 0, s1, 0)`:
```
c1 = c0 c2 ,   c2 s0 = 0 ,   s1 = −s0 s2 ,   c0 s2 = 0 .
```
`c2 s0 = 0 ∧ c0 s2 = 0` splits into exactly two feasible cases (the other two
are impossible since `cⱼ²+sⱼ²=1`):

* **s0 = s2 = 0** ⇒ `s1 = 0`, `c1 = c0 c2`, so all `cᵢ² = 1` and
  `c0 c1 c2 = c0(c0c2)c2 = c0² c2² = 1`. This is exactly **ZeroBranchData
  branch A** (`cos²=1` for all three ∧ `∏cos = +1`).
* **c0 = c2 = 0** ⇒ `c1 = 0`, `s1 = −s0 s2`, so all `cᵢ = 0` and
  `s0 s1 s2 = s0(−s0 s2)s2 = −s0² s2² = −1`. This is exactly **ZeroBranchData
  branch B** (`cos=0` for all three ∧ `∏sin = −1`).

Conversely both branches give `u0=1, w=0` directly. Hence
`weylStep q = I ⇔ ZeroBranchData q`. **The product-sign conditions are not extra
assumptions — they are automatically forced by each family and merely recorded.**

### Solving `u0=−1, w=0` (`F1 F2 F3 = −1`)
Same computation with the sign flipped gives
`c1 = −c0c2, c2 s0 = 0, s1 = s0 s2, c0 s2 = 0`, so:
* **s0=s2=0** ⇒ all `cᵢ²=1`, `∏cos = c0(−c0c2)c2 = −1` → **PiBranchData A**.
* **c0=c2=0** ⇒ all `cᵢ=0`, `∏sin = s0(s0 s2)s2 = +1` → **PiBranchData B**.

Hence `weylStep q = −I ⇔ PiBranchData q`.

---

## Findings (severity-ranked)

### [None — Blocking] No false statement, no missing hypothesis.
All seven targets are provable as stated. No corrected theorem is required.

### [Info] S1 — `weylStep_eq_one_iff` is a true, complete biconditional.
`⇔` proved via matrix entries + the two-case quaternion solve above. Both
directions hold; the classification is exhaustive over the whole torus.

### [Info] S2 — `weylStep_eq_neg_one_iff` is a true, complete biconditional.
Symmetric to S1 with the global sign flipped.

### [Info] S3 — Disjointness `zeroBranchData_disjoint_piBranchData` holds.
Case cross-check on the four (Zero-family × Pi-family) combinations:
- corner/corner: `∏cos = +1` vs `−1` — contradiction.
- body/body: `∏sin = −1` vs `+1` — contradiction.
- corner/body and body/corner: `cos²=1` vs `cos=0` — contradiction.
Purely from the `Prop` data; needs no analytic input. (Also implied by
`u0=1` vs `u0=−1`.)

### [Info] S4 / S5 — Jacobian nondegeneracy on both branches.
`det (weylJacobian q) = u0 · (c1² − s1²)` is already proved
(`LiveWeylJacobian.det_weylJacobian`). On any crossing `u0 = ±1`, and:
- corner family: `c1² = 1, s1 = 0` ⇒ `c1² − s1² = 1`;
- body family: `c1 = 0, s1² = 1` ⇒ `c1² − s1² = −1`.
So `det = (±1)(±1) = ±1 ≠ 0`. Both S4 and S5 hold. (The `q1` factor never
vanishes on a crossing precisely because a crossing forbids the "middle"
mixed value `c1²=s1²=½` that produces rank deficiency.)

### [Info] S6 — Rank-deficient control is not a crossing.
`rankDeficientControl = (0, π/4, 0)`: `c0=c2=1, s0=s2=0, c1=s1=√2/2`. Then
`u0 = 1·(√2/2)·1 − 0 = √2/2 ∉ {±1}`, so `weylStep ≠ ±I`. (Consistently,
`det = (√2/2)(½−½) = 0`: rank deficiency without a branch crossing — exactly the
intended negative control.) `LiveWeylJacobian.rankDeficientControl_det` already
records the zero determinant.

### [Info] S7 — "cos²=1 plus product sign" question, answered.
The audit asks whether `cos²=1` together with a product sign is *sufficient*.
**Yes.** For the corner families, `cos²=1` forces every `sin=0`, so `w=0`
automatically and `u0 = ∏cos`; the single product-sign equation then pins
`u0=±1`. No independent `w=0` conditions are needed. Symmetrically, `cos=0`
forces `sin=±1`, `w=0`, `u0 = −∏sin`. The two families together are exhaustive
(the quaternion solve leaves no third case), so the definitions capture the full
solution set with no over- or under-specification.

---

## Proof blueprint (exact existing declarations)

Common rewrite for S1–S5:
`rw [LiveWeylJacobian.weylStep_eq_pauliForm]` then unfold
`LiveWeylJacobian.pauliForm`, `CubicWeylSectorCharge.sigma1/2/3`, `u0`,
`weylVector`.

- **S1/S2 (`…_eq_one_iff`, `…_eq_neg_one_iff`):**
  1. `Matrix.ext_iff` / `funext`+`fin_cases i,j` reduce matrix equality to the
     four entries; `Complex.ext_iff` splits each into real/imag parts, yielding
     `u0 = ±1 ∧ w0 = 0 ∧ w1 = 0 ∧ w2 = 0`.
  2. For the analytic core, prove the helper
     `(u0 q = 1 ∧ weylVector q 0 = 0 ∧ weylVector q 1 = 0 ∧ weylVector q 2 = 0)
        ↔ ZeroBranchData q`
     (and the `−1` analogue). Forward: introduce `hpy j : sin(qⱼ)^2+cos(qⱼ)^2=1`
     (`Real.sin_sq_add_cos_sq`), then `nlinarith`/`polyrith` on the two feasible
     cases from `c2·s0 = 0 ∧ c0·s2 = 0` (obtainable as `w`-combinations); the
     product-sign equalities follow by `ring`/`nlinarith`. Backward: substitute
     `sin=0` (branch A) or `cos=0` (branch B) and close with `nlinarith` using
     `Real.sin_sq_add_cos_sq`.
     *Recommended:* split each biconditional into two named directional lemmas
     and each direction into the corner/body sub-cases for the subagent.
- **S3 (`disjoint`):** `rintro` the conjunction, `rcases` both disjunctions into
  four cases, and in each derive a numeric contradiction with `nlinarith`/`linarith`
  (e.g. `∏cos = 1` vs `= −1`, or `cos²=1` vs `cos=0`).
- **S4/S5 (`…_jacobian_det_ne_zero`):** first turn `hq` into `ZeroBranchData q`
  (resp. `PiBranchData q`) via S1/S2, then
  `rw [LiveWeylJacobian.det_weylJacobian]`; `rcases` the branch, substitute
  `sin(q1)=0`/`cos(q1)=0`, and finish with `nlinarith`/`norm_num` using
  `Real.sin_sq_add_cos_sq (q 1)` to get `det = ±1 ≠ 0`.
- **S6 (`rankDeficientControl_not_crossing`):** `rw [weylStep_eq_pauliForm]`,
  unfold `rankDeficientControl`, `Real.cos_pi_div_four`, `Real.sin_pi_div_four`,
  `Real.cos_zero`, `Real.sin_zero`; then show the (0,0) entry `u0 = √2/2 ≠ 1`
  and `≠ −1` by comparing a single matrix entry (`Matrix.ext_iff`/`fun_prop` on
  entry `(0,0)` real part) and `norm_num` with `Real.sqrt_eq_iff`/`Real.sq_sqrt`.
  Alternatively, if a `weylStep = ±I → det = ±(c1²−s1²)` bridge is available,
  contradict `rankDeficientControl_det : det = 0`.

## Reproducibility

Numeric sweep (pure-Python, no deps) over `qⱼ ∈ {2πk/180}`:
`max |u0²+w0²+w1²+w2²−1| = 7.8e-16`; off-list solutions with `|u0|=1`, `‖w‖<1e-3`
that are neither "all cos²≈1" nor "all cos≈0": **0**.
