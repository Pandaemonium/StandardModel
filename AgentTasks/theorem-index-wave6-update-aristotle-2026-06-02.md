# Aristotle task: Paper theorem index wave-6 update

**Agent**: Aristotle
**Status**: Submitted
**Priority**: Urgent
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `47d9b960-feda-4b14-84d3-fbc4bad7aa66`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260602`
**Output**: `AgentTasks/aristotle-output/theorem-index-wave6-20260602`

## Result inspection

Status: OUT_OF_BUDGET, inspected 2026-06-04.

Downloaded output archive:
`AgentTasks/aristotle-output/47d9b960-output`

Extracted output:
`AgentTasks/aristotle-output/47d9b960-output-extracted/paper-wave6-20260602_aristotle`

The output includes useful index ideas, but its
`PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean` is stale relative to the
live repository: it removes later integrated fields and imports, including the
electroweak complete package, complement Jordan bimodule, standard-B Lie
subalgebra package, and true-product quotient work. It also imports
`PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv`, which is currently not a
clean dependency in the live tree.

No bulk merge was performed. Follow-up should be a safe theorem-index refresh
that preserves every existing live field and avoids the broken Z6-equivalence
dependency until that module is repaired.
**Type**: Editorial — add wave-5 results to the paper-facing theorem index

## Goal

Update `PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean` to include the
results proved in the most recent Aristotle waves that are not yet indexed.

## Results to add

The following modules are **not yet referenced** in the index:

### 1. Furey T₃ weak-isospin operator

Import: `PhysicsSM.Algebra.Furey.T3OpJbar`

Add a new structure:

```lean
/-- Bundled index of the T₃ weak-isospin operator for the Jbar sector. -/
structure ElectroweakT3Index where
  /-- T₃ equals the target T3End from OperatorElectroweakIdentity. -/
  t3_eq_target : T3OpJbar.T3End = targetT3End
  /-- T₃ eigenvalue on each basis state. -/
  t3_eigenvalue : ∀ s, T3OpJbar.T3End (T3OpJbar.JbarBasisState s) =
      (targetT3 s : ℚ) • T3OpJbar.JbarBasisState s
  /-- Operator-level GMN relation Q = T₃ + Y/2. -/
  gmn_operator :
      T3OpJbar.T3End + (1/2 : ℂ) • targetYEnd = physicalQEnd

noncomputable def electroweakT3Index : ElectroweakT3Index where
  t3_eq_target := T3OpJbar.T3End_eq_targetT3End
  t3_eigenvalue := T3OpJbar.T3End_eigenvalue
  gmn_operator := T3OpJbar.T3End_add_half_YEnd_eq_QEnd
```

Then extend `FureyIndex` with a new field `t3_operator : ElectroweakT3Index`.

### 2. Krasnov Hermitian sesquilinearity

Import: `PhysicsSM.Spinor.KrasnovHermitianSesquilinear`

Add a new structure:

```lean
/-- Bundled index of Krasnov Hermitian form sesquilinearity results. -/
structure KrasnovHermitianIndex where
  /-- Sesquilinearity: linear in second argument. -/
  linear_right : ∀ q z r₁ r₂,
      flatHermitian q (z • r₁ + r₂) = z * flatHermitian q r₁ + flatHermitian q r₂
  /-- Sesquilinearity: conjugate-linear in first argument. -/
  antilinear_left : ∀ z q r,
      flatHermitian (z • q) r = starRingEnd ℂ z * flatHermitian q r
  /-- Hermitian symmetry. -/
  conj_symm : ∀ q r, flatHermitian q r = starRingEnd ℂ (flatHermitian r q)
  /-- J preserves the Hermitian norm. -/
  J_norm_preserving : ∀ q : OctonionicQubit,
      flatHermitian (flattenQubit (rightMulE111 q)) (flattenQubit (rightMulE111 q)) =
        flatHermitian (flattenQubit q) (flattenQubit q)
```

Instantiate from `krasnovHermitianSesquilinearPackage`.

Then extend `KrasnovModuleIndex` (or the new structure) with a field
`hermitian : KrasnovHermitianIndex`.

### 3. Inner derivation Jacobi identity and bilinear map

Import: `PhysicsSM.Algebra.Jordan.InnerDerivationJacobiLie`

Extend `InnerDerivationIndex` with new fields:

```lean
  /-- Jacobi identity for the commutator bracket on H3ODerivation. -/
  jacobi : ∀ D E F : H3ODerivation,
      commutator (commutator D E) F +
      commutator (commutator E F) D +
      commutator (commutator F D) E = 0
  /-- The Lie span of inner derivations is closed under brackets. -/
  lie_span_closed : ∀ D E : H3ODerivation,
      D ∈ innerDerivationSubspace →
      E ∈ innerDerivationSubspace →
      commutator D E ∈ innerDerivationSubspace
  /-- The inner derivation map is bilinear. -/
  bilinear : H3O →ₗ[ℝ] H3O →ₗ[ℝ] H3ODerivation
```

### 4. Inner derivations stabilize h₃(ℂ)

Import: `PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer`

Extend `InnerDerivationIndex` with new fields:

```lean
  /-- h₃(ℂ) is closed under the Jordan product. -/
  standardB_jordan_closed : ∀ {a b}, InStandardB a → InStandardB b →
      InStandardB (jordanProduct a b)
  /-- Inner derivations from h₃(ℂ) stabilize h₃(ℂ). -/
  inner_deriv_stabilizes_standardB : ∀ {a b}, InStandardB a → InStandardB b →
      innerDerivation a b ∈ standardB_derivationStabilizer
```

Use the bridge `toStabDerivation (innerDerivation a b)` as needed.

### 5. DVT (SU(3)×SU(3))/Z₃ quotient stabilizer

Import: `PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer`

Add a new structure to the Jordan section:

```lean
/-- Bundled index of the DVT (SU(3)×SU(3))/Z₃ quotient action results. -/
structure DVTSu3QuotientIndex where
  /-- The action homomorphism from SU(3)×SU(3)ᵒᵖ to AddMonoid.End H3OComplement. -/
  action_hom : DVTTwoSidedSU3Pair →* AddMonoid.End H3OComplement
  /-- The quotient is equivalent to the image. -/
  quotient_equiv_image :
      DVTTwoSidedSU3Quotient ≃* (dvtTwoSidedSU3ActionHom.range : Submonoid _)
  /-- The identity fiber is Z₃: only cube-root scalar pairs act trivially. -/
  identity_fiber_z3 :
      ∀ x : DVTTwoSidedSU3Pair,
        dvtTwoSidedSU3ActionHom x = 1 →
        ∃ z : DVTZ3CentralScalar,
          x.1.unit.val = (z : ℂ) • 1 ∧
          x.2.unop.unit.val = (z : ℂ)⁻¹ • 1
```

### 6. G₂ ≅ SU(3) group equivalence

Import: `PhysicsSM.Algebra.Octonion.G2FixingE111GroupEquiv`

Extend `G2SU3Index` with:

```lean
  /-- su3Submonoid carries a Group instance. -/
  su3_is_group : Group su3Submonoid
  /-- The full group equivalence FixingE111MulLinear ≃* su3Submonoid. -/
  group_equiv : FixingE111MulLinear ≃* su3Submonoid
```

Instantiate from `fixingE111MulLinearGroupEquivSU3`.

### 7. Z6 first isomorphism theorem

Import: `PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv`

Add a new structure to the gauge section:

```lean
/-- Bundled index of the Z6 first isomorphism theorem results. -/
structure Z6IsomorphismIndex where
  /-- The full algebraic equivalence: SMCoveringQuotient ≃* SMBlockUnitsSubgroup. -/
  covering_quotient_equiv_smblock :
      MulEquiv SMCoveringQuotient SMBlockUnitsSubgroup
  /-- The surjectivity witness (sixth-root construction). -/
  surjective : Function.Surjective smCoveringQuotientToSMBlockUnits
```

## Updated PaperTheoremIndex

Extend `PaperTheoremIndex` with new fields:
- `electroweak_t3 : ElectroweakT3Index`
- `krasnov_hermitian : KrasnovHermitianIndex`
- `dvt_su3_quotient : DVTSu3QuotientIndex`
- `z6_isomorphism : Z6IsomorphismIndex`

And extend the existing `InnerDerivationIndex`, `FureyIndex`, `G2SU3Index`, and
`KrasnovModuleIndex` fields with the additional theorems listed above.

## Constraints

- Do **not** remove any existing fields from any structure.
- Do **not** change the `ClaimBoundary` structure.
- If a declaration does not exist or has a slightly different name, use the
  closest available name and add a comment noting the discrepancy.
- The file must stay sorry-free.
- Use `open` statements to avoid namespace clutter where appropriate.

## Verification

```bash
lake env lean PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
```
