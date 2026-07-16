import Mathlib

/-!
# Controlled transverse-sector Floquet composition

This standalone target combines a finite transverse rank-one selector with two
independent unitary spin-sector updates.  It is deliberately abstract in the
spin updates: a later project will instantiate the selected update with the
exact HNU endpoint and the complement update with the compensating pi-gap or
bulk dynamics.

The target is finite linear algebra only.  It does not claim real-space
locality, primitive-null support, a Weyl winding, or anomaly cancellation.
-/

namespace FloquetTransverseComposite

open Matrix

noncomputable section

abbrev TSite := Fin 3
abbrev Spin := Fin 2

def IsUnitary {n : Type} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

def w : TSite -> Complex := ![2, 0, -1]

def selector : Matrix TSite TSite Complex :=
  (1 / 5 : Complex) • vecMulVec w w

def controlled (U V : Matrix Spin Spin Complex) :
    Matrix (TSite × Spin) (TSite × Spin) Complex :=
  kroneckerMap (fun a b => a * b) selector U +
    kroneckerMap (fun a b => a * b)
      ((1 : Matrix TSite TSite Complex) - selector) V

def embed (e : Spin -> Complex) : TSite × Spin -> Complex :=
  fun p => w p.1 * e p.2

/-- The rank-one selector is an exact Hermitian projector. -/
theorem selector_isHermitian : selector.IsHermitian := by
  sorry

theorem selector_idempotent : selector * selector = selector := by
  sorry

theorem selector_mulVec_w : selector *ᵥ w = w := by
  sorry

theorem complement_mulVec_w :
    ((1 : Matrix TSite TSite Complex) - selector) *ᵥ w = 0 := by
  sorry

/-- Independent unitary updates on the two orthogonal transverse sectors give
an exactly unitary combined update. -/
theorem controlled_isUnitary {U V : Matrix Spin Spin Complex}
    (hU : IsUnitary U) (hV : IsUnitary V) :
    IsUnitary (controlled U V) := by
  sorry

/-- The selected transverse sector carries `U` exactly, independently of the
complement update `V`. -/
theorem controlled_restriction (U V : Matrix Spin Spin Complex)
    (e : Spin -> Complex) :
    controlled U V *ᵥ embed e = embed (U *ᵥ e) := by
  sorry

/-- A nonzero spinor remains nonzero after embedding, so the restriction is
nonvacuous. -/
theorem embed_ne_zero {e : Spin -> Complex} (he : e != 0) : embed e != 0 := by
  sorry

/-- The stationary-complement choice is explicit rather than hidden. -/
theorem stationary_complement_restriction (U : Matrix Spin Spin Complex)
    (e : Spin -> Complex) :
    controlled U 1 *ᵥ embed e = embed (U *ᵥ e) := by
  sorry

end

end FloquetTransverseComposite
