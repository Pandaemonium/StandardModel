# Task: Spin(10) pure-spinor Selector Theorem chain (S1 transitivity -> S4 selector)

Project: Lean 4 (v4.28.0) + Mathlib. Spin(10) stabilizer program:
Standard-Model gauge group selected as the stabilizer of a Krasnov pair of
pure spinors inside the even Clifford group of the tenfold spinor space.
Self-contained package (27 modules: the trusted SpinorTenfold Clifford/CAR/
purity tree, the Jordan/projective layer, the SM gauge-subgroup layer, and
the three draft stabilizer files).

## Targets (priority ladder; partial success is success)

1. `Spin10StabilizerTransitivity.evenCliffordGroup_transitive_on_krasnov_pairs`
   (Lemma S1): the even Clifford group acts transitively on collinear
   pure-spinor pairs.  This is the load-bearing orbit theorem.  Route
   suggestion: reduce to the basis pair via the landed
   `SpinorTenfoldBasisOrbit` machinery (Witt-extension style: move the
   first pure spinor to the vacuum spinor with the landed orbit lemmas,
   then use the stabilizer-of-the-first action on the second; the
   orthogonality hypothesis controls the intersection dimension).
2. The single hole in `Spin10StabilizerIsomorphism` (open the file; it is
   the stabilizer-to-SM-group isomorphism layer feeding S4).
3. `Spin10StabilizerSelector.physical_embedding_selected_by_krasnov_pair`
   (Corollary S4): the selector - a subgroup isomorphic to the SM gauge
   group is a Krasnov-pair stabilizer iff it is conjugate to the standard
   one.  Uses 1-2.
4. If time remains: the single hole in
   `ExceptionalJordanProjectiveGeometry` (supporting layer).

## Honesty protocol (pre-registered)

- Statements must NOT be weakened.  If a statement is false as given
  (e.g. transitivity needs an extra nondegeneracy or dimension hypothesis),
  prove the corrected statement with the minimal explicit added hypothesis,
  rename it, and record the change prominently - then continue the ladder
  with the corrected version.
- A counterexample to any stated target is a first-class outcome; report
  it prominently with the witness.
- If a target resists proof, return a precise proof-plan report: the exact
  sub-lemmas missing (with suggested statements), which landed lemmas were
  useful, and the recommended decomposition for a follow-up job.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the trusted (non-Draft) modules.
- Verify each target file with `lake env lean <file>` first; avoid a full
  `lake build` until holes are closed.

## Success criteria

S1 proven (or honestly corrected + proven) is the primary success; each
additional rung is a bonus.  Completion report: solved targets, statement
changes, remaining holes with proof plans, axioms used.
