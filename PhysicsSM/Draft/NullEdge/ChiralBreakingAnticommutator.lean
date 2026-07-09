import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Mass = the obstruction to `γ5` anticommuting with the Dirac operator (`{γ5,D} = -2m·γ5`)

This unifies the two projector sets grounded in the program — the chiral (Weyl)
projectors `P_L,R = (1 ∓ γ5)/2` (`ChiralProjectorsDirac`) and the energy
projectors `Λ± = (pslash±m)/2m` (`MassShellProjectors`) — into the single cleanest
algebraic statement of "mass from massless" at the Dirac-operator level.

For the **covariant** Dirac operator `D = pslash - m·1`:

  `{γ5, D} = γ5 D + D γ5 = -2m·γ5`.

At `m = 0` this VANISHES (`γ5` anticommutes with the massless Dirac operator
`pslash` — this is CHIRAL SYMMETRY, left and right decouple). For `m ≠ 0` it is
`-2m·γ5 ≠ 0`: the mass is precisely the chiral-symmetry breaking. So mass is the
obstruction to `γ5` anticommuting with `D` — the algebraic core of the thesis.
(This `{γ5, D}` is exactly the object in the lattice Ginsparg-Wilson relation
`{γ5, D} = 2a·D γ5 D`; the continuum-mass value here is `-2m·γ5`. Provenance:
Ginsparg-Wilson PRD 25 (1982) 2649, Luscher hep-lat/9802011 — both already tracked,
§8 load-bearing.)

## Convention reconciliation with `ZigzagWeyl` (READ THIS before comparing)

`ZigzagWeyl` and the manuscript §2a point 2 say "the mass term is **chiral-ODD**".
That refers to the Dirac **Hamiltonian** mass `βm = m·γ0` (`ZigzagWeyl.chiralFlip`
is `γ0` in the Weyl basis, block-off-diagonal), which **anticommutes** with `γ5`;
there, chiral-symmetry breaking appears as `[γ5, H] ≠ 0`.

Here the **covariant** mass `m·1` is chiral-**EVEN** (`g5_commutes_mass`,
`[γ5, m·1] = 0`); chiral-symmetry breaking appears instead as `{γ5, D} ≠ 0`. These
are the SAME physics in two forms (covariant vs Hamiltonian), NOT a contradiction.
The bridge is `mass_bilinear_couples_chirality`: `γ0` intertwines the two
chiralities (`P_L γ0 P_R = P_L γ0 ≠ 0`), which is exactly why the Lagrangian mass
bilinear `ψ̄ψ = ψ†γ0ψ` couples `L ↔ R` (`ψ̄` carries the chirality-flipping `γ0`).
Do NOT quote "mass commutes with γ5" next to "mass term is chiral-odd" without this
covariant/Hamiltonian distinction.

## Model (real Dirac-rep gammas, `(t,z)` plane ⟶ rational 4×4)

`g5` (block off-diagonal identity), `g0 = diag(1,1,-1,-1)`, `g3`,
`pslash E kz = E•g0 − kz•g3`, `D E kz m = pslash − m•1`, and `PL,PR = (1∓g5)/2`.
All rational (no `Complex`).

Provenance: PhysLean's Dirac-representation gamma convention (`spaceTime.gamma`),
REFERENCE only, NOT imported. Draft status: kernel-checked with no proof escape
hatches; every headline carries an in-file `#print axioms` guard pinned to exactly
`[propext, Classical.choice, Quot.sound]`.
-/

namespace ChiralBreakingAnticommutator

/-- Rational scalars: real Dirac-rep gammas in the (t,z) plane collapse to rational 4×4 matrices. -/
abbrev Q := ℚ
abbrev M := Matrix (Fin 4) (Fin 4) Q

/-- Dirac-rep gamma5 (block off-diagonal identity). -/
def g5 : M := !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

/-- gamma0 = diag(1,1,-1,-1). -/
def g0 : M := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- gamma3 (Dirac rep, (t,z) plane). -/
def g3 : M := !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]

/-- Feynman slash in the (t,z) plane: `pslash E kz = E • g0 - kz • g3`. -/
def pslash (E kz : Q) : M := E • g0 - kz • g3

/-- The Dirac operator `D = pslash - m • 1`. -/
def D (E kz m : Q) : M := pslash E kz - m • (1 : M)

/-- Left chiral projector `P_L = (1/2)(1 - g5)`. -/
def PL : M := (1/2 : Q) • ((1 : M) - g5)

/-- Right chiral projector `P_R = (1/2)(1 + g5)`. -/
def PR : M := (1/2 : Q) • ((1 : M) + g5)

/-- gamma5 anticommutes with gamma0. -/
theorem g5_anticommutes_g0 : g5 * g0 + g0 * g5 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [g5, g0]

/-- gamma5 anticommutes with gamma3. -/
theorem g5_anticommutes_g3 : g5 * g3 + g3 * g5 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [g5, g3]

/-- gamma5 anticommutes with the kinetic term `pslash` (chirality flips). -/
theorem g5_anticommutes_pslash (E kz : Q) :
    g5 * pslash E kz + pslash E kz * g5 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [g5, g0, g3, pslash]

/-- The mass term is chirality-even: it commutes with gamma5. -/
theorem g5_commutes_mass (m : Q) :
    g5 * (m • (1 : M)) - (m • (1 : M)) * g5 = 0 := by
  rw [Matrix.mul_smul, Matrix.smul_mul, mul_one, one_mul, sub_self]

/-- **Payload.** The anticommutator of gamma5 with the Dirac operator is `-2m • g5`. -/
theorem chiral_breaking (E kz m : Q) :
    g5 * D E kz m + D E kz m * g5 = (-2 * m) • g5 := by
  have h1 : g5 * (m • (1:M)) = m • g5 := by rw [Matrix.mul_smul, mul_one]
  have h2 : (m • (1:M)) * g5 = m • g5 := by rw [Matrix.smul_mul, one_mul]
  have hp := g5_anticommutes_pslash E kz
  rw [D, mul_sub, sub_mul, h1, h2]
  have hrw : g5 * pslash E kz - m • g5 + (pslash E kz * g5 - m • g5)
      = (g5 * pslash E kz + pslash E kz * g5) - (2 * m) • g5 := by module
  rw [hrw, hp]
  module

/-- **Payload.** At `m = 0`, gamma5 anticommutes with the massless Dirac operator (chiral symmetry). -/
theorem massless_chiral_symmetry (E kz : Q) :
    g5 * D E kz 0 + D E kz 0 * g5 = 0 := by
  rw [chiral_breaking]
  simp

/-- **Companion.** `g0` intertwines the two chiralities: `PL * g0 * PR = PL * g0`.
This is the bridge to the Hamiltonian / Lagrangian picture: the mass bilinear
`ψ̄ψ = ψ†γ0ψ` couples `L ↔ R` because `γ0` flips chirality (`ZigzagWeyl`'s
chiral-odd mass `m·γ0`). -/
theorem mass_bilinear_couples_chirality :
    PL * g0 * PR = PL * g0 ∧ PL * g0 * PR ≠ 0 := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PL, PR, g5, g0, Matrix.mul_apply, Fin.sum_univ_four,
        Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply] <;> ring
  · intro h
    have := congrArg (fun A => A 0 0) h
    simp [PL, PR, g5, g0, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply] at this

/-- gamma5 is nonzero. -/
theorem g5_ne_zero : g5 ≠ 0 := by
  intro h
  have := congrArg (fun A => A 0 2) h
  simp [g5] at this

/-- **Verdict.** Package: `{g5,D} = -2m•g5`; vanishes at `m=0` (chiral symmetry),
nonzero for `m≠0` (mass = chiral-symmetry breaking). Explicit witnesses at `E=5,kz=3`. -/
theorem chiral_breaking_verdict :
    (∀ E kz m : Q, g5 * D E kz m + D E kz m * g5 = (-2 * m) • g5) ∧
    (∀ E kz : Q, g5 * D E kz 0 + D E kz 0 * g5 = 0) ∧
    g5 ≠ 0 ∧
    (g5 * D 5 3 4 + D 5 3 4 * g5 = (-8 : Q) • g5) ∧
    ((-8 : Q) • g5) ≠ 0 ∧
    g5 * D 5 3 0 + D 5 3 0 * g5 = 0 := by
  refine ⟨chiral_breaking, massless_chiral_symmetry, g5_ne_zero, ?_, ?_, massless_chiral_symmetry 5 3⟩
  · rw [chiral_breaking]; norm_num
  · intro h
    have := congrArg (fun A => A 0 2) h
    simp [g5, Matrix.smul_apply] at this

/-- info: 'ChiralBreakingAnticommutator.g5_anticommutes_g0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms g5_anticommutes_g0
/-- info: 'ChiralBreakingAnticommutator.g5_anticommutes_g3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms g5_anticommutes_g3
/-- info: 'ChiralBreakingAnticommutator.g5_anticommutes_pslash' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms g5_anticommutes_pslash
/-- info: 'ChiralBreakingAnticommutator.g5_commutes_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms g5_commutes_mass
/-- info: 'ChiralBreakingAnticommutator.chiral_breaking' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms chiral_breaking
/-- info: 'ChiralBreakingAnticommutator.massless_chiral_symmetry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_chiral_symmetry
/-- info: 'ChiralBreakingAnticommutator.mass_bilinear_couples_chirality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mass_bilinear_couples_chirality
/-- info: 'ChiralBreakingAnticommutator.g5_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms g5_ne_zero
/-- info: 'ChiralBreakingAnticommutator.chiral_breaking_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms chiral_breaking_verdict

end ChiralBreakingAnticommutator
