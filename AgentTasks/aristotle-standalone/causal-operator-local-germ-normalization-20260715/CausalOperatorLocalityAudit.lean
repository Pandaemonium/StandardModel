import Mathlib

/-!
# Causal-operator locality audit seed

This standalone file records the exact entrywise kernels underlying the A39
and A40 numerical audits.  The Aristotle job is primarily a hostile design and
continuum-normalization audit; this file keeps its Lean preflight independent
of the full PhysicsSM import graph.
-/

namespace CausalOperatorLocalityAudit

/-- A finite real operator on an `n`-event set. -/
abbrev RealOperator (n : Nat) := Matrix (Fin n) (Fin n) Real

/-- Entrywise kernel of `[[B, M_f], M_h]`. -/
def doubleKernel {n : Nat} (B : RealOperator n) (f h : Fin n -> Real) :
    RealOperator n := fun i j => B i j * (f j - f i) * (h j - h i)

/-- Entrywise kernel of `[[[B, M_f], M_h], M_k]`. -/
def tripleKernel {n : Nat} (B : RealOperator n) (f h k : Fin n -> Real) :
    RealOperator n := fun i j => doubleKernel B f h i j * (k j - k i)

/-- The double-commutator kernel is symmetric in its function arguments. -/
theorem doubleKernel_swap {n : Nat} (B : RealOperator n) (f h : Fin n -> Real) :
    doubleKernel B f h = doubleKernel B h f := by
  ext i j
  simp only [doubleKernel]
  ring

/-- Adding a constant to either argument does not change the kernel. -/
theorem doubleKernel_add_const_left {n : Nat} (B : RealOperator n)
    (f h : Fin n -> Real) (c : Real) :
    doubleKernel B (fun i => f i + c) h = doubleKernel B f h := by
  ext i j
  simp [doubleKernel]

end CausalOperatorLocalityAudit
