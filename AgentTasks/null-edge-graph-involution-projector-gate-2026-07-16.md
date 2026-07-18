# Graph-native involution/projector gate

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: projector/involution equivalence and permutation no-go integrated and independently approved

## Central correction

An involution does not by itself solve projector selection. For an idempotent
real-linear map (P),

\[
  J_P = 2P-I
\]

is an involution and

\[
  \frac{I+J_P}{2}=P.
\]

Conversely, an involution (J) gives the positive projector

\[
  P_J=\frac{I+J}{2}.
\]

Thus the two packages are algebraically equivalent. The involution route gains
scientific content only when the graph supplies (J) for a reason independent
of already knowing the desired projector. The reverse bridge is now proved
beside the positive-projector lemmas in
`PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean`.

Claim status: finite linear-algebra identity, `M [orig/comp]`; direct Lean,
targeted build, source scan, and build-enforced axiom guards pass.

## Existing exact control

`PhysicsSM/Draft/NullEdge/IntrinsicProbeSubspace.lean` already contains the
sharp symmetric example. On the five-event antichain, the canonical zero-sum
scalar-field subspace has finrank four while every individually natural
zero-sum probe vector vanishes. This proves that full automorphism symmetry
forbids a canonical ordered frame but can preserve a gauge-relative rank-four
subspace.

The same zero-sum construction has rank (n-1) on (n) vertices. Its rank
four at (n=5) is therefore a cardinality control, not a refinement-stable
spacetime reconstruction. `BareGraphPermutationProjectorNoGo.lean` proves the
complementary theorem: for (n\ge 6), no fully permutation-equivariant
idempotent on the natural scalar vertex-probe module has rank four. Together,
the two statements isolate the escape correctly: the program needs restricted
graph symmetry, added equivariant structure, or a richer probe module.

## Candidate mechanisms

| Candidate | What is graph-native | What it gives | Fatal debt or test |
|---|---|---|---|
| Zero-sum vertex projector | Vertex set and counting measure | Exact natural projector; rank (n-1) | Rank varies with carrier size; rank four only at five events |
| `J = sign(A - tau I)` | A graph-derived self-adjoint `A`, intrinsic threshold `tau` | Basis-free involution and spectral projector | Must derive `A`, `tau`, a stable four-mode gap, and Lorentzian inertia |
| Kernel projector of a constraint (Q) | A graph-derived equivariant constraint | Four-dimensional sector if \(\dim\ker Q=4\) | Kernel dimension, gap, and refinement stability are the entire G2 debt |
| Sorkin-Johnston positive spectral sector of (i\Delta) | Retarded/advanced Green data on a finite causal set | Covariant spectral split without eigenvector ordering | Field-mode rank is generally extensive, not a four-coordinate sector |
| Hermitian dilation of a retarded operator | A graph-derived retarded map and adjoint | Canonical paired positive/negative spectrum | Positive rank tracks operator rank; no reason for four modes |

The Sorkin-Johnston row is a structural precedent, not an identification. The
causal-set literature constructs a positive spectral part of the finite
Pauli-Jordan matrix (i\Delta); see the full-text-indexed reviews
arXiv:2306.04800 and arXiv:1010.5514. That construction concerns field
quantization and does not supply a tetrad sector.

## Preferred theorem ladder

1. **Projector/involution equivalence: complete.** The integrated module proves
   (J_P^2=I), (P_{J_P}=P), and (J_{P_J}=J), plus exact range and
   intertwining transport for the forward positive projector.
2. **Symmetry obstruction: complete.** The fully permutation-equivariant
   rank-four no-go for scalar vertex probes at (n\ge6) is kernel-checked with a
   build-enforced axiom guard and independently approved without revision.
3. **Polynomial-filter naturality: complete.** Intertwining carrier operators
   transport every common real-polynomial filter, its range, idempotence, and
   range finrank exactly. A certified rank-four filter packages into the
   carrier projector without eigenvector choices. The graph still owes the
   operator and the spectral certificate.
4. **Four-mode isolation.** State a displayed fourth/fifth spectral-gap gate
   and prove rank four only from that gate. Do not infer rank from a numerical
   eigensolver without a certified gap.
5. **Lorentzian inertia.** Restrict the independently defined probe pairing to
   the selected sector and prove inertia `(1,3,0)`. A positive spectral sector
   alone does not provide a Lorentzian form.
6. **Overlap/refinement transport.** Feed the selected projector into
   `ProtectedCoreProbeProjectorTransition.lean`; separately prove shared
   projector, liftability, restricted injectivity, triple compatibility, and
   gap persistence along refinement.

## Operator-selection decision

No new numerical selector should be opened merely by writing
`sign(A - tau I)`. First require a candidate (A) to satisfy all four
pre-data conditions:

1. constructed from the finite order and admitted carrier decorations only;
2. exactly equivariant under order isomorphisms;
3. accompanied by an intrinsic threshold or a threshold-free kernel target;
4. linked to an analytic continuum symbol or a sourced field-theoretic role.

The current causal retarded operator is a possible input only after its
protected-germ support and adjoint structure are fixed. Its raw lowest modes
and normal-operator filters have already failed the earlier intrinsic-probe
benchmark, so low spectral cost alone is a killed selection principle.

There is now a sharper preregistered audit of the direct polynomial route. The
finite retarded operator appears to be a scalar diagonal plus a weighted
strict-past operator. Focused Aristotle projects
`cdb53c37-a5ad-4c72-9714-27136ce91f62` and
`1c4479b1-3215-4d68-a5f1-6bfd9fb13aae` prove, respectively, strict-past
nilpotence and the theorem that scalar-plus-nilpotent operators have only
trivial idempotent polynomial filters. Both are integrated and composed with
the production layered and active smeared operators in
`LayeredOperatorPolynomialNoGo.lean`. Independent review approved both
Aristotle statement chains and the graph-facing bridge without revision. The
direct retarded polynomial-filter family is therefore closed; corrected
symmetric, normal, Hermitian, and richer constraint operators remain open.

The exact polynomial interface is now landed in
`PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean`. This
removes functional-calculus covariance as a possible hidden obstacle but does
not make a numerical threshold canonical. The admissible next theorem must
derive an order-native operator and certify a four-mode polynomial projector
or an equivalent separated spectral sector before any held-out metric test.

## Kill conditions

- **K1:** the proposed operator is scalar under all automorphisms and its
  symmetric controls fall under the permutation no-go.
- **K2:** rank four occurs only because a carrier happens to have five events.
- **K3:** a fourth/fifth gap does not persist or improve on a frozen refinement
  ladder.
- **K4:** selected sectors fail exact relabeling/intertwining tests.
- **K5:** the restricted pairing lacks stable Lorentzian inertia on flat
  controls.
- **K6:** overlap restrictions fail liftability or injectivity, even when both
  local rank/gap gates pass.

Any K1-K6 failure kills the displayed operator/sector architecture, not every
possible graph reconstruction.

## Current boundary

This audit improves the statement of G2 but does not open it. The graph still
owes the local probe representation, the order-native operator or constraint,
the source spectral certificate/gap, exact source rank four, Lorentzian
inertia, and compatible overlap and refinement transport. Polynomial
naturality and target certificate transport are complete. The downstream
spin, curvature, stress-energy, and Einstein-dynamics layers remain
conditional.

Proof packages:

- `AgentTasks/protected-core-involution-projector-aristotle-2026-07-16.md`:
  integrated.
- `AgentTasks/bare-graph-permutation-projector-no-go-aristotle-2026-07-16.md`:
  integrated.
- `AgentTasks/retarded-polynomial-projector-no-go-aristotle-2026-07-16.md`:
  integrated and independently approved with the graph-specific composition.
