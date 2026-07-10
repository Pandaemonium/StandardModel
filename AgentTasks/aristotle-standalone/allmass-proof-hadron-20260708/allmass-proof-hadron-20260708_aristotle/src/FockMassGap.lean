import Mathlib

/-!
# The finite second-quantized mass gap (free `dΓ` gap = one-particle gap)

This module lands the *second-quantized* mass gap that was previously missing
from the finite Fock program.  Everything kernel-checked before this file was
**first-quantized**: the carrier `D` is a one-particle operator, and "mass" is
the least eigenvalue of a compressed sector form `B(lam, kappa)`, with squared
mass gap `lam - kappa > 0` (aperture minus closure).  There was no many-body
ground state and no gap above a second-quantized vacuum.

Here we build the finite fermionic Fock model in the diagonal (occupation)
basis, define the free many-body Hamiltonian `dΓ(B)` as the second quantization
of the one-particle form, and prove the flagship finite theorem:

> **The free second-quantized mass gap equals the one-particle gap `lam - kappa`.**
> The many-body ground energy is `0` (the empty/vacuum state) and the first
> excited energy is `lam - kappa` (a single particle in the ground mode), so
> `massGap = firstExcitedEnergy - groundEnergy = lam - kappa`.

See `secondQuantized_massGap`.

## 1. The finite second-quantized types

We model the one-particle sector by its `N` energy eigenvalues
`d : Fin N → ℝ` (the diagonalization of the Hermitian one-particle form `B`;
the physical-sector spectrum, so `d i ≥ lam - kappa` with the minimum attained).
Passing to a diagonal one-particle basis is WLOG for a Hermitian `B` and makes
the free `dΓ` fully explicit.

The **fermionic Fock space** `⊕_k Λ^k(sector)` has an occupation basis indexed by
occupation vectors `occ : Fin N → Bool` (bit `i` = "mode `i` occupied").  The
degree-`k` summand `Λ^k` corresponds to the `occ` with exactly `k` set bits, so
`Fin N → Bool ≃ ⊕_k Λ^k(sector)` as index sets of the diagonal basis.  This is
the concrete finite shadow of the `ExteriorAlgebra` / `⨁ n, ⋀[K]^n W`
construction used in `FockQuotientPairing` / `FockGradedRadical`; here we only
need the eigenvalues of the *diagonal* second-quantized operator, so we work
directly on the occupation basis rather than re-deriving the exterior algebra.

The **free many-body Hamiltonian** `dΓ(B)` acts diagonally on the occupation
basis: on `occ` it multiplies by the sum of the occupied one-particle
eigenvalues (`fockEnergy`).  This is exactly the standard second quantization of
a one-body operator restricted to its own eigenbasis.

## 2. The sharpest true statement (delivered as kernel Lean)

`secondQuantized_massGap`:  for the physical spectrum `d` with
`d i ≥ lam - kappa` (`kappa < lam`) and the gap attained at some mode `i₀`,

  `massGap d = lam - kappa`.

The ingredients (`ground_isLeast`, `excited_isLeast`) are themselves clean
`IsLeast` statements about the many-body spectrum, so the gap is a genuine
"first excited minus ground", not a definitional artefact.

## 3. Free vs. interacting boundary (the line, and the seed)

Everything above is the **free** `dΓ(B)`: the many-body spectrum is the set of
subset-sums of `d`, so the two-particle energy is *exactly* the sum of its two
constituents (`fockEnergy_twoParticle`).  A genuine **hadron** mass is a bound
state whose mass is **strictly below** the sum of its constituents; this is
impossible for the free `dΓ(B)` and requires a genuine interaction term
`V` in `dΓ(B) + V`.

The block-level binding defect `Delta = -kappa` (already kernel-proved
first-quantized) is the right seed: adding it to the free two-body threshold
`d i + d j` produces an energy strictly below threshold exactly when `kappa > 0`
(`twoBody_bound_below_threshold`).  This is the honest finite witness of "mass ≠
sum of constituents"; it is NOT yet a hadron, because `Delta` here is inserted by
hand rather than derived as the least eigenvalue of an interacting two-body
operator on `Λ^2(sector)`.  That derivation is the open/hard step (see the
blocker in the module footer).

Provenance: clean-room finite formalization succeeding the Q08 first-quantized
mass-gap and the `FockQuotientPairing` / `FockGradedRadical` Fock modules.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.FockMassGap

variable {N : ℕ}

/-! ## The finite Fock occupation basis and the free `dΓ` energy -/

/-- An occupation basis vector of the finite fermionic Fock space
`⊕_k Λ^k(sector)`: bit `i` records whether one-particle mode `i` is occupied. -/
abbrev FockState (N : ℕ) := Fin N → Bool

/-- The free many-body Hamiltonian `dΓ(B)` in the diagonal (occupation) basis:
its eigenvalue on `occ` is the sum of the occupied one-particle eigenvalues.
Here `d : Fin N → ℝ` is the spectrum of the Hermitian one-particle form `B`. -/
def fockEnergy (d : Fin N → ℝ) (occ : FockState N) : ℝ :=
  ∑ i, if occ i then d i else 0

/-- The Fock vacuum: no modes occupied. -/
def vacuum : FockState N := fun _ => false

/-- The one-particle state with a single particle in mode `i₀`. -/
def singleParticle (i₀ : Fin N) : FockState N := fun i => decide (i = i₀)

/-- The two-particle state occupying distinct modes `i` and `j`. -/
def twoParticle (i j : Fin N) : FockState N := fun k => decide (k = i ∨ k = j)

/-- The excited spectrum of `dΓ(B)`: the many-body energies of all non-vacuum
(at least one particle) Fock states. -/
def excitedSpectrum (d : Fin N → ℝ) : Set ℝ :=
  {e | ∃ occ : FockState N, (∃ i, occ i = true) ∧ fockEnergy d occ = e}

/-! ## Basic energies -/

/-- The vacuum has zero energy: `dΓ(B)` annihilates the Fock vacuum. -/
theorem fockEnergy_vacuum (d : Fin N → ℝ) : fockEnergy d vacuum = 0 := by
  simp [fockEnergy, vacuum]

/-- A single particle in mode `i₀` has energy `d i₀`, the one-particle eigenvalue. -/
theorem fockEnergy_singleParticle (d : Fin N → ℝ) (i₀ : Fin N) :
    fockEnergy d (singleParticle i₀) = d i₀ := by
  simp [fockEnergy, singleParticle]

/-- Two particles in distinct modes have energy `d i + d j`: for the *free*
`dΓ(B)` the two-body energy is exactly the sum of the constituents (no binding). -/
theorem fockEnergy_twoParticle (d : Fin N → ℝ) (i j : Fin N) (hij : i ≠ j) :
    fockEnergy d (twoParticle i j) = d i + d j := by
  unfold fockEnergy
  rw [show (fun k => if twoParticle i j k then d k else 0)
        = (fun k => if (k = i ∨ k = j) then d k else 0) from by
      funext k; by_cases h : (k = i ∨ k = j) <;> simp [twoParticle, h]]
  rw [Finset.sum_ite, Finset.sum_const_zero, add_zero]
  have hset : (Finset.univ.filter (fun k => k = i ∨ k = j)) = {i, j} := by
    ext k; simp [and_or_left]
  rw [hset, Finset.sum_pair hij]

/-- With a nonnegative one-particle spectrum, every many-body energy is
nonnegative: the vacuum is a genuine ground state. -/
theorem fockEnergy_nonneg (d : Fin N → ℝ) (hd : ∀ i, 0 ≤ d i) (occ : FockState N) :
    0 ≤ fockEnergy d occ := by
  apply Finset.sum_nonneg
  intro i _
  by_cases h : occ i <;> simp [h, hd i]

/-- Lower bound on any excited energy: if every one-particle eigenvalue is at
least the gap `g ≥ 0`, then any state with at least one particle has energy
at least `g`. -/
theorem fockEnergy_excited_lb (d : Fin N → ℝ) (g : ℝ) (hg : 0 ≤ g)
    (hlb : ∀ i, g ≤ d i) (occ : FockState N) (hocc : ∃ i, occ i = true) :
    g ≤ fockEnergy d occ := by
  obtain ⟨i₁, hi₁⟩ := hocc
  have hnn : ∀ i ∈ Finset.univ, (0 : ℝ) ≤ (if occ i then d i else 0) := by
    intro i _
    by_cases h : occ i
    · simp [h]; exact le_trans hg (hlb i)
    · simp [h]
  have hsum := Finset.single_le_sum hnn (Finset.mem_univ i₁)
  simp [hi₁] at hsum
  exact le_trans (hlb i₁) hsum

/-! ## Ground state and first excited state as least energies -/

/-- **Ground state.**  With a nonnegative one-particle spectrum, the many-body
ground energy is `0`, attained by the Fock vacuum, and it is the least of the
entire many-body spectrum. -/
theorem ground_isLeast (d : Fin N → ℝ) (hd : ∀ i, 0 ≤ d i) :
    IsLeast (Set.range (fockEnergy d)) 0 := by
  refine ⟨⟨vacuum, fockEnergy_vacuum d⟩, ?_⟩
  rintro e ⟨occ, rfl⟩
  exact fockEnergy_nonneg d hd occ

/-- **First excited state.**  If the gap `g = lam - kappa ≥ 0` bounds the
one-particle spectrum from below and is attained at mode `i₀`, then the least
excited many-body energy is exactly `g`, attained by a single particle in the
ground mode `i₀`. -/
theorem excited_isLeast (d : Fin N → ℝ) (g : ℝ) (hg : 0 ≤ g)
    (hlb : ∀ i, g ≤ d i) (i₀ : Fin N) (hi₀ : d i₀ = g) :
    IsLeast (excitedSpectrum d) g := by
  refine ⟨⟨singleParticle i₀, ⟨i₀, ?_⟩, ?_⟩, ?_⟩
  · simp [singleParticle]
  · rw [fockEnergy_singleParticle, hi₀]
  · rintro e ⟨occ, hocc, rfl⟩
    exact fockEnergy_excited_lb d g hg hlb occ hocc

/-! ## The second-quantized mass gap -/

/-- The many-body ground energy of the free `dΓ(B)`. -/
noncomputable def groundEnergy (d : Fin N → ℝ) : ℝ := sInf (Set.range (fockEnergy d))

/-- The first excited many-body energy of the free `dΓ(B)`. -/
noncomputable def firstExcitedEnergy (d : Fin N → ℝ) : ℝ := sInf (excitedSpectrum d)

/-- The finite second-quantized mass gap: first excited minus ground energy. -/
noncomputable def massGap (d : Fin N → ℝ) : ℝ := firstExcitedEnergy d - groundEnergy d

/-- **Flagship: the free second-quantized mass gap equals the one-particle gap.**

Given the physical-sector one-particle spectrum `d` with squared-mass gap
`lam - kappa > 0` bounding it from below and attained at some mode `i₀`, the
second-quantized many-body mass gap of the free Hamiltonian `dΓ(B)` is exactly
`lam - kappa`:

  ground energy `= 0` (vacuum),  first excited `= lam - kappa` (one particle in
  the ground mode),  so  `massGap = lam - kappa`. -/
theorem secondQuantized_massGap (d : Fin N → ℝ) (lam kappa : ℝ) (hgap : kappa < lam)
    (hlb : ∀ i, lam - kappa ≤ d i) (i₀ : Fin N) (hi₀ : d i₀ = lam - kappa) :
    massGap d = lam - kappa := by
  have hg : 0 ≤ lam - kappa := by linarith
  have hd : ∀ i, 0 ≤ d i := fun i => le_trans hg (hlb i)
  have h0 : groundEnergy d = 0 := (ground_isLeast d hd).csInf_eq
  have h1 : firstExcitedEnergy d = lam - kappa :=
    (excited_isLeast d (lam - kappa) hg hlb i₀ hi₀).csInf_eq
  simp [massGap, h0, h1]

/-! ## The interacting seed (free-vs-interacting boundary)

The free `dΓ(B)` two-body energy is *exactly* `d i + d j`
(`fockEnergy_twoParticle`), so no bound state below threshold exists for the free
theory.  A genuine hadron mass needs an interaction.  The block-level binding
defect `Delta = -kappa` is the seed: added to the free threshold it produces a
two-body energy strictly below the sum of the constituents exactly when
`kappa > 0`. -/

/-- **Interacting seed / mass defect witness.**  Perturbing the free two-body
threshold `d i + d j` by the binding defect `Delta = -kappa` gives a two-body
energy strictly below the sum of the constituents whenever the closure defect
`kappa` is positive.  This is the honest finite witness of "bound-state mass ≠
sum of constituents"; turning `Delta` into the *proved* least eigenvalue of an
interacting two-body operator on `Λ²(sector)` is the open step. -/
theorem twoBody_bound_below_threshold (d : Fin N → ℝ) (i j : Fin N)
    (kappa : ℝ) (hk : 0 < kappa) :
    (fockEnergy d (twoParticle i j) + (-kappa)) <
      fockEnergy d (twoParticle i j) := by
  linarith

/-! ## Feasibility, ranked sub-lemmas, and the blocker

**Feasibility.**  The free second-quantized gap (`secondQuantized_massGap`) is
fully landed above — it is elementary finite convex geometry (subset-sums of a
bounded-below spectrum) once the diagonal `dΓ` is used.  The interacting
bound-state hadron mass is *not* landed and is genuinely hard.

**Ranked sub-lemmas (done → open).**
1. `fockEnergy_vacuum`, `fockEnergy_singleParticle` — trivial. ✓
2. `fockEnergy_nonneg`, `fockEnergy_excited_lb` — finite `Finset.sum` bounds. ✓
3. `ground_isLeast`, `excited_isLeast` — `IsLeast` of the many-body spectrum. ✓
4. `secondQuantized_massGap` — the flagship free gap. ✓
5. `fockEnergy_twoParticle`, `twoBody_bound_below_threshold` — the free/interacting
   boundary and the mass-defect seed. ✓
6. (open) Build the interacting two-body operator `H₂ = dΓ(B)|_{Λ²} + V` with
   `V` seeded by `Delta = -kappa`, as a Hermitian form on `Λ²(sector)`.
7. (open) Prove `H₂` has a least eigenvalue strictly below the two-particle
   free threshold `min_{i≠j}(d i + d j)` (a genuine bound state).
8. (open) Identify that eigenvalue with a hadron mass and show it is a `dΓ`
   invariant, not `= d i + d j`.

**The blocker.**  Steps 6–8 need a finite spectral theorem for the *interacting*
two-body form on `Λ²(sector)`: constructing `V` from the first-quantized binding
defect and proving its least eigenvalue dips below the free threshold.  Mathlib
has `ExteriorAlgebra`, `⋀[K]^n`, `exteriorPower.pairingDual`, and the Hermitian
`LinearMap.IsSymm`/spectral API, but there is no packaged "least eigenvalue of a
compressed interacting form is below the sum of one-particle eigenvalues"
result; that variational/min-max estimate must be built. Until then, only the
free gap (= one-particle gap) is earned; the interacting hadron mass is open.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockMassGap.secondQuantized_massGap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms secondQuantized_massGap

end PhysicsSM.Draft.NullEdge.Carrier.FockMassGap
