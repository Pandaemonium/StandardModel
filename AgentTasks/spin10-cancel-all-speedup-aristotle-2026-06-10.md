# Aristotle task: speed up the Fierz kernel enumeration

Date: 2026-06-10

## Goal

Reduce the compile cost of the trusted theorem `cancel_all` in

```text
PhysicsSM/Spinor/SpinorTenfoldFierzKernel.lean
```

Currently it is proved by a single kernel `decide` over all `32^3` triples
(`maxHeartbeats 4000000`, `maxRecDepth 10000`) and takes roughly 7 minutes of
wall-clock time on a clean rebuild of the module. Target: the module builds
in well under one minute, with the **same theorem statements** exported
(`cancel_all`, or at minimum `fierzZ_three` with `cancel_all` allowed to be
refactored/renamed if `fierzZ_three` and everything downstream keeps
compiling unchanged).

## Status quo

`termData S T U` is a closed-form single signed monomial for
`cliffordActionZ (gBasisZ S T) (basisZ U)` (`termData_eq`), and `cancel3` is
the three-way cancellation predicate on the `(coeff, target)` data.
`cancel_all` checks `cancel3 (termData S T U) (termData S U T) (termData T U S)`
for all even triples by brute-force `decide`.

## Suggested routes

1. **Structural case analysis** (preferred). `termData S T U` is nonzero
   only when the cardinalities match: the `a`-half needs `|S| + |T| = 6`
   with the active index `i` the unique element of `S \ Tᶜ` and `i ∉ U`;
   the `b`-half needs `|S| + |T| = 4` with `i ∈ U`. Classify which of the
   three terms can be active for a given even triple and prove the pairwise
   sign cancellations as explicit `opSignZ`/`chevSignZ` lemmas (the sign
   bookkeeping helpers in `PhysicsSM/Spinor/SpinorTenfoldCAR.lean` —
   `belowCount_erase_of_lt` etc. — and the structural proofs in
   `SpinorTenfoldGammaSymm.lean` are the model). This eliminates the
   enumeration entirely and documents why the signs cancel.
2. **Stratified/cheaper enumeration**. Restrict the decided statement to the
   support configurations (e.g. quantify over the active index and the small
   intersection data instead of raw triples), bringing the kernel check down
   to thousands of cheap cases; derive `cancel_all` from it structurally.
   Plain kernel `decide` is fine; the point is to shrink what is decided.

A hybrid (case analysis down to a few small `decide`s) is acceptable.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- The exported theorems `fierzZ_three` and (transitively)
  `PhysicsSM.Spinor.SpinorTenfoldFierz.fierz_clifford` must keep compiling
  with unchanged statements.
- Do not change the definitions `gBasisZ`, `termData`, `cliffordActionZ`, or
  any sign convention. (Adding new helper definitions is fine.)

## Verification

```bash
lake build PhysicsSM.Spinor.SpinorTenfoldFierzKernel
lake build PhysicsSM.Spinor.SpinorTenfoldFierz
```

and confirm the build time of the first command. Axiom check:

```lean
#print axioms PhysicsSM.Spinor.SpinorTenfold.fierzZ_three
-- must show only [propext, Classical.choice, Quot.sound]
```

## Submission

Status: COMPLETE. Integrated 2026-06-10.

Result: `cancel_all` is now derived (statement unchanged) from a kernel
`decide` over a `Nat` bit-mask mirror (`Fz.cancelAllN`, the 16^3 even
codes with native integer arithmetic), transported back through the
encoding `enc32`/`dec32` via small per-operation `decide` bridges. Module
clean-build time dropped from ~7 minutes to ~30 seconds. `fierzZ_three`
and `fierz_clifford` unchanged; axiom check still
`[propext, Classical.choice, Quot.sound]` only. No `native_decide`.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave4-20260610
```

Job ID:

```text
1bca1a38-8f7e-4e61-ad1a-13e5f7277d2d
```
