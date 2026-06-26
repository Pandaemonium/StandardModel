# Aristotle semantic context pack

Generated: 2026-06-25T16:18:01
Query: `checkerboard Bohm Bell master finite model null step full Minkowski nullity trajectory measure caveat closure`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Key Findings]

Score: `0.779`

```text
ut ("Popescu–Rohrlich boxes in quantum measure theory," J. Phys. A 40 (2007) 7255–7264, quant-ph/0605253) prove "any set of no-signalling probabilities, for two distant experimenters with a choice of two alternative experiments each and two possible outcomes per experiment, admits a joint quantal measure, though one that is not necessarily strongly positive," while quantum (Tsirelson-bounded) correlations are strongly positive. This is exactly the structure that makes a null-edge histories theory a legitimate quantum-foundational proposal — Bell-violating, no-signalling, not a local hidden variable model — provided "Bell causality" is implemented at the level of D, which is subtle (Dowker et al. showed complex percolation fails the relevant convergence condition).

**6. Lorentz invariance and nonlocality.** Bombelli–Henson–Sorkin proved that Poisson sprinkling of Minkowski space admits no equivariant measurable map to spacetime directions; in "Discreteness without symmetry breaking: a theorem" (Mod. Phys. Lett. A 24 (2009) 2579–2587, gr-qc/0605006) they state "there is no way to associate a finite-valency graph to a sprinkling consistently with Lorentz invarianc
...[truncated]
```

### 2. `Sources/Null_Edge_Interaction_Ontology.md` [Null-step dynamics and chirality coherence]

Score: `0.775`

```text
## Null-step dynamics and chirality coherence

The ontology becomes much more credible when the null-edge story is tied to a
finite dynamics, not only to a kinematic decomposition. A promising exact model
is the discrete null-step quantum walk

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x).
```

Its quasienergy satisfies

```text
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence is

```text
C_z = |sin(mu a)| / |sin(omega a)|.
```

In the continuum limit this tends to

```text
mu / sqrt(k^2 + mu^2) = m / E.
```

This is exactly the kind of bridge the ontology needs: luminal conditional
shifts, chirality-flip amplitude, Dirac dispersion, and the observer-visible
proper-time ratio appear in one finite model. It should be treated as a
priority theorem target for the P2/P4 dynamics paper. The interpretive slogan
"all elementary visible movement is lightlike" is strongest when it can be
backed by this kind of first-order transfer operator, not merely by the fact
that any timelike momentum admits null decompositions.
```

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Do not lead with ontology]

Score: `0.773`

```text
### Do not lead with ontology

"All motion is luminal" is a powerful slogan, but the trusted content should
be stated at the level of propagators, finite path sums, spinor identities,
and graph amplitudes. The ontology can be discussed, but it should not carry
the proof burden.

The safe claim is:

> Certain relativistic propagators and finite path sums have exact
> descriptions in terms of null or lightlike microscopic steps, with mass
> appearing as a chirality-mixing or corner amplitude.

This is supported by the 1+1-dimensional Feynman checkerboard, by
projector-weighted 3+1-dimensional checkerboard constructions, and by
Dirac/Weyl quantum walks. It is not yet a universal theorem for arbitrary
random null-edge ensembles.
```

### 4. `AgentTasks/null-edge-grand-strategy-scaffold2-prompt-20260622.md` [Big-picture context]

Score: `0.770`

```text
## Big-picture context

The null-edge causal-graph program derives Standard Model and quantum-gravity
structure from a finite causal graph whose edges carry null momenta. See the
included `Null_Edge_Causal_Graph_Publication_Plan.md` for gates P1..P9 and
conventions. Banked finite results already include celestial-Plucker mass,
rank-one null momenta, visible-fan mass `(E^2-|C|^2)/4`, the non-collinearity
no-go, boundary-exact source invisibility, fluctuation/uniform-suppression
identities, and a path-pair higher-gauge interchange law.
```

### 5. `AgentTasks/null-edge-p9-source-visibility-api-output.md` [6. Physics confidence scores (1-10) for the core definitions]

Score: `0.768`

```text
## 6. Physics confidence scores (1-10) for the core definitions

| object / lemma | score | justification |
|---|---|---|
| `closureVector` / visible closure `C=0` | 9 | exact moment-map data; matches celestial-dipole convention; banked identity. |
| `pairwiseAngularMass` / `visibleMass` | 9 | banked, exact, central; the guardrail identity is proved. |
| `closureDefect` / BF closure `Σ B_f = 0` | 7 | correct finite Gauss-law statement, but the `Bivector := Fin 3 → ℝ` carrier is a toy `su(2)_L` stand-in; the *linear simplicity* sector tracking (EPRL vs degenerate vs `II±`) is **not** yet encoded. |
| `diamondSource = ‖closureDefect‖²` | 6 | honest bulk-source candidate, but `‖·‖²` is a choice; its physical normalisation and the bulk-vs-boundary reading are conjectural, and it is not additive. |
| `IsBoundaryExact` (cancelling-pair coboundary) | 6 | faithful finite `d∘d=0` shadow; but the real order-complex boundary map is richer, and nontrivial homology (closed-not-exact) is exactly where the physics lives and is not yet modelled. |
| `visibleClosure_not_sourceInvisibility` | 9 | the separation is real, exact, and checked; the central correct lesson of P9. |
| `b
...[truncated]
```

## Scoped paper hits

No paper hits returned.
