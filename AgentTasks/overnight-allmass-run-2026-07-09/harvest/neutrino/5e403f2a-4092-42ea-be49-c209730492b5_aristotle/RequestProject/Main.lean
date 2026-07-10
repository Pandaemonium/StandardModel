import Mathlib

open scoped BigOperators
open scoped Classical

open Matrix

/-!
# The Dirac / Majorana distinction as a null-edge structure

A **finite, self-contained matrix-algebra** model of the Dirac-vs-Majorana question
for neutrinos, tied to the landed CPT operator `Theta` and a lepton-number phase
generator `Q`.

We work in a `4`-dimensional complex carrier `Fin 4 → ℂ`.  The four basis slots are
read as two "null-edge zigzags":

* slots `0,1` — the particle sector (lepton number `+1`);
* slots `2,3` — the antiparticle sector (lepton number `-1`).

The CPT operator is `Theta v = R * conj v` with the *real* involution `R` swapping the
particle and antiparticle sectors (`0 ↔ 2`, `1 ↔ 3`); it is antiunitary and involutive.

* A **Dirac** mass `M_D` swaps *within* a sector (`0 ↔ 1`, `2 ↔ 3`): it couples a state
  to an *independent* partner and commutes with the phase generator `Q`
  (lepton number conserved).  Its CPT-conjugate is a genuinely different state.
* A **Majorana** mass `M_M` couples slot `0` to its CPT partner slot `2`: it is
  supported on the `Theta`-invariant (self-conjugate) sector, acts nontrivially there,
  annihilates the orthogonal sector, and does **not** commute with `Q`
  (lepton number violated).

Honest scope: this is a finite *structural* statement about the two mass-term types and
their CPT / phase properties.  It is **not** a prediction of the physical neutrino's
Dirac-or-Majorana nature or its mass.
-/

namespace NeutrinoDiracMajorana

/-- The complex `4 × 4` carrier. -/
abbrev M4 := Matrix (Fin 4) (Fin 4) ℂ

/-- The real CPT involution `R = Γ·J`: swaps the particle sector `{0,1}` with the
antiparticle sector `{2,3}`. -/
def R : M4 := !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

/-- Dirac mass matrix: swaps *within* each sector (`0 ↔ 1`, `2 ↔ 3`).  Couples a state
to an independent partner of the *same* lepton number. -/
def MD : M4 := !![0,1,0,0; 1,0,0,0; 0,0,0,1; 0,0,1,0]

/-- Majorana mass matrix: couples slot `0` to its CPT partner slot `2` (opposite lepton
numbers). -/
def MM : M4 := !![0,0,1,0; 0,0,0,0; 1,0,0,0; 0,0,0,0]

/-- Lepton-number phase generator `Q = diag(1,1,-1,-1)`. -/
def Q : M4 := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The CPT operator `Θ v = R · conj v` (antiunitary, involutive). -/
noncomputable def Theta (v : Fin 4 → ℂ) : Fin 4 → ℂ := R.mulVec (fun i => star (v i))

/-- A particle state in the `0`-slot. -/
def psiP : Fin 4 → ℂ := ![1,0,0,0]

/-- The Dirac partner produced from `psiP` by `M_D`: the `1`-slot state. -/
def psiDPartner : Fin 4 → ℂ := ![0,1,0,0]

/-- A `Theta`-invariant (self-conjugate) state: `Θ psiInv = psiInv`. -/
def psiInv : Fin 4 → ℂ := ![1,0,1,0]

/-- A non-`Theta`-invariant state living in the sector `M_M` annihilates. -/
def psiNI : Fin 4 → ℂ := ![0,1,0,0]

/-- CPT is involutive: `Θ (Θ v) = v` for every state. -/
theorem Theta_involutive (v : Fin 4 → ℂ) : Theta (Theta v) = v := by
  funext i; fin_cases i <;>
    simp [Theta, R, Matrix.mulVec, dotProduct, Fin.sum_univ_four]

/-! ## Target 1 — Dirac: two independent null-edge zigzags -/

/-- **Dirac two states.**  A Dirac mass couples `psiP` to an *independent* partner
(`M_D · psiP = psiDPartner`, and `psiDPartner ≠ psiP`), while the CPT conjugate of the
particle is a genuinely *different* state (`Θ psiP ≠ psiP`).  The two null-edge zigzags
(particle and antiparticle) are independent. -/
theorem dirac_two_states :
    Theta psiP ≠ psiP ∧ MD.mulVec psiP = psiDPartner ∧ psiDPartner ≠ psiP := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := congrFun h 0
    simp [Theta, R, psiP, Matrix.mulVec, dotProduct, Fin.sum_univ_four] at this
  · funext i; fin_cases i <;>
      simp [MD, psiP, psiDPartner, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  · intro h
    have := congrFun h 0
    simp [psiP, psiDPartner] at this

/-! ## Target 2 — Majorana: the self-conjugate constraint -/

/-- **Majorana self-conjugate.**  The Majorana mass imposes the self-conjugate
constraint: it is supported on the `Theta`-invariant sector.  We exhibit an explicit
`Theta`-invariant witness `psiInv` (`Θ psiInv = psiInv`) on which `M_M` acts
nontrivially (`M_M · psiInv ≠ 0`), versus a non-invariant state `psiNI`
(`Θ psiNI ≠ psiNI`) which `M_M` annihilates (`M_M · psiNI = 0`). -/
theorem majorana_self_conjugate :
    Theta psiInv = psiInv ∧ MM.mulVec psiInv ≠ 0 ∧
      Theta psiNI ≠ psiNI ∧ MM.mulVec psiNI = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · funext i; fin_cases i <;>
      simp [Theta, R, psiInv, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  · intro h
    have := congrFun h 0
    simp [MM, psiInv, Matrix.mulVec, dotProduct, Fin.sum_univ_four] at this
  · intro h
    have := congrFun h 1
    simp [Theta, R, psiNI, Matrix.mulVec, dotProduct, Fin.sum_univ_four] at this
  · funext i; fin_cases i <;>
      simp [MM, psiNI, Matrix.mulVec, dotProduct, Fin.sum_univ_four]

/-! ## Target 3 — Lepton number: `[M_D, Q] = 0` but `[M_M, Q] ≠ 0` -/

/-- **Lepton number.**  The Dirac mass conserves the `U(1)` lepton number: it commutes
with the phase generator `Q` (`[M_D, Q] = 0`).  The Majorana mass breaks it: it does
*not* commute with `Q`, with an explicit nonzero commutator entry
`(M_M·Q − Q·M_M) 0 2 = -2`. -/
theorem lepton_number :
    MD * Q = Q * MD ∧ MM * Q ≠ Q * MM ∧ (MM * Q - Q * MM) 0 2 = -2 := by
  refine ⟨?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [MD, Q, Matrix.mul_apply, Fin.sum_univ_four]
  · intro h
    have := congrFun (congrFun h 0) 2
    simp [MM, Q, Matrix.mul_apply, Fin.sum_univ_four] at this
    norm_num at this
  · simp [MM, Q, Matrix.sub_apply]
    norm_num

/-! ## Target 4 — Verdict -/

/-- **Neutrino verdict (package).**

*Dirac neutrino* = two independent null-edge zigzags: the CPT conjugate `Θ psiP` is a new
state, the Dirac mass links `psiP` to an independent partner `psiDPartner ≠ psiP`, and
lepton number is conserved (`[M_D, Q] = 0`).

*Majorana neutrino* = a single self-CPT-conjugate zigzag: there is a `Theta`-invariant
witness `psiInv` on which the Majorana mass acts, and lepton number is violated
(`[M_M, Q] ≠ 0`).

The distinction is exactly whether the CPT-conjugate is a *new* state (Dirac) or the
*same* state (Majorana).  CPT is involutive throughout.  Finite structural statement;
not a physical prediction. -/
theorem neutrino_verdict :
    -- Dirac: CPT conjugate is a NEW state; independent partner; lepton number conserved
    (Theta psiP ≠ psiP ∧ MD.mulVec psiP = psiDPartner ∧ psiDPartner ≠ psiP ∧
      MD * Q = Q * MD) ∧
    -- Majorana: self-conjugate witness M_M acts on; lepton number violated
    (Theta psiInv = psiInv ∧ MM.mulVec psiInv ≠ 0 ∧ MM * Q ≠ Q * MM) ∧
    -- CPT involution holds for all states
    (∀ v : Fin 4 → ℂ, Theta (Theta v) = v) := by
  obtain ⟨hD1, hD2, hD3⟩ := dirac_two_states
  obtain ⟨hM1, hM2, _, _⟩ := majorana_self_conjugate
  obtain ⟨hL1, hL2, _⟩ := lepton_number
  exact ⟨⟨hD1, hD2, hD3, hL1⟩, ⟨hM1, hM2, hL2⟩, Theta_involutive⟩

/-! ## Axiom audit — footprint exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'NeutrinoDiracMajorana.dirac_two_states' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_two_states

/-- info: 'NeutrinoDiracMajorana.majorana_self_conjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms majorana_self_conjugate

/-- info: 'NeutrinoDiracMajorana.lepton_number' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lepton_number

/-- info: 'NeutrinoDiracMajorana.neutrino_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms neutrino_verdict

end NeutrinoDiracMajorana
