# Aristotle task: Wave 7 dual-soldered super-Dirac strategy

**Date:** 2026-06-26
**Status:** submitted
**Priority:** highest
**Requested by:** Codex on behalf of the NullStrand program
**Aristotle project ID:** ac66ea2e-0c47-458a-b5cc-b5def90c3c20

## Purpose

We need a massive strategy analysis for the next phase of the null-strand graph-operator program. The recent analyses identify a constructive path that is much sharper than the earlier super-Dirac proposal:

1. The diagonal null-symbol operator `sum_a c(ell_a) nabla_a` cannot be the exact continuum Dirac soldering operator in 4D.
2. Primitive null support can still survive if the Clifford coefficient is dual/cross-soldered: `D_sol = sum_a c(alpha^a) nabla_a` with `xi = sum_a xi(ell_a) alpha^a`.
3. A tetrahedral null frame gives an explicit four-direction model using inverse Gram coefficients.
4. The finite square should still have the desired Lichnerowicz shape with null propagation, diamond curvature, frame variation, one Yukawa mass block, and no duplicate Pluecker mass term.
5. A finite Krein or retarded/advanced doubled operator is likely the Lorentzian-honest spectral object.

This job should focus on constructive strategy: build the path, specify Lean theorem targets, identify dependencies, and give a rigorous development order. Use no-go results only as motivation for replacing the failed diagonal ansatz, not as the center of the response.

## Repository context

The repository is a Lean 4 project for mathematical structures in Standard Model physics and a null-strand Bohm-Bell program. Relevant planning documents in the package:

- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- existing `PhysicsSM/NullStrand/Graph/*` modules where available
- existing `PhysicsSM/NullStrand/Histories/*`, `BellQFT/*`, `NullLift/*`, and finite-probability modules where relevant

The Lean kernel is the source of truth. Trusted Lean code must compile without proof holes or fake assumptions. For this strategy job, we are not asking Aristotle to fully implement every theorem; we want a detailed, executable formalization plan and, where feasible, concrete theorem statements or small trusted starter modules.

## Main constructive path to analyze

### A. Diagonal trace obstruction as a gateway lemma

Formalize or plan the theorem that the diagonal null-symbol ansatz fails:

```lean
theorem diagonal_null_symbol_trace_zero
  (ell : Fin r -> Minkowski4)
  (hnull : forall i, minkowskiInner (ell i) (ell i) = 0)
  (b : Fin r -> K) :
  trace (sum i, b i • rankOneEndomorphism (flat (ell i)) (ell i)) = 0
```

Mathematical content:

```text
A xi = sum_i b_i xi(ell_i) ell_i^flat
tr(A) = sum_i b_i ell_i^flat(ell_i) = 0
```

Conclusion: `A` cannot equal identity on 4D cotangent space, whose trace is `4`. This should retire the diagonal `c(ell_i) nabla_i` symbol as the continuum Dirac soldering operator. However, it should not freeze the graph branch.

Requested analysis:

- Best Lean representation of covectors, flats, rank-one endomorphisms, and trace in the current repo/mathlib stack.
- Whether to prove the theorem over `Real`, `Complex`, or an abstract scalar field.
- Minimal hypotheses needed to state the trace result cleanly.
- How to connect this theorem to the graph-symbol story without overcommitting to continuum analysis.

### B. NullSolderFrame as the corrected core abstraction

Define or plan a structure:

```lean
structure NullSolderFrame where
  r     : Type
  instFintype : Fintype r
  ell   : r -> Minkowski4
  alpha : r -> Covector4
  null  : forall a, IsNull (ell a)
  dual  : forall xi : Covector4, sum a, xi (ell a) • alpha a = xi
```

Core identity:

```text
sum_a alpha^a tensor ell_a = I
xi = sum_a xi(ell_a) alpha^a
```

Corrected operator:

```text
D_sol = sum_a c(alpha^a) nabla_a
```

Requested analysis:

- Best definition of `Covector4` in the live repo.
- Whether `alpha` should be a covector, a Clifford generator, or separated into two layers.
- Which dual identity is easiest to use in Lean: tensor identity, pointwise covector identity, matrix identity, or basis-coordinate identity.
- Whether to make `NullSolderFrame` generic over dimension first, then specialize to 4D, or make the first trusted version 4D-only.
- How to keep primitive null support separate from Clifford coefficients in all naming and theorem statements.

### C. Tetrahedral null frame as first explicit witness

Use future-null directions in mostly-minus signature:

```text
ell_A = (1, n_A)
```

where the `n_A` are regular tetrahedron spatial unit vectors. The intended Gram data:

```text
G_AA = 0
G_AB = 4/3 for A != B
G^AA = -1/2
G^AB = 1/4 for A != B
alpha^A = sum_B G^AB ell_B^flat
alpha^A(ell_B) = delta^A_B
D_tet = sum_A c(alpha^A) nabla_A
      = sum_A,B G^AB c(ell_B^flat) nabla_A
```

Requested analysis:

- Provide exact rational/sqrt representation strategy for the tetrahedral vectors in Lean.
- Decide whether to avoid square roots by using scaled null directions, rationalized coordinates, or an abstract Gram witness.
- Identify the smallest exact witness theorem to prove first.
- Explain how this witness can be used as the canonical example for the dual-soldered operator.

### D. Corrected finite square theorem

Let:

```text
C_a = c(alpha^a)
D_N = sum_a C_a nabla_a
```

Finite square decomposition:

```text
D_N^2 = Box_null + C_diamond + T_frame
```

with:

```text
Box_null  = 1/4 sum_a,b {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_a,b [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_a,b C_a [nabla_a, C_b] nabla_b
```

Then:

```text
D = i D_N + Gamma_5 Phi
D^2 =
  -Box_null
  -C_diamond
  -T_frame
  +Phi^2
  -i Gamma_5 sum_a C_a [nabla_a, Phi]
```

under grading hypotheses:

```text
Gamma_5 C_a = -C_a Gamma_5
[Gamma_5, nabla_a] = 0
[Gamma_5, Phi] = 0
```

Requested analysis:

- Give the cleanest algebraic Lean formulation for this theorem over finite matrices or endomorphisms.
- Separate theorem layers: pure noncommutative algebra identity, graph support theorem, Clifford anticommutator theorem, and geometric interpretation theorem.
- Identify which hypotheses are necessary and which can be derived from structures.
- Audit signs carefully, especially the condition under which `(Gamma_5 Phi)^2 = +Phi^2`.
- Explain how to prevent conflating order-complex degree, left/right chirality, and any internal grading under which `Phi` is odd.

### E. Krein and retarded/advanced doubled construction

Retarded finite difference:

```text
D_+ = h^{-1} sum_a C_a (T_a - I)
```

Advanced adjoint candidate:

```text
D_- = D_+^sharp
```

Doubled operator:

```text
D_double = [[0, D_-],
            [D_+, 0]]
```

Requested analysis:

- Minimal finite Krein API: fundamental symmetry `J`, `J`-adjoint, `J`-self-adjointness, block operator lemmas.
- Whether the doubled operator is the right finite Lorentzian object to pursue before continuum causal-set questions.
- How to state functoriality under graph embeddings preserving labeled null edges and reverse/advanced partners.
- How this gives a bounded-dimension, non-cheating natural dilation candidate for Q6/Q7.

### F. No-double-counting mass and Pluecker kinetic interpretation

The current interpretation:

- `Phi^2` is the only zero-order mass block.
- Pluecker/Gram spread is the kinetic invariant of the dual-soldered symbol.
- On shell, `P_h(xi)^2 = m^2`; this is a dispersion relation, not a second additive mass.

Requested analysis:

- Make this precise as theorem statements or documentation contracts.
- Identify a small finite theorem connecting squared dual-soldered kinetic symbol to the Lorentzian quadratic form.
- Explain how the existing Pluecker-mass/exterior-history layer should or should not connect to this operator track.

### G. Theorem sequencing and Aristotle job decomposition

Give a concrete implementation plan with named theorem targets, recommended files, dependencies, and expected difficulty. Prefer a staged sequence such as:

1. trace obstruction;
2. `NullSolderFrame` API;
3. tetrahedral witness;
4. principal-symbol/commutator theorem;
5. noncommutative square theorem;
6. corrected super-Dirac theorem;
7. finite Krein API;
8. doubled retarded/advanced operator;
9. residual endomorphism audit;
10. link to Pluecker kinetic invariant.

For each stage, specify:

- exact mathematical statement;
- proposed Lean module path;
- required existing imports;
- whether it is trusted-code feasible now or should be draft/handoff;
- what should be delegated to Aristotle as proof jobs;
- what semantic review Codex should perform afterward.

## Secondary constructive targets

These are less central than Q5, but the same analysis sharpened them. Please include strategy notes only after the super-Dirac path.

### Finite continuous-time Markov-chain SLLN

Proof route:

```text
-Q g = f - pi f
M_t = g(X_t) - g(X_0) - integral_0^t Qg(X_s) ds
integral_0^t (f(X_s) - pi f) ds = g(X_0) - g(X_t) + M_t
```

Then divide by `t`. The endpoint term vanishes and `M_t/t -> 0` if quadratic variation grows at most linearly.

Please analyze how much of this is currently Lean-feasible and whether a finite discrete-time analogue should come first.

### Stopped weighted diffusion near nodes

Weighted form:

```text
E(f,g) = kappa integral_{S^2} <grad f, grad g> rho d sigma
L f = kappa rho^{-1} div(rho grad f)
```

Exit time:

```text
tau_epsilon = inf {t : rho(X_t) <= epsilon}
```

Near-node heuristic:

```text
rho ~ r^alpha
Bessel effective dimension delta = d_perp + alpha
node inaccessible when delta >= 2
```

Please translate this into a formalization charter, not full Lean implementation.

## Expected deliverable

Return a detailed strategy report, ideally with:

- a revised Q5 theorem architecture;
- specific Lean declarations and structures to add;
- exact theorem statements where possible;
- risk register and stop/go criteria;
- recommended Aristotle proof-job decomposition;
- notes on which claims are finite algebra, which are symbol/continuum asymptotic, and which are physical interpretation;
- a short executive summary of the path Aristotle recommends.

If you modify files, keep changes small and trusted. Do not introduce proof holes or fake assumptions into trusted Lean. Draft theorem sketches can go under `AgentTasks/` or `PhysicsSM/Draft/` only if clearly marked as draft/handoff.

## Submission metadata

```yaml
wave: 7
kind: strategy
focus: dual_soldered_super_dirac
submitted_project_id: ac66ea2e-0c47-458a-b5cc-b5def90c3c20
submitted_at: 2026-06-26
```
