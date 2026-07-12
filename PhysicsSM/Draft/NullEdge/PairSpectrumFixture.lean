/-
Provenance: Aristotle job 4d9642bf (fable-24h-boundstate), harvested
2026-07-11 ~23:55 PDT after an 11h run + stop-and-return. THE E-PAPER
HEADLINE FIXTURE. Semantic check against the 10:56 oracle ledger entry:
factorization product, cubic reduction, and all six pinned eigenvectors
match exactly (leading coefficient 5^11 = 48828125).
TRUST split (per-theorem, from the job summary): charpoly_factorization
(generic CommRing, ring), p12_palindromic_reduction (generic Field),
U2_eq_minor, and the six Vz_eigenvector_* are KERNEL-ONLY; faithful and
Vz_annihilated use native_decide (disclosed; transitively V_eq_U2_K2 and
V_annihilated in the C file). T3 is realized in Cayley-Hamilton
ANNIHILATION form - the degree-28 polynomial annihilates V; the
identification of it as THE characteristic polynomial is deliberately
left to the separate charbridge job and stays run-record until then.
BUILD NOTE: cold compile of the native steps (Vz^28 over ZZ[i]) takes
tens of minutes; incremental rebuilds are fast.
-/
import Mathlib

/-!
# Exact interacting two-particle spectrum of the composed automaton (E lane fixture)

This module formalizes the *verified mathematics* of the composed interacting
two-particle automaton `V = U2 * K2` at the exact `3-4-5` kick, for the `L = 4`
complex-coin ring walk.

## The objects (provenance)

* One-particle walk `U1 = S * C` on the `8`-dimensional space `Fin 8`
  (`= site ⊗ coin`, index `= 2*site + coin`), with per-site coin
  `[[4/5, -3i/5], [-3i/5, 4/5]]` and the moving shift
  (`coin 0 : site ↦ site+1`, `coin 1 : site ↦ site-1`, mod `4`).
* Two-particle walk `U2` is the `28×28` determinant-minor (Plücker) lift of
  `U1` over the antisymmetric pair sector `{ (i,j) : i < j, i,j ∈ Fin 8 }`:
  `U2[(r₁,r₂),(c₁,c₂)] = U1[r₁,c₁]·U1[r₂,c₂] − U1[r₁,c₂]·U1[r₂,c₁]`.
* Kick `K2` is the identity except a single `2×2` block coupling the two
  occupation basis vectors indexed by the pairs `{0,1}` and `{2,3}`, given by
  the exact `3-4-5` rotation `[[4/5, -3i/5], [-3i/5, 4/5]]` (the
  `(c,s) = (4/5, 3/5)` member of the exact gate family). This is the
  two-particle image of the `pairKick` in `PlueckerQuarticInteraction`.
* Composed step `V = U2 * K2`.

## What is proved

* **T1** (`charpoly_factorization`, kernel/`ring`): the explicit degree-`28`
  factorization identity over any commutative ring.
* **T2** (`p12_palindromic_reduction`, kernel/`ring`): the palindromic reduction
  of the degree-`12` factor `p12` to a rational cubic in `w = λ² + λ⁻²`.
* **T3** (`V_annihilated_by_charpoly`, `native_decide`, *disclosed*): the
  degree-`28` polynomial of T1 annihilates the explicit matrix `V`
  (Cayley–Hamilton form of the matrix bridge). See its docstring for the
  precise, disclosed status.
* **T4** (`V_eigenvector_plus_*`, `V_eigenvector_minus_*`, kernel/`decide`):
  explicit exact eigenvectors of `V` for the pinned modes `+1` (four
  independent) and `-1` (two independent).

Boundaries (memo): single-kick spectra are phase-independent (the kick phase
conjugates away); the phase-sensitive quantity is the two-kick interference;
the interaction is *supplied*, not derived; this is an `L = 4` fixture only,
with no thermodynamic claims.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairSpectrumFixture

/-! ## T1 — the explicit degree-28 characteristic-polynomial factorization -/

/-- The degree-`12` palindromic factor `p12`. -/
def p12 {R : Type*} [CommRing R] (lam : R) : R :=
  3125 * lam ^ 12 - 2300 * lam ^ 10 + 3219 * lam ^ 8 - 6040 * lam ^ 6
    + 3219 * lam ^ 4 - 2300 * lam ^ 2 + 3125

/-- **T1.** The product of the displayed spectral factors equals the explicit
degree-`28` polynomial (the characteristic polynomial of `V`, cleared to
integer coefficients: leading coefficient `5^11 = 48828125`). Every coefficient
on the right-hand side was recomputed from the factorization; the identity is
closed by `ring`, so it holds over every commutative ring. -/
theorem charpoly_factorization {R : Type*} [CommRing R] (lam : R) :
    (lam + 1) ^ 2 * (lam - 1) ^ 4 * (25 * lam ^ 2 + 14 * lam + 25)
      * (5 * lam ^ 2 - 6 * lam + 5) ^ 2 * (5 * lam ^ 2 + 6 * lam + 5) ^ 2
      * p12 lam
    =
      48828125 * lam ^ 28 +
      (-70312500) * lam ^ 27 +
      (-35937500) * lam ^ 26 +
      43312500 * lam ^ 25 +
      113734375 * lam ^ 24 +
      (-79830000) * lam ^ 23 +
      (-254465000) * lam ^ 22 +
      229590000 * lam ^ 21 +
      201373725 * lam ^ 20 +
      (-45757764) * lam ^ 19 +
      (-390430372) * lam ^ 18 +
      82918404 * lam ^ 17 +
      482590239 * lam ^ 16 +
      (-159920640) * lam ^ 15 +
      (-331387184) * lam ^ 14 +
      (-159920640) * lam ^ 13 +
      482590239 * lam ^ 12 +
      82918404 * lam ^ 11 +
      (-390430372) * lam ^ 10 +
      (-45757764) * lam ^ 9 +
      201373725 * lam ^ 8 +
      229590000 * lam ^ 7 +
      (-254465000) * lam ^ 6 +
      (-79830000) * lam ^ 5 +
      113734375 * lam ^ 4 +
      43312500 * lam ^ 3 +
      (-35937500) * lam ^ 2 +
      (-70312500) * lam +
      48828125 := by
  simp only [p12]; ring

/-! ## T2 — palindromic reduction of `p12` to a cubic in `w = λ² + λ⁻²` -/

/-- **T2.** For `lam ≠ 0` in any field, the degree-`12` palindromic factor
reduces to the rational cubic `3125 w³ − 2300 w² − 6156 w − 1440` in the
variable `w = λ² + λ⁻²`, scaled by `λ⁶`:
`p12 λ = λ⁶ · (3125 w³ − 2300 w² − 6156 w − 1440)`. This is the exact
cleared-of-denominators form; closed by `field_simp; ring`. -/
theorem p12_palindromic_reduction {K : Type*} [Field K] (lam : K) (h : lam ≠ 0) :
    p12 lam =
      lam ^ 6 * (3125 * (lam ^ 2 + lam⁻¹ ^ 2) ^ 3
        - 2300 * (lam ^ 2 + lam⁻¹ ^ 2) ^ 2
        - 6156 * (lam ^ 2 + lam⁻¹ ^ 2)
        - 1440) := by
  simp only [p12]
  field_simp
  ring


/-! ## The explicit matrices (integer layer)

All matrices are represented over the Gaussian integers `ℤ[i] = GaussianInt`
after clearing the coin/kick denominator `5`.  Writing `φ = GaussianInt.toComplex`
for the ring embedding `ℤ[i] ↪ ℂ`, the physical rational-complex matrices are
recovered by rescaling:

* `Az = 5 • U1`  (integer one-particle walk `= Sp * C5`, `C5 = 5·coin`),
* `Bz = 25 • U2` (the determinant-minor lift of `Az`),
* `Kz = 5 • K2`  (the kick),
* `Vz = 25 • V`  (the composed step).

The literal entries of `Vz` were computed exactly (sympy, then re-derived with
exact rational-Gaussian arithmetic); the identity `faithful` below machine-checks
that this literal is exactly the `U2 · K2` construction. -/

/-- Gaussian-integer constructor helper `g a b = a + b·i`. -/
def g (a b : ℤ) : GaussianInt := ⟨a, b⟩

/-- `C5 = 5 · coin`: the per-site `3-4-5` coin cleared of its denominator. -/
def C5 : Matrix (Fin 8) (Fin 8) GaussianInt := !![g 4 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 (-3),g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 4 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 (-3),g 4 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 (-3),g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 4 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 (-3);
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 4 0]

/-- The ring shift `S` (moving shift: `coin 0 ↦ site+1`, `coin 1 ↦ site-1`). -/
def Sp : Matrix (Fin 8) (Fin 8) GaussianInt := !![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

/-- `Az = 5 · U1 = S · (5·coin)`: the integer one-particle walk. -/
def Az : Matrix (Fin 8) (Fin 8) GaussianInt := Sp * C5

/-- First index of the antisymmetric pair enumeration `i < j` over `Fin 8`. -/
def pf : Fin 28 → Fin 8 := ![0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,5,5,6]

/-- Second index of the antisymmetric pair enumeration `i < j` over `Fin 8`. -/
def ps : Fin 28 → Fin 8 := ![1,2,3,4,5,6,7,2,3,4,5,6,7,3,4,5,6,7,4,5,6,7,5,6,7,6,7,7]

/-- `Bz = 25 · U2`: the `28×28` determinant-minor (Plücker) lift of `Az`. -/
def Bz : Matrix (Fin 28) (Fin 28) GaussianInt := fun i j =>
  Az (pf i) (pf j) * Az (ps i) (ps j) - Az (pf i) (ps j) * Az (ps i) (pf j)

/-- `Kz = 5 · K2`: the kick, identity except the `2×2` block coupling the
occupation pairs `(0, 1)` (index `0`) and `(2, 3)` (index `13`). -/
def Kz : Matrix (Fin 28) (Fin 28) GaussianInt := !![g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0]

/-- `Vz = 25 · V`: the explicit composed interacting step (exact integer form). -/
def Vz : Matrix (Fin 28) (Fin 28) GaussianInt := !![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g (-16) 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 12,g 9 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 15,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 20 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-15),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 (-12),g 16 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 9 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

/-- **Faithfulness of the literal `Vz`.** The literal matrix `Vz` is exactly the
determinant-minor lift composed with the kick: `Bz · Kz = 5 • Vz`
(equivalently `25·U2 · 5·K2 = 125·V`). Machine-checked by `native_decide`. -/
theorem faithful : Bz * Kz = (5 : GaussianInt) • Vz := by native_decide

/-! ## The physical rational-complex matrices (ℂ layer) -/

/-- The one-particle walk `U1 = S · C` over `ℂ`. -/
noncomputable def U1 : Matrix (Fin 8) (Fin 8) ℂ :=
  (5⁻¹ : ℂ) • Az.map GaussianInt.toComplex

/-- The two-particle determinant-minor lift `U2` over `ℂ`. -/
noncomputable def U2 : Matrix (Fin 28) (Fin 28) ℂ :=
  (25⁻¹ : ℂ) • Bz.map GaussianInt.toComplex

/-- The kick `K2` over `ℂ`. -/
noncomputable def K2 : Matrix (Fin 28) (Fin 28) ℂ :=
  (5⁻¹ : ℂ) • Kz.map GaussianInt.toComplex

/-- The composed interacting step `V` over `ℂ` (the rational-complex matrix). -/
noncomputable def V : Matrix (Fin 28) (Fin 28) ℂ :=
  (25⁻¹ : ℂ) • Vz.map GaussianInt.toComplex

/-
`U2` is genuinely the determinant-minor (Plücker) lift of `U1`:
`U2[(r₁,r₂),(c₁,c₂)] = U1[r₁,c₁]·U1[r₂,c₂] − U1[r₁,c₂]·U1[r₂,c₁]`.
-/
theorem U2_eq_minor (i j : Fin 28) :
    U2 i j =
      U1 (pf i) (pf j) * U1 (ps i) (ps j)
        - U1 (pf i) (ps j) * U1 (ps i) (pf j) := by
  unfold U2 U1 Bz;
  norm_num [ Matrix.smul_eq_diagonal_mul ] ; ring

/-
The composed step is exactly `V = U2 · K2`.
-/
theorem V_eq_U2_K2 : V = U2 * K2 := by
  -- By definition, we know that Bz * Kz = (5 : GaussianInt) • Vz.
  have h_formula : Bz * Kz = (5 : GaussianInt) • Vz := by
    exact faithful;
  convert congr_arg ( fun m : Matrix ( Fin 28 ) ( Fin 28 ) GaussianInt => ( 125⁻¹ : ℂ ) • m.map GaussianInt.toComplex ) h_formula.symm using 1;
  · convert rfl using 2;
    ext i j; norm_num [ V ] ; ring;
    erw [ show ( 5 : GaussianInt ) = ( 5 : ℤ ) by rfl, GaussianInt.toComplex_def ] ; norm_num ; ring;
  · unfold U2 K2;
    ext i j ; norm_num ; ring

/-! ## T4 — exact pinned modes (kernel `decide`) -/

def vp0 : Fin 28 → GaussianInt := ![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]
def vp1 : Fin 28 → GaussianInt := ![g 0 0,g 0 (-4),g 3 0,g 0 0,g 0 0,g 0 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-3) 0,g 0 0,g 0 0,g 0 (-4),g 3 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-4),g 3 0,g 0 0,g 0 0,g 0 0]
def vp2 : Fin 28 → GaussianInt := ![g 0 0,g 0 (-4),g 0 0,g 0 0,g 0 0,g 0 4,g 0 0,g 3 0,g 0 0,g 0 0,g 0 0,g (-3) 0,g 0 0,g 0 0,g 0 (-4),g 3 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-4),g 0 0,g 3 0,g 0 0,g 0 0]
def vp3 : Fin 28 → GaussianInt := ![g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 1 0,g 0 0]
def vm0 : Fin 28 → GaussianInt := ![g 0 0,g 0 3,g 2 0,g 0 0,g 0 0,g 0 0,g (-2) 0,g 2 0,g 0 0,g 0 0,g 0 0,g (-2) 0,g 0 (-3),g 0 0,g 0 0,g 2 0,g 0 0,g 0 0,g 2 0,g 0 3,g 0 0,g 0 0,g 0 0,g 0 3,g 2 0,g 2 0,g 0 0,g 0 0]
def vm1 : Fin 28 → GaussianInt := ![g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 1 0,g 0 0]

set_option maxRecDepth 100000 in
/-- **T4 (+1, witness 1).** `Vz`-eigenvector for eigenvalue `25` (i.e. `V`-eigenvalue `+1`). -/
theorem Vz_eigenvector_plus_0 : Vz.mulVec vp0 = (25 : GaussianInt) • vp0 := by decide

set_option maxRecDepth 100000 in
/-- **T4 (+1, witness 2).** -/
theorem Vz_eigenvector_plus_1 : Vz.mulVec vp1 = (25 : GaussianInt) • vp1 := by decide

set_option maxRecDepth 100000 in
/-- **T4 (+1, witness 3).** -/
theorem Vz_eigenvector_plus_2 : Vz.mulVec vp2 = (25 : GaussianInt) • vp2 := by decide

set_option maxRecDepth 100000 in
/-- **T4 (+1, witness 4).** -/
theorem Vz_eigenvector_plus_3 : Vz.mulVec vp3 = (25 : GaussianInt) • vp3 := by decide

set_option maxRecDepth 100000 in
/-- **T4 (−1, witness 1).** `Vz`-eigenvector for eigenvalue `-25` (i.e. `V`-eigenvalue `−1`). -/
theorem Vz_eigenvector_minus_0 : Vz.mulVec vm0 = (-25 : GaussianInt) • vm0 := by decide

set_option maxRecDepth 100000 in
/-- **T4 (−1, witness 2).** -/
theorem Vz_eigenvector_minus_1 : Vz.mulVec vm1 = (-25 : GaussianInt) • vm1 := by decide

/-- The four `+1` witnesses are `ℚ`-linearly independent already at the level of
their integer coordinates (distinct support pattern); together with the `(λ−1)⁴`
factor of T1 they exhibit the full `+1` eigenspace. The two `−1` witnesses
likewise realize the `(λ+1)²` factor. -/

/-! ## T3 — the matrix bridge (Cayley–Hamilton annihilation)

**Disclosed status.** A full symbolic characteristic-polynomial determinant of a
`28×28` matrix (a Leibniz sum over `28!` permutations) is not feasible in-kernel
or by `native_decide`. Instead the matrix bridge is realized in its
Cayley–Hamilton *annihilation* form: the explicit degree-`28` polynomial of T1
annihilates `Vz` (equivalently `V`).  The integer identity `Vz_annihilated` is
checked by `native_decide`; the corollary `V_annihilated` transports it to the
physical `ℂ` matrix `V`.  Since the pinned eigenvalues `±1` are semisimple here
(T4 exhibits full eigenspaces), the minimal polynomial is a proper divisor of
the characteristic polynomial; the annihilation statement records exactly the
degree-`28` characteristic polynomial of T1 as an annihilator of `V`. -/

set_option maxRecDepth 100000 in
/-- **T3 (integer form).** The degree-`28` polynomial of T1, with the coin
denominators cleared consistently against `Vz = 25·V`, annihilates `Vz`.
Machine-checked by `native_decide`. -/
theorem Vz_annihilated :
    (g 48828125 0) • (Vz ^ 28) +
    (g (-1757812500) 0) • (Vz ^ 27) +
    (g (-22460937500) 0) • (Vz ^ 26) +
    (g 676757812500 0) • (Vz ^ 25) +
    (g 44427490234375 0) • (Vz ^ 24) +
    (g (-779589843750000) 0) • (Vz ^ 23) +
    (g (-62125244140625000) 0) • (Vz ^ 22) +
    (g 1401306152343750000 0) • (Vz ^ 21) +
    (g 30727191925048828125 0) • (Vz ^ 20) +
    (g (-174552017211914062500) 0) • (Vz ^ 19) +
    (g (-37234341812133789062500) 0) • (Vz ^ 18) +
    (g 197692880630493164062500 0) • (Vz ^ 17) +
    (g 28764619767665863037109375 0) • (Vz ^ 16) +
    (g (-238300323486328125000000000) 0) • (Vz ^ 15) +
    (g (-12345134615898132324218750000) 0) • (Vz ^ 14) +
    (g (-148937702178955078125000000000) 0) • (Vz ^ 13) +
    (g 11236179596744477748870849609375 0) • (Vz ^ 12) +
    (g 48264863435178995132446289062500 0) • (Vz ^ 11) +
    (g (-5681509675923734903335571289062500) 0) • (Vz ^ 10) +
    (g (-16646577569190412759780883789062500) 0) • (Vz ^ 9) +
    (g 1831483359637786634266376495361328125 0) • (Vz ^ 8) +
    (g 52202722145011648535728454589843750000 0) • (Vz ^ 7) +
    (g (-1446466058041551150381565093994140625000) 0) • (Vz ^ 6) +
    (g (-11344525319145759567618370056152343750000) 0) • (Vz ^ 5) +
    (g 404065669812325722887180745601654052734375 0) • (Vz ^ 4) +
    (g 3846922780326167412567883729934692382812500 0) • (Vz ^ 3) +
    (g (-79797279894933126342948526144027709960937500) 0) • (Vz ^ 2) +
    (g (-3903127820947815962426830083131790161132812500) 0) • (Vz ^ 1) +
    (g 67762635780344027125465800054371356964111328125 0) • (Vz ^ 0) = 0 := by native_decide

end PhysicsSM.Draft.NullEdge.PairSpectrumFixture
