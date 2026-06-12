import Mathlib
import PhysicsSM.Gauge.QunitQubitQutritDictionary
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel

/-!
# Gauge.QunitQubitQutritRepresentation

Block-diagonal representation of `UnitCoveringTriple` on the
qubit-plus-qutrit space `QubitPlusQutrit = (Fin 2 ⊕ Fin 3) → ℂ`.

## Mathematical context

The covering image of a `UnitCoveringTriple` `(α, g, h)` is the pair
`(α³ · g, α⁻² · h)` of invertible matrices acting on ℂ² and ℂ³
respectively. The block-diagonal action on ℂ² ⊕ ℂ³ applies the first
matrix to the qubit component and the second to the qutrit component.

The six Z₆ kernel elements `(ω^k, ω^{-3k} · I₂, ω^{2k} · I₃)` all
have image `(I₂, I₃)`, so their block action is the identity.

## Main declarations

* `actQubitPlusQutrit` — the block-diagonal action.
* `actQubitPlusQutrit_one` — identity law.
* `actQubitPlusQutrit_mul` — multiplicativity law.
* `unitCoveringTripleQubitPlusQutritRepresentation` — monoid hom to `Function.End`.
* `kernelElt_actQubitPlusQutrit_eq_id` — kernel elements act trivially.
* `sixUnitCoveringKernelElts_actQubitPlusQutrit_eq_id` — all six kernel elements act trivially.

## Claim boundary

This is a finite-dimensional linear representation theorem for the
algebraic covering scaffold. It does not claim that the Standard Model
is quantum computing, nor does it prove dynamics or Hilbert-space physics.

Status: trusted — no `sorry`.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.QunitQubitQutritDictionary

open Complex Matrix PhysicsSM.Gauge.StandardModelSubgroup

/-! ## Block-diagonal action on QubitPlusQutrit -/

/--
The block-diagonal action of a `UnitCoveringTriple` on `QubitPlusQutrit`.

Given a triple `x = (α, g, h)`, its covering image is
`(α³ · g, α⁻² · h)`. The action on a vector `v : (Fin 2 ⊕ Fin 3) → ℂ`
applies `(α³ · g)` to the qubit (left) component and `(α⁻² · h)` to the
qutrit (right) component via matrix-vector multiplication.
-/
noncomputable def actQubitPlusQutrit
    (x : UnitCoveringTriple) :
    QubitPlusQutrit → QubitPlusQutrit :=
  fun v => Sum.elim
    (x.image.1.val.mulVec (fun i => v (Sum.inl i)))
    (x.image.2.val.mulVec (fun i => v (Sum.inr i)))

/-! ## Identity law -/

/--
The identity covering triple acts as the identity on `QubitPlusQutrit`.
-/
theorem actQubitPlusQutrit_one :
    actQubitPlusQutrit (1 : UnitCoveringTriple) = id := by
  funext v; simp [actQubitPlusQutrit, UnitCoveringTriple.image];
  exact funext fun x => by cases x <;> rfl;

/-! ## Multiplicativity law -/

/--
The action is compatible with multiplication: `(x * y)` acts as `x` composed with `y`.
-/
theorem actQubitPlusQutrit_mul
    (x y : UnitCoveringTriple) :
    actQubitPlusQutrit (x * y) =
      actQubitPlusQutrit x ∘ actQubitPlusQutrit y := by
  ext v i; cases i <;> simp [actQubitPlusQutrit];
  · rw [ UnitCoveringTriple.image_mul ];
    rfl;
  · erw [ UnitCoveringTriple.image_mul ] ; aesop

/-! ## Monoid representation -/

/--
The block-diagonal action of `UnitCoveringTriple` on `QubitPlusQutrit`,
packaged as a monoid homomorphism to `Function.End QubitPlusQutrit`.
-/
noncomputable def unitCoveringTripleQubitPlusQutritRepresentation :
    UnitCoveringTriple →* Function.End QubitPlusQutrit where
  toFun := actQubitPlusQutrit
  map_one' := actQubitPlusQutrit_one
  map_mul' := actQubitPlusQutrit_mul

/-! ## Kernel triviality -/

/--
Every unit-level kernel element acts as the identity on `QubitPlusQutrit`.
This follows from the fact that the kernel element's image is `(I₂, I₃)`.
-/
theorem kernelElt_actQubitPlusQutrit_eq_id
    (k : UnitCoveringKernelElt) :
    actQubitPlusQutrit k.toUnitCoveringTriple = id := by
  have h_k_image : k.toUnitCoveringTriple.image = (1, 1) := by
    convert k.image_eq_one using 1;
  unfold actQubitPlusQutrit;
  aesop

/--
Each of the six explicit unit-level kernel elements acts as the identity
on `QubitPlusQutrit`.
-/
theorem sixUnitCoveringKernelElts_actQubitPlusQutrit_eq_id
    (i : Fin 6) :
    actQubitPlusQutrit (sixUnitCoveringKernelElts i).toUnitCoveringTriple =
      id := by
  apply kernelElt_actQubitPlusQutrit_eq_id

end PhysicsSM.Gauge.QunitQubitQutritDictionary
