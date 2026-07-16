# Claude review: ExactFlowGeneratorAllTime (repaired)

- Reviewer: interactive Claude Code (claude family)
- Source: `PhysicsSM/Draft/NullEdge/ExactFlowGeneratorAllTime.lean` (67 lines),
  sha 4a9f8be5... verified
- Date: 2026-07-13

## Verdict: ACCEPT

Strengthens the zero-time pointwise generator to all times via Codex's
composition repair (the Aristotle direct proof did not replay). Sound proof,
correct orientation/sign, strictly pointwise scope.

## The repaired proof (sound)

`momMult_apply_hasDerivAt`: `HasDerivAt (fun s => momMult m s k v)
(momMult m t k (toEuclideanCLM (fibreGenerator k m) v)) t`. Construction:

1. `hzero` = the accepted `momMult_apply_hasDerivAt_zero` (derivative at `0` is
   `G v`, `G = toEuclideanCLM(-i H)`).
2. Chain-rule the R-restricted CLM `T = momMult m t k` onto `hzero`
   (`(T.hasFDerivAt).comp_hasDerivAt 0`): derivative of `s |-> T(momMult m s k v)`
   at `0` is `T (G v) = momMult m t k (G v)`.
3. `ExactFlowL2GroupCapstone.momMult_add_time` (the accepted group law
   `U(t+s)=U(t)U(s)`) rewrites `T(momMult m s k v) = momMult m (t+s) k v`, giving
   the derivative of `s |-> momMult m (t+s) k v` at `0`.
4. `comp_sub_const t t` translates the time variable (`s |-> s - t`), turning the
   derivative of `s |-> momMult m (t+s) k v` at `0` into the derivative of
   `s |-> momMult m s k v` at `t`.

Each step is a standard, valid calculus/algebra move; the group law is the
load-bearing ingredient that makes the all-time statement follow from the
zero-time one.

## Checks

- **Orientation.** Right-multiplication group orientation `d/dt U(t) v =
  U(t) (G v)` with `G = toEuclideanCLM(-i H(k))` - matches the repository
  convention (`ExactFlowGenerator`) and the docstring. (Since `U(t)=exp(-itH)` and
  `G=-iH` are both functions of `H` they commute, so left/right coincide here; the
  stated form is the right-oriented one.)
- **Sign.** `fibreGenerator = (-I) . H`, so the generator is `-i H`. Correct
  Schroedinger/Dirac sign.
- **Semantic scope - strictly pointwise.** Docstring: "remains pointwise in the
  momentum fibre and spinor. It is not a derivative in the Schwartz topology, a
  derivative of an `L2` equivalence class, a graph-domain theorem, or a
  position-space PDE." Correct - fixed `k`, fixed `v`, all `t`; nothing about
  Schwartz/L2/graph-domain/PDE/lattice.
- **Vacuity / hollow / false shape.** Non-vacuous (extends the nonzero-generator
  `t=0` result; `-i H` carries the mass). Not hollow (the group-law extension is
  genuine content). Correct shape for a one-parameter-group generator.
- **Footprint.** `lake build` exit 0 (8052 jobs); one `#guard_msgs` pins
  `[propext, Classical.choice, Quot.sound]`.

## Narrowest defensible claim

For every fixed momentum `k`, mass `m`, time `t`, and spinor `v`, the exact
Dirac momentum-multiplier orbit `s |-> momMult m s k v` is differentiable at `t`
with derivative `momMult m t k (-i H(k,m) v)` (right-oriented all-time generator).
This is pointwise in the momentum fibre and spinor only; it is not a
Schwartz-topology derivative, an `L2`-class derivative, a graph-domain/closed-
generator statement, a position-space PDE, or a lattice limit.
