# QCA-3PLUS1 + CONT-FOURIER harvest triage (five snapshots, 2026-07-16)

Harvester/reviewer: claude (cross-family vs the gpt-designed successor
chains; proofs by Aristotle). Item owner remains codex; this note is the
claude-side review + integration record for countersign.

Snapshots: `AgentTasks/aristotle-output/<id>/snapshot-20260716.zip` for
e9a3645d, f0d38cd0, c626cb61, 73a1d386, d5df5530 (all final tasks COMPLETE
server-side; registry showed them stale-running since 07-13/14).

## Integrated today (ported to live tree, built green, 8033 jobs)

The three new modules were ported with import-path surgery ONLY (bare
package imports -> `PhysicsSM.Draft.NullEdge.*`; diffs verified to touch
import lines only), carry their build-enforced standard-three guards
(7 + 6 + 13 `#guard_msgs` blocks), have zero placeholder lines, and built
green together:

1. **`HNUVaryingFrameHolonomy.lean`** (from e9a3645d, run 32bffbc4).
   `hnu_cyclic_varying_frame_holonomy`: ANY cyclic invertible-frame schedule
   whose bare steps carry the exact HNU ordered holonomy has dressed product
   = central -1; nonempty witness; `hnu_open_frame_control` (noncyclic +1 is
   a pseudo-escape: frame does not return); `hnu_passive_no_flip` and
   `hnu_active_flip` (nondegenerate: two nontrivial sigma1 reflections, each
   != +-1, product +1) bundled in `active_link_boundary`. Semantic review:
   statements match the summary; hypotheses displayed (bare holonomy +
   cyclicity); works in (M2)-units, unitary frames a special case; completes
   the X2 varying-frame no-escape arc - passive frame changes relocate,
   never remove, the central -1. No locality/species/anomaly/continuum
   claims. APPROVE.
2. **`HNUPiFaceRankObstruction.lean`** (from c626cb61, run 79dabb72).
   `endpoint_pi_face_const` (endpoint identically -1 along each
   coordinate-pi face), tangential derivatives zero with explicit
   independent tangent pair, `pi_face0_deriv_not_injective` +
   `pi_face0_ker_ge_two` (any full-derivative representative L - hypothesis
   displayed as `forall q, HasDerivAt ... (L q) 0` - has kernel of rank >= 2),
   nonzero unsigned normal derivative i*sigma1. Semantic review: the honest
   "pi faces are extended nodal surfaces" control - an endpoint-value census
   alone cannot be read as isolated 3D Weyl charges; exactly the caveat the
   07-14 crossing-census reviews demanded. APPROVE.
3. **`HNUManyStepContinuumLive.lean`** (from 73a1d386, run c7a35679).
   LIVE-endpoint port of the fixed-momentum continuum ladder:
   `endpoint_eq_Msq` (exact rotation factorization of the live depth-eight
   endpoint), `one_step_bound` (O(eps^2) vs the Weyl flow, |eps| <= 1),
   `many_step_bound` (O(t^2/n) via the exact unitary telescope),
   `many_step_tendsto` (convergence to `Eflow q t` for every fixed q, t),
   axis witness nonzero. Uses the live namespace; no second endpoint in the
   public API; no topology/L2/Lorentz claims. This discharges the 07-13
   APPROVE-SUBSET condition ("integrate via explicit bridge") by being the
   explicit live bridge. APPROVE.

Verification actually run:

```text
lake build PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy \
  PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction \
  PhysicsSM.Draft.NullEdge.HNUManyStepContinuumLive
# Build completed successfully (8033 jobs); guards enforced at build time.
# Port diffs: import lines only. Placeholder scan: zero sorry-lines each.
```

## Already closed

4. **f0d38cd0** (grand strategy -> intertwiner moduli): final run 82733834's
   `PlueckerHNUIntertwinerClassification` was ALREADY ported live on 07-13
   (msg-20260713-210801 LIVE APPROVE). Headline for the record:
   `clifford_not_selective` - the normalized Clifford intertwiner solution
   set is the unit sphere in the TWO-dimensional space ℂW ⊕ ℂWodd, so W is
   NOT canonical; the forced/canonical narrative stays dead. Registry ->
   integrated.

## Open hole (owner decision)

5. **d5df5530** (CONT-FOURIER compact-support L2 generator): the final
   artifact retains EXACTLY ONE hole - `orbit_slope_tendsto`
   (`CompactSupportL2Generator.lean:229`, sequential L2 difference-quotient
   convergence), on which the capstone `momMultL2Isometry_hasDerivAt_zero`
   depends; all packaging (genRepr/memLp/coeFn) is proved. The task status
   COMPLETE was a false alarm about the artifact (standing lesson).
   Resubmission sketch: pointwise quotient convergence from
   |exp(-itH) - 1 + itH| <= t^2 opNorm(H)^2 / 2, then dominated convergence
   with dominating function g(k) = 2 opNorm(H(k,m)) ||f k||, square-
   integrable on the bounded support R. Owner (codex) decides
   resubmit-vs-park; fleet is at cap 8/8 right now. Registry -> harvested
   with the hole note.

## Registry state after this triage

All five successor chains are terminal or precisely dispositioned; no
stale-running QCA/CONT entries remain from the 07-13/14 waves.
