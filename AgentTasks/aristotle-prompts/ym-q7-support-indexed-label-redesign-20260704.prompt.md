# Aristotle proof/design job: Q7 support-indexed plaquette polymer labels

You are acting as a Lean formalization partner.  Please produce a complete
Lean patch, not only an audit, for
`PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`.

Formatting: ASCII only, LF line endings.  In prose, spell Lean escape-hatch
tokens with spaces (`s o r r y`, `a x i o m`, `a d m i t`, `o p a q u e`).

## Project context

This is Q7 of a four-day Yang-Mills / mass-gap run.  Q7 maps finite
strong-coupling plaquette polymers into the Q6 abstract polymer system:

- `PolymerKPCriterion.PolymerSystem Gamma`
- `PolymerKPCriterion.KPCondition`
- `PolymerKPConclusion.Cluster`
- `PolymerKPConclusion.spanningTreeCount`
- `PolymerKPConclusion.ursellSum`

The current Q7 file already builds and is wired into the project aggregator.
It is a draft statement/definition layer only.  It does not claim a
volume-uniform KP theorem.

Prior Aristotle audit `52f42dd5` returned ACCEPT WITH CHANGES.  The safe P1
patch is already integrated:

- `SupportsOverlap.orTouch`
- `SupportsTouch.orTouch`
- `plaquettePolymerSystem_weight_nonneg`
- `tanh_nonneg_of_nonneg`
- `z2_plaquettePolymer_weight_eq_tanh_area`

The remaining P2 blocker is semantic: the current `PlaquettePolymer` uses a
total function `P -> Rlab` constrained only on the support.  Thus off-support
labels create distinct Lean values representing the same physical polymer.
That is harmless for the current wrappers, but it would inflate any future
`KPCondition` sum by a volume-dependent factor.  We need a support-indexed
label carrier before any KP instantiation.

## Target command

Please make this command pass:

```bash
lake env lean PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
```

Do not ask for a full project build first.

## Required patch

Modify `StrongCouplingPolymerMap.lean` so that `PlaquettePolymer` has physical
identity:

1. Replace the total off-support label carrier with support-indexed labels.
   A good shape is either:

   ```lean
   structure PlaquettePolymer ... where
     support : Finset P
     support_nonempty : support.Nonempty
     support_connected : ConnectedSupport support
     label : {p : P // p in support} -> Rlab
     label_nontrivial :
       forall p : {p : P // p in support}, NontrivialLabel (label p)
   ```

   or an equivalent Sigma/subtype encoding if it gives better Lean
   extensionality/Fintype behavior.

2. Preserve or minimally adapt these public names:

   - `PlaquettePolymer.support`
   - `PlaquettePolymer.label`
   - `PlaquettePolymer.support_nonempty`
   - `PlaquettePolymer.support_connected`
   - `PlaquettePolymer.label_nontrivial`
   - `PlaquettePolymer.coeffProduct`
   - `PlaquettePolymer.coeffProduct_nonneg`
   - `SupportsOverlap`, `SupportsTouch`, `SupportsOverlapOrTouch`
   - `plaquettePolymerSystem`
   - all existing wrapper theorems and Z2 specialization theorems

   It is acceptable if `label` now takes a membership proof, e.g.
   `X.label p hp`; update `coeffProduct` and all theorem proofs accordingly.

3. Add a physical extensionality theorem, for example:

   ```lean
   theorem PlaquettePolymer.ext_of_support_label
       {X Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel}
       (hs : X.support = Y.support)
       (hl : forall p (hpX : p in X.support) (hpY : p in Y.support),
          X.label p hpX = Y.label p hpY) :
       X = Y
   ```

   Adjust the exact statement if your encoding needs a cleaner theorem.

4. Add decidability support needed before Q6/Q8 can state KP on this system:

   ```lean
   instance SupportsOverlap.instDecidable ...
   instance SupportsTouch.instDecidable ...
   instance SupportsOverlapOrTouch.instDecidable ...
   ```

   The intended hypotheses are `Fintype P`, `DecidableEq P`, and
   `[DecidableRel Adj.touch]` for the touch relation.

5. Do NOT prove a volume-uniform `KPCondition` from beta/alpha.  If you add any
   KP-related theorem, it must carry the finite KP sum bound as an explicit
   hypothesis and be clearly named as a restatement.  This is optional; the
   required deliverable is the label-carrier redesign plus decidability.

## Success criteria

- The target file builds with no new executable proof placeholders.
- No new `a x i o m`, `o p a q u e`, or u n s a f e code.
- Existing theorem names remain where practical; if a name must change, explain
  why in `ARISTOTLE_SUMMARY.md`.
- The redesigned type does not count off-support labels.
- The summary explicitly lists any changed theorem statements and any remaining
  Q7/Q8 blockers.

## Output

Return the edited project, especially:

- `PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`
- `ARISTOTLE_SUMMARY.md`

This is a finite draft GateYM statement-layer job, not a continuum mass-gap
claim.
