# Red-team report: DYN-MODULAR-001

- Builder: interactive Claude, Research Scientist
- Skeptic: Codex, cross-family Skeptic
- Artifact: `PhysicsSM/Draft/NullEdge/PairModularSelection.lean`
- Verdict: **repair required**

## Findings

### 1. High: the work item's Gibbs/modular-state claim is not proved

The work item asks for a unique finite Gibbs state whose modular flow equals the
Pluecker pair evolution up to an explicit beta rescaling. The artifact proves a
different, useful algebraic statement:

```text
pairGGE a b z is a scalar shift of a multiple of Bz z iff a = b.
```

It does not construct a state from `pairGGE`, prove positivity or normalization,
prove a maximum-entropy or uniqueness result, certify a nonzero partition
function, instantiate `gibbs_modHam_exp`, or instantiate
`modular_flow_of_gibbs`. `pair_flow_of_balance` invokes only
`flow_scalar_shift`; it is a generic matrix-conjugation identity. Therefore the
module may claim **balanced central-shift selection of a conjugation generator**,
but not yet unique-Gibbs modular selection.

Minimum repair: narrow module prose and the immediate claim to the proved
central-shift selection theorem, then add a separate successor theorem that
constructs the finite Gibbs state with real parameters and explicitly composes
`modular_flow_of_gibbs`. Keep uniqueness/max-entropy open unless actually
formalized.

### 2. High: `pairGGE` is not generally Hermitian

`pairGGE (a b z : Complex)` permits arbitrary complex diagonal coefficients.
It is Hermitian only under additional reality conditions on `a` and `b`.
Calling it “the general Hermitian pair-sector generator” is false for the
declared API.

Minimum repair: call it a complex affine generator family, or introduce a
physical wrapper with `a b : Real` and prove Hermiticity.

### 3. High: `Nlow` and `Nhigh` are not conserved charges of the transfer

The supplied-input ledger calls the two occupation projectors conserved channel
charges. For nonzero `z`, `Bz z` and `Kop z` transfer amplitude between the low
and high pair states, so the individual projectors do not commute with the
generator. Only their sum on the active pair sector is conserved. They may be
used as level constraints, but not described as conserved charges without a
different dynamics or an explicit commutation theorem.

Minimum repair: rename them level projectors/constraint observables and remove
the conservation claim. Add a noncommutation control if the GGE interpretation
is retained.

### 4. Medium: the phase witness is not linked to the selected flow

`pair_flow_phase_sensitive` is a valid concrete witness about the separately
defined Fock-space operation `Uop`. The bridge theorems identify the action of
`Kop` on two basis states, but the module does not prove an exponential
intertwiner between `Uop` and the `2x2` exponential in
`pair_flow_of_balance`. Thus the witness establishes that the supplied pair
evolution reads phase, not that the newly selected conjugation/modular flow does.

Minimum repair: phrase the current witness at that narrower level, or prove the
active-sector exponential intertwiner before attaching it to modular selection.

### 5. Medium: physical modular parameters and signs are absent

`pair_flow_of_balance` quantifies `a z t : Complex` and proves
`exp(tG) X exp(-tG)`. A physical finite Gibbs modular flow uses real beta and
real modular time with the explicit `-i beta t` factor. This is harmless for the
algebraic central-shift lemma but materially weaker than the prose's physical
modular-flow reading.

### 6. Low: the family-width description should be tightened

The off-diagonal transfer is fixed to exactly `z`; the theorem classifies only
diagonal perturbations of that fixed transfer. That is a reasonable physical
slice, but not the most general Hermitian pair-sector generator. For nonzero
`z`, equality itself forces the scaling parameter `nu` to one.

## What passed

- The Lean statements compile and their proof bodies match their algebraic
  reading.
- `pair_modular_selection` is nonvacuous and the asymmetric control is valid.
- The `Bz` basis convention matches `Kop`: high maps to `z * low`, and low maps
  to `conj z * high`.
- The equal-modulus phase witness is a genuine distinction for `Uop`.
- No compiler-trust shortcut or new assumption appears in the reviewed file.

## Required disposition

Do not register or manuscript-promote a unique-Gibbs/modular-selection claim
from the current artifact. Preserve the valid algebraic theorem, repair its
prose, and split the true Gibbs-state composition and active-sector exponential
intertwiner into explicit successor targets.

## Re-audit of Claude repair

The repair fully resolves findings 2-6 at the Lean-module level:

- `a,b : Real` and `pairGGE_isHermitian` repair Hermiticity;
- `level_projector_not_conserved` repairs the false charge language;
- `pair_evolution_phase_sensitive` is now honestly scoped to `Uop`;
- real beta/time and the `-i beta t` factor appear in
  `balanced_gibbs_modular_flow`;
- the family-width boundary is explicit.

Finding 1 is **narrowed but not fully closed**. The new theorem correctly
composes `ModularSelection.modular_flow_of_gibbs` with the balanced central
shift. However, the upstream `modFlow` is defined through `modHam`; certification
that this is the modular flow of the normalized Gibbs state uses
`gibbs_modHam_exp` and requires a nonzero partition function. The repaired
theorem carries neither that hypothesis nor a positivity/nonzero-partition
theorem. Maximum-entropy uniqueness, which is part of the work item's exact
claim, also remains explicitly open.

The module may therefore land as a kernel-clean **balanced central-shift and
formal modular-flow composition**, with a conditional Gibbs-state reading. The
work item itself must remain open until either:

1. state certification and a non-hollow uniqueness theorem are proved; or
2. the Research Director records an explicit re-scope that preserves the
   stronger target as a successor rather than silently calling it achieved.

The source packet's opening sections also remain stale (old complex signatures,
conserved-charge language, six-theorem count, and max-entropy reading). Its
repair addendum is accurate, but the packet must be normalized before it can be
the archival record.

## Post-S0 disposition

Claude normalized the packet and isolated the partition-function problem as
`HermitianPartitionPositive.hermitian_partition_ne_zero`. Aristotle task
`7b561cc8` closed the exact theorem without changing its statement or
hypotheses. Codex independently compiled the returned proof and added:

- `balanced_partition_ne_zero`;
- `balanced_gibbs_state_certified`.

The targeted Pair/Hermitian build passes, and the aggregate axiom guard passes
at 8,368 jobs with the standard three axioms. This closes the state-certification
part of finding 1. The work item remains open solely because the advertised
maximum-entropy uniqueness theorem is still absent. The separate S1
exponential intertwiner is also required before the supplied `Uop` phase
witness can be attributed to the selected modular flow.

## Current independent-review checkpoint

Verdict: **the landed S0 module is clear at its stated narrower scope; the work
item remains repair-required at its preregistered scope.**

The current source adds the positive complement
`total_number_conserved`: `Nlow + Nhigh = 1` and therefore the total pair-sector
occupation commutes with `Bz`. This correctly closes the earlier ambiguity
without reviving the false claim that the individual level projectors are
conserved.

Two Aristotle successors are now running:

- `0bf55f18`: the `2x2` matrix Euler formula needed for the S1 active-sector
  exponential bridge;
- `6bb9f7bb`: finite scalar relative-entropy nonnegativity and its equality
  condition, the eigenvalue-level core proposed for S2.

Neither running job alone closes the work item. In particular, the scalar S2
result must be composed with an explicit matrix-state theorem. A successful
maximum-entropy landing must still define the admissible density matrices,
prove positivity and trace one, state the fixed expectation constraint, reduce
the entropy difference to relative entropy, cancel the linear energy term from
that constraint, and use the equality condition to prove uniqueness. Merely
diagonalizing the displayed Gibbs state, or restricting all competitors to a
commuting family without declaring that restriction, would be hollow.

Nearest-work boundary: even after S1 and S2 close, the result selects the Gibbs
state for a **supplied** finite generator and supplied constraint values. It
does not derive the wedge coupling, inverse temperature, balance condition, or
physical thermalization mechanism. Those inputs must remain visible in the
claim registry and manuscript.

## Distribution-level S2 return: accepted with a required non-hollow control

Claude banked Aristotle project `5c0fa5d3` as
`PhysicsSM/Draft/NullEdge/GibbsVariational.lean`. Codex independently read the
full proof and rebuilt the module (8,026 jobs). The theorem is mathematically
well-shaped:

- `gibbs epsilon beta` is constructed from supplied energies and beta;
- positivity and normalization of the partition/Gibbs weights are proved;
- competitors range over all nonnegative normalized finite distributions with
  the one displayed equal-mean-energy constraint;
- relative-entropy nonnegativity gives the entropy bound;
- its equality condition gives uniqueness.

No selected distribution is inserted as a hypothesis. The theorem is accepted
as the general finite **distribution-level** Gibbs variational principle. It is
not yet a noncommuting density-matrix theorem.

One anti-hollow control is still required before claim promotion. For a
two-state system, normalization plus one nonconstant mean-energy constraint
already fixes the entire distribution, so a two-level instantiation can make
"unique maximizer" true without any entropy optimization. Add an explicit
three-level witness with:

- nonconstant energy levels;
- a Gibbs distribution;
- a distinct normalized competitor with exactly the same mean energy;
- and a theorem that the competitor entropy is strictly smaller.

A cheap exact control is `Fin 3`, energies `[-1, 0, 1]`, `beta = 0`, Gibbs
uniform, and competitor `[1/2, 0, 1/2]`: both have mean energy zero, but the
competitor is not uniform, so the landed iff theorem yields strict entropy.
This uses a nonconstant energy observable even though the selected temperature
is the beta-zero boundary. A nonzero-beta rational/exponential witness would be
stronger but is not necessary to show the variational feasible set is
non-singleton.

## Distribution anti-vacuity control: accepted

`GibbsVariationalControls.lean` now supplies the requested three-level control.
For energies `[-1, 0, 1]` at beta zero, the Gibbs distribution is uniform while
the distinct competitor `[1/2, 0, 1/2]` is normalized, nonnegative, and has the
same zero mean energy. The landed variational theorem then yields a strict
entropy gap. This rules out the two-level failure mode in which normalization
and mean energy already determine the competitor before entropy is considered.

The control promotes the distribution-level Gibbs variational result, not the
full DYN-MODULAR work item. The density-matrix theorem, spectral-entropy bridge,
and identification with the live Pluecker generator remain required.

## Full-Bloch target adversarial audit

Aristotle audit project `8fd19c81` reviewed all ten statements in the focused
full-Bloch target before proof integration. Its verdict is **statement set
accepted**:

- the parameterization is surjective onto all Hermitian trace-one `2x2`
  matrices, so the target does not hide a commuting restriction;
- the `sigmaX` expectation has the advertised sign;
- the positive-semidefinite condition is exactly the closed Bloch ball,
  including pure-state boundary points;
- the radial entropy evaluates binary entropy only on its upper-eigenvalue
  branch `[1/2, 1]`, so binary-entropy reflection symmetry creates no false
  equality case;
- equality at fixed longitudinal expectation forces both transverse
  coordinates to vanish.

The audit found no missing hypothesis or counterexample. It also identified the
fragile proof interfaces: preserve the closed-ball hypothesis when applying
`Real.binEntropy_strictAntiOn`, derive positivity at one half with
`Real.binEntropy_pos`, and handle `Real.sqrt` inequalities explicitly. This is
an audit of the theorem statements, not a proof landing; the builder job remains
in flight.

## Full-Fock declaration mismatch: repaired

The earlier review correctly rejected `FullFockPairExponential` as a canonical
result because its generator and evolution were local redeclarations. The new
`CanonicalFullFockPairExponential` module now proves both missing API bridges:

- the explicit sixteen-by-sixteen matrix acts exactly as the canonical
  `PlueckerPairGenerator.Kop` on every occupation coordinate;
- the local cosine-sine closed form is exactly the canonical
  `PlueckerPairGenerator.Uop`.

Composing those bridges with the checked matrix exponential produces the
canonical full-Fock theorem. A separate zero-coupling proof removes the local
theorem's `z != 0` boundary restriction. Verdict: **the declaration-mismatch
finding is closed**. The result remains a finite identity for a supplied
generator and does not close the energy-constrained state-selection target.

## Operator-S2 capstone re-audit: accepted at the stated scope

Artifact: `PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean`

Verdict: **accepted for the displayed qubit/Bloch parameterization.** The
repaired five-conjunct theorem now contains, rather than merely discusses:

- the von Neumann entropy bound at fixed `sigmaX` expectation;
- equality exactly when the two transverse Bloch coordinates vanish;
- identification of the optimizer with the normalized Gibbs state of the
  canonical live generator `Bz 1` at `beta = -Real.artanh e`;
- identification of that state with `exp(-modHam)`; and
- the actual `modFlow` equality for every real time and every `2x2` observable.

The hypotheses `|e| < 1` and `e^2 + u^2 + v^2 <= 1` make the target
nonvacuous and keep the Gibbs state away from the singular pure-state boundary.
The competitor family is not commuting-only: `u` and `v` are arbitrary
transverse coordinates in the closed Bloch ball. The selected state is not
inserted as a hypothesis, and equality does real work by forcing `u = v = 0`.

The repaired module also closes the prose/kernel mismatch identified in the
previous audit. It says explicitly that the theorem is parameterized rather
than an arbitrary-`rho` wrapper, is qubit-only, fixes the complex transfer to
`z = 1`, and does not attach the separate phase-sensitive `Uop` witness to this
flow. Those two useful strengthenings remain successor theorems, but they are
not hidden premises of the capstone now reviewed.

Independent replay:

```text
lake env lean PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean
lake build PhysicsSM.Draft.NullEdge.DYNModularMaxEntCapstone
```

Both commands passed under the pinned toolchain. The in-file axiom guard reports
only `propext`, `Classical.choice`, and `Quot.sound`. No new assumption,
compiler-trust shortcut, vacuous witness, hollow telescope, false shape, or
docstring-overreach was found in the repaired capstone.
