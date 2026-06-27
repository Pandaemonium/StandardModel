# Null-edge flat branch-count script: implementation report

Type: no-build script implementation report. This documents the oracle script
`Scripts/experiments/null_edge_branch_count.py`, which generates raw branch-count
data for the flat tetrahedral retarded dual-soldered null-edge Dirac symbol. It
is an oracle, NOT a trusted proof and NOT a safety certificate (AGENTS.md "CAS
and oracle policy").

Provenance and program anchors:

- `docs/CONVENTIONS.md`, "Branch-count / no-doubling test" (Locked audit rule).
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 20 (Gate C:
  flat branch and stability audit, 20.5-20.6) and 21 (integration freeze).
- `AgentTasks/null-edge-flat-branch-count-protocol.md` (the full determinant-
  level branch protocol whose Sections 1-8 this script realizes numerically).

Claim label: consistency check / no-go audit (S). The script defines and emits
what must be computed and what the raw numbers are; it does not certify the
operator.

---

## 1. What the script computes

On a flat periodic patch with edge phases `q_a` on the Brillouin torus `T^4`,
lattice spacing `h`, mostly-minus metric `g = diag(+,-,-,-)`:

```text
u_a    = exp(i q_a) - 1
G^{-1} = -3/4 I + 1/4 J             (tetrahedral inverse Gram, d = 4)
p(q)_mu = h^{-1} sum_a u_a alpha^a_mu
p(q)^2 = u^T G^{-1} u / h^2 = h^{-2} ( -3/4 S2 + 1/4 S1^2 ),
         S1 = sum_a u_a,  S2 = sum_a u_a^2.
```

The tetrahedral dual frame is built directly in spacetime from the
unit-normalized directions `s_A` (Open Questions 6.9):

```text
alpha^A = (1/4) dt + (3/4) n_A . dx,   n_A = s_A / sqrt(3).
```

The branch test is determinant-level, using an explicit 4x4 Dirac gamma
representation:

```text
det c(p(q)) = (p^2)^2 = 0                      (massless)
det( i c(p) + m gamma5 ) = (m^2 - p^2)^2 = 0   (mass-shell p^2 = m^2)
```

The coefficient-vector condition `p(q) = 0` is recorded per candidate but is NOT
used as a branch criterion.

The script implements protocol Section 7 steps 1-6 and the multiplicity part of
step 8, plus kernel dimensions (step 7 at sample points):

1. Symbol map and regression checks (Section 7.1-7.2).
2. Determinant reduction regression `det(i c(p) + m gamma5) = (m^2 - p^2)^2`.
3. Discrete corner scan `q_a in {0, pi}^4` (16 points), Section 5.
4. High-symmetry candidate enumeration (origin, the four three-pi corners
   including the warning point, all-pi, one-/two-pi corners), Sections 2-3, 5.
5. Energy-slice (propagating-branch) enumeration over real spatial slices,
   tagging roots real (`|z1| = 1`) vs complex (`|z1| != 1`), Section 6.
6. Optional numerical grid scan over the real torus, counting null grid points
   and reporting `max |Im p^2|`, Section 6.
7. Krein doubling multiplicity note (Section 7.8 / Working Plan 20.6).

---

## 2. Deliverables and output format

- Script: `Scripts/experiments/null_edge_branch_count.py` (standalone,
  stdlib-only: `cmath`, `csv`, `itertools`, `json`, `math`, `random`).
- A JSON summary is always printed to stdout.
- With `--outdir DIR`, machine-readable tables are written:
  - `branch_count_report.json` (full structured report).
  - `branch_count_corners.csv` (16-corner scan).
  - `branch_count_high_symmetry.csv` (high-symmetry candidate table).
  - `branch_count_energy_slice.csv` (per-root real/complex branch table).

Options: `--grid N`, `--slice-grid N`, `--mass M`, `--h H`, `--seed S`,
`--tol T`. Output files are written only to the chosen `--outdir`; the script
never touches repository build artifacts.

Raw vs interpretation separation: the CSV/JSON tables carry only raw branch data
(locations, `p^2`, kernel dimensions, real/complex tags, doubled multiplicity).
Physical classification (doubler vs cutoff artifact vs Krein-nonphysical) is
left to a separate audit, per the protocol Section 3 and the guardrails below.

---

## 3. Raw results (reproduced numbers)

Run: `python3 Scripts/experiments/null_edge_branch_count.py --grid 12 --slice-grid 6`.

Regression checks (all pass to machine precision):

- `G^{-1}` equals `-3/4 I + 1/4 J` (diagonal `-1/2`, off-diagonal `1/4`).
- `p^2` quadratic form agrees with the spacetime build.
- `det c(p) = (p^2)^2` and `c(p)^2 = p^2 I`.
- `det( i c(p) + m gamma5 ) = (m^2 - p^2)^2`.

Warning example `q = (pi, pi, pi, 0)`:

```text
u = (-2, -2, -2, 0),  coefficient vector p(q) != 0,
S1 = -6,  S2 = 12,  u^T G^{-1} u = -3/4*12 + 1/4*36 = 0,
p(q)^2 = 0  (massless null branch),  massless Clifford kernel dim = 2.
```

Discrete corner scan (`q_a in {0, pi}^4`):

```text
16 corners total; exactly 5 massless null corners
  = 1 origin (0,0,0,0) + 4 three-pi corners (permutations of three pi, one 0).
10 corners with p^2 = -2 (one or two pi's, spacelike).
1 corner (pi,pi,pi,pi) with p^2 = +4 (timelike, not null).
```

Grid scan over the real torus (`N = 12` per dimension, 20736 points):

```text
201 massless null grid points (the null set is a positive-dimensional
  2-real-dimensional variety, not a finite point set),
max |Im p^2| ~ 3.23 (p^2 is genuinely complex-valued on T^4).
```

Energy-slice enumeration (slice grid 6 per spatial dimension, 216 slices, 432
roots):

```text
Real propagating roots (|z1| = 1): a measure-zero minority.
Complex-energy roots (|z1| != 1): the overwhelming majority
  (pervasive complex branches, Chernodub-style warning, arXiv:1701.07426).
```

These numbers match the protocol document
(`AgentTasks/null-edge-flat-branch-count-protocol.md`) Sections 2, 5, 6.

---

## 4. Guardrails (carried verbatim; do not weaken)

- Retardedness avoids coefficient-zero doublers only; determinant-level branches
  remain to be tested.
- The physical test is `det c(p(q)) = 0` (massless `p(q)^2 = 0`), not
  `p(q) = 0`; a nonzero Lorentzian null covector has a Clifford kernel.
- The script does NOT claim the operator is safe or unsafe from raw data alone.
- Coefficient-vector zeros are NOT used as the branch criterion.
- Krein `J`-self-adjointness / doubling supplies multiplicity and sign
  classification data, not a real-spectrum, positivity, or stability theorem
  (Working Plan 20.6).

---

## 5. Scope and follow-up

Implemented here: protocol Section 7 steps 1-6 and the multiplicity content of
step 8, with kernel dimensions sampled at high-symmetry / corner points (step 7
at sample points). Left for the Lean/numeric follow-up (T16 proof job):

- Full chirality decomposition of each kernel under `Gamma_s` and the internal
  grading `chi_E` (step 7).
- Explicit `J`-inner-product sign per kernel (step 8).
- `h`-scaling classification (physical / gapped / divergent / artifact) of each
  branch (Open Questions 6.13.9 scaling order; Gate D input).

Status echo (from the protocol audit, not re-derived here): the flat tetrahedral
retarded operator exhibits 4 high-momentum corner null branches plus a
positive-dimensional null variety and pervasive complex-energy branches on
generic real spatial slices. This raw data refutes any no-doubling claim that
rests on `p(q) = 0 iff q = 0` alone; it does not by itself certify or condemn the
operator.
