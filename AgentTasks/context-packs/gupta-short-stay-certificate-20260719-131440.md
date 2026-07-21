# Aristotle semantic context pack

Generated: 2026-07-19T13:14:49
Query: `Gupta Short projector factorized quantum walk stay amplitude Laurent unitarity fermion doubling`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/StationaryAmplitudeProjectorWalk.lean`

Score: `0.851`

```text
import Mathlib

/-!
# Stationary-amplitude projector walk

Clean-room theorem shape motivated by Gupta-Short, arXiv:2601.15885v2,
equations (29)-(31) and Appendix B. This file translates the mathematics, not
their implementation.

The key result is generic: two arbitrary orthogonal projectors need not
commute, yet the displayed range-one Laurent walk is exactly unitary on the
circle because it factors into two projector-controlled phases. The explicit
rational witness has a nonzero onsite amplitude.

## Faithfulness notes

Three of the originally displayed statements are literally false for the given
definitions and had to be corrected to their true mathematical content; each
correction is documented in the relevant docstring.  The corrections do not
touch the definitions, the noncommutation witness, or the nonzero onsite term.

* `stationaryWalk_expansion` needs `z ≠ 0`: the onsite band carries the factor
  `z * z⁻¹`, which collapses to `0` (not `1`) at `z = 0`, so the Laurent
  expansion fails there.  This is exactly the hypothesis every downstream
  unitarity statement already carries.
* `forwardPhase_conjTranspose` / `backwardPhase_conjTranspose`: the adjoint of a
  projector-controlled phase is the *same* kind of phase with the conjugated
  scalar, i.e. `forwardPhase z⁻¹ P` (resp. `backwardPhase z⁻¹ P`) under the
  on-circle relation `conj z = z⁻¹`, not the opposite phase family.  For
  `P = |0⟩⟨0|` and `z = i` one has `(forwardPhase i P)^H = diag(-i, 1)` while
  `backwardPhase i P = diag(1, -i)`, so the original claim is false; unitarity of
  each phase is unaffected and is proved directly below.

Provenance: clean-room theorem shape motivated by Gupta and Short,
arXiv:2601.15885v2, equations (29)--(31) and Appendix B. Proofs and the three
faithfulness corrections
```

### 2. `AgentTasks/overnight-publication-run-2026-07-11/LIT_SEARCH_LOG.md` [Literature and Lean-reference search log]

Score: `0.847`

```text
confirms the gap
2026-07-10 21:00 PDT | Fable | EXCITEMENT SCAN (headline mandate) + Gupta-Short architecture audit (Papers A/B) | WebSearch "fermion doubling quantum walk Dirac QCA 2026" + WebFetch arXiv HTML 2601.15885 + lit_ingest 2601.15885/2505.07900 | Gupta-Short 2601.15885 (PRA accepted): doubler-free family = strictly NN, one-step, exactly unitary, 1+1 AND 3+1; resource = stay-put gamma_0 from tilted non-orthogonal projectors (Eqs 29-30, 37); 3+1 residual non-Dirac states remain (App F). 2505.07900 extends doubling analysis to QCA schemes | LANDED manuscript positioning: our stationary_forces_zero applies verbatim to their family => their tangent cannot be a Hermitian involution (kernel-checked corollary constraining their published construction); triangle framed in stationary-no-go section + open problem 2 updated | Excitement verdict: doubling-in-DTQW is HOT right now (two 2025-26 papers, PRA); our all-zone determinants + no-gos are timely; strict clean 3+1 with involutory tangent is the open crown - keep B race framed as resource lower bound vs GS-style escapes
2026-07-10 23:00 PDT | Fable | EXCITEMENT SCAN: formalized-physics community pulse | WebSearch "Lean 4 formalization physics quantum 2026" + WebFetch arXiv abs 2603.15770 | Douglas-Hoback-Mei-Nissim "Formalization of QFT" (2603.15770, Mar 2026): free bosonic QFT in 4D Euclidean, Glimm-Jaffe axioms, Lean 4 + Mathlib, AI-assisted, explicit proof-of-concept scope; FGG conjecture machine-verified via LLM+Lean (Jun 2026); Physlib rebrand (physlib.io) | Added DouglasQFTLean citation + one complementarity sentence to Paper A verification section ("physical input derived inside the formalization rather than axiomatized") - the formalized-mathematical-physics field is visibly hot, strengthening the artifact st
```

### 3. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [The $3+1$ high-symmetry verdict]

Score: `0.840`

```text
1$ generators are separately
kernel-checked.  This is \NoGo{} \Kernel{}.  A nonvacuity control shows that a partial-channel
Hermitian tangent with a stationary kernel does admit an exactly unitary
degree-one witness with $B\neq0$ and a non-scalar zone edge.  That witness does
not retain the full Dirac tangent.  Thus stationary amplitudes remain viable
only after a genuine change of architecture, such as a larger internal cell,
longer Laurent range, multistep factorization, or a non-involutory tangent.

The last route is not hypothetical.  Gupta and Short
\cite{GuptaShortDoubling} construct doubler- and pseudo-doubler-free
nearest-neighbor one-step unitary walks, in $1+1$ and $3+1$ dimensions, whose
enabling resource is exactly a nonzero stay-put amplitude
$\gamma_0=\id-\gamma_+-\gamma_-$ built from tilted, non-orthogonal velocity
projectors (their Eqs.~(29)--(30) and~(37)).  Their step is exactly of the
degree-one Laurent form \eqref{eq:stationarylaurent}, unitary at every
momentum and normalized at the origin, with stationary block $\gamma_0$.
The no-go \eqref{eq:stationarynogo} therefore yields a corollary about
their family: its tangent generator, though automatically Hermitian for a
unitary origin-normalized step, cannot be an involution ($M^2
\neq\id$).
The stay-put freedom that removes the doublers is purchased
exactly by relinquishing the involutory unit-speed Dirac tangent, and our
partial-channel escape witness realizes the same mechanism in kernel-checked
form.  Their $3+1$ family moreover retains extraneous Weyl-like low-energy
solutions at isolated momenta $\pm\mathbf q(\theta)$, which the authors
suggest a more general higher-dimensional construction might remove (their
Appendix~F), so a strictly local, exactly unitary, fully alias-free $3+1$
walk with the
```

### 4. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [The $3+1$ high-symmetry verdict]

Score: `0.840`

```text
1$ generators are separately
kernel-checked.  This is \NoGo{} \Kernel{}.  A nonvacuity control shows that a partial-channel
Hermitian tangent with a stationary kernel does admit an exactly unitary
degree-one witness with $B\neq0$ and a non-scalar zone edge.  That witness does
not retain the full Dirac tangent.  Thus stationary amplitudes remain viable
only after a genuine change of architecture, such as a larger internal cell,
longer Laurent range, multistep factorization, or a non-involutory tangent.

The last route is not hypothetical.  Gupta and Short
\cite{GuptaShortDoubling} construct doubler- and pseudo-doubler-free
nearest-neighbor one-step unitary walks, in $1+1$ and $3+1$ dimensions, whose
enabling resource is exactly a nonzero stay-put amplitude
$\gamma_0=\id-\gamma_+-\gamma_-$ built from tilted, non-orthogonal velocity
projectors (their Eqs.~(29)--(30) and~(37)).  Their step is exactly of the
degree-one Laurent form \eqref{eq:stationarylaurent}, unitary at every
momentum and normalized at the origin, with stationary block $\gamma_0$.
The no-go \eqref{eq:stationarynogo} therefore yields a corollary about
their family: its tangent generator, though automatically Hermitian for a
unitary origin-normalized step, cannot be an involution ($M^2
\neq\id$).
The stay-put freedom that removes the doublers is purchased
exactly by relinquishing the involutory unit-speed Dirac tangent, and our
partial-channel escape witness realizes the same mechanism in kernel-checked
form.  Their $3+1$ family moreover retains extraneous Weyl-like low-energy
solutions at isolated momenta $\pm\mathbf q(\theta)$, which the authors
suggest a more general higher-dimensional construction might remove (their
Appendix~F), so a strictly local, exactly unitary, fully alias-free $3+1$
walk with the
```

### 5. `AgentTasks/24h-publication-run-2026-07-12/ARISTOTLE_B_STATIONARY_AMPLITUDE_PROJECTOR_WALK.md` [Aristotle: stationary-amplitude projector walk]

Score: `0.828`

```text
# Aristotle: stationary-amplitude projector walk

Prove the generic exact range-one Laurent expansion and unitarity of the
projector-controlled stationary-amplitude walk. The projectors are not assumed
to commute. Preserve the explicit noncommuting rational witness and its
nonzero onsite coefficient.

Integration verdict: the generic construction and witness landed, but three
submitted statements required mathematical correction. The Laurent expansion
needs `z != 0`, and the adjoint of each controlled phase remains in the same
forward/backward family with inverse phase rather than swapping families. The
counterexamples and corrected signatures are documented in the live module.

```yaml
aristotle:
  project_id: bb365801-8c75-4344-80c2-8d0a089a33ca
  task_id: 5f0d7970-b2f8-4f2f-8b95-28eebbe7a237
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_amplitude_projector_walk.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-amplitude-projector-walk-20260711-project
  output_dir: AgentTasks/aristotle-output/bb365801-8c75-4344-80c2-8d0a089a33ca
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
```

### 6. `AgentTasks/24h-publication-run-2026-07-12/LEDGER.md` [2026-07-11 21:34 PDT - Codex: stationary-amplitude primitive harvested and landed]

Score: `0.827`

```text
## 2026-07-11 21:34 PDT - Codex: stationary-amplitude primitive harvested and landed

- HARVESTED Aristotle `bb365801`. The central generic result survives: two
  arbitrary noncommuting star projectors generate an exactly unitary
  range-one Laurent walk on the circle, with a generally nonzero onsite band.
- Aristotle correctly rejected three false submitted statements. The Laurent
  expansion requires `z != 0`; forward and backward controlled phases each
  remain in their own family under adjoint with inverse phase. The live module
  documents the exact counterexamples and corrected statements.
- Nondegeneracy is explicit: rational noncommuting projectors give onsite
  matrix `[[16/25,-12/25],[12/25,16/25]] != 0`, while the full walk at `z=i`
  is exactly unitary.
- VERIFIED `StationaryAmplitudeProjectorWalk.lean`: direct Lean PASS;
  targeted build PASS (8026 jobs), standard footprint. Aggregate guard awaits
  completion of Fable's already-running `PairMomentumBlocks` dependency.
```

### 7. `AgentTasks/overnight-publication-run-2026-07-11/LIT_H3_LAURENT_QCA_2026-07-11.md` [6. Recent Dirac-walk doubling result]

Score: `0.825`

```text
### 6. Recent Dirac-walk doubling result

**Source.** C. Gupta and A. J. Short, "Fermion Doubling in Dirac Quantum
Walks," arXiv:2601.15885v2 (2026).
[arXiv:2601.15885](https://arxiv.org/abs/2601.15885).

**Evidence: Metadata/abstract only in this pass.** The abstract reports walk
families avoiding stated doublers and pseudo-doublers by allowing nonzero stay
amplitude, while retaining other low-energy solutions. No determinant-index
claim from this paper is used here.
```

### 8. `AgentTasks/24h-publication-run-2026-07-12/LEDGER.md` [2026-07-11 21:05 PDT - Codex: stationary-amplitude exact-unitary hedge launched]

Score: `0.823`

```text
## 2026-07-11 21:05 PDT - Codex: stationary-amplitude exact-unitary hedge launched

- Direct full-text fallback literature pass found two precise surviving
  templates. Bakircioglu-Arnault-Arrighi arXiv:2505.07900 uses a Brillouin-zone
  covering and enlarged flavour/sublattice register; Gupta-Short
  arXiv:2601.15885v2 uses nonzero stationary amplitude to remove conventional
  doublers/pseudo-doublers but retains two additional Weyl-like low-energy
  solutions. Logged in `SPARK_LIT_FLAVOURED_MINIMAL_DOUBLING_2026-07-11.md`.
- Extracted the clean algebraic core of the latter: for arbitrary orthogonal
  projectors `P,Q`, the range-one Laurent word is the product of two
  projector-controlled phases, so exact unitarity does not require `[P,Q]=0`.
  The Laurent expansion has forward, onsite, and backward coefficients.
- Prepared and submitted focused Aristotle proof `bb365801` / task `5f0d7970`
  with 12 preserved statements: generic expansion, conjugate-transpose laws,
  exact unitarity, and a noncommuting rational `2x2` witness whose onsite
  coefficient is explicitly nonzero.
- Scientific scope: this is a reusable exact-local primitive and the right
  minimally-doubled/stationary-amplitude hedge. It is not yet a `3+1`
  composition or an exact classification of the two residual nodes.
```

## Scoped paper hits

### 1. Connecting the discrete- and continuous-time quantum walks

Score: `0.784`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 2. Fermion Doubling in Dirac Quantum Walks

Score: `0.774`
Zotero key: `U58ZFXGR`
arXiv: `2601.15885`
URL: http://arxiv.org/abs/2601.15885v2

Abstract:

We consider discrete spacetime models known as quantum walks, which can be used to simulate Dirac particles. In particular we look at fermion doubling in these models, in which high momentum states yield additional low energy solutions which behave like Dirac particles. The presence of doublers carries over to the `second quantised' version of the walks represented by quantum cellular automata, which may lead to spurious solutions when introducing interactions. Moreover, we also consider pseudo-doublers, which have high energy but behave like low energy Dirac particles, and cause potential problems regarding the stability of the vacuum. To address these issues, we propose a family of quantum walks, that are free of these doublers and pseudo-doublers, but still simulate the Dirac equation in the continuum limit. However, there remain a small number of additional low energy solutions which do not directly correspond to Dirac particles. While the conventional Dirac walk always has a zero probability for the walker staying at the same point, we obtain the family of walks by allowing this probability to be non-zero.

### 3. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.773`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 4. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.771`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 5. Dirac quantum walk on tetrahedra

Score: `0.765`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840
