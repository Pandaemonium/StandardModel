# Red-team report: L0-BOOST-001

- Claim: `no_finite_forward_invariant_support` -- no finite momentum support
  containing the future unit-timelike vector `(1,0)` is forward-invariant under
  the exact rational 3-4-5 Lorentz boost.
- Builder: codex (research_scientist, NE-LORENTZ)
- Skeptic: claude (cross-family; Claude-family reviewing a Codex-family build)
- Date: 2026-07-12
- Artifact: `PhysicsSM/Draft/NullEdge/L0FiniteSupportBoostNoGo.lean`

## Verdict: CO-SIGN (confirm) as grade M, SRL 4, kernel-clean.

Genuine finite-support obstruction; scoping is exemplary.

## Audit points (as requested)

1. **Conventions vs `Goal3BoostCovRational` -- CONSISTENT.** `Boost c s =
   !![c,s;s,c]`, `Q v = v0^2 - v1^2` (Minkowski), `Lam = Boost (5/3) (4/3)`.
   Checked `c^2 - s^2 = 25/9 - 16/9 = 1`, so `Lam` is a genuine Lorentz boost
   preserving `Q` (`boost_preserves_Q`), not an arbitrary expanding map. The
   `t+x` tripling is exactly `(c+s) = 3` (and `t-x` scales by `c-s = 1/3`, so
   `Q` is preserved). No convention drift.
2. **Forward invariance sufficient; finiteness essential.** `ForwardInvariant S
   = ∀ v ∈ S, boostVec v ∈ S`. The proof puts the whole infinite orbit inside
   `S` and contradicts `S.finite_toSet`. Finiteness is load-bearing.
   Forward-only (not two-sided) invariance makes the no-go STRONGER, not weaker.
3. **Witness genuine.** `restVec_control`: `(1,0) ≠ 0`, `0 < (1,0).0`
   (future-directed), `Q (1,0) = 1` (unit timelike). PASS.
4. **Controls genuine and load-bearing.** `zero_singleton_forwardInvariant`:
   `{0}` IS forward-invariant, so the nonzero-witness hypothesis is essential
   (without it a finite invariant set exists). `identity_preserves_every_
   finite_support`: the identity preserves every finite `S`, so noncompactness
   of the boost is essential. Both controls directly block the natural
   overgeneralizations.
5. **No vacuity / false shape / hidden trust.** Orbit is genuinely infinite
   (`orbit_injective` via `nullPlus_orbit = 3^n` + `pow_three_strictMono`);
   footprint `[propext, Classical.choice, Quot.sound]`, guard-pinned, so no
   `sorry`/`native_decide` in the chain.
6. **Scope enforced -- this is the load-bearing check.** The theorem is a
   FIXED-finite-support obstruction under ONE noncompact boost. The docstring
   explicitly disclaims disproving Lorentz invariance in distribution,
   establishing Bombelli-Henson-Sorkin, or constructing a Lorentz-invariant
   decorated ensemble. This is exactly the L0 framing (fixed lattices are
   regulators; invariance-in-distribution is the separate open goal). No
   over-claim.

## Over-claim audit (ten modes): all clear.

vacuity NO; hollow telescoping NO; docstring-outruns-kernel NO (docstring is
more conservative than the theorem); false shape NO (`Lam` is a verified
Lorentz boost); convention drift NO (verified against source); source
laundering N/A; **finite-to-continuum slippage NO** (explicitly a finite
obstruction, continuum/distributional invariance kept separate and open);
fitted/predicted N/A; common-origin N/A; arithmetic-as-dynamics N/A.

## Notes (non-defects)

- The no-go is per-single-boost (indeed per-single-orbit), which is the minimal
  and sufficient witness that a finite support cannot be boost-invariant; the
  file correctly does not claim the full Lorentz group. A two-sided-invariance
  version is an immediate corollary (forward-only is already stronger).
- SRL 4 proposed: nondegenerate finite model with genuine controls and a formal
  proof. It is a clean no-go, not merely a toy calculation (SRL 3), because of
  the injective-orbit content and the two load-bearing controls.

## Disposition

Independence gate SATISFIED for L0-BOOST-001 (Codex build, Claude-family
skeptic). Codex may advance NE-LORENTZ per the writer lane. Recommend the same
clean-context REPLICATING pass (an agent that neither built nor audited) before
INTEGRATED, and keep the positive Lorentz-in-distribution theorem a separate,
still-open target.
