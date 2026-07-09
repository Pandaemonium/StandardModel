import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The Wigner–Araki–Yanase (WAY) no-go for the chirality ("turn") gate

A finite null-edge program has a "turn" channel `Γφ` that flips chirality.  Chirality
does not commute with conserved weak isospin `Q_s`.  The Wigner–Araki–Yanase theorem
says a gate not commuting with an additively conserved charge cannot be implemented by
a closed-system unitary conserving the total charge with a *trivial* ancilla; it needs
an ancilla carrying charge coherence.

We work with finite-dimensional operators as matrices over a commutative ring, with the
Kronecker (tensor) product `⊗ₖ`.  The total charge is `Q = Q_s ⊗ 1 + 1 ⊗ Q_a`.

Main results:

* `way_defect_identity` — an **exact** identity: for a trivial-ancilla gate `U = u ⊗ 1`,
  the charge-conservation defect `U Q - Q U` equals `[u, Q_s] ⊗ 1`, *independently of the
  ancilla charge* `Q_a`.  A trivial ancilla can never reduce the defect below the system
  commutator — this is the quantitative core of the no-go.
* `way_nogo` — if `U = u ⊗ 1` conserves the total charge, then `u` commutes with `Q_s`.
  Contrapositive: a chirality gate `u` with `[u, Q_s] ≠ 0` cannot be a charge-conserving
  closed-system unitary with a trivial ancilla.
* `chirality_gate_not_isospin_commuting` — an explicit `2×2` chirality flip and isospin
  operator with `[u, Q_s] ≠ 0`.
* `chirality_requires_nontrivial_ancilla` — combining the two: the explicit chirality gate,
  tensored with the identity on *any* nonempty ancilla and *any* ancilla charge `Q_a`,
  fails to conserve total charge.  It genuinely requires a nontrivial (entangling)
  charge-carrying ancilla.
-/

open Matrix Kronecker

namespace WAY

variable {R : Type*} [CommRing R]
variable {m n : Type*} [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]

/-- **Exact WAY defect identity.**  For a trivial-ancilla gate `U = u ⊗ 1`, the
charge-conservation defect `U Q - Q U`, with total charge `Q = Q_s ⊗ 1 + 1 ⊗ Q_a`,
equals `[u, Q_s] ⊗ 1`.  Note this is completely independent of the ancilla charge `Q_a`:
a trivial ancilla contributes nothing, so the defect cannot be made smaller than the
system commutator. -/
theorem way_defect_identity (Q_s u : Matrix m m R) (Q_a : Matrix n n R) :
    (u ⊗ₖ (1 : Matrix n n R)) * ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a))
      - ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a)) * (u ⊗ₖ (1 : Matrix n n R))
      = (u * Q_s - Q_s * u) ⊗ₖ (1 : Matrix n n R) := by
  have e1 : (u ⊗ₖ (1 : Matrix n n R)) * ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a))
      = (u * Q_s) ⊗ₖ (1 : Matrix n n R) + u ⊗ₖ Q_a := by
    rw [Matrix.mul_add, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul]
    simp
  have e2 : ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a)) * (u ⊗ₖ (1 : Matrix n n R))
      = (Q_s * u) ⊗ₖ (1 : Matrix n n R) + u ⊗ₖ Q_a := by
    rw [Matrix.add_mul, ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul]
    simp
  have hsk : (u * Q_s - Q_s * u) ⊗ₖ (1 : Matrix n n R)
      = (u * Q_s) ⊗ₖ (1 : Matrix n n R) - (Q_s * u) ⊗ₖ (1 : Matrix n n R) := by
    ext ⟨i, k⟩ ⟨j, l⟩
    simp [Matrix.kroneckerMap_apply, sub_mul]
  rw [e1, e2, hsk]
  abel

/-- **WAY no-go (trivial ancilla).**  If the trivial-ancilla gate `U = u ⊗ 1` conserves
the total charge `Q_s ⊗ 1 + 1 ⊗ Q_a`, then `u` commutes with the system charge `Q_s`. -/
theorem way_nogo (Q_s u : Matrix m m R) (Q_a : Matrix n n R) [Nonempty n]
    (hU : (u ⊗ₖ (1 : Matrix n n R)) * ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a))
        = ((Q_s ⊗ₖ 1) + (1 ⊗ₖ Q_a)) * (u ⊗ₖ (1 : Matrix n n R))) :
    u * Q_s = Q_s * u := by
  have key : (u * Q_s - Q_s * u) ⊗ₖ (1 : Matrix n n R) = 0 := by
    rw [← way_defect_identity Q_s u Q_a, hU, sub_self]
  obtain ⟨k⟩ := ‹Nonempty n›
  have hsub : u * Q_s - Q_s * u = 0 := by
    ext i j
    have := congrFun (congrFun key (i, k)) (j, k)
    simpa [Matrix.kroneckerMap_apply] using this
  exact sub_eq_zero.mp hsub

end WAY

namespace WAY

/-- An explicit `2×2` chirality-flip gate (Pauli-`X`), which swaps the two chirality
sectors. -/
noncomputable def chiralityGate : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- An explicit `2×2` weak-isospin operator (Pauli-`Z`), diagonal with eigenvalues `±1`
on the two chirality sectors. -/
noncomputable def isospin : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- **Witness.**  The explicit chirality gate does not commute with the isospin operator,
`[u, Q_s] ≠ 0`, so the WAY no-go bites: this gate cannot be a charge-conserving
closed-system unitary with a trivial ancilla. -/
theorem chirality_gate_not_isospin_commuting :
    chiralityGate * isospin ≠ isospin * chiralityGate := by
  intro h
  have hh := congrFun (congrFun h 0) 1
  simp [chiralityGate, isospin, Matrix.mul_apply, Fin.sum_univ_two] at hh
  norm_num at hh

/-- **The no-go bites (needs a nontrivial ancilla).**  For *any* nonempty ancilla index
type and *any* ancilla charge `Q_a`, the trivial-ancilla implementation
`chiralityGate ⊗ 1` fails to conserve the total charge `isospin ⊗ 1 + 1 ⊗ Q_a`.
Hence the chirality (turn) gate genuinely requires a nontrivial, charge-carrying,
entangling ancilla — the Higgs resource. -/
theorem chirality_requires_nontrivial_ancilla
    (n : Type*) [Fintype n] [DecidableEq n] [Nonempty n] (Q_a : Matrix n n ℂ) :
    (chiralityGate ⊗ₖ (1 : Matrix n n ℂ)) * ((isospin ⊗ₖ 1) + (1 ⊗ₖ Q_a))
      ≠ ((isospin ⊗ₖ 1) + (1 ⊗ₖ Q_a)) * (chiralityGate ⊗ₖ (1 : Matrix n n ℂ)) := by
  intro h
  exact chirality_gate_not_isospin_commuting (way_nogo isospin chiralityGate Q_a h)

end WAY

-- Axiom footprint guards: kernel-checked, no sorry/admit/native_decide/new axioms.
#print axioms WAY.way_defect_identity
#print axioms WAY.way_nogo
#print axioms WAY.chirality_gate_not_isospin_commuting
#print axioms WAY.chirality_requires_nontrivial_ancilla
