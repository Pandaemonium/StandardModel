import Mathlib
import PhysicsSM.Gauge.StandardModelZ6Kernel

/-!
# Gauge.StandardModelZ6FiniteKernel

Finite enumeration and bijection for the ℤ₆ kernel of the Standard Model
covering map.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))` has
kernel consisting of exactly six elements, indexed by the sixth roots of unity.

This module proves that:
1. Every sixth root of unity is one of the explicit `kernelPhases`.
2. The map `sixCoveringKernelElts : Fin 6 → CoveringKernelElt` is surjective
   (and therefore bijective).

The proofs use the fact that `omega` is a primitive sixth root of unity
(`omega_isPrimitiveRoot`), so every solution of `α⁶ = 1` is a power of `omega`.

## Claim boundary

This is finite algebraic kernel enumeration only. No topological Lie group
quotient theorem or first-isomorphism theorem is claimed.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## kernelPhases equals omega powers -/

/--
Each `kernelPhases k` equals `omega ^ k`. This is immediate from the
definition but convenient for rewriting.
-/
theorem kernelPhases_eq_omega_pow (k : Fin 6) :
    kernelPhases k = omega ^ (k : ℕ) := by
  fin_cases k <;> simp [kernelPhases]

/-! ## Surjectivity of kernel phases -/

/--
Every sixth root of unity equals `kernelPhases k` for some `k : Fin 6`.

Proof: since `omega` is a primitive 6th root of unity, every `α` with
`α⁶ = 1` is `omega ^ i` for some `i < 6`, which is exactly `kernelPhases i`.
-/
theorem kernelPhases_surj_of_pow_six
    {alpha : Complex} (halpha : alpha ^ 6 = 1) :
    ∃ k : Fin 6, kernelPhases k = alpha := by
  obtain ⟨i, hi_lt, hi_eq⟩ := omega_isPrimitiveRoot.eq_pow_of_pow_eq_one halpha
  exact ⟨⟨i, hi_lt⟩, kernelPhases_eq_omega_pow ⟨i, hi_lt⟩ ▸ hi_eq⟩

/-! ## Surjectivity and bijectivity of the covering kernel elements -/

/--
`sixCoveringKernelElts` is surjective: every `CoveringKernelElt` is
`sixCoveringKernelElts k` for some `k : Fin 6`.
-/
theorem sixCoveringKernelElts_surjective :
    Function.Surjective sixCoveringKernelElts := by
  intro ⟨phase, hphase⟩
  obtain ⟨k, hk⟩ := kernelPhases_surj_of_pow_six hphase
  exact ⟨k, (CoveringKernelElt.mk.injEq ..).mpr hk⟩

/--
`sixCoveringKernelElts` is bijective: the six covering kernel elements
are exactly the elements of `CoveringKernelElt`.
-/
theorem sixCoveringKernelElts_bijective :
    Function.Bijective sixCoveringKernelElts :=
  ⟨sixCoveringKernelElts_injective, sixCoveringKernelElts_surjective⟩

end PhysicsSM.Gauge.StandardModelSubgroup
