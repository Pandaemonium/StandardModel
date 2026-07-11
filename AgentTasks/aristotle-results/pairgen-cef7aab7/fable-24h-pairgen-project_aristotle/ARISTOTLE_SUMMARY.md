# Summary of changes for run ebc42584-4cd7-4a3b-95e9-09fc5e1efc30
Completed the E-lane P3 item: the pair kick as the half-pulse of a Hermitian quartic generator.

## What was delivered

**Fixed the broken build.** The supplied `context/PlueckerQuarticInteraction.lean` imports two upstream modules (`PhysicsSM.Draft.NullEdge.FiniteCARFockBasic` and `PhysicsSM.Spinor.PluckerMass`) that were absent from the project, so nothing compiled. I reconstructed those two modules (clean-room, occupation-basis / Jordan–Wigner sign convention) so the context file compiles verbatim — the context file is imported and left unmodified, and all of its own theorems and `#guard_msgs` axiom guards still pass. I added the two `lean_lib` targets to `lakefile.toml`.

**New deliverable file** `context/PlueckerPairGenerator.lean` (namespace `PhysicsSM.Draft.NullEdge.PlueckerPairGenerator`) proves the full ladder T1–T7:
- T1 `generator_hermitian`, T2 `generator_cubed` (K³ = |z|²K), T3 `group_law` (angle addition, pure algebra), T4 `unitary` (given m²=z·conj z, m>0, c²+s²=1).
- T6 witness (z=3+4i, m=5, (c,s)=(4/5,3/5)): `witness_unitary`, `witness_phase_eq`, and the corrected quarter-pulse identification.
- T7 negative control ((c,s)=(1,1)): `negative_control_value` (=2), `negative_control_input` (=1), `negative_control_not_unitary`.

**Kill condition triggered (reported, not silently patched).** T5 as stated — `Uop 0 1 z m = pairKick (-i z/m)` — is FALSE. The module's `pairKick u` is a Hermitian reflection (reverse amplitude = conjugate of forward), whereas the true quarter pulse `Uop 0 1 z m = -i·Kop z/m` is anti-Hermitian (reverse amplitude = negative conjugate). The exact mismatch is a sign (+i vs −i) in the reverse amplitude, exhibited and proved false in `naive_halfpulse_false`. The corrected, proved identification is that on the pair sector `Uop 0 1 z m = -i • pairKick (z/m)` (`halfpulse_low`, `halfpulse_high`, `halfpulse_off`), with `z/m` a unit phase equal to the module's own `witnessUnitPhase` at the witness. The `|u|=1` sub-claims are proved for both `z/m` and `-i z/m` (`unit_coefficient`, `unit_coefficient_naive`).

**Boundary** (stated in the memo and the file): this does NOT derive the generator from the free walk; Kop remains a supplied coupling. What is established is only the algebraic fact that the pair kick is, up to the global phase i, the exact exponential half-pulse of a finite Hermitian even quartic CAR generator.

**Verification:** the whole project builds with no errors/warnings, no `sorry`/`admit`, no `native_decide`, no added axioms or `@[implemented_by]`. Every headline theorem is checked at build time via `#print axioms`/`#guard_msgs` to depend only on `propext`, `Classical.choice`, `Quot.sound`.

A summary memo with all verified constants is in `MEMO_PlueckerPairGenerator.md`. All changes are committed and pushed.
