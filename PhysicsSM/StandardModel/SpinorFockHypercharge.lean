import Mathlib.Tactic
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# StandardModel.SpinorFockHypercharge

The hypercharge table of the `Spin(10)` Fock decomposition: the `16` of
`Spin(10)` decomposes under the Standard Model subgroup into exactly one
generation plus a right-handed neutrino, with the physical hypercharges.

## Mathematical context

In the Fock model `S⁺ = Λ^even(ℂ⁵)` (see `PhysicsSM.Spinor.SpinorTenfoldFock`),
basis states are indexed by even-cardinality subsets `S ⊆ {0,…,4}`. Following
the `d = 3` Krasnov normal form of the research notes, indices split as

- `{0, 1, 2}`: the (conjugate) **color** directions `W̄₃`, hypercharge weight
  `Y = -1/3` each;
- `{3, 4}`: the (conjugate) **weak** directions `W̄₂`, hypercharge weight
  `Y = +1/2` each,

in GUT normalization (`Y(W₃) = +1/3`, `Y(W₂) = -1/2` on the fundamentals,
hence the opposite signs on the conjugates spanning the Fock space). The
hypercharge of a basis state is the sum of the weights of its indices.

The resulting table (Proposition S3 of the research notes, with the
`3` vs `3̄` convention fixed as in its Message-4 correction):

| subset shape          | count | multiplet | Y (GUT) | Y (Q = T₃ + Y/2) |
|-----------------------|-------|-----------|---------|------------------|
| `∅`                   | 1     | `ν^c`     | `0`     | `0`              |
| `Λ²W̄₂` (e.g. `{3,4}`) | 1     | `e^c`     | `+1`    | `+2`             |
| `W̄₂ ⊗ W̄₃`            | 6     | `Q`       | `+1/6`  | `+1/3`           |
| `Λ²W̄₃`               | 3     | `u^c`     | `-2/3`  | `-4/3`           |
| `Λ²W̄₂ ⊗ Λ²W̄₃`        | 3     | `d^c`     | `+1/3`  | `+2/3`           |
| `W̄₂ ⊗ Λ³W̄₃`          | 2     | `L`       | `-1/2`  | `-1`             |

All sixteen states are accounted for, and the assignment matches the trusted
all-left-handed table of `PhysicsSM.StandardModel.OneGenerationTable` after
the normalization conversion `Y_{table} = 2 · Y_{GUT}`.

The witnesses of `PhysicsSM.Spinor.SpinorTenfoldPurity` plug in directly:
the Fock vacuum (subset `∅`) is the right-handed-neutrino direction `ν^c`,
and the second marked spinor `e₃ ∧ e₄` (subset `{3,4}`) is the positron
direction `e^c` — exactly the two `G_SM`-singlets of the `16`, which is why
they can be the Krasnov pair fixed by the Standard Model stabilizer.

## Proof engineering

Kernel reduction of `ℚ` arithmetic is unreliable under `decide` (rational
normalization uses well-founded `gcd` recursion), so the *primary*,
kernel-checked statements use the **integral hypercharge in units of `1/6`**
(`fockHypercharge6 : ℤ`, weak index `↦ +3`, color index `↦ -2`), where
`decide` over the 32 subsets works structurally. The physical `ℚ`-valued
statements are then derived algebraically.

## Claim boundary

This module proves the branching *bookkeeping* of the `16` under the chosen
index split. It does not construct the `Spin(10)` action, the subgroup
`S(U(2) × U(3))`, or prove that the stabilizer of the Krasnov pair realizes
these charges; those are future group-level targets.

## Sources

- Internal research notes: `Sources/Spin10_stabilizer.txt`, Proposition S3 and
  its Message-4 hypercharge-convention correction.
- Slansky, "Group theory for unified model building" (standard `16`
  branching).
- Provenance: clean-room formalization; table cross-checked against
  `PhysicsSM.StandardModel.OneGenerationTable`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.StandardModel.SpinorFockHypercharge

open PhysicsSM.StandardModel.OneGenerationTable

/-! ## Index weights and the hypercharge of a Fock state -/

/-- The set of color indices `{0, 1, 2}` (the conjugate color directions
`W̄₃` of the Krasnov normal form: the color axis `N₁ ∩ N₂` of the witness pair
in `PhysicsSM.Spinor.SpinorTenfoldPurity` is the matching `f₀, f₁, f₂` span). -/
def colorIndices : Finset (Fin 5) := {0, 1, 2}

/-- The set of weak indices `{3, 4}` (the conjugate weak directions `W̄₂`). -/
def weakIndices : Finset (Fin 5) := {3, 4}

/-- The hypercharge weight of a single Fock index in units of `1/6`
(GUT normalization): `+3` (i.e. `+1/2`) for weak indices, `-2` (i.e. `-1/3`)
for color indices. Working in sixths keeps everything in `ℤ`, where `decide`
reduces reliably in the kernel. -/
def indexHypercharge6 (i : Fin 5) : ℤ :=
  if 3 ≤ (i : ℕ) then 3 else -2

/-- The hypercharge of a Fock basis state in units of `1/6` (GUT
normalization): the sum of the weights of its indices. -/
def fockHypercharge6 (S : Finset (Fin 5)) : ℤ :=
  ∑ i ∈ S, indexHypercharge6 i

/-- The GUT-normalized (`ℚ`-valued) hypercharge of a Fock basis state.
The vacuum `∅` has hypercharge `0` (it is `ν^c`). -/
def fockHypercharge (S : Finset (Fin 5)) : ℚ :=
  (fockHypercharge6 S : ℚ) / 6

/-- Number of color indices occupied by a Fock state. -/
def colorCount (S : Finset (Fin 5)) : ℕ := (S ∩ colorIndices).card

/-- Number of weak indices occupied by a Fock state. -/
def weakCount (S : Finset (Fin 5)) : ℕ := (S ∩ weakIndices).card

/-! ## Classification of Fock states into Standard Model multiplets -/

/-- Classify an (even-cardinality) Fock basis state into its all-left-handed
Standard Model multiplet by its color/weak occupation numbers.

Odd-cardinality subsets are not in `S⁺`; they receive the junk value `nu_Rc`
and are excluded by the evenness hypothesis in every theorem below. -/
def toMultiplet (S : Finset (Fin 5)) : AllLeftMultiplet :=
  match colorCount S, weakCount S with
  | 0, 0 => .nu_Rc  -- Λ⁰: the Fock vacuum ν^c
  | 0, 2 => .e_Rc   -- Λ²(W̄₂): the positron e^c (the weakSpinor witness)
  | 1, 1 => .Q_L    -- W̄₂ ⊗ W̄₃: the quark doublet Q
  | 2, 0 => .u_Rc   -- Λ²(W̄₃): the up antiquark u^c
  | 2, 2 => .d_Rc   -- Λ²(W̄₂) ⊗ Λ²(W̄₃): the down antiquark d^c
  | 3, 1 => .L_L    -- W̄₂ ⊗ Λ³(W̄₃): the lepton doublet L
  | _, _ => .nu_Rc  -- unreachable for even subsets

/-- The all-left-handed hypercharge of a multiplet in units of `1/6` of the
GUT normalization, i.e. `3 ·` the `Q = T₃ + Y/2` value of
`PhysicsSM.StandardModel.OneGenerationTable` (see
`multipletHypercharge6_cast`). -/
def multipletHypercharge6 : AllLeftMultiplet → ℤ
  | .Q_L => 1     -- Y = +1/3,  GUT +1/6
  | .L_L => -3    -- Y = -1,    GUT -1/2
  | .u_Rc => -4   -- Y = -4/3,  GUT -2/3
  | .d_Rc => 2    -- Y = +2/3,  GUT +1/3
  | .e_Rc => 6    -- Y = +2,    GUT +1
  | .nu_Rc => 0   -- Y = 0

/-- Bridge to the trusted `ℚ`-valued table: the integral sixth-units value is
`3 ·` the `Q = T₃ + Y/2` hypercharge. -/
theorem multipletHypercharge6_cast (m : AllLeftMultiplet) :
    (multipletHypercharge6 m : ℚ) = 3 * m.hypercharge := by
  cases m <;> norm_num [multipletHypercharge6, AllLeftMultiplet.hypercharge]

/-! ## The sixteen states and their hypercharges -/

/-- The even-cardinality subsets (the Fock basis of `S⁺`) number exactly 16:
the `16` of `Spin(10)`. -/
theorem card_even_states :
    ((Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0)).card = 16 := by decide

/-- **The hypercharge table is physical** (kernel-checked integral form): for
every Fock basis state of `S⁺`, the sixth-units hypercharge of its Standard
Model multiplet equals its Fock hypercharge. -/
theorem hypercharge6_matches :
    ∀ S : Finset (Fin 5), S.card % 2 = 0 →
      multipletHypercharge6 (toMultiplet S) = fockHypercharge6 S := by decide

/-- **The hypercharge table is physical** (`ℚ` form, Proposition S3 of the
research notes): twice the GUT-normalized Fock hypercharge equals the
all-left-handed hypercharge of the state's multiplet in the `Q = T₃ + Y/2`
normalization of `PhysicsSM.StandardModel.OneGenerationTable`. -/
theorem hypercharge_matches (S : Finset (Fin 5)) (hS : S.card % 2 = 0) :
    (toMultiplet S).hypercharge = 2 * fockHypercharge S := by
  have h6 := hypercharge6_matches S hS
  have hq : ((multipletHypercharge6 (toMultiplet S) : ℤ) : ℚ)
      = ((fockHypercharge6 S : ℤ) : ℚ) := by
    exact_mod_cast h6
  rw [multipletHypercharge6_cast] at hq
  rw [fockHypercharge]
  linarith

/-- **The multiplicities are physical**: each Standard Model multiplet is
realized by exactly its number of Weyl states (`Q`: 6, `L`: 2, `u^c`: 3,
`d^c`: 3, `e^c`: 1, `ν^c`: 1) among the sixteen even Fock states. -/
theorem multiplicity_matches (m : AllLeftMultiplet) :
    ((Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0 ∧ toMultiplet S = m)).card = m.weylCount := by
  cases m <;> decide

/-- The Fock vacuum is the right-handed neutrino direction: the first marked
spinor (`vacuumSpinor` in `PhysicsSM.Spinor.SpinorTenfoldPurity`) carries the
quantum numbers of `ν^c`. -/
theorem toMultiplet_vacuum : toMultiplet ∅ = AllLeftMultiplet.nu_Rc := by decide

/-- The second marked spinor `e₃ ∧ e₄` (`weakSpinor` in
`PhysicsSM.Spinor.SpinorTenfoldPurity`) is the positron direction `e^c`. -/
theorem toMultiplet_weak :
    toMultiplet ({3, 4} : Finset (Fin 5)) = AllLeftMultiplet.e_Rc := by decide

theorem fockHypercharge_vacuum : fockHypercharge ∅ = 0 := by
  simp [fockHypercharge, fockHypercharge6]

theorem fockHypercharge6_weak :
    fockHypercharge6 ({3, 4} : Finset (Fin 5)) = 6 := by decide

/-- The second marked spinor has GUT hypercharge `+1`: it is the unit of the
hypercharge lattice, matching Remark S5 of the research notes ("hypercharge is
the projectiveness of the second spinor"). -/
theorem fockHypercharge_weak :
    fockHypercharge ({3, 4} : Finset (Fin 5)) = 1 := by
  rw [fockHypercharge, fockHypercharge6_weak]
  norm_num

/-- The vacuum and the weak witness are the only Standard Model singlets
(color-singlet, weak-singlet states) among the sixteen: the `ν^c` and `e^c`
directions. This is why precisely these two directions can be marked by a
`G_SM`-invariant Krasnov configuration. -/
theorem singlet_states :
    ((Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0 ∧ colorCount S = 0
        ∧ (weakCount S = 0 ∨ weakCount S = 2)))
      = ({∅, {3, 4}} : Finset (Finset (Fin 5))) := by decide

/-! ## Anomaly bookkeeping

Both the linear and the cubic hypercharge sums over the sixteen states vanish:
the `16` of `Spin(10)` is anomaly-free generation content. This complements
the rational anomaly package of
`PhysicsSM.StandardModel.AnomalyCancellation`. -/

/-- Kernel-checked integral form of the linear anomaly sum. -/
theorem hypercharge6_sum_zero :
    (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), fockHypercharge6 S) = 0 := by decide

/-- Kernel-checked integral form of the cubic anomaly sum. -/
theorem hypercharge6_cube_sum_zero :
    (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), (fockHypercharge6 S) ^ 3) = 0 := by decide

/-- The hypercharge trace over the sixteen states vanishes
(gravitational-`U(1)_Y` anomaly). -/
theorem hypercharge_sum_zero :
    (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), fockHypercharge S) = 0 := by
  unfold fockHypercharge
  rw [← Finset.sum_div, ← Int.cast_sum, hypercharge6_sum_zero, Int.cast_zero,
    zero_div]

/-- The cubic hypercharge sum over the sixteen states vanishes
(`U(1)_Y³` anomaly). -/
theorem hypercharge_cube_sum_zero :
    (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), (fockHypercharge S) ^ 3) = 0 := by
  have key : (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), ((fockHypercharge6 S : ℚ)) ^ 3) = 0 := by
    rw [show (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
        (fun S => S.card % 2 = 0), ((fockHypercharge6 S : ℚ)) ^ 3)
        = ((∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
            (fun S => S.card % 2 = 0), (fockHypercharge6 S) ^ 3 : ℤ) : ℚ) by
      push_cast
      rfl]
    rw [hypercharge6_cube_sum_zero, Int.cast_zero]
  unfold fockHypercharge
  simp only [div_pow]
  rw [← Finset.sum_div, key, zero_div]

end PhysicsSM.StandardModel.SpinorFockHypercharge
