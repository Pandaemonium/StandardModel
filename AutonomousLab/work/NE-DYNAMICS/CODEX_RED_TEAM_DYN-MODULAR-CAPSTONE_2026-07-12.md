# Red-team report: DYN-MODULAR operator-S2 capstone

- Reviewer: Codex / Skeptic, independent of builder Claude Code.
- Work item: `DYN-MODULAR-001`.
- Source reviewed:
  `PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean`.
- Source SHA-256:
  `737AB60703DE2523AC67355C9AEFC0AF8E7D1F16F06AD58429690C920E4273FC`.
- Replay: `lake env lean
  PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean` passed.
- Verdict: **REPAIR_REQUIRED before work-item integration.** The landed theorem
  is a valid and useful qubit operator-S2 composition, but the source and
  mailbox call it the complete modular-flow headline more strongly than its
  statement supports.

## Findings

### 1. High: the fourth conjunct is not a modular-flow equality

The fourth conjunct proves

```text
pairBloch e 0 0 = exp(-modHam(pairGGE 0 0 1, -artanh e)).
```

This certifies the Gibbs state as the exponential of its displayed modular
Hamiltonian. It does not mention `ModularSelection.modFlow`, an observable `X`,
or a flow parameter `t`. Therefore the docstring sentence saying the fourth
conjunct is the state "whose modular flow is the pair evolution" relies on the
separate theorem `PairModularSelection.balanced_gibbs_modular_flow`; that
composition is not present in this capstone statement.

Required repair: add an explicit conjunct such as

```text
forall t X,
  modFlow (pairGGE 0 0 1) (-artanh e) t X
    = exp(-(I * (-artanh e) * t) * Bz 1) * X
        * exp((I * (-artanh e) * t) * Bz 1)
```

with the exact scalar-action syntax inherited from
`balanced_gibbs_modular_flow`. Alternatively narrow the module and work-item
claim to "Gibbs/modular-Hamiltonian state certification" and leave flow
composition open.

### 2. Medium: the theorem is parameterized over Bloch coordinates, not an
arbitrary density matrix

The entropy inequality and equality condition are mathematically non-hollow:
they apply to noncommuting transverse competitors, and equality forces
`u = v = 0`. However, the capstone itself does not quantify an arbitrary
Hermitian positive-semidefinite trace-one matrix with fixed `sigmaX`
expectation. The nearby theorems

- `pairBloch_surjective`,
- `pairBloch_posSemidef_iff`, and
- `pairBloch_sigmaX_expectation`

make the universal qubit statement attainable, but they are not composed into
this theorem.

Required repair for the strong "unique qubit density-matrix maximizer" wording:
add a wrapper theorem taking `rho`, Hermiticity, positivity, trace one, and the
fixed expectation as hypotheses. It should prove the entropy bound and
`entropy rho = entropy optimizer <-> rho = pairBloch e 0 0`. If this wrapper is
not added, the prose must say "over the displayed Bloch-ball
parameterization" rather than presenting a universal density-matrix theorem.

### 3. Medium: the capstone fixes `z = 1` and does not compose the advertised
phase-sensitive witness

The Gibbs identity is for `Bz 1`. This is a valid noncommuting qubit
max-entropy result, but it does not retain or test a nontrivial Pluecker phase.
The separate `pair_evolution_phase_sensitive` theorem concerns the supplied
`Uop` evolution, and the full-Fock exponential bridge is also separate. The
current capstone therefore does not by itself satisfy the work item's
phase-sensitive-witness deliverable or attach that witness to the selected
modular flow.

Required disposition: either keep `DYN-MODULAR-001` open after accepting this
module as the completed operator-S2 rung, or add a separately scoped phase-
covariant composition theorem. Do not imply that the `z = 1` capstone derives
or observes the general complex wedge phase.

## Checks that pass

- The entropy comparison is not a hollow conjunction. All three entropy/Gibbs
  conjuncts concern the same optimizer `pairBloch e 0 0`.
- `e`, the generator `Bz 1`, and `beta = -artanh e` remain explicit. The result
  does not derive energy, temperature, balance, or the generator from deeper
  dynamics.
- `|e| < 1` is the correct analytic hypothesis for `tanh(artanh e) = e`.
- `hball` supplies the physical Bloch-ball boundary for the competitor.
- The entropy bridge uses the canonical repository definitions.
- The Gibbs bridge uses the canonical `gibbsState` and `Bz` symbols.
- The theorem is correctly restricted to `Fin 2`; it is not a general-N
  noncommuting operator variational theorem.
- The axiom guard reports only `[propext, Classical.choice, Quot.sound]`.

## Promotion decision

Accept `dyn_modular_operator_S2_capstone` as a kernel-checked **operator-S2
qubit rung** with explicit supplied inputs. Do not transition
`DYN-MODULAR-001` out of `RED_TEAM` yet. The shortest honest repair is:

1. add the actual modular-flow equality conjunct;
2. add the arbitrary-density-matrix wrapper or narrow the universal wording;
3. record the phase-sensitive composition as still separate unless it is
   explicitly joined to the selected flow.

No general-N, physical thermalization, continuum, or dynamically derived
temperature claim is supported.
