# Summary of changes for run 9eb716ed-38d1-4579-b70b-047e0a08560e
## FUR-H2 — Can Furey/Krasnov complex-structure data discharge `chi_E`?

**Answer: No.** The Furey/Krasnov datum ("right multiplication by `e111` acts as multiplication by `i`") is a **complex structure** `J` with `J² = −1`, whereas `chi_E` is a **Z/2 grading / involution** with `χ² = +1`. They are different invariants; a complex structure cannot serve as `chi_E`, and the project itself already lists `Gamma_s, chi_E, J` as three separate decorations.

### Deliverables
- **`PhysicsSM/Draft/NullEdgeFureyChiE.lean`** — a self-contained Lean module (imports Mathlib only, **no `sorry`**, 12 proved theorems, audited axioms `propext`/`Classical.choice`/`Quot.sound`). It builds independently via `lake build PhysicsSM.Draft.NullEdgeFureyChiE`. It formalizes:
  - `complexStructure_not_grading` / `complexStructure_ne_grading` — a complex structure (`J²=−1`) is never, and never equals, a Z/2 grading (`χ²=+1`) whenever `(1:A) ≠ −1`. This is the formal "do not conflate `×i` with a chirality grading."
  - `grading_of_complexStructure_mul_central` — the only clean way to make an involution from `J` is to twist it by a *second, commuting* square-root of `−1`: `(i·J)² = +1`. This isolates the extra data required.
  - `complexStructure_self_mul_is_trivial` — on the ideal the Krasnov identification makes `i = J`, so the twist degenerates to `−1` (the trivial central involution, grading nothing).
  - `central_cannot_be_internal_grading` / `central_invertible_odd_block_zero` — since `×i` acts as the central scalar `i`, it commutes with everything and so can never make a nonzero `Phi_H` odd, whereas `chi_E` is *defined* by `{chi_E, Phi_H}=0`.
  - `sign_bridge_with_grading` / `complexStructure_cannot_fill_grading_slot` — the Gate A sign dichotomy (`+Phi_H²` with the commuting `Gamma_s`, `−Phi_H²` with the odd `chi_E`); the grading slot must be an involution, so a complex structure can play neither `Gamma_s` nor `chi_E`.
  - Non-vacuity witnesses in `ℂ`.
- **`Sources/FUR_H2_chiE_report.md`** — a precise report covering all five task items: an inventory of the existing definitions, the classification table, the bridge theorem statements, the explicit `chi_E`/`Phi_H`/Gate-A interaction, the `Gamma_s`/`chi_E`/`J`/degree separation guardrail, and the list of missing APIs.

### Key conclusions
1–2. Existing data: the Furey files define `omega = (1−i·e111)/2`, `omega_bar`, the ladder/number operators, but **no** grading/involution on `J`; the complex structure exists only in prose. `NullEdgeInternalSpectrum.grading` (`InternalGrading = even | odd`) is the `chi_E` Z/2 label.
4. The Krasnov datum is a complex structure, **not** a grading, and **not both** — no theorem converts one into the other naively, and the only conversion needs extra commuting-`i` data that degenerates on `J`.
3+5. The correct, separate source of `chi_E` is the number-operator parity `(−1)^(N1+N2+N3)` (equivalently the `omega`/`omega_bar`, particle/antiparticle, L/R reflection): a genuine non-central involution that anticommutes with `Phi_H`. The complex structure instead feeds the central `i` of the `i·D_N` term.

### Build situation
A bridge module *referencing* the real `J`/`grading` objects cannot compile in this delivered subset, because the foundational files those context files import (`ComplexOctonion`, `LadderOperators`, `AnomalyPackage`, the `NullEdgeSuperDirac*`/`NullEdgeFiniteTetradPostulate` files) are absent. The abstract module is written so every symbol maps to a named repository object; the report lists the four missing formal APIs (a formal `rightMulE111` with square `−1`; its identification with `×i`; the number-parity involution `chiN`; and `{chiN, Phi_H}=0`) whose addition would let the abstract theorems transport verbatim to the concrete ideal.
