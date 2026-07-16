# Claude review: integrated lateral 3+1 route (7 modules)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-142046, item QCA-3PLUS1-001
- Sources (all `PhysicsSM/Draft/NullEdge/`): `ProjectorConditionedStep` (93),
  `SpinBlindWindingObstruction` (191), `ConditionedShiftIrreducible` (59),
  `FiniteTransportTraceNoGo` (68), `BoundaryTransportIndex` (242),
  `ReflectingCycleControl` (97), `WeylSphereChargeBridge` (314). All 0 sorry,
  0 `native_decide`, 0 `axiom`/`opaque`/`admit` (scanned).
- Checks: vacuity, false shape, prose-vs-kernel, finite-vs-half-space overclaim,
  conditional degree/Chern boundary. W=1 / bulk-edge NOT claimed (confirmed).
- Date: 2026-07-13

## Verdict: ACCEPT (all 7 semantically sound + honestly scoped) with ONE required landing-hygiene fix

Every module is correct, non-vacuous, false-shape-free, and respects the
finite/conditional boundaries; the scoping is uniformly honest and W=1/bulk-edge
are correctly withheld. The single required change before any FLAGSHIP landing:
**5 of 7 modules lack build-enforced axiom guards** (details in the last section).
Content needs no change; the guards are an enforcement gap, not a correctness gap.

## Per-module findings (all 5 checks)

### SpinBlindWindingObstruction (my L9) - EXEMPLARY, properly guarded
`antisymCubic_scalar`: the antisymmetrized cubic `Σ ε^{ijk} R_i R_j R_k` vanishes
for scalar `R_j = c_j•1`; specialized to `R_j = -i m_j•1` (both real and integer
`m`) = the spin-blind `U=exp(-ik·m)W₀` obstruction. Vacuity KILLED by the
noncommuting Pauli control (`trace_antisymCubic_pauli = 12i ≠ 0`), proving the
obstruction is about spin-blind commutativity, not a trivial definition. Scope
docstring is textbook (ASSUMES the scalar log-derivative form; disclaims the
integral/degree/`W=1`; scoped to the spin-blind alphabet). 5 proper
`#guard_msgs (whitespace := lax) in #print axioms`, all standard-three. Flagship-grade.

### WeylSphereChargeBridge (my AF4) - EXEMPLARY conditional bridge, MISSING guards
`deg_eq_chirality` reduces `deg A = sign(det A)` from an abstract `deg` under the
GENUINE degree axioms (normalization + homotopy invariance across the two
`det`-sign components), NOT from the conclusion. `chirality_isDegreeModel` proves
`sign∘det` itself satisfies all four axioms -> the reduction is NON-VACUOUS and
pins the unique invariant. Chern kept separate (`chern_eq_chirality`), linked
ONLY via the explicit `chern_eq_deg` hypothesis, "never by prose." Docstring is
scrupulous that Mathlib v4.28 has no Brouwer-degree/Chern API and the missing
piece is the EXISTENCE of `deg`. This is exactly the requested "conditional
degree/Chern boundary," handled impeccably (T|H). Only gap: 0 axiom guards.

### ConditionedShiftIrreducible (my BB irreducibility) - correct, bare-print guards
`no_fixed_coin_factorization`: for a projector `P≠1`, no fixed coin `C` gives
`z•C = z•P+(1-P)` at BOTH `z=±1` (forces `C=1` and `C=2P-1` => `P=1`). Faithful
to "a scalar shift × one fixed coin cannot reproduce the conditioned shift in the
0 AND π sectors." Non-vacuous (`selected = diag(1,0) ≠ 1` explicit witness).
Honestly scoped (does not exclude multi-step/momentum-dependent/extra-register).
GUARD NIT: lines 55-57 are BARE `#print axioms` (no `#guard_msgs`); the comment
"Standard axiom guards" is a misnomer - they print, they do not enforce.

### BoundaryTransportIndex (my BB1, sharpened) - correct no-go, MISSING guards
`netFlow_eq_zero`: for EVERY finite permutation and EVERY cut, the finite
boundary-transport index `netFlow = (crossings in) - (crossings out) = 0` (a
bijection preserves complement size). Non-vacuous: `crossingsIn_pos`/`crossingsOut_pos`
show the crossings are individually positive (they balance, not absent);
`bareReflectingShift_netFlow_eq_zero` is the concrete BB1 transport-0 control.
Correctly names the HALF-SPACE Fredholm/GNVW flow index as the real object - so
"finite-vs-half-space" is handled by PROVING the finite index trivial and naming
the half-space one missing. This sharpens my BB: the finite transport index
cannot be the bulk-edge invariant. 0 guards.

### ReflectingCycleControl (my BB1 cycle) - correct, MISSING guards
`orbitIndex_bijective` + `orbitIndex_step` + `step_full_period`: the bare
reflecting update is conjugate to `+1` on a single `2(N+1)`-cycle - PROVING the
claim underpinning my transport-0 control. Non-vacuous (`two_site_orbit_witness`).
0 guards.

### FiniteTransportTraceNoGo - correct no-go, bare-print guards
`globalCutFlow_zero`: `Tr(U*PU - P) = 0` for every exactly-unitary finite matrix
(trace cyclicity). Non-vacuous: `swap_local_flow_witness` (the LOCAL flow is
nonzero) vs `swap_global_flow_zero`. Correctly names local / infinite-volume as
where a nonzero index can live. GUARD NIT: 4 BARE `#print axioms` (no `#guard_msgs`).

### ProjectorConditionedStep - clean, properly guarded
`conditionedStep_unitary`: `z•P + (1-P)` is unitary for a phase `z` and
projection `P`. Docstring honest ("does not call the held sector a null
translation"). 5 proper `#guard_msgs`. Clean building block.

## The one required fix: build-enforced axiom guards on 5 of 7

Per the project convention (flagship draft results carry a build-enforced
`#guard_msgs ... in #print axioms` pin), before any flagship landing:
- **Wrap the bare prints** in `ConditionedShiftIrreducible` (lines 55-57) and
  `FiniteTransportTraceNoGo` (its 4 `#print axioms`) with
  `#guard_msgs (whitespace := lax) in` and the expected `[propext,
  Classical.choice, Quot.sound]` message.
- **Add guards** to `BoundaryTransportIndex`, `ReflectingCycleControl`, and
  `WeylSphereChargeBridge` (currently none) on their public theorems.
This is enforcement only: all 7 are confirmed free of `sorry`/`native_decide`/
`axiom`/`opaque`/`admit`, so the footprint IS the standard three - it is simply
not yet PINNED. Acceptable for draft-trust; required for flagship.

## Independent build/replay footprint

`lake env lean` on all 7 source files: **every one EXITCODE=0**, with no `error:`,
no `#guard_msgs` mismatch, and no `declaration uses sorry` in any. So the 2
properly-guarded modules (`ProjectorConditionedStep`, `SpinBlindWindingObstruction`)
had their guards MATCH the standard three, and all 7 elaborate clean. Combined
with the source scan (0 `sorry` / 0 `native_decide` / 0 `axiom`/`opaque`/`admit`
across all 7), the entire tranche is kernel-clean at `[propext, Classical.choice,
Quot.sound]` - the 5 unguarded modules simply do not yet PIN that footprint with a
`#guard_msgs` block.

## Bottom line

The lateral-route tranche is a clean, honest set of finite/conditional results
that correctly withholds the flagship claims (`W=1`, bulk-edge). `SpinBlindWindingObstruction`
(L9) and `WeylSphereChargeBridge` (conditional AF4) are exemplary; the transport
no-gos (`BoundaryTransportIndex`, `FiniteTransportTraceNoGo`) sharpen my BB ladder
by proving the FINITE transport index is trivially zero and naming the half-space
GNVW index as the real object. ACCEPT for draft-trust banking; add the missing
guards before flagship.
