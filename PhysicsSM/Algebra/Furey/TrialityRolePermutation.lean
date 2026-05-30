import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTriple

/-!
# Triality role permutation API

This trusted module provides a finite permutation API for `TrialityRole` and
its action on `TrialityTriple`.

It does not define `Spin(8)`, `tri(O)`, or any Standard Model action. It only
proves the combinatorics of the three role labels and their effect on triples.

## Convention

The cyclic permutation follows:

```text
spinorPlus -> spinorMinus -> vector -> spinorPlus
```

For `TrialityTriple.permute`, we use the pullback convention: the component at
role `r` of `t.permute e` is `t.proj (e.symm r)`.

For composition, `permute_trans` follows Lean's `Equiv.trans` convention where
`(e.trans f) x = f (e x)`:

```text
(t.permute e).permute f = t.permute (e.trans f)
```

Provenance: integrated from Aristotle job
`98d12a96-312c-4f8f-9d15-df9735d42649`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey

/-! ## Cyclic permutation of roles -/

/-- The cyclic permutation of triality roles:
`spinorPlus -> spinorMinus -> vector -> spinorPlus`. -/
def TrialityRole.cycle : TrialityRole → TrialityRole
  | .spinorPlus => .spinorMinus
  | .spinorMinus => .vector
  | .vector => .spinorPlus

/-- Applying `cycle` three times is the identity. -/
theorem TrialityRole.cycle_three (r : TrialityRole) :
    TrialityRole.cycle (TrialityRole.cycle (TrialityRole.cycle r)) = r := by
  cases r <;> rfl

/-- `cycle` is injective. -/
theorem TrialityRole.cycle_injective :
    Function.Injective TrialityRole.cycle := by
  intro a b h
  cases a <;> cases b <;> first | rfl | simp [TrialityRole.cycle] at h

/-- The inverse of `cycle`: `spinorPlus <- spinorMinus <- vector <- spinorPlus`. -/
def TrialityRole.cycleInv : TrialityRole → TrialityRole
  | .spinorPlus => .vector
  | .spinorMinus => .spinorPlus
  | .vector => .spinorMinus

/-- `cycleInv` is a left inverse of `cycle`. -/
theorem TrialityRole.cycleInv_cycle (r : TrialityRole) :
    TrialityRole.cycleInv (TrialityRole.cycle r) = r := by
  cases r <;> rfl

/-- `cycle` is a left inverse of `cycleInv`. -/
theorem TrialityRole.cycle_cycleInv (r : TrialityRole) :
    TrialityRole.cycle (TrialityRole.cycleInv r) = r := by
  cases r <;> rfl

/-- The cyclic permutation as an `Equiv.Perm`. -/
def TrialityRole.cycleEquiv : Equiv.Perm TrialityRole where
  toFun := TrialityRole.cycle
  invFun := TrialityRole.cycleInv
  left_inv r := by cases r <;> rfl
  right_inv r := by cases r <;> rfl

@[simp]
theorem TrialityRole.cycleEquiv_apply (r : TrialityRole) :
    TrialityRole.cycleEquiv r = TrialityRole.cycle r := rfl

@[simp]
theorem TrialityRole.cycleEquiv_symm_apply (r : TrialityRole) :
    TrialityRole.cycleEquiv.symm r = TrialityRole.cycleInv r := rfl

/-! ## Permutation of triples -/

variable {A : Type*}

/--
Permute the components of a `TrialityTriple` by pulling back along a role
permutation `e`. The component at role `r` of the result is `t.proj (e.symm r)`.
-/
def TrialityTriple.permute (e : Equiv.Perm TrialityRole)
    (t : TrialityTriple A) : TrialityTriple A :=
  TrialityTriple.ofFun (fun r => t.proj (e.symm r))

/-- Projection after permutation. -/
theorem TrialityTriple.proj_permute
    (e : Equiv.Perm TrialityRole) (t : TrialityTriple A) (r : TrialityRole) :
    (t.permute e).proj r = t.proj (e.symm r) := by
  simp [TrialityTriple.permute, TrialityTriple.proj_ofFun]

/-- Permuting by the identity permutation is the identity. -/
theorem TrialityTriple.permute_refl
    (t : TrialityTriple A) :
    t.permute (Equiv.refl TrialityRole) = t := by
  ext <;> simp [TrialityTriple.permute, TrialityTriple.ofFun, TrialityTriple.proj]

/--
Composing two permutations of a triple.

Convention: `(t.permute e).permute f = t.permute (e.trans f)`, because pullback
by `e` then by `f` yields `t.proj (e.symm (f.symm r))`, which equals
`t.proj ((e.trans f).symm r)`.
-/
theorem TrialityTriple.permute_trans
    (e f : Equiv.Perm TrialityRole) (t : TrialityTriple A) :
    (t.permute e).permute f = t.permute (e.trans f) := by
  simp only [TrialityTriple.permute]
  congr 1
  ext r
  simp [TrialityTriple.proj_ofFun, Equiv.symm_trans_apply]

/-! ## Specialization to the triality cycle -/

/-- Cycle the components of a triality triple using the canonical cyclic permutation. -/
def TrialityTriple.cycle (t : TrialityTriple A) : TrialityTriple A :=
  t.permute TrialityRole.cycleEquiv

/-- Cycling three times returns the original triple. -/
theorem TrialityTriple.cycle_three (t : TrialityTriple A) :
    t.cycle.cycle.cycle = t := by
  ext <;> simp [TrialityTriple.cycle, TrialityTriple.permute, TrialityTriple.ofFun,
    TrialityTriple.proj, TrialityRole.cycleInv]

end PhysicsSM.Algebra.Furey
