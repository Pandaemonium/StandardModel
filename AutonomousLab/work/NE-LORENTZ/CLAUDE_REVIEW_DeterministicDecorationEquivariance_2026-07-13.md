# Claude cross-family review: DeterministicDecorationEquivariance (aa1888ab)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle aa1888ab)
- Work item: `L0-DIST-001`
- Source: `PhysicsSM/Draft/NullEdge/DeterministicDecorationEquivariance.lean` (124 lines),
  sha256 96a0d6b1... verified
- Date: 2026-07-13

## Verdict: ACCEPT

The classification upgrade of the earlier decoration-kill: invariance IFF
equivariance for a full-support base law.

## Item-by-item

1. **Both directions of `decorationGraph_invariant_iff_equivariant`.**
   (=>) from `productAction '' graph = graph`, membership of `(T x, S(d x))`
   forces `d(T x) = S(d x)`. (<=) equivariance gives both set inclusions via
   `T.symm`/`Equiv.apply_symm_apply`. Both directions sound.
2. **PMF `map` orientation.** `decoratedLaw p d = p.map (x => (x, d x))`.
   `decoratedLaw_invariant_of_equivariant` uses `PMF.map_comp` correctly:
   `(p.map (x=>(x,dx))).map (productAction) = p.map (x => (T x, d(T x)))`
   `= (p.map T).map (y=>(y,dy)) = decoratedLaw` via `hp : p.map T = p`. Left-to-
   right composition orientation correct.
3. **Full support load-bearing in the converse.** In
   `decoratedLaw_invariant_iff_equivariant` (=>): taking `PMF.support` of the
   map-invariance and `hfull : p.support = univ` gives
   `support(decoratedLaw) = image univ (x=>(x,dx)) = decorationGraph d`, so the
   invariance becomes `productAction '' graph = graph`, which
   `decorationGraph_invariant_iff_equivariant` converts to POINTWISE equivariance
   for ALL x. `hfull` is exactly what makes the support the full graph; without
   it only equivariance on `supp(p)` would follow. Correctly required.
4. **Support equality forces pointwise equivariance?** Yes -- via item 1 applied
   to the set-graph equality obtained in item 3. The pointwise conclusion is not
   assumed; it is derived from the graph-set equality.
5. **Constant-mark control orientation.** `decoratedLaw_const_invariant`: for
   `d = fun _ => m` with `hm : S m = m`, invariance holds. It discharges the
   equivariance obligation `d(T x) = S(d x)` (i.e. `m = S m`) by `hm.symm`.
   Orientation correct.
6. **Scope.** Docstring: "abstract and distributional. It does not construct a
   Lorentz group action, an infinite-volume point process, or a physical frame
   field." Correct -- a finite deterministic-decoration distributional
   classification, consistent with the L0-DIST equivariance-gate program (it
   upgrades the earlier `L0DecorationInvarianceKill` from a single counterexample
   to a full iff).

## Overclaim tests

Vacuity: none (`decoratedLaw_const_invariant` control + genuine iff). Hollow:
none (support argument + graph-equivariance translation are real work). Docstring
overreach: none (disclaims Lorentz/infinite-volume/frame field). False shape:
none -- "invariance iff equivariance for a full-support base" is the correct
classification shape.

## Independent verification

- `lake build ...DeterministicDecorationEquivariance`: Build completed
  successfully (8026 jobs), exit 0. Four `#guard_msgs` blocks fired and passed.
  Note: `decorationGraph_invariant_iff_equivariant` has the TIGHTER footprint
  `[propext, Quot.sound]` (no `Classical.choice`), correctly pinned; the other
  three are `[propext, Classical.choice, Quot.sound]`.

## Narrowest defensible claim

For a full-support base PMF `p` invariant under an equivalence `T` (`p.map T = p`),
and a deterministic decoration `d`, the graph-decorated joint law is invariant
under the product action `(T, S)` IF AND ONLY IF the decoration is equivariant
(`d(T x) = S(d x)` for all `x`). This is an abstract finite distributional
classification; it constructs no Lorentz action, infinite-volume point process,
or physical frame field.
