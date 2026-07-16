import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.PlueckerPairGenerator
import PhysicsSM.Draft.NullEdge.HermitianPartitionPositive

/-!
# Central-shift / Gibbs-modular selection of the Plücker pair generator

This module connects the finite modular-selection engine of `ModularSelection`
to the **actual** interacting pair generator `Kop z` of `PlueckerPairGenerator`
(the even quartic CAR generator of the Paper E lane, whose cube closes
`Kop^3 = |z|^2 Kop`).

The Paper E lane states plainly that its two-particle generator is *supplied*,
not derived from the free carrier. This module sharpens "supplied" into
"selected as a conjugation/modular-flow generator by a balanced two-level
state": a finite selection theorem with a nondegenerate balance condition, an
asymmetry kill, a noncommutation control, and an explicit Gibbs-state
composition. It does **not** claim maximum-entropy uniqueness.

## Scope discipline (post cross-family audit, 2026-07-12)

The audited earlier draft over-read the algebra. Corrections carried here:

* the level parameters `a, b` are **real**, so `pairGGE` is genuinely Hermitian
  (`pairGGE_isHermitian`); the earlier complex version was not Hermitian;
* `Nlow, Nhigh` are **level projectors / constraint observables**, not conserved
  charges: for `z ≠ 0` they do not commute with the transfer
  (`level_projector_not_conserved`); only their sum is preserved on the pair
  sector;
* the generator theorem `pair_modular_selection` is a **central-shift selection**
  statement; the genuine **Gibbs modular flow** is the separate composed theorem
  `balanced_gibbs_modular_flow` (which does invoke `modular_flow_of_gibbs` with
  real `β, t`), and no uniqueness/max-entropy claim is made;
* the phase witness is about the **supplied** pair evolution `Uop`
  (`pair_evolution_phase_sensitive`); attaching it to the selected conjugation
  flow needs an exponential intertwiner `Uop = exp(-i α Kop)`, an explicit open
  successor, not claimed here;
* the classified family is the fixed transfer `z` with varying diagonal levels;
  for `z ≠ 0`, equality forces the scale `ν = 1`.

## Achievement status (post second cross-family audit, 2026-07-12)

This module is the kernel-clean **partial** result for the DYN-MODULAR-001 work
item, which asked for a *unique max-entropy Gibbs* state whose modular flow is
the pair evolution. Achieved and kernel-checked: balanced central-shift
selection, the asymmetry kill, the noncommutation control, Hermiticity,
partition nonvanishing, Gibbs-state certification, and the modular-Hamiltonian
flow composition. NOT achieved (recorded successors, and the reason the full
work item stays open pending a Research Director re-scope):

* **S1 (exponential intertwiner)**: `Uop = exp(-i α Kop)` on the pair sector, to
  attach `pair_evolution_phase_sensitive` to the selected flow.
* **S2 (max-entropy uniqueness)**: the balanced Gibbs state is the *unique*
  max-entropy state under the level + transfer constraints (finite GGE
  variational argument).

## The pair-sector picture

On the two occupation states `lowPair = {0,1}` and `highPair = {2,3}`, the
generator `Kop z` acts as the `2x2` Hermitian block `B z = !![0, z; conj z, 0]`,
the Paper A rest operator (see `kop_lowPair`, `kop_highPair`). Adding the two
occupation levels gives `pairGGE a b z = a • Nlow + b • Nhigh + B z`
(`a, b : ℝ`).

## Main results

* `pairGGE_isHermitian` : `pairGGE a b z` is Hermitian (`a, b` real).
* `pair_modular_selection` : `pairGGE a b z = ν • B z + d • 1` for some scalars
  `ν, d` -- the exact condition (via `ModularSelection.flow_scalar_shift`) for
  its conjugation flow to be the `B z`-generated pair evolution up to time
  rescaling and a central shift -- **iff** the two levels balance, `a = b`.
* `pair_flow_of_balance` : the forward conjugation-flow corollary at balance.
* `balanced_partition_ne_zero` and `balanced_gibbs_state_certified` : the
  balanced Hermitian generator has nonzero partition function, and its displayed
  modular Hamiltonian exponentiates to the normalized Gibbs state.
* `balanced_gibbs_modular_flow` : the modular-Hamiltonian flow of the *balanced*
  generator `pairGGE a a z` equals the `B z`-generated pair evolution with
  modular time `β` (composes `modular_flow_of_gibbs`; the `log Z` term drops out
  unconditionally). Together with `balanced_gibbs_state_certified`, this is a
  certified finite Gibbs-state modular flow. No uniqueness is claimed.
* `pair_selection_kill` : an asymmetric level pair (`a = 1, b = 0`) is provably
  not of the form `ν • B z + d • 1`.
* `level_projector_not_conserved` : for `z ≠ 0`, `B z` does not commute with
  `Nlow` -- the level projectors are constraints, not conserved charges.
* `pair_evolution_phase_sensitive` : the quarter-period **supplied** pair
  evolution `Uop 0 1`, read on the `lowPair→highPair` amplitude, separates the
  equal-modulus fields `z = 3+4i` and `z = 5` (`equal_modulus`): the supplied
  evolution reads `arg z`.
* `kop_lowPair` / `kop_highPair` : the bridge -- `Kop z` acts on the two pair
  basis states exactly as the block `B z`.

## Supplied-input ledger (honest scope)

* wedge coupling `z` (hence `B z`, `Kop z`): SUPPLIED (from Paper E; not derived).
* `Nlow, Nhigh`: level projectors / constraints (NOT conserved charges; see
  `level_projector_not_conserved`).
* `β`: real modular time rescale (used in `balanced_gibbs_modular_flow`).
* balance `a = b`: the SELECTION criterion; *why* a dynamics enforces it is not
  derived (the same open boundary as `equipartition_generator`).
* the state: finite Gibbs state; full-conjugation modular flow, not half-sided;
  no maximum-entropy uniqueness and no continuum thermal-time claim.

Provenance: clean-room composition over `ModularSelection` and
`PlueckerPairGenerator`; repaired after the Codex cross-family red-team
`AutonomousLab/work/NE-DYNAMICS/CODEX_RED_TEAM_DYN-MODULAR-001_2026-07-12.md`.
Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairModularSelection

open Matrix
open PhysicsSM.Draft.NullEdge.PlueckerPairGenerator
open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
open scoped BigOperators

/-! ## The pair-sector `2x2` generators -/

/-- The pair-sector rest block `B_z = [[0, z], [conj z, 0]]` (Paper A rest
operator; the `Kop z` block, see `kop_lowPair`/`kop_highPair`). -/
def Bz (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- Level projector onto `lowPair` (a constraint observable, not a conserved
charge; see `level_projector_not_conserved`). -/
def Nlow : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 0]

/-- Level projector onto `highPair`. -/
def Nhigh : Matrix (Fin 2) (Fin 2) ℂ := !![0, 0; 0, 1]

/-- The Hermitian pair-sector generator: two **real** occupation levels plus the
supplied pair transfer. -/
def pairGGE (a b : ℝ) (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (a : ℂ) • Nlow + (b : ℂ) • Nhigh + Bz z

/-- `pairGGE a b z` is Hermitian (the diagonal levels are real, the off-diagonal
transfer is `z / conj z`). -/
theorem pairGGE_isHermitian (a b : ℝ) (z : ℂ) :
    (pairGGE a b z)ᴴ = pairGGE a b z := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pairGGE, Bz, Nlow, Nhigh, Matrix.conjTranspose_apply, Matrix.add_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.of_apply, Complex.conj_ofReal]

/-! ## The rest-mass-is-area identity and its cube law -/

/-- **`B_z² = |z|² · 1` (the rest mass IS the area).**  The pair-sector rest
block squares to the area scalar `|z|² = z · conj z` times the identity -- the
finite avatar of Paper A's `B_z² = det P`, here at the `2x2` pair-sector level.
For two null spinors `det P = |z|²` is the squared Plücker area, so the squared
rest operator is exactly that area. -/
theorem Bz_sq (z : ℂ) :
    Bz z * Bz z = (z * (starRingEnd ℂ) z) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.smul_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.of_apply, mul_comm]

/-- **Rest-operator cube law `B_z³ = |z|² B_z`.**  Immediate from `Bz_sq`; this
is the `2x2` rest-operator instance of the shared cube-law closure that also
governs the interacting generator (`PlueckerPairGenerator.generator_cubed`,
`Kop³ = |z|² Kop`), cf. `CubeLawTripotent`. -/
theorem Bz_cube (z : ℂ) :
    Bz z * (Bz z * Bz z) = (z * (starRingEnd ℂ) z) • Bz z := by
  rw [Bz_sq, Matrix.mul_smul, Matrix.mul_one]

/-- The rest block `B_z` is Hermitian. -/
theorem Bz_isHermitian (z : ℂ) : (Bz z)ᴴ = Bz z := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.conjTranspose_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.of_apply]

/-- **At unit area the rest operator is a Hermitian involution (a reflection).**
When `|z|² = z · conj z = 1`, `B_z² = 1`; together with `Bz_isHermitian` this
makes the normalized rest operator a self-adjoint involution -- the reflection
structure behind the exactly-unitary null-step walk and the phase witness. -/
theorem Bz_involution (z : ℂ) (hz : z * (starRingEnd ℂ) z = 1) :
    Bz z * Bz z = 1 := by
  rw [Bz_sq, hz, one_smul]

/-! ## Central-shift selection, forward flow, and kill -/

/-- **Central-shift selection.**  The pair-sector generator is a central shift of
a multiple of `B z` -- the exact condition (via
`ModularSelection.flow_scalar_shift`) for its conjugation flow to be the
`B z`-generated pair evolution -- **iff** the two levels balance. (Parallel to
`ModularSelection.equipartition_generator`.) -/
theorem pair_modular_selection (a b : ℝ) (z : ℂ) :
    (∃ ν d : ℂ, pairGGE a b z = ν • Bz z + d • (1 : Matrix (Fin 2) (Fin 2) ℂ))
      ↔ a = b := by
  constructor
  · rintro ⟨ν, d, h⟩
    have e00 : (pairGGE a b z) 0 0
        = (ν • Bz z + d • (1 : Matrix (Fin 2) (Fin 2) ℂ)) 0 0 := by rw [h]
    have e11 : (pairGGE a b z) 1 1
        = (ν • Bz z + d • (1 : Matrix (Fin 2) (Fin 2) ℂ)) 1 1 := by rw [h]
    simp only [pairGGE, Bz, Nlow, Nhigh, Matrix.add_apply, Matrix.smul_apply,
      Matrix.one_apply_eq, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.of_apply, smul_eq_mul, mul_zero, mul_one, add_zero, zero_add]
      at e00 e11
    have hcast : (a : ℂ) = (b : ℂ) := by rw [e00, e11]
    exact_mod_cast hcast
  · rintro rfl
    refine ⟨1, (a : ℂ), ?_⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [pairGGE, Bz, Nlow, Nhigh, Matrix.add_apply, Matrix.smul_apply,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.of_apply]

/-- **Forward conjugation-flow corollary.**  A balanced generator gives a
`B z`-generated conjugation flow: the central level shift is invisible. -/
theorem pair_flow_of_balance (a : ℝ) (z t : ℂ) (X : Matrix (Fin 2) (Fin 2) ℂ) :
    NormedSpace.exp (t • pairGGE a a z) * X * NormedSpace.exp ((-t) • pairGGE a a z)
      = NormedSpace.exp (t • Bz z) * X * NormedSpace.exp ((-t) • Bz z) := by
  have hsplit : pairGGE a a z = Bz z + (a : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [pairGGE, Bz, Nlow, Nhigh, Matrix.add_apply, Matrix.smul_apply,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.of_apply]
  rw [hsplit]
  exact ModularSelection.flow_scalar_shift (Bz z) X (a : ℂ) t

/-- **Modular-Hamiltonian flow at balance.**  The flow generated by the modular
Hamiltonian of the *balanced* generator `pairGGE a a z` -- i.e. `modFlow`, which
conjugates by `exp(-it · modHam)` with `modHam = β·(pairGGE a a z) + (log Z)•1` --
equals the `B z`-generated pair evolution with modular time `β`.  Composes
`ModularSelection.modular_flow_of_gibbs` with `pair_flow_of_balance`; the central
`log Z` term drops out, so the identity holds unconditionally.

The separate theorems `balanced_partition_ne_zero` and
`balanced_gibbs_state_certified` certify that the displayed modular Hamiltonian
really exponentiates to the normalized finite Gibbs state. No maximum-entropy
uniqueness is claimed. -/
theorem balanced_gibbs_modular_flow (a : ℝ) (z : ℂ) (β t : ℝ)
    (X : Matrix (Fin 2) (Fin 2) ℂ) :
    ModularSelection.modFlow (pairGGE a a z) β t X
      = NormedSpace.exp ((-(Complex.I * (β : ℂ) * (t : ℂ))) • Bz z) * X
          * NormedSpace.exp ((Complex.I * (β : ℂ) * (t : ℂ)) • Bz z) := by
  rw [ModularSelection.modular_flow_of_gibbs]
  have h := pair_flow_of_balance a z (-(Complex.I * (β : ℂ) * (t : ℂ))) X
  simpa using h

/-- The balanced Hermitian pair generator has a nonzero finite partition
function for every real inverse-temperature parameter. -/
theorem balanced_partition_ne_zero (a : ℝ) (z : ℂ) (β : ℝ) :
    ModularSelection.partition (pairGGE a a z) β ≠ 0 := by
  simpa [ModularSelection.partition, ModularSelection.gibbsWeight] using
    HermitianPartitionPositive.hermitian_partition_ne_zero
      (pairGGE a a z) (pairGGE_isHermitian a a z) β

/-- The displayed modular Hamiltonian for the balanced pair generator really
exponentiates to its normalized finite Gibbs state. This certifies the state
reading of `balanced_gibbs_modular_flow`; it does not prove maximum-entropy
uniqueness. -/
theorem balanced_gibbs_state_certified (a : ℝ) (z : ℂ) (β : ℝ) :
    NormedSpace.exp (-(ModularSelection.modHam (pairGGE a a z) β))
      = ModularSelection.gibbsState (pairGGE a a z) β :=
  ModularSelection.gibbs_modHam_exp
    (pairGGE a a z) β (balanced_partition_ne_zero a z β)

/-- **Kill.**  An asymmetric level pair is not a central shift of `B z`, so its
conjugation flow is not the pure pair evolution. -/
theorem pair_selection_kill (z : ℂ) :
    ¬ ∃ ν d : ℂ, pairGGE 1 0 z = ν • Bz z + d • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  rw [pair_modular_selection]
  exact (by norm_num : (1 : ℝ) ≠ 0)

/-- **Noncommutation control.**  For `z ≠ 0`, the transfer `B z` does not commute
with the level projector `Nlow`: the individual level projectors are constraints,
not conserved charges of the pair transfer. -/
theorem level_projector_not_conserved (z : ℂ) (hz : z ≠ 0) :
    Bz z * Nlow ≠ Nlow * Bz z := by
  intro h
  have h10 := congrFun (congrFun h 1) 0
  simp [Bz, Nlow, Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply] at h10
  exact hz (by simpa using (starRingEnd ℂ).injective (by simpa using h10))

/-- The two level projectors sum to the identity on the pair sector. -/
theorem level_projectors_sum_one :
    (Nlow + Nhigh : Matrix (Fin 2) (Fin 2) ℂ) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Nlow, Nhigh, Matrix.add_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.of_apply]

/-- **Total-number conservation (positive complement of the control).**  Although
neither level projector is individually conserved (`level_projector_not_conserved`),
their sum -- the total occupation on the pair sector -- commutes with the transfer
`B z` for every `z`.  This is the explicit commutation theorem behind "only the
total is conserved": the level projectors are constraints, the total number is the
genuine conserved charge. -/
theorem total_number_conserved (z : ℂ) :
    Bz z * (Nlow + Nhigh) = (Nlow + Nhigh) * Bz z := by
  rw [level_projectors_sum_one, mul_one, one_mul]

/-! ## Operational phase witness (about the SUPPLIED evolution) -/

/-- **Phase-sensitive supplied-evolution witness.**  The quarter-period pair
evolution `Uop 0 1` (the closed form of the supplied `Kop z` one-parameter
group), read on the `lowPair→highPair` amplitude with input `basisVec lowPair`,
distinguishes the two equal-modulus fields `z = 3+4i` and `z = 5`
(`equal_modulus`).  A `|z|`-only description cannot see the difference; the
supplied evolution reads `arg z`.

Scope: this is a witness about the supplied evolution `Uop`, not yet about the
selected conjugation/modular flow; linking the two needs an exponential
intertwiner `Uop = exp(-i α Kop)` (an explicit open successor). -/
theorem pair_evolution_phase_sensitive :
    Uop 0 1 (3 + 4 * Complex.I) 5 (basisVec lowPair) highPair
      ≠ Uop 0 1 (5 : ℂ) 5 (basisVec lowPair) highPair := by
  rw [Uop_high, Uop_high]
  simp only [basisVec, lowPair, highPair]
  norm_num [Complex.ext_iff, lowPair, highPair]

/-- The two witness fields share the same modulus, so a `|z|`-only description
cannot separate them: `pair_evolution_phase_sensitive` is a genuine phase
reading. -/
theorem equal_modulus :
    (3 + 4 * Complex.I) * (starRingEnd ℂ) (3 + 4 * Complex.I) = 25
      ∧ (5 : ℂ) * (starRingEnd ℂ) (5 : ℂ) = 25 := by
  constructor <;> simp [Complex.ext_iff] <;> norm_num

/-! ## Bridge to the actual generator `Kop` -/

/-- Bridge: `Kop z` sends `basisVec highPair` to `z • basisVec lowPair`
(the `(lowPair, highPair)` block entry is `z`). -/
theorem kop_highPair (z : ℂ) :
    Kop z (basisVec highPair) = z • basisVec lowPair := by
  funext S
  rw [Kop_apply]
  by_cases h1 : S = lowPair
  · subst h1; simp +decide [basisVec, Pi.smul_apply, smul_eq_mul]
  · by_cases h2 : S = highPair
    · subst h2; simp +decide [basisVec, Pi.smul_apply, smul_eq_mul]
    · simp [h1, h2, basisVec, Pi.smul_apply, smul_eq_mul]

/-- Bridge: `Kop z` sends `basisVec lowPair` to `conj z • basisVec highPair`
(the `(highPair, lowPair)` block entry is `conj z`). -/
theorem kop_lowPair (z : ℂ) :
    Kop z (basisVec lowPair) = (starRingEnd ℂ) z • basisVec highPair := by
  funext S
  rw [Kop_apply]
  by_cases h1 : S = lowPair
  · subst h1; simp +decide [basisVec, Pi.smul_apply, smul_eq_mul]
  · by_cases h2 : S = highPair
    · subst h2; simp +decide [basisVec, Pi.smul_apply, smul_eq_mul]
    · simp [h1, h2, basisVec, Pi.smul_apply, smul_eq_mul]

/-! ## Build-enforced assumption-footprint guards (standard three axioms only) -/

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.pairGGE_isHermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairGGE_isHermitian

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.Bz_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bz_sq

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.Bz_cube' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bz_cube

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.Bz_involution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bz_involution

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.pair_modular_selection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pair_modular_selection

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.pair_flow_of_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pair_flow_of_balance

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.balanced_gibbs_modular_flow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms balanced_gibbs_modular_flow

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.balanced_partition_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms balanced_partition_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.balanced_gibbs_state_certified' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms balanced_gibbs_state_certified

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.pair_selection_kill' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pair_selection_kill

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.level_projector_not_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms level_projector_not_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.total_number_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms total_number_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.pair_evolution_phase_sensitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pair_evolution_phase_sensitive

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.kop_highPair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kop_highPair

/-- info: 'PhysicsSM.Draft.NullEdge.PairModularSelection.kop_lowPair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kop_lowPair

end PhysicsSM.Draft.NullEdge.PairModularSelection
