# Planning-session prep notes (read after TASK_DIRECTIONS, before starting T1/T2)

Verified facts and pre-work done by the planning session on 2026-07-03,
so the night does not re-derive them. Everything below marked VERIFIED
was actually executed/checked this session; nothing is from memory.

## 1. Oracle v0.2: both TODOs CLOSED (VERIFIED: 36/36 this session)

`Scripts/oracle/validate_lgt_core.py` is now v0.2:

- ORACLE-TODO-2 closed: section [3]'s decay row is a real monotonicity
  check (fixed 2x2 volume, h = 0.2/0.1/0.05).
- ORACLE-TODO-1 closed: new section [9], Z3 complex-character fixture.
  **It found a real convention subtlety, normative for T1/T2 statement
  files:** the freeze s4 fusion form `sum_h w(h) chi_R(A h)` is valid
  exactly when the weight is inversion-symmetric (`w(h) = w(h^{-1})`,
  true for every Wilson weight `exp(beta Re chi_f)`). For a GENERAL
  class function the correct form is the convolution form
  `sum_h w(h) chi_R(h^{-1} A) = |G| w_hat_R chi_R(A) / d_R`, and the
  oracle's guard row shows the naive order genuinely differs for an
  asymmetric complex class function. **State Lemma 2a in Lean in
  convolution form; derive the Wilson case as a corollary via inversion
  symmetry.** C-5 is pinned as the EXPANSION coefficient
  (`w = sum_R w_hat_R chi_R`).
- T0/T2 no longer need to touch the oracle. The suite count is now 36;
  it must stay green (36/36) after any further edit.

## 2. Mathlib API: verified present this session (lean-explore)

Confirms and extends freeze s15. All names checked against the index:

- `Representation.char_tensor`, `Representation.char_orthonormal`,
  `FDRep.char_tensor`, `FDRep.char_orthonormal`,
  `Representation.IsIrreducible.bijective_or_eq_zero` (Schur) - present,
  as s15 said. The s15 trap stands: `char_conj` is class-function
  conjugation-invariance, NOT complex conjugation.

**CORRECTION (01:35, claude, mid-T1, before starting Route A): the
`Representation.character` / `Representation.char_tensor` /
`Representation.char_orthonormal` family does NOT exist** in this
repo's pinned Mathlib (checked directly:
`.lake/packages/mathlib/Mathlib/RepresentationTheory/Character.lean`
defines `character`, `char_tensor`, `char_conj`, `char_dual`,
`char_orthonormal` ALL under `namespace FDRep`, on the CATEGORICAL type
`FDRep k G` - not on the raw `Representation k G V` structure). This is
the SAME pattern as the `Matrix.PosSemidef.hadamard` overclaim in
section 1: freeze s15 (and lean-explore) named the `Representation.*`
form as primary and `FDRep.*` as merely "the categorical-layer twin,"
but only the `FDRep.*` form is actually present here.
`Representation.IsIrreducible` DOES genuinely exist (in
`RepresentationTheory/Irreducible.lean`, as an `abbrev` for
`IsSimpleOrder (Subrepresentation rho)`), but it is NOT the typeclass
`FDRep.char_orthonormal` uses (that lemma uses the categorical
`[Simple V]` from `CategoryTheory.Simple`, a different irreducibility
notion for a different representation type) - the two don't compose
directly without a bridge.

**Consequence for Route A:** any `CharacterPositivity.lean` statement
file MUST be written against `V W : FDRep k G` with `[Simple V]`
(category-theoretic simplicity), not against `rho : Representation k G V`
with `Representation.IsIrreducible rho`. The step-(i) unitarity gap
(freeze s15's identified blocker: `conj(chi(g)) = chi(g^-1)`) is now
ALSO harder to close via `FDRep`, since `FDRep k G` carries no built-in
inner-product/unitarity structure to hang an explicit hypothesis on the
way `WilsonWeightPositivity.lean`'s bare-matrix `rho` did - a Route A
statement file would likely need to define its own unitary-`FDRep`
wrapper or drop back to a bare-matrix formulation (losing `char_tensor`/
`char_orthonormal`'s direct applicability). This makes Route A
GENUINELY HARDER than the freeze assessed, not just "needs an API
exploration session" - it needs a design decision first. Given Route B
(`WilsonWeightPositivity.lean`) already supplies everything RP-LINK
needs (confirmed in `review:t1-routeB`), Route A is deprioritized for
tonight below T3 (the lattice/D12 layer, which directly unblocks
RP-LINK's remaining content per `idea:rp-link-scope`) unless someone
has fresh appetite for the `FDRep` category-theory API specifically.
- **`Matrix.PosSemidef.kronecker` and `Matrix.PosDef.kronecker` EXIST**
  (`Mathlib/Analysis/Matrix/Order.lean`, for any `RCLike 𝕜`, so `𝕜 = ℝ`
  works directly). Cor 3b's tensor-product-of-kernels step is a citation,
  not a proof.
- **CORRECTION (00:40, claude, mid-T1): `Matrix.PosSemidef.hadamard` does
  NOT exist** in this repo's pinned Mathlib (`mathlib4` commit `8f9d9cf`,
  2026-02-16 - checked via direct grep of
  `.lake/packages/mathlib/Mathlib/{LinearAlgebra,Analysis}/Matrix/*.lean`,
  not just lean-explore). The Schur product theorem (Hadamard product of
  two PSD matrices is PSD) is simply absent under any name searched. The
  earlier "VERIFIED present" claim was wrong - lean-explore's index
  apparently reaches a newer/different Mathlib snapshot than what this
  repo vendors. **Lesson for the rest of the night: lean-explore hits are
  a lead, not a fact - confirm load-bearing citations against
  `.lake/packages/mathlib` directly (grep or `lean_declaration_file`)
  before designing a proof plan around them, especially for anything
  Aristotle will be told to "just cite".**
  Good news: it is cheaply DERIVABLE from what IS present -
  `A ⊙ B = (A ⊗ₖ B).submatrix (fun i => (i,i)) (fun i => (i,i))`
  (Hadamard product is the Kronecker product restricted to the diagonal
  embedding), and `Matrix.PosSemidef.submatrix (hM) (e : m → n) :
  (M.submatrix e e).PosSemidef` holds for ANY `e` (no injectivity
  needed) - both confirmed present. See `WilsonWeightPositivity.lean`'s
  new `hadamard_posSemidef` lemma (added this session) for the proof;
  it is a genuinely reusable, Mathlib-shaped result this repo now owns
  and should consider upstreaming.
- `Matrix.PosSemidef.submatrix` (compressions), `Matrix.posSemidef_sum`,
  `Matrix.PosSemidef.add/.smul`, `Matrix.posSemidef_conjTranspose_mul_self`
  and `_self_mul_conjTranspose`, `Matrix.PosSemidef.mul_mul_conjTranspose_same`
  / `.conjTranspose_mul_mul_same`, `Matrix.PosSemidef.eigenvalues_nonneg`
  - the whole PSD toolbox for 3a/3b is present.
- Graph cycle-space / even-degree-subgraph machinery: ABSENT from
  Mathlib (searched). T2's even-cover lemma is bespoke finite
  combinatorics, as planned - a genuine PKG-YM1-B target.

## 3. Route B for the RP kernel (strategic; planning-session observation)

RP-LINK needs ONE fact from section 5: the per-link kernel
`K(g,h) = w(g h^{-1})` is PSD for Wilson weights. There is a
character-theory-FREE route, entirely on the verified PSD toolbox:

1. `M(g,h) := Re chi_f(g h^{-1}) = Re tr(rho(g) rho(h)^H)` for unitary
   `rho` - a real Gram kernel (Hilbert-Schmidt inner products of the
   matrices `rho(g)`), hence PSD. Unitarity is exactly the
   `design:ym3-unitarity` hypothesis (option 1).
2. `K = exp(beta * M)` ENTRYWISE = `sum_k (beta^k / k!) M^{hadamard k}`;
   each Hadamard power is PSD by `Matrix.PosSemidef.hadamard`
   (induction), each term has nonneg coefficient (beta >= 0), and for
   any vector `x` the quadratic form is a convergent series of nonneg
   reals (`tsum_nonneg` + swapping the FINITE quadratic-form sums with
   the exp `tsum`).

Recommendation: run BOTH routes as separate targets. Route B
(`wilsonKernel_posSemidef` via Gram + Schur product) is the fastest path
to a kernel-checked RP-LINK and does not need `char_orthonormal` at all.
Route A (Theorem 3 proper: `w_hat_R >= 0`, then Bochner both directions)
is still wanted on its own - it is the freeze's Theorem 3, it feeds the
2D exact solution (T2) and the Bochner CONVERSE, and it is the statement
the YM3 paper narrates. Route B de-risks the flagship; Route A completes
it. If Route A stalls in character-theory bookkeeping, RP-LINK still
lands tonight via Route B.

Scaffold: `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean`
(planning session; typechecked - see its module docstring) contains the
Route B definitional layer and statement skeletons with documented
handoff `s o r r y` markers, wired into the `GateYM.lean` aggregator.

## 4. Neo4j: was DOWN; started headlessly by the planning session

`neo4j_paper_search.py` initially failed with "connection refused"
(127.0.0.1:7687) - no service, no Docker, Neo4j Desktop 2 not running.
Started headlessly in a background console:

```text
JAVA_HOME = C:\Users\Owner\.Neo4jDesktop2\Cache\runtime\zulu21.48.17-ca-jre21.0.10-win_x64
& C:\Users\Owner\.Neo4jDesktop2\Data\dbmss\dbms-2edec9a4-3c37-4c8c-8597-860c35408aa1\bin\neo4j.bat console
```

VERIFIED up: Bolt on localhost:7687, HTTP on 7474, vector queries
working. **T0 must re-verify it is still up** (one `--query` call) and
restart with the same command if the console died with the planning
session. If it cannot be restarted, the lit protocol degrades to
web-search-only with ingests deferred to a morning batch - note that in
the ledger, do not silently skip ingests.

## 5. Literature graph state (VERIFIED empty of YM sources)

Semantic queries for RP/Osterwalder-Seiler, strong-coupling/mass-gap,
and cluster-expansion/KP all return only off-topic C1/C2-era lattice
fermion papers (scores < 0.76). **The YM debt register starts from an
empty shelf: every T6 item is discovery + ingest, not lookup.** Also
observed: arXiv 1709.04891 is duplicated in the graph (keys `5J5XDKMN`
and a malformed `zotero:SZJE69PE`) - known dup-key pathology; log it,
clean it only if touching that record anyway.

Verified identifiers to seed T6 (web-checked this session):

- Chatterjee, "Yang-Mills for probabilists": **arXiv:1803.01950**
  (Springer Proc. Math. Stat. 283, 2019). Register item 10.
- "A stochastic analysis approach to lattice Yang-Mills at strong
  coupling": arXiv:2204.12737 (modern school, item 10).
- "Geometric Derivation of the Finite N Master Loop Equation":
  arXiv:2309.07399 (item 10).
- Nature Reviews Physics 2025, "The Yang-Mills Millennium problem"
  (s42254-025-00909-2) - candidate source for the CURRENT community
  assessment (items 7/11); verify content before citing.
- Pre-arXiv classics (Elitzur 1975 PRD 12 3978; Osterwalder-Seiler 1978
  Ann. Phys. 110 440; Wegner 1971 JMP 12 2259; Wilson 1974 PRD 10 2445;
  Kotecky-Preiss 1986 CMP 103 491; Banks-Casher 1980 NPB 169 103):
  these identifiers are STILL FROM MEMORY - verify each against the
  actual source before it enters a docstring or LIT_LOG verdict.

**Novelty check (item 8) - preliminary adjacent-art finding, MUST be
scoped tonight:** arXiv **2606.07922** ("A Finite-Lattice Model from a
Reciprocal Cost Action: Spectral and Reflection-Positivity Properties",
repo github.com/jonwashburn/shape-of-logic) advertises Lean + RP in one
breath. Per its own text the discrete-field RP is a TEXT proof, with
only elementary algebraic facts in Lean - i.e., it does NOT appear to
preempt "first kernel-checked reflection positivity", and it is not
lattice gauge theory. But it is the closest known art: read it (ingest
+ `--chunks`), check the repo's actual Lean contents, and scope the
flagship claim language against it explicitly. Do not write any "first"
sentence before this is logged.

## 6. Aristotle partner prompts: pre-drafted

`AgentTasks/aristotle-prompts/overnight-ym-ladder-strategy.prompt.md` is
complete - submit as-is after filling the one TONIGHT-STATE block.
`AgentTasks/aristotle-prompts/overnight-ym3-semantic-redteam.prompt.md`
is a template with `<<PASTE ...>>` slots for the verbatim Lean
statements once T1 authors them. Both follow the established format.
