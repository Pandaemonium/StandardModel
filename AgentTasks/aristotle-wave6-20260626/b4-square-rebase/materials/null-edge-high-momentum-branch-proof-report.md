# High-momentum tetrahedral null branch: Lean proof report

Type: kernel-checked Lean proof report (finite branch-data theorem). This
documents the deliverable `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean`,
the Lean/numeric follow-up (T16 proof job) to the determinant-level branch-count
protocol.

Claim label: **consistency check / no-go finite identity (S)**. This is finite
branch data, NOT a physical doubler theorem and NOT a safety certificate.

Provenance and program anchors:

- `PROMPT.md` (this job's target theorem package and guardrails).
- `AgentTasks/null-edge-flat-branch-count-protocol.md` Sections 2 (inverse-Gram
  form and warning example) and 5 (discrete corner doublers).
- `AgentTasks/null-edge-branch-count-acceptance-criteria.md` Section 0
  (determinant-level premise) and Section 2 (`p_sq`, `is_coeff_zero` columns).
- `AgentTasks/null-edge-branch-script-report.md` Section 3 (raw corner numbers
  reproduced here as kernel-checked theorems).
- `docs/CONVENTIONS.md`: "Metric signature" (mostly-minus, Locked),
  "Branch-count / no-doubling test" (Locked audit rule), "Krein / Lorentzian
  adjointness" (Locked non-overclaim rule).

---

## 1. What is proved

The file formalizes, over the complex numbers, the finite algebra of the flat
tetrahedral retarded dual-soldered null-edge Dirac symbol on the discrete
corner set `q_a in {0, pi}^4` of the Brillouin torus, with lattice spacing
`h = 1` and mostly-minus Lorentzian signature `g = diag(+,-,-,-)`.

### 1.1 Inverse Gram matrix and the Lorentzian quadratic form

- `Ginv` : the tetrahedral inverse Gram matrix on `Fin 4`, diagonal `-1/2`,
  off-diagonal `1/4`.
- `Ginv_eq` : `G^{-1} = -3/4 . I + 1/4 . J` (identity plus all-ones matrix).
- `qform u = sum_{i,j} u_i (G^{-1})_{ij} u_j` : the Lorentzian quadratic form
  `p(q)^2 = u^T G^{-1} u` in edge-phase coordinates.
- `qform_eq` : closed form `u^T G^{-1} u = -3/4 . sum_a u_a^2 + 1/4 . (sum_a u_a)^2`.

### 1.2 The warning example `q = (pi, pi, pi, 0)`

- `cornerU s a = exp(i q_a) - 1` with `q_a = pi` if the bit `s a` is set else
  `0`; `cornerU_apply` proves `u_a = -2` at a `pi` edge and `u_a = 0` at a `0`
  edge (via `Complex.exp_pi_mul_I` and `Complex.exp_zero`).
- `warning_u` : `u = (-2, -2, -2, 0)`.
- `warning_uT_Ginv_u` : **`u^T G^{-1} u = 0` while `u != 0`.** This is the
  decisive finite identity: a high-momentum null Clifford singularity whose
  symbol coefficient (the retarded vector `u`, equivalently `p(q)` since the
  `alpha^a` form a basis) is nonzero, but whose Lorentzian quadratic form is
  null.

### 1.3 All four three-pi corners

- `threePi_null` : every corner with exactly three `pi` edges (the four
  permutations of `(pi,pi,pi,0)`) satisfies `u^T G^{-1} u = 0` and `u != 0`.

### 1.4 Full classification of the 16 `{0, pi}^4` corners

With `k = cornerCount s` the number of `pi` edges:

- `corner_qform` : `u^T G^{-1} u = k^2 - 3k` (closed form per corner).
- `corner_origin` (`k = 0`) : `u = 0` and `p^2 = 0` (coefficient-zero null).
- `threePi_null` (`k = 3`) : `p^2 = 0`, `u != 0` (high-momentum nonzero null).
- `corner_spacelike` (`k in {1,2}`) : `p^2 = -2` (spacelike).
- `corner_timelike` (`k = 4`) : `p^2 = +4` (timelike).
- `cornerU_eq_zero_iff` : `u = 0` iff `k = 0` (only the origin is
  coefficient-zero).

Corner counts (kernel-checked by `decide`):

| theorem | corners | `k` | meaning |
| --- | --- | --- | --- |
| `count_origin` | 1 | 0 | origin, coefficient-zero null |
| `count_highMomentumNull` | 4 | 3 | high-momentum nonzero null |
| `count_spacelike` | 10 | 1 or 2 | spacelike, `p^2 = -2` |
| `count_timelike` | 1 | 4 | timelike, `p^2 = +4` |
| `count_null` | 5 | 0 or 3 | total null corners (1 + 4) |
| `count_total` | 16 | - | full corner set `{0,pi}^4` |

This reproduces, as kernel-checked theorems, the oracle numbers of
`AgentTasks/null-edge-branch-script-report.md` Section 3 and protocol Section 5:
`5 = 1 physical-point + 4 high-momentum null corners`, `10` spacelike, `1`
timelike.

### 1.5 Explicit Lorentzian (Minkowski) build

To make the mostly-minus signature explicit (not just packaged in `G^{-1}`):

- `sVec` : the four tetrahedral directions `s_1 = (1,1,1)`, `s_2 = (1,-1,-1)`,
  `s_3 = (-1,1,-1)`, `s_4 = (-1,-1,1)`.
- `alpha a` : the unit-normalized dual frame `alpha^A = (1/4) dt + (3/4) n_A.dx`,
  `n_A = s_A / sqrt(3)` (time component `1/4`, spatial components
  `(sqrt 3 / 4) s_A`).
- `pCov u mu = sum_a u_a alpha^a_mu` : the spacetime symbol covector `p(q)_mu`.
- `mink p = p_0^2 - p_1^2 - p_2^2 - p_3^2` : the mostly-minus Minkowski square.
- `pSq_mink_eq_qform` : **`mink (pCov u) = qform u`**, i.e. the genuine Minkowski
  square of the spacetime covector equals `u^T G^{-1} u` (this is exactly
  `alpha^a . alpha^b = (G^{-1})_{ab}` summed against `u`). Hence the values
  `0 / -2 / +4` are literally null / spacelike / timelike in the mostly-minus
  sense.
- `pCov_time` : `p_0 = (1/4) sum_a u_a`.
- `threePi_pCov_ne_zero` : for a `k = 3` corner the spacetime covector is
  nonzero, witnessed by `p_0 = -3/2 != 0` (so the "coefficient nonzero, form
  null" statement holds for the genuine spacetime covector, not only for `u`).

---

## 2. Conventions used

- Mostly-minus signature `g = diag(+,-,-,-)`: null `p^2 = 0`, spacelike
  `p^2 < 0`, timelike `p^2 > 0` (`docs/CONVENTIONS.md`, Locked).
- Tetrahedral inverse Gram `G^{-1} = -(d-1)/d I + (1/d) J = -3/4 I + 1/4 J`
  for `d = 4` (protocol Section 2; Open Questions 6.9 unit-normalized values
  `G^{-1}_AA = -1/2`, `G^{-1}_AB = 1/4`).
- Retarded phase vector `u_a = exp(i q_a) - 1` (forward difference).
- Lattice spacing normalized to `h = 1` (the `h^{-2}` prefactor of
  `p(q)^2 = h^{-2} u^T G^{-1} u` is dropped; it does not affect the sign /
  null classification).
- Field: complex numbers (faithful to `u = exp(i q) - 1`); on the corner set
  the values are real rationals in `{0, -2}`.

---

## 3. Guardrails (carried verbatim, not weakened)

- This is **finite branch data**, NOT a physical doubler theorem. Being a
  quadratic-form / determinant-level null is necessary but not sufficient to be
  a physical doubler.
- The classifiable object is the determinant / mass-shell zero
  (`det c(p(q)) = 0`, massless `p(q)^2 = 0`), never the coefficient-vector zero
  `p(q) = 0`. The theorems above precisely separate the two: only the origin is
  coefficient-zero (`cornerU_eq_zero_iff`), while the four `k = 3` corners are
  nonzero-coefficient nulls.
- Retardedness removes coefficient-zero doublers only; these four
  determinant-level high-momentum null corners remain and are still to be
  physically classified.
- Physical classification (Gate C) still needs, per branch, the data NOT
  computed here: energy-slice real/complex character, Krein `J`-sign, gauge /
  constraint content, spacetime chirality (`Gamma_s`) and internal grading
  (`chi_E`) decompositions, and `h`-scaling. Krein `J`-self-adjointness is a
  Lorentzian-adjointness audit, not a stability / real-spectrum / positivity
  theorem.

---

## 4. Verification

Commands run (toolchain pinned at `leanprover/lean4:v4.28.0`, Mathlib
`v4.28.0`):

```text
lake env lean PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean
```

Result: compiles with no errors, no warnings, no `s o r r y`, no info
diagnostics.

Axiom audit (`#print axioms`) for the headline theorems
(`warning_uT_Ginv_u`, `threePi_null`, `corner_qform`, `count_highMomentumNull`,
`count_null`, `pSq_mink_eq_qform`, `count_total`): each depends only on
`[propext, Classical.choice, Quot.sound]`. No `n a t i v e _ d e c i d e` /
`Lean.ofReduceBool`; all corner-count cardinalities are closed by kernel
`decide`.

---

## 5. Scope and follow-up

Delivered (finite, kernel-checked): the warning-example identity, the four
three-pi corners, the full 16-corner classification with counts, and the
explicit Minkowski identification `p(q)^2 = u^T G^{-1} u`.

Out of scope for this finite file (the physical-classification follow-up, per
the protocol Section 7 and the acceptance criteria Section 2 columns): the
energy-slice real/complex enumeration, the Clifford-kernel dimension and
chirality decomposition per branch, the Krein `J`-sign and doubled
multiplicity, and the `h`-scaling (physical / gapped / divergent / artifact)
classification that would decide whether the four high-momentum null corners
are fatal doublers (category 1.6), benign gapped branches (1.2), or
Krein-nonphysical (1.4).
