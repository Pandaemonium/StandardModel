# Aristotle task: Baez-Huerta octonionic Fierz, stage two

Date: 2026-06-10

## Goal

Fill the documented `sorry`s in

```text
PhysicsSM/Draft/OctonionFierzAristotle.lean
```

This is stage two of the Baez-Huerta program: deriving the `D = 10` Fierz
identity from the division-algebra structure of the octonions, instead of a
finite enumeration.

## Context

The trusted module `PhysicsSM/Algebra/Octonion/SpinorFierz.lean` already
defines the octonionic spinor model (vectors as 2x2 hermitian octonionic
matrices, spinors as octonion pairs) and proves the diagonal 3-psi rule
`fierz_octonionic` and the Clifford relation `clifford_relation_octonionic`.
It also defines the complexified (bioctonionic) model (`COctSpinor`,
`CHermVector`, `octConjC`, `normSqC`, `hermActionC`, `spinorSquareC`).

Useful trusted lemmas:

```text
PhysicsSM/Algebra/Octonion/TrialityCompanions.lean  (cancellation laws)
PhysicsSM/Algebra/Octonion/Conjugation.lean         (conj_mul, conj_conj, ...)
PhysicsSM/Algebra/Octonion/Norm.lean                (normSq_mul, ...)
PhysicsSM/Algebra/Octonion/ComplexOctonion.lean     (bioctonion arithmetic)
```

## Targets, in priority order

1. Polarized real identities: `spinorPairing_comm`, `spinorPairing_self`,
   `spinorSquare_polarization`, `fierz_octonionic_polarized` (the symmetric
   trilinear 3-Psi's rule).
2. Bioctonionic cancellation laws: `octConjC_mul`, `mul_octConjC_self`,
   `mul_octConjC_cancel_right`, `octConjC_mul_cancel_left`,
   `mul_octConjC_cancel_left`.
3. Bioctonionic Clifford relation and Fierz identity:
   `clifford_relation_bioctonionic`, `fierz_bioctonionic`.

If the full list is too large, complete the stages in order and leave clear
handoff notes for the remainder.

## Suggested proof routes

- The house style for octonion identities is coordinate expansion plus
  `ring`: `ext <;> simp [<defs>, normSq] <;> ring` (see the proofs in the
  trusted `SpinorFierz.lean` and `TrialityCompanions.lean`).
- The polarized trilinear identity also follows from the proved diagonal
  case by polarization over `ℝ` (char 0).
- Bioctonionic identities are polynomial identities with integer
  coefficients in the 16 real coordinates (`re`/`im` octonion parts); they
  hold because the real versions hold. Expanding `ComplexOctonion`
  componentwise and finishing with `ring` should work; coordinate simp
  lemmas for `octConjC` and `normSqC` are welcome helpers.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change the definitions in `SpinorFierz.lean`, the octonion
  multiplication convention, or the `ComplexOctonion` arithmetic.
- Do not weaken the theorem statements.

## Verification

```bash
lake build PhysicsSM.Draft.OctonionFierzAristotle
```

## Submission

Status: COMPLETE. All targets proved; promoted to trusted.
Integration: 2026-06-10. Output: Aristotle job `04babfce`.
Trusted module: `PhysicsSM/Algebra/Octonion/SpinorFierzPolarized.lean`
(namespace `PhysicsSM.Algebra.Octonion`).
Axioms verified: `[propext, Classical.choice, Quot.sound]` only.
Draft `PhysicsSM/Draft/OctonionFierzAristotle.lean` kept as historical record.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave4-20260610
```

Job ID:

```text
04babfce-16a7-4827-a4da-a7b298d71cca
```
