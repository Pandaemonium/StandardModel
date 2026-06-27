# Gate A super-Dirac square/sign bridge — closeout report

**Lean-backed deliverable. Job A1 (Wave 8).**

This report accompanies the kernel-checked Lean file
`PhysicsSM__Draft__NullEdgeSuperDiracSignBridge.lean`, which closes the Gate A
super-Dirac **square/sign bridge** that must land *before* any finite-square
theorem is promoted.

## 1. What was missing

The individual Gate A facts were already proved, but in **separate** draft files
with no single theorem connecting the two distinct gradings:

- the abstract sign dichotomy `(Γ_s Φ)² = ±Φ²` lived in
  `PhysicsSM__Draft__NullEdgeSuperDiracSignAudit`
  (`graded_square_comm`, `graded_square_anticomm`, `super_dirac_square_sum`);
- the fact that the off-diagonal internal mass block `Φ_H` is **χ_E-odd** lived
  in `PhysicsSM__Draft__NullEdgeSuperDiracBlockCore`
  (`chirality_anticommutes_offDiagonal`) and
  `PhysicsSM__Draft__NullEdgeSuperDiracProductGradingKrein`
  (`productGrading_anticommutes_internalBlock`).

What linked "`Φ_H` is χ_E-odd" to "the super-Dirac square is `+Φ_H²`" was only
prose.  The bridge theorem package removes that gap.

## 2. The locked safe sign convention

`Φ_H` carries **two distinct gradings that must never be conflated**:

- internal chirality `χ_E`: `Φ_H` is **odd**, `{χ_E, Φ_H} = 0` (it is the
  off-diagonal block `[[0, M†],[M, 0]]` on `L ⊕ R`);
- spacetime chirality `Γ_s`: `Φ_H` is **even**, `[Γ_s, Φ_H] = 0` (it is internal,
  so it commutes with the distinct spacetime chirality that appears in
  `D = i D_N + Γ_s Φ_H`).

Because the mass term in `D` pairs `Φ_H` with the grading it **commutes** with
(`Γ_s`), the super-Dirac square carries the physical `+Φ_H²`.  The sign trap is
exactly the conflation `Γ_s := χ_E`: pairing `Φ_H` with the grading it is **odd**
under flips the mass term to the tachyonic `-Φ_H²`.

## 3. Theorems proved (file `PhysicsSM__Draft__NullEdgeSuperDiracSignBridge.lean`)

All depend only on `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, no
`native_decide`.

| Lean name | Statement | Role |
|---|---|---|
| `super_dirac_sign_bridge` | with distinct `Gs`,`Xe` (each `²=1`), `[Gs,Ph]=0`, `{Xe,Ph}=0`: `(Gs Ph)²=+Ph²` ∧ `(Xe Ph)²=-Ph²` | abstract two-grading package |
| `super_dirac_square_sum_safe` | full finite-sum `+Φ²` square repackaged with the safe convention, plus the `+Ph²`/`-Ph²` dichotomy | promotion-facing full square |
| `gammaS_commutes_internalBlock` | degree grading commutes with any internal block | `Γ_s`-even, concrete |
| `chiE_anticommutes_internalBlock` | chirality grading anticommutes with any internal block | `χ_E`-odd, concrete |
| `gammaS_ne_chiE` | `gammaS ≠ chiE` | the two gradings are genuinely distinct |
| `productGrading_concrete_bridge` | for any internal block `D`: `(gammaS D)²=+D²` ∧ `(chiE D)²=-D²` ∧ `gammaS≠chiE` | concrete realisation on `Deg × Chir` |
| `massBlock_bridge` | explicit nonzero block: `+1` (safe) vs `-1` (conflated), `gammaS≠chiE` | non-vacuous witness (`Φ²=1≠0`) |

Supporting lemmas: `grading_mul_self`, `grading_commutes_of_evenForSign`,
`internalBlock_evenForDegSign`, `internalBlock_oddForChirSign`, `gammaS_sq`,
`chiE_sq`, `massBlock_internalBlock`, `massBlock_sq`.

The strongest pre-existing statement of the intended square was
`SuperDirac.super_dirac_square_sum`; `super_dirac_square_sum_safe` is the bridge
that wraps it together with the explicit χ_E-odd / Γ_s-even convention and the
wrong-convention `-Φ²` companion.

## 4. Imports and convention dependencies

`PhysicsSM__Draft__NullEdgeSuperDiracSignBridge.lean` imports:

- `Mathlib`
- `PhysicsSM__Draft__NullEdgeSuperDiracSignAudit` (sign dichotomy, finite-sum square)
- `PhysicsSM__Draft__NullEdgeSuperDiracBlockCore` (off-diagonal mass block, internal chirality)
- `PhysicsSM__Draft__NullEdgeSuperDiracProductGradingKrein` (product-grading layer: `grading`, `Deg`, `Chir`, `degSign`, `chirSign`, `InternalBlock`, `OddForSign`, `grading_anticommutes_of_oddForSign`)

Convention dependencies (the hypotheses each result carries; none is weakened to
manufacture a sign):

- `Γ_s² = 1`, `χ_E² = 1`;
- `[Γ_s, Φ_H] = 0` (the `+Φ²` guardrail, H4);
- `{χ_E, Φ_H} = 0` (Φ_H is internal-chirality-odd);
- for the full square also (H1)-(H3),(H5) of the sign audit.

## 5. The requested theorem is TRUE (not false)

The package confirms the locked convention; no counterexample to the intended
`+Φ_H²` statement exists once `Γ_s` and `χ_E` are kept distinct.  The
wrong-grading variant (`Γ_s := χ_E`, i.e. pairing `Φ_H` with the grading it is
odd under) is isolated as the explicit tachyonic `-Φ_H²` branch
(`graded_square_anticomm`, the second conjunct of `super_dirac_sign_bridge`, and
`productGrading_concrete_bridge`/`massBlock_bridge`), exactly the M1 sign trap.

## 6. Gate A promotion checklist

- [x] A1 sign theorem + odd companion (`SignAudit`): PROVED.
- [x] A2 wrong-grading / wrong-sign counterexamples (`SignAudit`): PROVED.
- [x] **Square/sign bridge** joining "Φ_H is χ_E-odd" to "square is +Φ_H²" in
  one kernel-facing package (`SignBridge`): PROVED.
- [x] Two gradings (`Γ_s`, `χ_E`) kept formally distinct: `gammaS_ne_chiE`.
- [x] Non-vacuous positive branch witness (`massBlock_bridge`, `Φ²=1≠0`).
- [x] Axiom-clean: `propext`, `Classical.choice`, `Quot.sound` only; no `sorry`,
  no `native_decide` in this file.
- [ ] A3 convention fold-in to `docs/CONVENTIONS.md` (prose lock; outside this
  Lean project tree).
- [ ] Optional: canonical-kinetic-name square `super_dirac_square_named`
  (`-Knull - Cdiamond - Tframe + Φ²`) — deferred; requires a kinetic-normalization
  file (`Knull`/`Cdiamond`/`Tframe`) that is **not present** in this project.

**Verdict.** The Gate A super-Dirac square/sign bridge is closed and
kernel-checked.  Finite-square promotion is unblocked on the sign/grading axis.

## 7. Note on an unrelated pre-existing build failure

`PhysicsSM__Draft__NullEdgeSuperDiracKreinCore.lean` fails to build in the
pristine project because its first line imports a dotted module
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore` that does not exist in this
flat-file layout (the other modules use `PhysicsSM__Draft__…` names).  This is
pre-existing and unrelated to Gate A; it was left untouched.
