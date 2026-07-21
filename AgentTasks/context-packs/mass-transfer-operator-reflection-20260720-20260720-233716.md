# Aristotle semantic context pack

Generated: 2026-07-20T23:37:39
Query: `finite symmetric transfer operator reflection positivity orbit Gram correlation exponential decay resolvent residue Kallen Lehmann`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md` [1. YM3/YM4 should stay transfer-first]

Score: `0.796`

```text
### 1. YM3/YM4 should stay transfer-first

The paper reinforces the transfer-matrix ordering already in our roadmap:
reflection positivity is not an ornament; it is what turns Euclidean estimates
into a positive self-adjoint transfer operator and then into spectral
statements. This supports keeping YM3 as a flagship finite/abstract
formalization before deeper continuum claims.

Lean-facing extraction:

- Define the OS positive-time form.
- Quotient by the null space and complete in the finite-dimensional case.
- Construct the one-step transfer operator from time-shift invariance.
- Prove positivity/self-adjointness/contraction under finite hypotheses.

For finite groups this should be much less analytic than the paper's compact
Lie-group setting and is a strong candidate for a clean theorem stack.
```

### 2. `AgentTasks/aristotle-prompts/ym-q2-transfer-hilbert-block-instantiation-20260704.prompt.md` [Project context]

Score: `0.793`

```text
## Project context

This is Q2 of a four-day Yang-Mills / mass-gap run.  The generic finite
OS/GNS transfer-Hilbert statement layer has just landed in
`TransferHilbert.lean`:

- `reflectionPairing (K : Matrix I I C) (f g : I -> C) : C`
- `rpHilbertSpace K = range (CFC.sqrt K)`
- `KernelCommutesShifts`, `kernelCommutesShifts_iff`
- shift/`CFC.sqrt` commutation and OS range preservation
- OS-form transfer symmetry/positivity
- auxiliary `compressedTransfer` facts

`ReflectionPositivityKernel.lean` supplies the RP kernel API:

```lean
def reflectionForm (W : A -> C -> A -> Complex) (f : A -> C -> Complex) : Complex
def cutKernel (W : A -> C -> A -> Complex) (c : C) : Matrix A A Complex
def IsReflectionPositive (W : A -> C -> A -> Complex) : Prop

theorem cutKernel_posSemidef_of_reflectionPositive [DecidableEq C]
    (W : A -> C -> A -> Complex) (hW : IsReflectionPositive W) (c : C) :
    (cutKernel W c).PosSemidef
```

The next Q2 blocker is to instantiate the generic matrix layer from the
family of cut kernels.  Keep this finite and algebraic.  Do not claim a
physical transfer matrix, Hamiltonian, continuum Hilbert space, or spectral
gap.
```

### 3. `AgentTasks/fourday-ym-run-2026-07-05/GRAND_STRATEGY_AUDIT_ym_codex_89ae2c3b.md` [Top 10 next targets (ranked by expected value / proof effort)]

Score: `0.789`

```text
nsemble.reflectionPositive_of_hol_factorization`.
6. **Feed that lattice into `rpBlockMatrix` for a first physical positive
   transfer operator**, then instantiate `TransferGapDefinition.finiteMassGap`
   on it. This is the first non-toy consumer of the gap API.
7. **`kp_tail_bound`** with the explicit coercivity hypothesis kept external.
   Rides on (2); statement is already honest about the extra geometry layer.
8. **QMF3 Berezin / Matthews–Salam finite identity** (fermionic Gaussian
   integral = determinant on 1–4 modes). Independent of the mountains, fully
   finite/kernel-checkable, oracle-testable first, publishable standalone.
9. **`FermionicReflection` concrete `A` instantiation** for the Wilson boundary
   coupling with the stated reflection-hermiticity hypothesis, routed through
   the existing lifted-projector PSD lemmas. Only after M1 geometry is pinned.
10. **NE-U1 aperture keystone consolidation** (`compositeMassSq_eq_zero_iff_
    collinear` + Plücker bridge as a named, docstring-clean corollary). Cheap,
    it is the honest core of the unification narrative and worth stating
    crisply so the paper has a defensible spine.

---
```

### 4. `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md` [design:q2-transfer-polarization (seeded by planning session; resolve before any T2 Lean)]

Score: `0.784`

```text
er_posSemidef`.

   The actual lattice one-slab convolution/compression then instantiates this
   API later, using `TransferPositivity.compression_posSemidef` where relevant.

5. Suggested deliverable names:
   `reflectionPairing`, `rpBlockMatrix`, `rpHilbertSpace`,
   `compressedTransfer`, `compressedTransfer_isSelfAdjoint`,
   `compressedTransfer_posSemidef`. The file should be
   `TransferHilbert.lean` and must state in the module docstring that this is
   the finite OS/GNS algebraic construction, not a Hamiltonian or physical
   Hilbert-space interpretation.

Review questions:

- Is `IsReflectionPositive W` alone the right public hypothesis, with
  `rpBlockMatrix_posSemidef_of_reflectionPositive` as a proof obligation, or
  should the first statement freeze expose the stronger per-cut PSD hypothesis
  and add the `IsReflectionPositive` bridge later?
- Should `rpHilbertSpace` be the range of `sqrt K`, as proposed, or the quotient
  by `ker K` despite the extra definiteness/Cauchy-Schwarz work?
- What is the most ambitious defensible transfer operator statement at Q2
  without a concrete one-slab kernel from Q1/Q7?
```

### 5. `AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` [5. Theorem 3 (the reflection-positivity engine: character positivity)]

Score: `0.782`

```text
## 5. Theorem 3 (the reflection-positivity engine: character positivity)

This section is the analytical core of the YM3 rung; it reduces reflection
positivity and transfer positivity for finite G to five lines of character
theory plus Gram bookkeeping.

THEOREM 3 (character positivity of Wilson weights). Let chi be any
character of a finite group G (any nonnegative-integer combination of
irreducible characters), beta >= 0, and w = exp(beta Re chi). Then EVERY
coefficient w_hat_R >= 0.

PROOF. (i) Re chi = (chi + conj chi)/2, and conj chi is the character of
the conjugate representation, so 2 Re chi is a character. (ii) Products of
characters are characters (tensor products), so (Re chi)^k is, for every k,
a nonnegative rational combination of irreducible characters. (iii) The
exponential series has nonnegative coefficients beta^k / k! (beta >= 0) and
converges absolutely pointwise on the finite set G, so w is a nonnegative
combination of irreducible characters; its coefficients in the chi_R basis
are exactly the w_hat_R. QED. [T]

COROLLARY 3a (finite Bochner, both directions Gram). For a class function
w, the kernel K(g,h) = w(g h^{-1}) on G x G is PSD iff all w_hat_R >= 0.
(<=): chi_R(g h^{-1}) = sum_{ij} rho_R(g)_{ij} conj(rho_R(h)_{ij}) for a
unitary realization - a Gram matrix - and a nonnegative combination of
Gram matrices is PSD. (=>): test K against the vectors (chi_R(g))_g.
[T]

Structural remark [orig, cross-track]. This is the SAME move as
`GateMP.SCGGramPositivity` on the measure track: strong positivity of the
SCG decoherence functional and reflection positivity of the Wilson ensemble
are both instances of "exhibit the bilinear form as a Gram matrix". The
planning document's shared-toolbox claim (section 0) is hereby a
lemma-level identity, not an analogy
```

### 6. `AgentTasks/aristotle-prompts/qmf5-fermionic-rp-strategy-20260705.prompt.md` [DELIVERABLE 1 (primary, super-stretch): finite fermionic reflection positivity]

Score: `0.781`

```text
## DELIVERABLE 1 (primary, super-stretch): finite fermionic reflection positivity

Design the cleanest KERNEL-CHECKABLE finite statement of fermionic (Grassmann /
Wilson-quark) reflection positivity that REUSES the RP-KER stack (A), the
Berezin=det identity (B), and the Wilson-Dirac gamma5-hermiticity (C). The
physics targets are Osterwalder-Seiler (1978) Sec. 4-5 and Menotti-Pelissetto
(1987) (Wilson-fermion RP). I want:

1. The exact Lean DEFINITIONS for the fermionic reflected weight (after
   integrating out the Grassmann fields, so the weight is a determinant / ratio
   of determinants of a REFLECTED block of `wilsonDirac`), phrased so that the
   existing `reflectionForm` / `cutKernel` / `rpBlockMatrix` API applies with
   the fermionic determinant playing the role of `W`.
2. The theorem SHAPE(S): signature, hypotheses (time-reflection symmetry of the
   link field, positivity of the Wilson hopping across the cut, mass-degenerate
   flavor pairing), and conclusion (`IsReflectionPositive` of the fermionic
   weight, or PSD of the fermionic `cutKernel`/`rpBlockMatrix`).
3. The full lemma DAG from (A)+(B)+(C) to that conclusion, each node a named
   Lean lemma with a one-line proof strategy and its dependency edges, marking
   which nodes are direct from the existing API and which are genuinely new.
4. The key mathematical crux (I expect it is: the reflected Wilson-Dirac block
   factorizes as `Mᴴ M` or a convex mixture of such, so `cutKernel_posSemidef_
   of_factorized`/`_of_mixture` fires) - state it precisely and prove the
   linear-algebra core, or give the smallest missing lemma.
```

### 7. `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md` [design:q2-transfer-polarization (seeded by planning session; resolve before any T2 Lean)]

Score: `0.780`

```text
## design:q2-transfer-polarization (seeded by planning session; resolve before any T2 Lean)

Decisions needed:
1. Pairing definition and argument order: `reflectionPairing W f g` with
   `f` in the antilinear slot (matching `reflectionForm W f =
   reflectionPairing W f f`). Confirm or amend.
2. Quotient route. Planning session recommends the finite matrix route:
   block-diagonal PSD matrix `K` (blocks `cutKernel W c`), Hilbert space
   = range of `CFC.sqrt K` with the standard inner product, transfer
   operator = compression (reuses `TransferPositivity` atoms). The
   alternative (`InnerProductSpace.Core` on a quotient) needs
   Cauchy-Schwarz-for-semidefinite plumbing - argue if you prefer it.
3. Name the deliverable statements (suggest: `transferSpace`,
   `transferOp`, `transferOp_posSemidef`, `transferOp_isSelfAdjoint`),
   abstract over `W` with only `IsReflectionPositive W`.

Codex 1.11:44 PROPOSED RESOLUTION, review requested before Lean:

1. Pairing order: confirm the seeded order. Define
   `reflectionPairing W f g` as the same sum as `reflectionForm W f`, but with
   `g a c` in the linear slot:

   ```lean
   def reflectionPairing (W : A -> C -> A -> Cplx)
       (f g : A -> C -> Cplx) : Cplx :=
     sum c, sum b, sum a, conj (f b c) * W a c b * g a c
   ```

   Thus `reflectionPairing W f f = reflectionForm W f`, and the antilinear
   slot is the first argument / mirrored-negative `b` coordinate. This matches
   RP-KER and the T14 Z3 anti-linear oracle guard.

2. Matrix route: keep the public hypothesis as
   `ReflectionPositivityKernel.IsReflectionPositive W`, but introduce the
   proof bridge to the finite matrix:

   - index type `I := C x A` (or an equivalent sigma/product type);
   - `rpBlockMatrix W : Matrix I I Cplx`, block diagonal in `c`, with
```

### 8. `AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md` [T2 - Q2: transfer Hilbert space from RP (design-first)]

Score: `0.779`

```text
## T2 - Q2: transfer Hilbert space from RP (design-first)

**Goal.** From `IsReflectionPositive W`: inner-product space + positive
self-adjoint transfer operator.

**First moves.** Resolve `design:q2-transfer-polarization` in
`DISCUSSION.md` BEFORE writing Lean. Decisions needed: (a) the pairing -
define `reflectionPairing W f g` (the off-diagonal sesquilinear form
whose diagonal is `reflectionForm`), fix argument order once; (b) the
quotient route - RECOMMENDED: finite-dimensional matrix route. The
pairing is `sum_c star (f .c) K_c (g .c)` for the PSD matrices
`K_c = cutKernel W c`; assemble the block-diagonal PSD matrix `K` on the
function space `A x C -> C` (finite!) and define the Hilbert space as the
range/column space of `K` (or quotient by `ker K`), with inner product
induced by `K`. Mathlib assets: `Matrix.PosSemidef.sqrt`-era
`CFC.sqrt`, `Matrix.toLin`, `LinearMap.range`/`ker` quotients,
`FiniteDimensional`. This avoids `InnerProductSpace.Core` definiteness
plumbing entirely: define the space as `range (CFC.sqrt K)` with the
standard inner product - positivity is free, self-adjointness of the
compressed transfer operator is a finite computation. (c) What the
transfer operator IS at this layer: the one-slab convolution/compression;
`TransferPositivity.compression_posSemidef` is the existing atom.

**Pitfalls.** Do not claim a Hamiltonian or physical Hilbert space -
Krein caveat stands; this is the OS/GNS-at-finite-level construction.
Keep the statement abstract over `W` with `IsReflectionPositive W` as the
only hypothesis, so Q1's Wilson instance plugs in.

**Tiers.** Baseline: design thread resolved + statement file frozen with
documented handoffs. Strong: the inner-product space + positivity of the
compressed transfer operator kernel-checked abstractly. Shocki
```

## Scoped paper hits

### 1. A Note on Reflection Positivity and the Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation Functions

Score: `0.761`
Zotero key: `R3JICUIK`
arXiv: `1201.3415`
URL: http://arxiv.org/abs/1201.3415

Abstract:

It will be proved that a model of lattice field theories which satisfies (A1) Hermiticity, (A2) translational invariance, (A3) reflection positivity, and (A4) polynomial boundedness of correlations, permits the Umezaa-Kamefuchi-Kallen-Lehmann representation of two point correlation functions with positive spectral density function. Then, we will also argue that positivity of spectral density functions is necessary for a lattice theory to satisfy conditions (A1) - (A4). As an example, a lattice overlap scalar boson model will be discussed. We will find that the overlap scalar boson violates the reflection positivity.

### 2. Reflection Positivity---A Representation Theoretic Perspective

Score: `0.728`
Zotero key: `W3F7R3BF`
arXiv: `1802.09037`
URL: http://arxiv.org/abs/1802.09037

Abstract:

Refection Positivity is a central theme at the crossroads of Lie group representations, euclidean and abstract harmonic analysis, constructive quantum field theory, and stochastic processes. This book provides the first presentation of the representation theoretic aspects of Refection Positivity and discusses its connections to those different fields on a level suitable for doctoral students and researchers in related fields.

### 3. Reflection-Positive Construction of a Four-Dimensional SU(N) Yang-Mills Theory with Mass Gap and Confinement

Score: `0.727`
Zotero key: `BH39WBRV`
arXiv: `2606.19362`
DOI: `10.1002/prop.70097`
URL: http://arxiv.org/abs/2606.19362

Abstract:

In the Euclidean view one must first require that positivity not be violated, and from this modest demand, together with locality, a great deal follows: starting from a reflection-positive lattice formulation of pure SU(N) Yang-Mills theory we obtain a transfer operator with a uniform gap, while large Wilson loops already show an area law by means of convergent character (polymer) expansions; a finite-range, gauge-covariant multiscale analysis then carries these features from one scale to the next with interlaced inequalities whose small defects can be summed, so that exponential clustering and a strictly positive string tension endure in the continuum; the Osterwalder-Schrader reconstruction turns these Euclidean facts into a Minkowski theory with a self-adjoint Hamiltonian, the spectral gap lying above the vacuum and the linear potential for static charges appearing, which gives a concrete picture of confinement; the construction depends on no special regulator, for a single-scale Lipschitz control and a telescoping argument bind all admissible reflection-positive slicings into a unique limiting measure and thus secure universality; moreover, the same framework admits entry from weak coupling, so that the continuum reached from strong coupling meets the one approached along an asymptotically free trajectory, yielding one and the same theory; in my view this is how mathematical clarity and physical insight cooperate: positivity, locality, and renormalization working together so that the mass gap and confinement are not marvels to be assumed, but natural properties of the non-Abelian vacuum.

### 4. Kallen-Lehmann Spectral Representation of the Scalar SU(2) Glueball

Score: `0.719`
Zotero key: `DPJ6N6WS`
arXiv: `2103.11846`
DOI: `10.1140/epjc/s10052-022-10213-3`
URL: http://arxiv.org/abs/2103.11846

Abstract:

The Kallen-Lehmann spectral density is estimated from gauge-invariant lattice two-point functions in the scalar SU(2) glueball channel. The extracted ground-state mass agrees with the standard large-time exponential method and the spectral density contains indications of excited states.

### 5. Locality properties of Neuberger's lattice Dirac operator

Score: `0.716`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010
