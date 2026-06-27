# NullStrand / null-edge agent orientation

This is a living orientation note for agents working on the NullStrand and
null-edge causal graph program. It records current program guardrails,
conventions, and task-shaping advice. AGENTS.md keeps the permanent quick rules;
this file can evolve as the program sharpens.

## Current program status

The near-term publishable target is a dual-soldered finite null-edge Dirac
algebra. It should be presented as a finite algebraic and formalization result,
not as a completed physical theory.

The strongest current finite-core package is:

1. Simplex null-solder frame.
2. Diagonal trace obstruction for diagonal null soldering.
3. Dual-soldered commutator theorem.
4. Correct graded super-Dirac square.
5. Finite tetrad-postulate and frame-term audit.
6. Krein retarded/advanced double.
7. Determinant-level branch-count protocol.
8. Spectral mass-shell matching theorem.
9. Pauli diamond normalization audit.
10. Claim-boundary ledger.

The full physics program still needs controlled continuum scaling, chirality and
anomaly control, a finite spectral-action or variational principle with genuine
codimension, and at least one non-inserted prediction if the goal is stronger
than reconstruction.

## Core operator convention

Do not identify the null finite-difference direction with the Clifford soldering
covector.

The active architecture is:

```text
D_+^h = sum_a c(alpha^a) (T_a - I) / h
```

where `ell_a` is the primitive null edge direction and `alpha^a` is the dual
covector in the null-solder frame. The support is null; the Clifford symbol is
dual-soldered.

Do not revive:

```text
sum_a c(ell_a^flat) nabla_ell_a
```

as the continuum Dirac-symbol operator. The diagonal trace obstruction is known:
`sum_a b_a ell_a^flat tensor ell_a` has trace zero because every `ell_a` is
null, while the identity on cotangent space has trace `d`.

## Simplex null-solder frame

In spacetime dimension `d = s + 1`, with mostly-minus signature, use spatial
simplex vertices `n_A` satisfying:

```text
n_A . n_A = 1
n_A . n_B = -1 / (d - 1), A != B
sum_A n_A = 0
ell_A = (1, n_A)
```

Then `ell_A` are future null, and the dual covectors are:

```text
alpha^A = (1 / d) dt + ((d - 1) / d) n_A . dx
```

with:

```text
alpha^A(ell_B) = delta^A_B
xi = sum_A xi(ell_A) alpha^A
```

For `d = 4`:

```text
alpha^A = 1/4 dt + 3/4 n_A . dx
```

If scaled null vectors are used, scale the dual covectors consistently. Do not
mix scaled vectors with unscaled duals.

This construction does not derive four dimensions. It works for all `d >= 2`
using a spatial `(d - 1)`-simplex.

## Super-Dirac square guardrails

Keep these gradings distinct:

```text
Gamma_s       spacetime chirality
chi_E         internal finite grading
epsilon_form  cochain/form degree, if present
```

For:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
D = i D_N + Gamma_s Phi
```

the safe sign hypotheses for a `+ Phi^2` square include:

```text
Gamma_s^2 = 1
{Gamma_s, C_a} = 0
[Gamma_s, nabla_a] = 0
[Gamma_s, Phi] = 0
[C_a, Phi] = 0
```

The Higgs or internal mass block should be internally odd under `chi_E`, not
spacetime-chirality odd under the same `Gamma_s`. If `Phi` anticommutes with
`Gamma_s`, the square flips the sign of `Phi^2`.

Use `Box_null` as the kinetic mass-shell operator. In mostly-minus signature,
the analytic d'Alembertian has plane-wave symbol `-p^2`; the mass-shell
normalization for `-Box_null + Phi^2 = 0` should give `p^2 = m^2`.

## Frame term and tetrad compatibility

The finite square should be decomposed as:

```text
D_N^2 = Box_null + C_diamond + T_frame
```

with:

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

The finite tetrad postulate is:

```text
[nabla_a, C_b] = 0
```

or the corresponding edge-transport compatibility equation. If this fails,
classify the defect rather than hiding it:

- Nonmetricity or bad soldering if metric compatibility fails.
- Curvature or holonomy if metric compatibility holds but connection
  commutators survive.
- Torsion-like defect if edge parallelograms fail to close or antisymmetric
  displacement defects appear.
- Smooth-limit contamination if `C_b` jumps by order one across `h`-edges.

## Krein double guardrails

The minimal finite Krein API is:

```text
J = J^dagger = J^{-1}
[u, v]_J = <u, J v>
A^sharp = J A^dagger J
```

Given `D_- := D_+^sharp`, the doubled operator:

```text
D_dbl = [[0, D_-], [D_+, 0]]
```

is the right finite object to audit for `J`-self-adjointness.

Do not overclaim. Krein self-adjointness does not by itself imply positivity,
unitary time evolution, real spectrum, stability, anomaly cancellation, or a
chiral Standard Model sector.

## No-doubling and branch-count tests

Retardedness alone is not a no-doubling proof.

On a flat periodic patch:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q))
p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a
```

The fact that `p(q) = 0` only at the continuum point rules out coefficient-zero
doublers. It does not rule out determinant-level Clifford singularities.

The physical test is:

```text
det D_+(q) = 0
```

or, in the massless flat case:

```text
p(q)^2 = 0
```

A nonzero null `p(q)` can still have a Clifford kernel. Future no-doubling
claims should discuss the determinant-level branch-count protocol, including
high-momentum real branches, complex branches, kernel dimensions, chirality, and
Krein doubling behavior.

## Universal null frames

For a single hidden strand, observer normalization or a timelike barycenter can
be useful. For a universal field operator, do not introduce a preferred observer
unless that is an explicit physical assumption.

The preferred architecture is a decorated null-tetrad graph. In four dimensions:

```text
ell_A(x) = e_0(x) + n_A^i e_i(x)
alpha^A(x) = 1/4 e^0(x) + 3/4 n_A^i e^i(x)
```

The finite object carries:

```text
V, E, ell_a(x), alpha^a(x), h_a(x), U_a(x), J_x,
Gamma_s, chi_E, Phi_x
```

plus compatibility laws. Do not claim that a bare graph canonically supplies a
tetrad or finite null frame unless a separate theorem derives it.

## Scaling and continuum tests

Use this order:

1. Flat symbol test on a fixed decorated periodic graph.
2. Flat determinant/branch-count test for real and complex branches.
3. Curved tetrad test with smooth frame and spin connection.
4. Commuting-square test: finite square then limit equals continuum Dirac then
   Lichnerowicz square.
5. Stochastic or covariant graph ensemble test only after the decorated
   deterministic case works.

The finite square can be exact while the continuum limit fails. Watch for
surviving frame terms, wrong holonomy normalization, wrong Pauli coefficient,
high-frequency branches that do not decouple, and wrong Lichnerowicz
endomorphism.

## Claim-boundary labels

When discussing physics implications, prefer explicit labels:

- finite identity
- asymptotic theorem
- reconstruction
- kinematic identity
- consistency check
- prediction

This is not mandatory prose bureaucracy, but it prevents accidental overclaiming.
The dual-soldered square is currently a reconstruction and finite identity, not
new physics by itself.

## Aristotle jobs for NullStrand

Use Aristotle ambitiously. Besides Lean proof jobs, good NullStrand Aristotle
tasks include:

- strategy jobs that compare proof routes and no-go risks;
- audit jobs for hidden assumptions, sign errors, grading mistakes, and
  convention drift;
- determinant branch-count analysis;
- continuum scaling and commuting-square analysis;
- literature-informed formalization plans;
- semantic review of returned Lean theorem statements;
- pressure tests for prediction claims.

Aristotle output still needs human/agent semantic review. The Lean kernel checks
proofs, not whether the theorem is the intended physics statement.

## Current priority list

High-priority near-term jobs:

- determinant branch-count audit for the tetrahedral retarded operator;
- graded square theorem with separated `Gamma_s` and `chi_E`;
- frame-term and finite tetrad-postulate theorem;
- Krein retarded/advanced self-adjointness API plus spectral caveats;
- spectral mass-shell matching theorem;
- Pauli diamond normalization;
- finite Markov regenerative strong-law route;
- stopped/local node theorem charter;
- moduli-rank prediction ledger.

## Main source files

Start with:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `AgentTasks/`

These files are allowed to evolve faster than AGENTS.md.

## Lateral-analysis guardrails (2026-06-27)

Guardrails added after a lateral read of the mass program. These are
convention/claim-label rules, recorded here so future agents apply them by
default. The decision-log entry is
`AgentTasks/null-edge-decision-log-2026-06-27.md` (D25).

- **Treat the project as obstruction geometry, not only mass from spread.** The
  finite Plucker theorem is the trusted core example, but the wider program is
  the classification of canonical failures of one-beam, one-branch, one-orbit,
  or one-mode descriptions. Use the pattern `zero locus / moduli locus +
  canonical obstruction + quadratic norm, determinant, Hessian, or gap`. Do not
  force Yukawa, Higgs, QCD, Gate C, and internal finite algebra into one literal
  Plucker formula.

- **Observer-conditioned mixedness is a separate claim label from the invariant
  Pluecker mass.** Keep `det P = m^2` as the invariant finite statement on the
  unnormalized visible momentum block `P = sum_i psi_i psi_i^dagger`. Only the
  normalized form `det rho_{p|u} = (m / E_u)^2`, with `rho = P / Tr(P)` in a
  chosen visible sector and `E_u` a chosen timelike normalization, may carry
  "mixedness" / "impurity" language, and it must be labeled observer-conditioned:
  it depends on both a resolution observer (the partial trace over hidden labels)
  and a kinematic observer (the timelike frame). Do not let frame-relative
  mixedness language leak into statements about the invariant determinant.

- **Gate C is a branch-topology problem, not a scalar-coefficient tweak.** Treat
  the branch locus `Z = { q : det D_+(q) = 0 }`, its kernel sheaf, and the branch
  involution as first-class objects. Do not describe a Gate C1 release as scalar
  Wilson tuning: the scalar Wilson no-go is sharp. Log any candidate release in
  terms of nodal control, kernel/spinor-line projection, a true inverse-propagator
  mass gap (not a propagator zero), ghost-zero safety, and chirality alignment.
  This sharpens the existing guardrail that retardedness alone is not a
  no-doubling proof: the determinant-level test lives on `Z`.

- **C1 is release data, not a bare corrected symbol.** A C1 claim needs at least
  `(D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)` with a selected
  one-Weyl-line origin sector, true gaps on mirror/unwanted branch components,
  locality or controlled quasi-locality, and anomaly/ghost audits. Treat direct
  unprojected overlap on the full bare `D_+` as unsafe until a shifted-kernel
  mass-window theorem proves there is no singular crossing from an unwanted
  zero branch germ. The null-edge-native route to try first is a branch
  classifier/projector (`T_br` or `Pi_br`) that is not scalar on the balanced
  origin kernel and separates branch germs rather than tastes only.

- **Prediction-grade should start with absence theorems.** Before numerical mass
  values, prefer forbidden-operator, codimension, rank, texture, and map-choice
  constraints. In particular, Gate H/Gate F should prioritize legal finite
  Dirac/Higgs block classification and neutrino branch decisions before any
  Yukawa-value rhetoric.
