# Flat determinant-level branch-count and no-doubling protocol

Type: no-build audit / protocol. This is an audit and protocol document, NOT a
proof that the operator is safe. It specifies the determinant-level branch test
for the flat retarded dual-soldered null-edge Dirac operator, works the
tetrahedral warning example, classifies it, and gives a finite enumeration
protocol with acceptance/failure criteria.

Provenance and program anchors:

- `docs/NULLSTRAND.md`, "No-doubling and branch-count tests" and "Krein double
  guardrails".
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 18.5 (blocker
  3), 18.6 (square/sign convention), 20.5 (Gate C), 20.6 (Krein addendum).
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` 6.13.7 (the
  decisive correction), 6.13.9 (scaling test order), 6.9 / 1245-1275 (frame and
  inverse-Gram normalization).
- `AgentTasks/null-edge-unified-mass-proof-chain.md` entry T16.
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md` C.3 (branch-count
  determinant tests), C.4 (Krein vs stability), D.7 (predictive vs
  reconstructive).
- Companion oracle script: `Scripts/experiments/null_edge_branch_count.py`
  (standalone, stdlib-only; reproduces every number below). The script is an
  oracle, not a trusted proof (AGENTS.md "CAS and oracle policy").

Claim label: this protocol is a **consistency check / no-go audit (S)**, in the
sense of the four-way label system (Working Plan 18.2). It does not certify the
operator; it specifies what must be computed and what would pass or fail.

---

## 0. Operator and the determinant-level test

On a flat periodic patch, with edge phases `q_a` on the Brillouin torus `T^4`
and lattice spacing `h`:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q)),
p(q)   = h^{-1} sum_a (exp(i q_a) - 1) alpha^a,
C_a    = c(alpha^a)        (dual-covector soldering, NOT c(ell_a^flat)).
```

The branch (singularity) test is determinant-level:

```text
det c(p(q)) = 0          (massless)
det( i D_+(q) + Gamma_s Phi ) = 0     (with internal mass block Phi)
```

NOT the coefficient-vector test `p(q) = 0`. Because the `alpha^a` form a basis,
`p(q) = 0` holds only when every `exp(i q_a) = 1`, i.e. `q = 0`. This rules out
**coefficient-zero doublers only**. A nonzero null `p(q)` (Lorentzian null
covector) still has `det c(p(q)) = 0` and a nontrivial Clifford kernel.

Guardrail (mandatory wording, NULLSTRAND / Working Plan 20.5): do not say
"retardedness avoids doublers". Say "retardedness avoids coefficient-zero
doublers; determinant-level branches remain to be tested."

---

## 1. Exact branch-count target for the tetrahedral 3+1 dual frame

Frame (observer-normalized unit version, Open Questions 6.9; `d = s + 1 = 4`):

```text
s_1=(1,1,1)  s_2=(1,-1,-1)  s_3=(-1,1,-1)  s_4=(-1,-1,1)
n_A = s_A / sqrt(3),  ell_A = (1, n_A),  e_0 . ell_A = 1,
alpha^A = (1/4) dt + (3/4) n_A . dx,  alpha^A(ell_B) = delta^A_B.
```

The Dirac symbol is `c(p) = gamma^mu p_mu` with mostly-minus metric
`g = diag(+,-,-,-)`. In four dimensions `det c(p) = (p . p)^2`, so the massless
determinant zero set is exactly the null cone of the symbol covector `p(q)`.

The closed-form branch target. Using the determinant reduction of Section 4, the
branch test for the full operator collapses to a single SCALAR condition:

```text
det( i D_+(q) + Gamma_s Phi ) = (m^2 - p(q)^2)^2 = 0
  <=>  p(q)^2 = m^2,    Phi = m (scalar internal block, Gamma_s = gamma_5).
```

So the exact branch-count target is:

> Characterize the zero set `Z_m = { q in T^4 : p(q)^2 = m^2 }`, and for each
> connected component / isolated point record (i) whether the implied energy is
> real (propagating) or complex (damped/growing), (ii) the Clifford kernel
> dimension, (iii) the spacetime chirality content of the kernel, (iv) the
> multiplicity after Krein doubling. The desired result is: exactly the
> continuum branch near `q = 0` is a physical massless/massive mode, and every
> other component of `Z_m` is gapped, projected out, Krein-nonphysical, or
> removed by an explicit Wilson / Ginsparg-Wilson / domain-wall term.

Reference doubler count. Naive central-difference fermions (symbol
`~ sum sin q_mu`) have `2^d = 16` corner zeros in `d = 4`. The retarded forward
difference `u_a = exp(i q_a) - 1` changes the picture: the discrete corner null
set `q_a in {0, pi}^4` has exactly **5** members (Section 5). But the full
massless null set `Z_0` is positive-dimensional (Section 6), which is the whole
point of going to the determinant level.

---

## 2. Tetrahedral inverse-Gram form and the warning example

The inverse Gram of the null frame (equivalently the symbol metric in edge-phase
coordinates) is, for `d = 4`:

```text
G^{-1} = -(d-1)/d I + (1/d) J = -3/4 I + 1/4 J,
```

i.e. diagonal entries `-3/4 + 1/4 = -1/2`, off-diagonal entries `1/4`. This
equals `alpha^A . alpha^B` under the mostly-minus metric and matches the
unit-normalized values `G^{-1}_AA = -1/2`, `G^{-1}_AB = 1/4` of Open Questions
6.9. The symbol square in edge-phase coordinates is

```text
p(q)^2 = h^{-2} u^T G^{-1} u,    u_a = exp(i q_a) - 1.
```

Equivalently, with `S1 = sum_a u_a` and `S2 = sum_a u_a^2`,

```text
h^2 p(q)^2 = -3/4 S2 + 1/4 S1^2.
```

Warning example (Open Questions 6.13.7; Working Plan 20.5):

```text
q = (pi, pi, pi, 0),    u = exp(i q) - 1 = (-2, -2, -2, 0),
u^T I u = 12,  (sum u)^2 = (-6)^2 = 36,
u^T G^{-1} u = -3/4 * 12 + 1/4 * 36 = -9 + 9 = 0.
```

So `p(q) != 0` but `p(q)^2 = 0`: a high-momentum null Clifford singularity. The
script confirms `u^T G^{-1} u = 0` and `p(q)^2 = 0` directly from the spacetime
build, and that `dim ker c(p) = 2` there (a nonzero null `p` still has a
2-dimensional Clifford kernel, the L+R Weyl pair, the same size as the physical
point `q = 0` once `q = 0` is approached as a null direction).

---

## 3. Is the warning a genuine branch, and what classifies it?

Yes: `q = (pi, pi, pi, 0)` is a **genuine high-momentum null branch of the flat
massless symbol**. It is a true determinant-level zero (`det c(p(q)) = 0`,
`dim ker c(p) = 2`), not a coefficient-zero artifact (`p(q) != 0`). It is one of
four symmetric "three-pi" corners (the permutations of three `pi` and one `0`);
together with the origin these are the 5 discrete corner null points
(Section 5). This refutes any no-doubling claim that rests only on
`p(q) = 0 iff q = 0`.

It is NOT yet classified as doubler vs cutoff artifact vs Krein-nonphysical
mode. Being a determinant zero of the massless symbol is necessary but not
sufficient to be a physical doubler. The additional data needed to classify it:

1. Energy-slice character. Pick a physical time covector (the barycentric
   `e^0 = dt`) and treat the three independent spatial momenta as the real
   external data. Solve `p(q)^2 = m^2` for the remaining ("time") edge phase and
   ask whether the solution has a real energy (a propagating pole, hence a true
   low-/high-momentum doubler) or a complex energy (a damped/growing mode, hence
   a candidate instability or cutoff pole rather than a propagating doubler).
   Section 6 shows the warning corner lies on the measure-zero **real**
   propagating locus, so it behaves as a genuine high-momentum doubler of the
   flat massless symbol, not merely a complex artifact.

2. Krein sign data. Compute the `J`-inner-product on the 2-dimensional kernel at
   the branch. A branch whose kernel has indefinite or negative `J`-norm is
   Krein-nonphysical and may be projected out; a branch with positive `J`-norm
   on the physical sector is a genuine propagating state that must be removed by
   a Wilson / Ginsparg-Wilson / domain-wall mechanism if unwanted.

3. Chirality content. Decompose the kernel under `Gamma_s` (and, separately,
   under the internal grading `chi_E`). A vector-like (L+R balanced) high-
   momentum branch is the standard doubler signature; a chirally imbalanced
   branch would instead bear on the anomaly/chirality audit (T18).

4. Continuum decoupling. Check the `h`-scaling: a cutoff artifact must gap off
   (energy `~ 1/h -> infinity`) as `h -> 0`, while a genuine surviving doubler
   stays at finite physical energy. This is the scaling step 2 of Open Questions
   6.13.9 and feeds Gate D (continuum square).

Until items 1-4 are computed, the honest label for the warning point is
"determinant-level null branch, classification pending", not "doubler" and not
"harmless".

---

## 4. Determinant reduction (the computational backbone)

In `d = 4` the 4x4 Clifford determinant collapses to a scalar. Two identities,
both verified numerically by the script to machine precision:

```text
det c(p) = (p . p)^2,
( i c(p) + m gamma_5 )^2 = (m^2 - p^2) I
  => det( i c(p) + m gamma_5 ) = (m^2 - p^2)^2.
```

The second follows because `gamma_5` anticommutes with every `gamma^mu`, so the
cross term cancels and `c(p)^2 = p^2 I`, `gamma_5^2 = I`. Consequences:

- The branch condition is the scalar `p(q)^2 = m^2`.
- Every determinant zero has algebraic multiplicity 2 (the squared scalar), and
  the Clifford kernel is 2-dimensional on a simple null point.
- The mass term `Gamma_s Phi = m gamma_5` shifts the null cone to the mass-shell
  `p^2 = m^2` but does NOT lift the doubling: each branch of the massless problem
  becomes a branch of the massive problem at shifted `q`. The mass block alone is
  not a no-doubling mechanism. (This is consistent with the Working Plan 18.6
  guardrail that `Box_null` and `Phi_H^2` are two sides of one on-shell
  condition, not two additive mass sources.)

---

## 5. Discrete corner doublers

Massless corner enumeration `q_a in {0, pi}^4` (script, Section 4):

```text
p^2 = 0 at exactly 5 corners:
  (0,0,0,0)              -- the continuum / physical point
  (pi,pi,pi,0) and its 3 permutations  -- high-momentum null doublers
p^2 = -2 at the 10 corners with exactly one or two pi's (spacelike)
p^2 = +4 at (pi,pi,pi,pi) (timelike, not a null branch)
```

So the discrete corner null count is `5 = 1 physical + 4 high-momentum
doublers`. Compared with the `16` naive central-difference corners, retardedness
removes the coefficient-zero corners but leaves 4 determinant-level corner
doublers. This is the concrete, finite refutation of the coefficient-zero
argument.

---

## 6. The full null set is positive-dimensional; complex branches appear

`p(q)^2` is a complex-valued function on the real torus `T^4` (the script finds
`max |Im p^2| ~ 3.25`). The massless condition `p(q)^2 = 0` is therefore ONE
complex equation = TWO real equations on a 4-real-dimensional torus, so `Z_0` is
generically a **2-real-dimensional variety**, not a finite set of points (the
script finds 201 exact null grid points at `N = 12`, scaling like a surface).
The 5 corners are special points on this variety.

Energy-slice enumeration (script, Section 6). Fix three edge phases as real
spatial data and solve `p(q)^2 = m^2` for the first phase via the quadratic

```text
-1/2 a^2 + 1/2 T1 a + (1/4 T1^2 - 3/4 T2) = m^2,
a = u_1 = z_1 - 1,  T1 = sum_{A>=2} u_A,  T2 = sum_{A>=2} u_A^2,
real (propagating) branch  <=>  |z_1| = 1,  else complex-energy branch.
```

Findings:

- On a GENERIC real spatial slice, BOTH roots are complex-energy (`|z_1| != 1`):
  the retarded operator has pervasive complex branches. This is exactly the
  Chernodub-style warning (`arXiv:1701.07426`): a non-Hermitian / retarded
  construction can carry complex spectral branches. Treat this as a warning, NOT
  as evidence the operator is safe.
- Real propagating branches (`|z_1| = 1`) live on a measure-zero locus that
  random sampling misses. The discrete corner null points (including the warning
  corner family `(q2,q3,q4) = (pi,pi,0)`) and the continuum line
  `(q2,q3,q4) = (0,0,0)` are explicitly real branches (script check).

---

## 7. Finite search / enumeration protocol for `det(i D_+(q) + Gamma_s Phi) = 0`

Inputs: the tetrahedral `alpha^A`, metric `g`, gamma representation, mass `m`,
grid resolution `N`, tolerances.

Procedure:

1. Symbol map. Build `u_a(q) = exp(i q_a) - 1` and `p(q)_mu = sum_a u_a
   alpha^a_mu`. Verify `p(q)^2 = h^{-2} u^T G^{-1} u` against the direct
   spacetime build (regression test).

2. Determinant reduction. Confirm `det(i c(p) + m gamma_5) = (m^2 - p^2)^2` on
   random `q` (regression test). Thereafter work with the scalar
   `F_m(q) = p(q)^2 - m^2`; the branch set is `Z_m = { F_m(q) = 0 }`.

3. Discrete corner scan. Enumerate `q_a in {0, pi}^4` (16 points) and record
   `p^2`. Tag null corners. (Massless: expect 5.)

4. Real-branch (propagating) enumeration. For each of the three independent
   spatial-momentum directions, fix the spatial data on a real grid and solve
   the quadratic `F_m = 0` for the time edge phase. Tag each root real
   (`|z| = 1`) or complex (`|z| != 1`). Count real branches per spatial momentum
   = the physical dispersion sheets; locate zero crossings near `q = 0`
   (continuum branch) and away from it (high-momentum branches).

5. High-momentum null branches. Within the real-branch set, separate the
   component connected to `q = 0` from the rest; everything else is a
   high-momentum branch candidate. Record its `h`-scaling (does its energy
   diverge like `1/h`?).

6. Complex-energy branches. Record all roots with `|z| != 1`; report their
   growth/decay rate `log|z|` and whether they occur in conjugate pairs.

7. Kernel dimension and chirality per branch. At each branch point compute
   `dim ker(i c(p) + m gamma_5)` and decompose the kernel under `Gamma_s`
   (chirality) and `chi_E` (internal grading), kept strictly separate per the
   NULLSTRAND grading guardrail.

8. Krein doubling. Form `D_dbl = [[0, D_-],[D_+,0]]` with `D_- = J D_+^dagger J`.
   Then `det D_dbl = (+/-) det D_+ . det D_-`, so each branch multiplicity
   doubles (a 2-dim massless kernel becomes 4-dim). Compute the `J`-inner-product
   sign on each kernel to mark branches Krein-physical or Krein-nonphysical.
   Note (Gate C addendum 20.6 / report C.4): `J`-self-adjointness does NOT imply
   real spectrum, positivity, or stability; the Krein sign is classification
   data, not a safety certificate.

9. Report. For each branch: location, real/complex energy, `log|z|` if complex,
   kernel dimension, chirality, internal grading, doubled multiplicity, Krein
   sign, and `h`-scaling class (physical / gapped / divergent / artifact).

The companion script implements steps 1-6 and 8 (multiplicity), and step 7 at
sample points; steps 7 (full chirality decomposition) and 8 (explicit `J`) are
specified here for the Lean/numeric follow-up (T16 proof job).

---

## 8. Acceptance / failure criteria for the null-edge Dirac branch

Acceptance (Gate C pass, Working Plan 20.5):

- Exactly the desired continuum branch near `q = 0` (one massless/massive Dirac
  cone with the correct chirality content and 2-dim kernel).
- No extra stable low-energy or high-momentum PHYSICAL branches: every other
  component of `Z_m` is either gapped (energy diverges as `h -> 0`), projected
  out, Krein-nonphysical (indefinite/negative `J`-norm on its kernel), or
  explicitly removed by a Wilson / Ginsparg-Wilson / domain-wall term.
- Any complex-energy branches in the physical sector are either absent or shown
  to be projected out / non-growing under the chosen evolution.

Failure (Gate C fail):

- Persistent high-momentum massless poles in the physical sector (genuine
  surviving doublers): the warning corner family is a candidate until classified
  by Section 3.
- Complex growing modes in the physical sector (the Chernodub-style instability
  warning realized).
- A no-doubling claim resting only on coefficient-zero analysis
  (`p(q) = 0 iff q = 0`), ignoring the determinant-level null set.

Current status from this audit: the flat tetrahedral retarded operator has (i) 4
high-momentum corner null branches plus a positive-dimensional null variety, and
(ii) pervasive complex-energy branches on generic real spatial slices. Neither
the unmodified massless operator nor the `+ Gamma_s Phi` mass block removes them.
Therefore the operator does NOT pass Gate C as-is; passage requires a Krein-sign
projection and/or an explicit doubler-removal term, plus the `h`-scaling and
chirality classification of Section 3. This audit does not certify safety; it
defines the tests and records that, as it stands, the operator fails the naive
no-doubling claim.

---

## 9. Guardrail summary (carry verbatim into any P2 text)

- Retardedness avoids coefficient-zero doublers only; determinant-level branches
  remain to be tested.
- The physical test is `det c(p(q)) = 0` (massless `p(q)^2 = 0`), not
  `p(q) = 0`. A nonzero Lorentzian null `p(q)` has a Clifford kernel.
- Chernodub-style non-Hermitian / retarded evasion is a WARNING, not a safety
  argument: complex spectral branches can and do appear here.
- Krein `J`-self-adjointness is an algebraic Lorentzian-adjointness repair, not
  positivity, real spectrum, unitary evolution, stability, anomaly safety, or
  chirality.
- This is an audit / protocol, not a proof that the operator is safe.
