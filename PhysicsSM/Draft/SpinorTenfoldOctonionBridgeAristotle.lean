import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldOctonionBridge
import PhysicsSM.Spinor.SpinorTenfoldGammaSymm
import PhysicsSM.Algebra.Octonion.SpinorFierzPolarized

/-!
# Draft.SpinorTenfoldOctonionBridgeAristotle

Aristotle handoff: the theorems of the bioctonion ↔ Fock bridge — the
final stage of the Baez-Huerta program for this repository.

## Mathematical intent

The definitions module `PhysicsSM.Spinor.SpinorTenfoldOctonionBridge`
constructs an explicit candidate equivalence between the bioctonionic
spinor model (`PhysicsSM.Algebra.Octonion.SpinorFierz`) and the Fock model
(`PhysicsSM.Spinor.SpinorTenfoldFock`): the vector bridge `iotaV`, the
basis table `octImage`, the linear bridge `fockToOct`, and the two
chirality-restricted inverses `octToFockEven` / `octToFockOdd`. **Every
target below is verified, in exact Gaussian-rational arithmetic, by the
oracle `Scripts/oracle/validate_bioctonion_fock_bridge.py`** — the
statements are correct as written; what is needed is kernel-checked proofs.

The payoff (the final two theorems, derivations already written): the
trusted ten-dimensional Fierz identity
`PhysicsSM.Spinor.SpinorTenfold.fierz_clifford` is *re-derived* from the
alternativity of the octonions via `fierz_bioctonionic`, replacing the
finite-enumeration explanation with the structural one ("the `D = 10` SUSY
identity holds because `𝕆` is a normed division algebra"), and the Fock
purity quadric is identified with the bioctonionic rank-one condition —
Lemma 1 of `Sources/Spin10_stabilizer.txt` in its octonionic form.

## Proof guidance

Everything is `ℂ`-(bi)linear, so all targets reduce to finite basis grids.
The intertwining and inverse identities are reduced to per-`(vector,
subset)` basis cases (`octImage` entries are `0, ±1`; `nullVecE/F` entries
are `0, ±1/2`) which close by `decide`-driven `simp` plus `norm_num`/`ring`.
The vector bridge injectivity uses an explicit left inverse `iotaVinv`.

This draft file now contains kernel-checked proofs of the submitted targets.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldOctonionBridge

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Spinor.SpinorTenfoldOctonionBridge
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Octonion.ComplexOctonion
open Finset

-- The coordinate identities in this file expand to 16/32-coordinate octonion
-- polynomials, which exceed the default heartbeat budget.
set_option maxHeartbeats 4000000

/-! ## Small helper lemmas (proved here) -/

/-- Trace reversal commutes with scalars. -/
theorem hermTraceRevC_smul (z : ℂ) (A : CHermVector) :
    hermTraceRevC (z • A) = z • hermTraceRevC A := by
  unfold hermTraceRevC
  ext1 <;> simp

/-- Trace reversal is an involution. -/
@[simp] theorem hermTraceRevC_hermTraceRevC (A : CHermVector) :
    hermTraceRevC (hermTraceRevC A) = A := by
  unfold hermTraceRevC
  ext1 <;> simp

/-- Trace reversal is additive. -/
theorem hermTraceRevC_add (A B : CHermVector) :
    hermTraceRevC (A + B) = hermTraceRevC A + hermTraceRevC B := by
  unfold hermTraceRevC
  ext1 <;> simp <;> ring

/-- Trace reversal of zero. -/
@[simp] theorem hermTraceRevC_zero : hermTraceRevC (0 : CHermVector) = 0 := by
  unfold hermTraceRevC
  ext1 <;> simp

/-- Trace reversal distributes over finite sums. -/
theorem hermTraceRevC_sum {ι : Type*} (s : Finset ι) (v : ι → CHermVector) :
    hermTraceRevC (∑ i ∈ s, v i) = ∑ i ∈ s, hermTraceRevC (v i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, hermTraceRevC_add, ih]

/-! ## Bioctonion algebra helpers -/

/-- A complex scalar is central on the left of bioctonion multiplication. -/
theorem co_smul_mul (z : ℂ) (x y : ComplexOctonion) : (z • x) * y = z • (x * y) := by
  refine ComplexOctonion.ext ?_ ?_ <;>
  · ext <;>
      simp only [ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im,
        ComplexOctonion.mul_re, ComplexOctonion.mul_im,
        Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
        Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7,
        Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
        Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7,
        Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2, Octonion.sub_c3,
        Octonion.sub_c4, Octonion.sub_c5, Octonion.sub_c6, Octonion.sub_c7,
        Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3,
        Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7] <;> ring

/-- A complex scalar is central on the right of bioctonion multiplication. -/
theorem co_mul_smul (z : ℂ) (x y : ComplexOctonion) : x * (z • y) = z • (x * y) := by
  refine ComplexOctonion.ext ?_ ?_ <;>
  · ext <;>
      simp only [ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im,
        ComplexOctonion.mul_re, ComplexOctonion.mul_im,
        Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
        Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7,
        Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
        Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7,
        Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2, Octonion.sub_c3,
        Octonion.sub_c4, Octonion.sub_c5, Octonion.sub_c6, Octonion.sub_c7,
        Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3,
        Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7] <;> ring

/-- Octonionic conjugation is `ℂ`-linear. -/
theorem octConjC_smul (z : ℂ) (x : ComplexOctonion) :
    octConjC (z • x) = z • octConjC x := by
  unfold octConjC
  ext <;> simp <;> ring

/-! ## Linearity of `hermActionC` -/

@[simp] theorem hermActionC_zero_vec (ψ : COctSpinor) : hermActionC 0 ψ = 0 := by
  unfold hermActionC octConjC
  ext <;> simp

@[simp] theorem hermActionC_zero_spinor (A : CHermVector) : hermActionC A 0 = 0 := by
  unfold hermActionC octConjC
  ext <;> simp

theorem hermActionC_add_vec (A B : CHermVector) (ψ : COctSpinor) :
    hermActionC (A + B) ψ = hermActionC A ψ + hermActionC B ψ := by
  unfold hermActionC octConjC
  ext <;> simp [add_mul, mul_add] <;> ring

theorem hermActionC_smul_vec_aux (z : ℂ) (A : CHermVector) (ψ : COctSpinor) :
    hermActionC (z • A) ψ = z • hermActionC A ψ := by
  unfold hermActionC octConjC
  ext <;> simp [mul_sub, mul_add] <;> ring

theorem hermActionC_add_spinor (A : CHermVector) (ψ φ : COctSpinor) :
    hermActionC A (ψ + φ) = hermActionC A ψ + hermActionC A φ := by
  unfold hermActionC octConjC
  ext <;> simp [add_mul, mul_add] <;> ring

theorem hermActionC_smul_spinor (z : ℂ) (A : CHermVector) (ψ : COctSpinor) :
    hermActionC A (z • ψ) = z • hermActionC A ψ := by
  unfold hermActionC octConjC
  ext <;> simp [mul_sub, mul_add, sub_mul, add_mul] <;> ring

theorem hermActionC_sum_vec {ι : Type*} (s : Finset ι) (v : ι → CHermVector)
    (ψ : COctSpinor) :
    hermActionC (∑ i ∈ s, v i) ψ = ∑ i ∈ s, hermActionC (v i) ψ := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi,
      hermActionC_add_vec, ih]

theorem hermActionC_sum_spinor {ι : Type*} (s : Finset ι) (A : CHermVector)
    (g : ι → COctSpinor) :
    hermActionC A (∑ i ∈ s, g i) = ∑ i ∈ s, hermActionC A (g i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi,
      hermActionC_add_spinor, ih]

/-! ## Linearity of `fockToOct`, `wedge`, `contract` over finite sums -/

theorem fockToOct_sum {ι : Type*} (s : Finset ι) (f : ι → FockSpinor) :
    fockToOct (∑ i ∈ s, f i) = ∑ i ∈ s, fockToOct (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, fockToOct_add, ih]

theorem wedge_sum {ι : Type*} (j : Fin 5) (s : Finset ι) (f : ι → FockSpinor) :
    wedge j (∑ i ∈ s, f i) = ∑ i ∈ s, wedge j (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, wedge_add, ih]

theorem contract_sum {ι : Type*} (j : Fin 5) (s : Finset ι) (f : ι → FockSpinor) :
    contract j (∑ i ∈ s, f i) = ∑ i ∈ s, contract j (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, contract_add, ih]

/-! ## Closed forms for the bridge of a creation/annihilation on a basis state -/

theorem fockToOct_wedge_basisSpinor (j : Fin 5) (S : Finset (Fin 5)) :
    fockToOct (wedge j (basisSpinor S))
      = if j ∈ S then 0 else opSign j (insert j S) • octImage (insert j S) := by
  by_cases h : j ∈ S
  · rw [wedge_basisSpinor_of_mem j S h, fockToOct_zero, if_pos h]
  · rw [wedge_basisSpinor_of_not_mem j S h, fockToOct_smul, fockToOct_basisSpinor, if_neg h]

theorem fockToOct_contract_basisSpinor (j : Fin 5) (S : Finset (Fin 5)) :
    fockToOct (contract j (basisSpinor S))
      = if j ∈ S then opSign j (S.erase j) • octImage (S.erase j) else 0 := by
  by_cases h : j ∈ S
  · rw [contract_basisSpinor_of_mem j S h, fockToOct_smul, fockToOct_basisSpinor, if_pos h]
  · rw [contract_basisSpinor_of_not_mem j S h, fockToOct_zero, if_neg h]

/-! ## The 32-term enumeration of a sum over `Finset (Fin 5)` -/

/-- A sum over the `32` subsets of `Fin 5`, written out explicitly. -/
theorem sum_finset_fin5 {M : Type*} [AddCommMonoid M] (f : Finset (Fin 5) → M) :
    (∑ S : Finset (Fin 5), f S) =
    f ∅ + f {0} + f {1} + f {2} + f {3} + f {4} + f {0,1} + f {0,2} + f {0,3} + f {0,4}
    + f {1,2} + f {1,3} + f {1,4} + f {2,3} + f {2,4} + f {3,4}
    + f {0,1,2} + f {0,1,3} + f {0,1,4} + f {0,2,3} + f {0,2,4} + f {0,3,4}
    + f {1,2,3} + f {1,2,4} + f {1,3,4} + f {2,3,4}
    + f {0,1,2,3} + f {0,1,2,4} + f {0,1,3,4} + f {0,2,3,4} + f {1,2,3,4} + f {0,1,2,3,4} := by
  rw [show (Finset.univ : Finset (Finset (Fin 5))) =
    {∅, {0}, {1}, {2}, {3}, {4}, {0,1}, {0,2}, {0,3}, {0,4},
     {1,2}, {1,3}, {1,4}, {2,3}, {2,4}, {3,4},
     {0,1,2}, {0,1,3}, {0,1,4}, {0,2,3}, {0,2,4}, {0,3,4},
     {1,2,3}, {1,2,4}, {1,3,4}, {2,3,4},
     {0,1,2,3}, {0,1,2,4}, {0,1,3,4}, {0,2,3,4}, {1,2,3,4}, {0,1,2,3,4}} from by decide]
  repeat rw [Finset.sum_insert (by decide)]
  rw [Finset.sum_singleton]
  abel

/-- The bridge written out as `32` explicit basis contributions. -/
theorem fockToOct_expand (ψ : FockSpinor) : fockToOct ψ =
    ψ ∅ • octImage ∅ + ψ {0} • octImage {0} + ψ {1} • octImage {1} + ψ {2} • octImage {2}
    + ψ {3} • octImage {3} + ψ {4} • octImage {4}
    + ψ {0,1} • octImage {0,1} + ψ {0,2} • octImage {0,2} + ψ {0,3} • octImage {0,3}
    + ψ {0,4} • octImage {0,4}
    + ψ {1,2} • octImage {1,2} + ψ {1,3} • octImage {1,3} + ψ {1,4} • octImage {1,4}
    + ψ {2,3} • octImage {2,3} + ψ {2,4} • octImage {2,4} + ψ {3,4} • octImage {3,4}
    + ψ {0,1,2} • octImage {0,1,2} + ψ {0,1,3} • octImage {0,1,3} + ψ {0,1,4} • octImage {0,1,4}
    + ψ {0,2,3} • octImage {0,2,3} + ψ {0,2,4} • octImage {0,2,4} + ψ {0,3,4} • octImage {0,3,4}
    + ψ {1,2,3} • octImage {1,2,3} + ψ {1,2,4} • octImage {1,2,4} + ψ {1,3,4} • octImage {1,3,4}
    + ψ {2,3,4} • octImage {2,3,4}
    + ψ {0,1,2,3} • octImage {0,1,2,3} + ψ {0,1,2,4} • octImage {0,1,2,4}
    + ψ {0,1,3,4} • octImage {0,1,3,4}
    + ψ {0,2,3,4} • octImage {0,2,3,4} + ψ {1,2,3,4} • octImage {1,2,3,4}
    + ψ {0,1,2,3,4} • octImage {0,1,2,3,4} := by
  rw [fockToOct, sum_finset_fin5 (fun S => ψ S • octImage S)]

/-! ## Linearity of the inverse rows -/

theorem coordC_add (x y : ComplexOctonion) (k : Fin 8) :
    coordC (x + y) k = coordC x k + coordC y k := by
  fin_cases k <;> simp [coordC, Complex.ext_iff]

theorem coordC_smul (z : ℂ) (x : ComplexOctonion) (k : Fin 8) :
    coordC (z • x) k = z * coordC x k := by
  fin_cases k <;> · apply Complex.ext <;> simp [coordC] <;> ring

theorem octToFockEven_add (φ ψ : COctSpinor) :
    octToFockEven (φ + ψ) = octToFockEven φ + octToFockEven ψ := by
  funext S
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases hmem <;>
    simp (config := {decide := true}) only [octToFockEven, if_true, if_false, Pi.add_apply,
      COctSpinor.add_fst, COctSpinor.add_snd, coordC_add] <;> ring

theorem octToFockEven_smul (z : ℂ) (φ : COctSpinor) :
    octToFockEven (z • φ) = z • octToFockEven φ := by
  funext S
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases hmem <;>
    simp (config := {decide := true}) only [octToFockEven, if_true, if_false, Pi.smul_apply,
      smul_eq_mul, COctSpinor.smul_fst, COctSpinor.smul_snd, coordC_smul] <;> ring

theorem octToFockEven_sum {ι : Type*} (s : Finset ι) (f : ι → COctSpinor) :
    octToFockEven (∑ i ∈ s, f i) = ∑ i ∈ s, octToFockEven (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, octToFockEven_add, ih]

theorem octToFockOdd_add (φ ψ : COctSpinor) :
    octToFockOdd (φ + ψ) = octToFockOdd φ + octToFockOdd ψ := by
  funext S
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases hmem <;>
    simp (config := {decide := true}) only [octToFockOdd, if_true, if_false, Pi.add_apply,
      COctSpinor.add_fst, COctSpinor.add_snd, coordC_add] <;> ring

theorem octToFockOdd_smul (z : ℂ) (φ : COctSpinor) :
    octToFockOdd (z • φ) = z • octToFockOdd φ := by
  funext S
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases hmem <;>
    simp (config := {decide := true}) only [octToFockOdd, if_true, if_false, Pi.smul_apply,
      smul_eq_mul, COctSpinor.smul_fst, COctSpinor.smul_snd, coordC_smul] <;> ring

theorem octToFockOdd_sum {ι : Type*} (s : Finset ι) (f : ι → COctSpinor) :
    octToFockOdd (∑ i ∈ s, f i) = ∑ i ∈ s, octToFockOdd (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih => rw [Finset.sum_insert hi, Finset.sum_insert hi, octToFockOdd_add, ih]

/-! ## The intertwining basis grids

These are the per-`(creation/annihilation index, subset)` finite identities
between explicit bioctonions; they are the combinatorial heart of the
bridge. Each is proved by enumerating the `5 × 32` cases and closing by a
`decide`-driven `simp` plus `norm_num`. -/

set_option maxHeartbeats 0 in
/-- Creation matches `nullVecE` on even basis states. -/
theorem hermActionC_nullVecE_octImage_even (j : Fin 5) (S : Finset (Fin 5))
    (hS : S.card % 2 = 0) :
    hermActionC (nullVecE j) (octImage S) = fockToOct (wedge j (basisSpinor S)) := by
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases j <;>
    first
    | exact absurd hS (by decide)
    | (fin_cases hmem <;>
        first
        | exact absurd hS (by decide)
        | (rw [fockToOct_wedge_basisSpinor]
           simp (config := {decide := true}) only [octImage, nullVecE, hermActionC, octConjC,
             opSign, belowCount]
           repeat first
             | rw [Even.neg_one_pow (by decide)]
             | rw [Odd.neg_one_pow (by decide)]
           ext <;> norm_num))

set_option maxHeartbeats 0 in
/-- Annihilation matches `nullVecF` on even basis states. -/
theorem hermActionC_nullVecF_octImage_even (j : Fin 5) (S : Finset (Fin 5))
    (hS : S.card % 2 = 0) :
    hermActionC (nullVecF j) (octImage S) = fockToOct (contract j (basisSpinor S)) := by
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases j <;>
    first
    | exact absurd hS (by decide)
    | (fin_cases hmem <;>
        first
        | exact absurd hS (by decide)
        | (rw [fockToOct_contract_basisSpinor]
           simp (config := {decide := true}) only [octImage, nullVecF, hermActionC, octConjC,
             opSign, belowCount]
           repeat first
             | rw [Even.neg_one_pow (by decide)]
             | rw [Odd.neg_one_pow (by decide)]
           ext <;> norm_num))

set_option maxHeartbeats 0 in
/-- Creation matches the trace-reversed `nullVecE` on odd basis states. -/
theorem hermActionC_nullVecE_octImage_odd (j : Fin 5) (S : Finset (Fin 5))
    (hS : S.card % 2 = 1) :
    hermActionC (hermTraceRevC (nullVecE j)) (octImage S)
      = fockToOct (wedge j (basisSpinor S)) := by
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases j <;>
    first
    | exact absurd hS (by decide)
    | (fin_cases hmem <;>
        first
        | exact absurd hS (by decide)
        | (rw [fockToOct_wedge_basisSpinor]
           simp (config := {decide := true}) only [octImage, nullVecE, hermTraceRevC, hermActionC,
             octConjC, opSign, belowCount]
           repeat first
             | rw [Even.neg_one_pow (by decide)]
             | rw [Odd.neg_one_pow (by decide)]
           ext <;> norm_num))

set_option maxHeartbeats 0 in
/-- Annihilation matches the trace-reversed `nullVecF` on odd basis states. -/
theorem hermActionC_nullVecF_octImage_odd (j : Fin 5) (S : Finset (Fin 5))
    (hS : S.card % 2 = 1) :
    hermActionC (hermTraceRevC (nullVecF j)) (octImage S)
      = fockToOct (contract j (basisSpinor S)) := by
  have hmem : S ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ S
  fin_cases j <;>
    first
    | exact absurd hS (by decide)
    | (fin_cases hmem <;>
        first
        | exact absurd hS (by decide)
        | (rw [fockToOct_contract_basisSpinor]
           simp (config := {decide := true}) only [octImage, nullVecF, hermTraceRevC, hermActionC,
             octConjC, opSign, belowCount]
           repeat first
             | rw [Even.neg_one_pow (by decide)]
             | rw [Odd.neg_one_pow (by decide)]
           ext <;> norm_num))

/-! ## The lift lemmas: the per-index intertwining on all (even/odd) spinors -/

theorem fockToOct_wedge_even {ψ : FockSpinor} (h : IsEvenSpinor ψ) (j : Fin 5) :
    fockToOct (wedge j ψ) = hermActionC (nullVecE j) (fockToOct ψ) := by
  have key : fockToOct (wedge j ψ)
      = ∑ S : Finset (Fin 5), ψ S • fockToOct (wedge j (basisSpinor S)) := by
    conv_lhs => rw [spinor_eq_sum_basis ψ]
    rw [wedge_sum, fockToOct_sum]
    exact Finset.sum_congr rfl fun S _ => by rw [wedge_smul, fockToOct_smul]
  have key2 : hermActionC (nullVecE j) (fockToOct ψ)
      = ∑ S : Finset (Fin 5), ψ S • hermActionC (nullVecE j) (octImage S) := by
    simp only [fockToOct, hermActionC_sum_spinor]
    exact Finset.sum_congr rfl fun S _ => by rw [hermActionC_smul_spinor]
  rw [key, key2]
  refine Finset.sum_congr rfl fun S _ => ?_
  by_cases hp : S.card % 2 = 0
  · rw [hermActionC_nullVecE_octImage_even j S hp]
  · rw [h S (by omega), zero_smul, zero_smul]

theorem fockToOct_contract_even {ψ : FockSpinor} (h : IsEvenSpinor ψ) (j : Fin 5) :
    fockToOct (contract j ψ) = hermActionC (nullVecF j) (fockToOct ψ) := by
  have key : fockToOct (contract j ψ)
      = ∑ S : Finset (Fin 5), ψ S • fockToOct (contract j (basisSpinor S)) := by
    conv_lhs => rw [spinor_eq_sum_basis ψ]
    rw [contract_sum, fockToOct_sum]
    exact Finset.sum_congr rfl fun S _ => by rw [contract_smul, fockToOct_smul]
  have key2 : hermActionC (nullVecF j) (fockToOct ψ)
      = ∑ S : Finset (Fin 5), ψ S • hermActionC (nullVecF j) (octImage S) := by
    simp only [fockToOct, hermActionC_sum_spinor]
    exact Finset.sum_congr rfl fun S _ => by rw [hermActionC_smul_spinor]
  rw [key, key2]
  refine Finset.sum_congr rfl fun S _ => ?_
  by_cases hp : S.card % 2 = 0
  · rw [hermActionC_nullVecF_octImage_even j S hp]
  · rw [h S (by omega), zero_smul, zero_smul]

theorem fockToOct_wedge_odd {ψ : FockSpinor} (h : IsOddSpinor ψ) (j : Fin 5) :
    fockToOct (wedge j ψ) = hermActionC (hermTraceRevC (nullVecE j)) (fockToOct ψ) := by
  have key : fockToOct (wedge j ψ)
      = ∑ S : Finset (Fin 5), ψ S • fockToOct (wedge j (basisSpinor S)) := by
    conv_lhs => rw [spinor_eq_sum_basis ψ]
    rw [wedge_sum, fockToOct_sum]
    exact Finset.sum_congr rfl fun S _ => by rw [wedge_smul, fockToOct_smul]
  have key2 : hermActionC (hermTraceRevC (nullVecE j)) (fockToOct ψ)
      = ∑ S : Finset (Fin 5), ψ S • hermActionC (hermTraceRevC (nullVecE j)) (octImage S) := by
    simp only [fockToOct, hermActionC_sum_spinor]
    exact Finset.sum_congr rfl fun S _ => by rw [hermActionC_smul_spinor]
  rw [key, key2]
  refine Finset.sum_congr rfl fun S _ => ?_
  by_cases hp : S.card % 2 = 0
  · rw [h S hp, zero_smul, zero_smul]
  · rw [hermActionC_nullVecE_octImage_odd j S (by omega)]

theorem fockToOct_contract_odd {ψ : FockSpinor} (h : IsOddSpinor ψ) (j : Fin 5) :
    fockToOct (contract j ψ) = hermActionC (hermTraceRevC (nullVecF j)) (fockToOct ψ) := by
  have key : fockToOct (contract j ψ)
      = ∑ S : Finset (Fin 5), ψ S • fockToOct (contract j (basisSpinor S)) := by
    conv_lhs => rw [spinor_eq_sum_basis ψ]
    rw [contract_sum, fockToOct_sum]
    exact Finset.sum_congr rfl fun S _ => by rw [contract_smul, fockToOct_smul]
  have key2 : hermActionC (hermTraceRevC (nullVecF j)) (fockToOct ψ)
      = ∑ S : Finset (Fin 5), ψ S • hermActionC (hermTraceRevC (nullVecF j)) (octImage S) := by
    simp only [fockToOct, hermActionC_sum_spinor]
    exact Finset.sum_congr rfl fun S _ => by rw [hermActionC_smul_spinor]
  rw [key, key2]
  refine Finset.sum_congr rfl fun S _ => ?_
  by_cases hp : S.card % 2 = 0
  · rw [h S hp, zero_smul, zero_smul]
  · rw [hermActionC_nullVecF_octImage_odd j S (by omega)]

/-! ## The inverse basis grids -/

set_option maxHeartbeats 0 in
/-- The even inverse row recovers the even basis states. -/
theorem octToFockEven_octImage_even (T : Finset (Fin 5)) (hT : T.card % 2 = 0) :
    octToFockEven (octImage T) = basisSpinor T := by
  funext U
  have hmemT : T ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ T
  have hmemU : U ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ U
  fin_cases hmemT <;>
    first
    | exact absurd hT (by decide)
    | (fin_cases hmemU <;>
        simp (config := {decide := true}) only [octToFockEven, octImage, coordC, basisSpinor,
          Matrix.cons_val] <;>
        norm_num [Complex.ext_iff])

set_option maxHeartbeats 0 in
/-- The odd inverse row recovers the odd basis states. -/
theorem octToFockOdd_octImage_odd (T : Finset (Fin 5)) (hT : T.card % 2 = 1) :
    octToFockOdd (octImage T) = basisSpinor T := by
  funext U
  have hmemT : T ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ T
  have hmemU : U ∈ (Finset.univ : Finset (Finset (Fin 5))) := Finset.mem_univ U
  fin_cases hmemT <;>
    first
    | exact absurd hT (by decide)
    | (fin_cases hmemU <;>
        simp (config := {decide := true}) only [octToFockOdd, octImage, coordC, basisSpinor,
          Matrix.cons_val] <;>
        norm_num [Complex.ext_iff])

/-! ## The vector-bridge left inverse -/

/-- An explicit left inverse of `iotaV`, used to prove injectivity. -/
def iotaVinv (A : CHermVector) : V10 :=
  (fun j => match j with
    | 0 => (⟨A.y.re.c0 - A.y.im.c7, A.y.im.c0 + A.y.re.c7⟩ : ℂ)
    | 1 => (⟨A.y.re.c1 - A.y.im.c6, A.y.im.c1 + A.y.re.c6⟩ : ℂ)
    | 2 => (⟨A.y.re.c2 - A.y.im.c5, A.y.im.c2 + A.y.re.c5⟩ : ℂ)
    | 3 => (⟨A.y.re.c3 - A.y.im.c4, A.y.im.c3 + A.y.re.c4⟩ : ℂ)
    | 4 => -A.b,
   fun j => match j with
    | 0 => (⟨A.y.re.c0 + A.y.im.c7, A.y.im.c0 - A.y.re.c7⟩ : ℂ)
    | 1 => (⟨A.y.re.c1 + A.y.im.c6, A.y.im.c1 - A.y.re.c6⟩ : ℂ)
    | 2 => (⟨A.y.re.c2 + A.y.im.c5, A.y.im.c2 - A.y.re.c5⟩ : ℂ)
    | 3 => (⟨A.y.re.c3 + A.y.im.c4, A.y.im.c3 - A.y.re.c4⟩ : ℂ)
    | 4 => A.a)

theorem iotaVinv_iotaV (v : V10) : iotaVinv (iotaV v) = v := by
  apply Prod.ext <;> funext j <;> fin_cases j <;>
    simp only [iotaVinv, iotaV, Fin.sum_univ_five, nullVecE, nullVecF,
      CHermVector.add_a, CHermVector.add_b, CHermVector.add_y, CHermVector.smul_a,
      CHermVector.smul_b, CHermVector.smul_y,
      ComplexOctonion.add_re, ComplexOctonion.add_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im, Octonion.add_c0, Octonion.add_c1, Octonion.add_c2,
      Octonion.add_c3, Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7,
      Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3, Octonion.smul_c4,
      Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7, Octonion.zero_c0, Octonion.zero_c1,
      Octonion.zero_c2, Octonion.zero_c3, Octonion.zero_c4, Octonion.zero_c5, Octonion.zero_c6,
      Octonion.zero_c7] <;>
    apply Complex.ext <;> simp <;> ring

theorem iotaVinv_zero : iotaVinv 0 = 0 := by
  apply Prod.ext <;> funext j <;> fin_cases j <;>
    simp only [iotaVinv, CHermVector.zero_a, CHermVector.zero_b, CHermVector.zero_y,
      ComplexOctonion.zero_re, ComplexOctonion.zero_im, Octonion.zero_c0, Octonion.zero_c1,
      Octonion.zero_c2, Octonion.zero_c3, Octonion.zero_c4, Octonion.zero_c5, Octonion.zero_c6,
      Octonion.zero_c7] <;> simp <;> rfl

/-! ## Targets: the vector bridge matches the quadratic forms -/

set_option maxHeartbeats 2000000 in
/-- **Target 1**: `iotaV` pulls the bioctonionic quadratic form back to
`Q10`: the Clifford scalars agree. -/
theorem Q10_iotaV (v : V10) :
    normSqC (iotaV v).y - (iotaV v).a * (iotaV v).b = Q10 v := by
  simp only [iotaV, Q10, Fin.sum_univ_five, nullVecE, nullVecF, normSqC, normSq, dotOct]
  apply Complex.ext <;> simp <;> ring

/-! ## Targets: intertwining -/

/-- **Target 2 (the heart of the bridge)**: on even spinors the bridge
intertwines the Fock Clifford action with the plain bioctonionic action. -/
theorem fockToOct_cliffordAction_even (v : V10) {ψ : FockSpinor}
    (h : IsEvenSpinor ψ) :
    fockToOct (cliffordAction v ψ) = hermActionC (iotaV v) (fockToOct ψ) := by
  rw [cliffordAction_eq_sum, fockToOct_add, fockToOct_sum, fockToOct_sum, iotaV,
    hermActionC_add_vec, hermActionC_sum_vec, hermActionC_sum_vec]
  congr 1
  · refine Finset.sum_congr rfl fun j _ => ?_
    rw [fockToOct_smul, hermActionC_smul_vec_aux, fockToOct_wedge_even h j]
  · refine Finset.sum_congr rfl fun j _ => ?_
    rw [fockToOct_smul, hermActionC_smul_vec_aux, fockToOct_contract_even h j]

/-- **Target 3**: on odd spinors the bioctonionic action is the
trace-reversed one (the other chirality half). -/
theorem fockToOct_cliffordAction_odd (v : V10) {ψ : FockSpinor}
    (h : IsOddSpinor ψ) :
    fockToOct (cliffordAction v ψ)
      = hermActionC (hermTraceRevC (iotaV v)) (fockToOct ψ) := by
  rw [cliffordAction_eq_sum, fockToOct_add, fockToOct_sum, fockToOct_sum, iotaV,
    hermTraceRevC_add, hermTraceRevC_sum, hermTraceRevC_sum,
    hermActionC_add_vec, hermActionC_sum_vec, hermActionC_sum_vec]
  congr 1
  · refine Finset.sum_congr rfl fun j _ => ?_
    rw [fockToOct_smul, hermTraceRevC_smul, hermActionC_smul_vec_aux, fockToOct_wedge_odd h j]
  · refine Finset.sum_congr rfl fun j _ => ?_
    rw [fockToOct_smul, hermTraceRevC_smul, hermActionC_smul_vec_aux, fockToOct_contract_odd h j]

/-! ## Targets: the chirality-restricted inverses -/

/-- **Target 4**: the inverse identity on even spinors. -/
theorem octToFockEven_fockToOct {ψ : FockSpinor} (h : IsEvenSpinor ψ) :
    octToFockEven (fockToOct ψ) = ψ := by
  conv_rhs => rw [spinor_eq_sum_basis ψ]
  simp only [fockToOct, octToFockEven_sum]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [octToFockEven_smul]
  by_cases hp : S.card % 2 = 0
  · rw [octToFockEven_octImage_even S hp]
  · rw [h S (by omega), zero_smul, zero_smul]

/-- **Target 5**: the inverse identity on odd spinors. -/
theorem octToFockOdd_fockToOct {ψ : FockSpinor} (h : IsOddSpinor ψ) :
    octToFockOdd (fockToOct ψ) = ψ := by
  conv_rhs => rw [spinor_eq_sum_basis ψ]
  simp only [fockToOct, octToFockOdd_sum]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [octToFockOdd_smul]
  by_cases hp : S.card % 2 = 0
  · rw [h S hp, zero_smul, zero_smul]
  · rw [octToFockOdd_octImage_odd S (by omega)]

set_option maxHeartbeats 8000000 in
/-- **Target 6**: the bridge is onto: `fockToOct ∘ octToFockEven = id`. -/
theorem fockToOct_octToFockEven (φ : COctSpinor) :
    fockToOct (octToFockEven φ) = φ := by
  rw [fockToOct_expand]
  apply COctSpinor.ext <;> apply ComplexOctonion.ext <;> ext <;>
    simp (config := {decide := true}) only [octToFockEven, octImage, coordC, Matrix.cons_val,
      if_true, if_false, COctSpinor.add_fst, COctSpinor.add_snd, COctSpinor.smul_fst,
      COctSpinor.smul_snd, ComplexOctonion.add_re,
      ComplexOctonion.add_im, ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im,
      ComplexOctonion.zero_re, ComplexOctonion.zero_im,
      Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3, Octonion.add_c4,
      Octonion.add_c5, Octonion.add_c6, Octonion.add_c7, Octonion.sub_c0, Octonion.sub_c1,
      Octonion.sub_c2, Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5, Octonion.sub_c6,
      Octonion.sub_c7, Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
      Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7, Octonion.zero_c0,
      Octonion.zero_c1, Octonion.zero_c2, Octonion.zero_c3, Octonion.zero_c4, Octonion.zero_c5,
      Octonion.zero_c6, Octonion.zero_c7, Complex.add_re, Complex.add_im, Complex.mul_re,
      Complex.mul_im, Complex.zero_re, Complex.zero_im] <;> ring

set_option maxHeartbeats 8000000 in
/-- **Target 7**: the odd counterpart of Target 6. -/
theorem fockToOct_octToFockOdd (φ : COctSpinor) :
    fockToOct (octToFockOdd φ) = φ := by
  rw [fockToOct_expand]
  apply COctSpinor.ext <;> apply ComplexOctonion.ext <;> ext <;>
    simp (config := {decide := true}) only [octToFockOdd, octImage, coordC, Matrix.cons_val,
      if_true, if_false, COctSpinor.add_fst, COctSpinor.add_snd, COctSpinor.smul_fst,
      COctSpinor.smul_snd, ComplexOctonion.add_re,
      ComplexOctonion.add_im, ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im,
      ComplexOctonion.zero_re, ComplexOctonion.zero_im,
      Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3, Octonion.add_c4,
      Octonion.add_c5, Octonion.add_c6, Octonion.add_c7, Octonion.sub_c0, Octonion.sub_c1,
      Octonion.sub_c2, Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5, Octonion.sub_c6,
      Octonion.sub_c7, Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
      Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7, Octonion.zero_c0,
      Octonion.zero_c1, Octonion.zero_c2, Octonion.zero_c3, Octonion.zero_c4, Octonion.zero_c5,
      Octonion.zero_c6, Octonion.zero_c7, Complex.add_re, Complex.add_im, Complex.mul_re,
      Complex.mul_im, Complex.zero_re, Complex.zero_im] <;> ring

/-- The bridge is injective on even spinors (derived from Target 4). -/
theorem fockToOct_eq_zero_iff_even {ψ : FockSpinor} (h : IsEvenSpinor ψ) :
    fockToOct ψ = 0 ↔ ψ = 0 := by
  constructor
  · intro h0
    have hinv := octToFockEven_fockToOct h
    rw [h0, octToFockEven_zero] at hinv
    exact hinv.symm
  · intro h0
    rw [h0, fockToOct_zero]

/-- The bridge is injective on odd spinors (derived from Target 5). -/
theorem fockToOct_eq_zero_iff_odd {ψ : FockSpinor} (h : IsOddSpinor ψ) :
    fockToOct ψ = 0 ↔ ψ = 0 := by
  constructor
  · intro h0
    have hinv := octToFockOdd_fockToOct h
    rw [h0, octToFockOdd_zero] at hinv
    exact hinv.symm
  · intro h0
    rw [h0, fockToOct_zero]

/-! ## Targets: the quadric bridge -/

/-- **Target 8 (helper)**: `hermActionC` commutes with scalars in the
vector slot (`ℂ` is central in the bioctonions). -/
theorem hermActionC_smul_vec (z : ℂ) (A : CHermVector) (ψ : COctSpinor) :
    hermActionC (z • A) ψ = z • hermActionC A ψ :=
  hermActionC_smul_vec_aux z A ψ

set_option maxHeartbeats 0 in
set_option maxRecDepth 100000 in
/-- **Target 9 (the quadric bridge)**: the bioctonionic vector-valued
spinor bilinear matches the Fock gamma-bilinear through `iotaV`, one trace
reversal, and the constant `2`. With this, the Fock purity quadric *is* the
bioctonionic rank-one condition. The proof expands both sides into the finite
basis grid (`fockToOct_expand`, `sum_finset_fin5`), canonicalizes all subset
arguments, and closes by `ring` per coordinate. -/
theorem spinorSquareC_fockToOct {ψ : FockSpinor} (h : IsEvenSpinor ψ) :
    spinorSquareC (fockToOct ψ)
      = (2 : ℂ) • hermTraceRevC (iotaV (gammaBilinear ψ ψ)) := by
  have e0 : ψ {0} = 0 := h _ (by decide)
  have e1 : ψ {1} = 0 := h _ (by decide)
  have e2 : ψ {2} = 0 := h _ (by decide)
  have e3 : ψ {3} = 0 := h _ (by decide)
  have e4 : ψ {4} = 0 := h _ (by decide)
  have e012 : ψ {0,1,2} = 0 := h _ (by decide)
  have e013 : ψ {0,1,3} = 0 := h _ (by decide)
  have e014 : ψ {0,1,4} = 0 := h _ (by decide)
  have e023 : ψ {0,2,3} = 0 := h _ (by decide)
  have e024 : ψ {0,2,4} = 0 := h _ (by decide)
  have e034 : ψ {0,3,4} = 0 := h _ (by decide)
  have e123 : ψ {1,2,3} = 0 := h _ (by decide)
  have e124 : ψ {1,2,4} = 0 := h _ (by decide)
  have e134 : ψ {1,3,4} = 0 := h _ (by decide)
  have e234 : ψ {2,3,4} = 0 := h _ (by decide)
  have e01234 : ψ {0,1,2,3,4} = 0 := h _ (by decide)
  have x1 : (∅:Finset (Fin 5))ᶜ = {0,1,2,3,4} := by decide
  have x2 : ({0}:Finset (Fin 5))ᶜ = {1,2,3,4} := by decide
  have x3 : ({1}:Finset (Fin 5))ᶜ = {0,2,3,4} := by decide
  have x4 : ({2}:Finset (Fin 5))ᶜ = {0,1,3,4} := by decide
  have x5 : ({3}:Finset (Fin 5))ᶜ = {0,1,2,4} := by decide
  have x6 : ({4}:Finset (Fin 5))ᶜ = {0,1,2,3} := by decide
  have x7 : ({0,1}:Finset (Fin 5))ᶜ = {2,3,4} := by decide
  have x8 : ({0,2}:Finset (Fin 5))ᶜ = {1,3,4} := by decide
  have x9 : ({0,3}:Finset (Fin 5))ᶜ = {1,2,4} := by decide
  have x10 : ({0,4}:Finset (Fin 5))ᶜ = {1,2,3} := by decide
  have x11 : ({1,2}:Finset (Fin 5))ᶜ = {0,3,4} := by decide
  have x12 : ({1,3}:Finset (Fin 5))ᶜ = {0,2,4} := by decide
  have x13 : ({1,4}:Finset (Fin 5))ᶜ = {0,2,3} := by decide
  have x14 : ({2,3}:Finset (Fin 5))ᶜ = {0,1,4} := by decide
  have x15 : ({2,4}:Finset (Fin 5))ᶜ = {0,1,3} := by decide
  have x16 : ({3,4}:Finset (Fin 5))ᶜ = {0,1,2} := by decide
  have x17 : ({0,1,2}:Finset (Fin 5))ᶜ = {3,4} := by decide
  have x18 : ({0,1,3}:Finset (Fin 5))ᶜ = {2,4} := by decide
  have x19 : ({0,1,4}:Finset (Fin 5))ᶜ = {2,3} := by decide
  have x20 : ({0,2,3}:Finset (Fin 5))ᶜ = {1,4} := by decide
  have x21 : ({0,2,4}:Finset (Fin 5))ᶜ = {1,3} := by decide
  have x22 : ({0,3,4}:Finset (Fin 5))ᶜ = {1,2} := by decide
  have x23 : ({1,2,3}:Finset (Fin 5))ᶜ = {0,4} := by decide
  have x24 : ({1,2,4}:Finset (Fin 5))ᶜ = {0,3} := by decide
  have x25 : ({1,3,4}:Finset (Fin 5))ᶜ = {0,2} := by decide
  have x26 : ({2,3,4}:Finset (Fin 5))ᶜ = {0,1} := by decide
  have x27 : ({0,1,2,3}:Finset (Fin 5))ᶜ = {4} := by decide
  have x28 : ({0,1,2,4}:Finset (Fin 5))ᶜ = {3} := by decide
  have x29 : ({0,1,3,4}:Finset (Fin 5))ᶜ = {2} := by decide
  have x30 : ({0,2,3,4}:Finset (Fin 5))ᶜ = {1} := by decide
  have x31 : ({1,2,3,4}:Finset (Fin 5))ᶜ = {0} := by decide
  have x32 : ({0,1,2,3,4}:Finset (Fin 5))ᶜ = ∅ := by decide
  have x33 : insert 0 (∅:Finset (Fin 5)) = {0} := by decide
  have x34 : insert 1 (∅:Finset (Fin 5)) = {1} := by decide
  have x35 : insert 2 (∅:Finset (Fin 5)) = {2} := by decide
  have x36 : insert 3 (∅:Finset (Fin 5)) = {3} := by decide
  have x37 : insert 4 (∅:Finset (Fin 5)) = {4} := by decide
  have x38 : insert 1 ({0}:Finset (Fin 5)) = {0,1} := by decide
  have x39 : insert 2 ({0}:Finset (Fin 5)) = {0,2} := by decide
  have x40 : insert 3 ({0}:Finset (Fin 5)) = {0,3} := by decide
  have x41 : insert 4 ({0}:Finset (Fin 5)) = {0,4} := by decide
  have x42 : insert 0 ({1}:Finset (Fin 5)) = {0,1} := by decide
  have x43 : insert 2 ({1}:Finset (Fin 5)) = {1,2} := by decide
  have x44 : insert 3 ({1}:Finset (Fin 5)) = {1,3} := by decide
  have x45 : insert 4 ({1}:Finset (Fin 5)) = {1,4} := by decide
  have x46 : insert 0 ({2}:Finset (Fin 5)) = {0,2} := by decide
  have x47 : insert 1 ({2}:Finset (Fin 5)) = {1,2} := by decide
  have x48 : insert 3 ({2}:Finset (Fin 5)) = {2,3} := by decide
  have x49 : insert 4 ({2}:Finset (Fin 5)) = {2,4} := by decide
  have x50 : insert 0 ({3}:Finset (Fin 5)) = {0,3} := by decide
  have x51 : insert 1 ({3}:Finset (Fin 5)) = {1,3} := by decide
  have x52 : insert 2 ({3}:Finset (Fin 5)) = {2,3} := by decide
  have x53 : insert 4 ({3}:Finset (Fin 5)) = {3,4} := by decide
  have x54 : insert 0 ({4}:Finset (Fin 5)) = {0,4} := by decide
  have x55 : insert 1 ({4}:Finset (Fin 5)) = {1,4} := by decide
  have x56 : insert 2 ({4}:Finset (Fin 5)) = {2,4} := by decide
  have x57 : insert 3 ({4}:Finset (Fin 5)) = {3,4} := by decide
  have x58 : insert 2 ({0,1}:Finset (Fin 5)) = {0,1,2} := by decide
  have x59 : insert 3 ({0,1}:Finset (Fin 5)) = {0,1,3} := by decide
  have x60 : insert 4 ({0,1}:Finset (Fin 5)) = {0,1,4} := by decide
  have x61 : insert 1 ({0,2}:Finset (Fin 5)) = {0,1,2} := by decide
  have x62 : insert 3 ({0,2}:Finset (Fin 5)) = {0,2,3} := by decide
  have x63 : insert 4 ({0,2}:Finset (Fin 5)) = {0,2,4} := by decide
  have x64 : insert 1 ({0,3}:Finset (Fin 5)) = {0,1,3} := by decide
  have x65 : insert 2 ({0,3}:Finset (Fin 5)) = {0,2,3} := by decide
  have x66 : insert 4 ({0,3}:Finset (Fin 5)) = {0,3,4} := by decide
  have x67 : insert 1 ({0,4}:Finset (Fin 5)) = {0,1,4} := by decide
  have x68 : insert 2 ({0,4}:Finset (Fin 5)) = {0,2,4} := by decide
  have x69 : insert 3 ({0,4}:Finset (Fin 5)) = {0,3,4} := by decide
  have x70 : insert 0 ({1,2}:Finset (Fin 5)) = {0,1,2} := by decide
  have x71 : insert 3 ({1,2}:Finset (Fin 5)) = {1,2,3} := by decide
  have x72 : insert 4 ({1,2}:Finset (Fin 5)) = {1,2,4} := by decide
  have x73 : insert 0 ({1,3}:Finset (Fin 5)) = {0,1,3} := by decide
  have x74 : insert 2 ({1,3}:Finset (Fin 5)) = {1,2,3} := by decide
  have x75 : insert 4 ({1,3}:Finset (Fin 5)) = {1,3,4} := by decide
  have x76 : insert 0 ({1,4}:Finset (Fin 5)) = {0,1,4} := by decide
  have x77 : insert 2 ({1,4}:Finset (Fin 5)) = {1,2,4} := by decide
  have x78 : insert 3 ({1,4}:Finset (Fin 5)) = {1,3,4} := by decide
  have x79 : insert 0 ({2,3}:Finset (Fin 5)) = {0,2,3} := by decide
  have x80 : insert 1 ({2,3}:Finset (Fin 5)) = {1,2,3} := by decide
  have x81 : insert 4 ({2,3}:Finset (Fin 5)) = {2,3,4} := by decide
  have x82 : insert 0 ({2,4}:Finset (Fin 5)) = {0,2,4} := by decide
  have x83 : insert 1 ({2,4}:Finset (Fin 5)) = {1,2,4} := by decide
  have x84 : insert 3 ({2,4}:Finset (Fin 5)) = {2,3,4} := by decide
  have x85 : insert 0 ({3,4}:Finset (Fin 5)) = {0,3,4} := by decide
  have x86 : insert 1 ({3,4}:Finset (Fin 5)) = {1,3,4} := by decide
  have x87 : insert 2 ({3,4}:Finset (Fin 5)) = {2,3,4} := by decide
  have x88 : insert 3 ({0,1,2}:Finset (Fin 5)) = {0,1,2,3} := by decide
  have x89 : insert 4 ({0,1,2}:Finset (Fin 5)) = {0,1,2,4} := by decide
  have x90 : insert 2 ({0,1,3}:Finset (Fin 5)) = {0,1,2,3} := by decide
  have x91 : insert 4 ({0,1,3}:Finset (Fin 5)) = {0,1,3,4} := by decide
  have x92 : insert 2 ({0,1,4}:Finset (Fin 5)) = {0,1,2,4} := by decide
  have x93 : insert 3 ({0,1,4}:Finset (Fin 5)) = {0,1,3,4} := by decide
  have x94 : insert 1 ({0,2,3}:Finset (Fin 5)) = {0,1,2,3} := by decide
  have x95 : insert 4 ({0,2,3}:Finset (Fin 5)) = {0,2,3,4} := by decide
  have x96 : insert 1 ({0,2,4}:Finset (Fin 5)) = {0,1,2,4} := by decide
  have x97 : insert 3 ({0,2,4}:Finset (Fin 5)) = {0,2,3,4} := by decide
  have x98 : insert 1 ({0,3,4}:Finset (Fin 5)) = {0,1,3,4} := by decide
  have x99 : insert 2 ({0,3,4}:Finset (Fin 5)) = {0,2,3,4} := by decide
  have x100 : insert 0 ({1,2,3}:Finset (Fin 5)) = {0,1,2,3} := by decide
  have x101 : insert 4 ({1,2,3}:Finset (Fin 5)) = {1,2,3,4} := by decide
  have x102 : insert 0 ({1,2,4}:Finset (Fin 5)) = {0,1,2,4} := by decide
  have x103 : insert 3 ({1,2,4}:Finset (Fin 5)) = {1,2,3,4} := by decide
  have x104 : insert 0 ({1,3,4}:Finset (Fin 5)) = {0,1,3,4} := by decide
  have x105 : insert 2 ({1,3,4}:Finset (Fin 5)) = {1,2,3,4} := by decide
  have x106 : insert 0 ({2,3,4}:Finset (Fin 5)) = {0,2,3,4} := by decide
  have x107 : insert 1 ({2,3,4}:Finset (Fin 5)) = {1,2,3,4} := by decide
  have x108 : insert 4 ({0,1,2,3}:Finset (Fin 5)) = {0,1,2,3,4} := by decide
  have x109 : insert 3 ({0,1,2,4}:Finset (Fin 5)) = {0,1,2,3,4} := by decide
  have x110 : insert 2 ({0,1,3,4}:Finset (Fin 5)) = {0,1,2,3,4} := by decide
  have x111 : insert 1 ({0,2,3,4}:Finset (Fin 5)) = {0,1,2,3,4} := by decide
  have x112 : insert 0 ({1,2,3,4}:Finset (Fin 5)) = {0,1,2,3,4} := by decide
  have x113 : ({0}:Finset (Fin 5)).erase 0 = ∅ := by decide
  have x114 : ({1}:Finset (Fin 5)).erase 1 = ∅ := by decide
  have x115 : ({2}:Finset (Fin 5)).erase 2 = ∅ := by decide
  have x116 : ({3}:Finset (Fin 5)).erase 3 = ∅ := by decide
  have x117 : ({4}:Finset (Fin 5)).erase 4 = ∅ := by decide
  have x118 : ({0,1}:Finset (Fin 5)).erase 0 = {1} := by decide
  have x119 : ({0,1}:Finset (Fin 5)).erase 1 = {0} := by decide
  have x120 : ({0,2}:Finset (Fin 5)).erase 0 = {2} := by decide
  have x121 : ({0,2}:Finset (Fin 5)).erase 2 = {0} := by decide
  have x122 : ({0,3}:Finset (Fin 5)).erase 0 = {3} := by decide
  have x123 : ({0,3}:Finset (Fin 5)).erase 3 = {0} := by decide
  have x124 : ({0,4}:Finset (Fin 5)).erase 0 = {4} := by decide
  have x125 : ({0,4}:Finset (Fin 5)).erase 4 = {0} := by decide
  have x126 : ({1,2}:Finset (Fin 5)).erase 1 = {2} := by decide
  have x127 : ({1,2}:Finset (Fin 5)).erase 2 = {1} := by decide
  have x128 : ({1,3}:Finset (Fin 5)).erase 1 = {3} := by decide
  have x129 : ({1,3}:Finset (Fin 5)).erase 3 = {1} := by decide
  have x130 : ({1,4}:Finset (Fin 5)).erase 1 = {4} := by decide
  have x131 : ({1,4}:Finset (Fin 5)).erase 4 = {1} := by decide
  have x132 : ({2,3}:Finset (Fin 5)).erase 2 = {3} := by decide
  have x133 : ({2,3}:Finset (Fin 5)).erase 3 = {2} := by decide
  have x134 : ({2,4}:Finset (Fin 5)).erase 2 = {4} := by decide
  have x135 : ({2,4}:Finset (Fin 5)).erase 4 = {2} := by decide
  have x136 : ({3,4}:Finset (Fin 5)).erase 3 = {4} := by decide
  have x137 : ({3,4}:Finset (Fin 5)).erase 4 = {3} := by decide
  have x138 : ({0,1,2}:Finset (Fin 5)).erase 0 = {1,2} := by decide
  have x139 : ({0,1,2}:Finset (Fin 5)).erase 1 = {0,2} := by decide
  have x140 : ({0,1,2}:Finset (Fin 5)).erase 2 = {0,1} := by decide
  have x141 : ({0,1,3}:Finset (Fin 5)).erase 0 = {1,3} := by decide
  have x142 : ({0,1,3}:Finset (Fin 5)).erase 1 = {0,3} := by decide
  have x143 : ({0,1,3}:Finset (Fin 5)).erase 3 = {0,1} := by decide
  have x144 : ({0,1,4}:Finset (Fin 5)).erase 0 = {1,4} := by decide
  have x145 : ({0,1,4}:Finset (Fin 5)).erase 1 = {0,4} := by decide
  have x146 : ({0,1,4}:Finset (Fin 5)).erase 4 = {0,1} := by decide
  have x147 : ({0,2,3}:Finset (Fin 5)).erase 0 = {2,3} := by decide
  have x148 : ({0,2,3}:Finset (Fin 5)).erase 2 = {0,3} := by decide
  have x149 : ({0,2,3}:Finset (Fin 5)).erase 3 = {0,2} := by decide
  have x150 : ({0,2,4}:Finset (Fin 5)).erase 0 = {2,4} := by decide
  have x151 : ({0,2,4}:Finset (Fin 5)).erase 2 = {0,4} := by decide
  have x152 : ({0,2,4}:Finset (Fin 5)).erase 4 = {0,2} := by decide
  have x153 : ({0,3,4}:Finset (Fin 5)).erase 0 = {3,4} := by decide
  have x154 : ({0,3,4}:Finset (Fin 5)).erase 3 = {0,4} := by decide
  have x155 : ({0,3,4}:Finset (Fin 5)).erase 4 = {0,3} := by decide
  have x156 : ({1,2,3}:Finset (Fin 5)).erase 1 = {2,3} := by decide
  have x157 : ({1,2,3}:Finset (Fin 5)).erase 2 = {1,3} := by decide
  have x158 : ({1,2,3}:Finset (Fin 5)).erase 3 = {1,2} := by decide
  have x159 : ({1,2,4}:Finset (Fin 5)).erase 1 = {2,4} := by decide
  have x160 : ({1,2,4}:Finset (Fin 5)).erase 2 = {1,4} := by decide
  have x161 : ({1,2,4}:Finset (Fin 5)).erase 4 = {1,2} := by decide
  have x162 : ({1,3,4}:Finset (Fin 5)).erase 1 = {3,4} := by decide
  have x163 : ({1,3,4}:Finset (Fin 5)).erase 3 = {1,4} := by decide
  have x164 : ({1,3,4}:Finset (Fin 5)).erase 4 = {1,3} := by decide
  have x165 : ({2,3,4}:Finset (Fin 5)).erase 2 = {3,4} := by decide
  have x166 : ({2,3,4}:Finset (Fin 5)).erase 3 = {2,4} := by decide
  have x167 : ({2,3,4}:Finset (Fin 5)).erase 4 = {2,3} := by decide
  have x168 : ({0,1,2,3}:Finset (Fin 5)).erase 0 = {1,2,3} := by decide
  have x169 : ({0,1,2,3}:Finset (Fin 5)).erase 1 = {0,2,3} := by decide
  have x170 : ({0,1,2,3}:Finset (Fin 5)).erase 2 = {0,1,3} := by decide
  have x171 : ({0,1,2,3}:Finset (Fin 5)).erase 3 = {0,1,2} := by decide
  have x172 : ({0,1,2,4}:Finset (Fin 5)).erase 0 = {1,2,4} := by decide
  have x173 : ({0,1,2,4}:Finset (Fin 5)).erase 1 = {0,2,4} := by decide
  have x174 : ({0,1,2,4}:Finset (Fin 5)).erase 2 = {0,1,4} := by decide
  have x175 : ({0,1,2,4}:Finset (Fin 5)).erase 4 = {0,1,2} := by decide
  have x176 : ({0,1,3,4}:Finset (Fin 5)).erase 0 = {1,3,4} := by decide
  have x177 : ({0,1,3,4}:Finset (Fin 5)).erase 1 = {0,3,4} := by decide
  have x178 : ({0,1,3,4}:Finset (Fin 5)).erase 3 = {0,1,4} := by decide
  have x179 : ({0,1,3,4}:Finset (Fin 5)).erase 4 = {0,1,3} := by decide
  have x180 : ({0,2,3,4}:Finset (Fin 5)).erase 0 = {2,3,4} := by decide
  have x181 : ({0,2,3,4}:Finset (Fin 5)).erase 2 = {0,3,4} := by decide
  have x182 : ({0,2,3,4}:Finset (Fin 5)).erase 3 = {0,2,4} := by decide
  have x183 : ({0,2,3,4}:Finset (Fin 5)).erase 4 = {0,2,3} := by decide
  have x184 : ({1,2,3,4}:Finset (Fin 5)).erase 1 = {2,3,4} := by decide
  have x185 : ({1,2,3,4}:Finset (Fin 5)).erase 2 = {1,3,4} := by decide
  have x186 : ({1,2,3,4}:Finset (Fin 5)).erase 3 = {1,2,4} := by decide
  have x187 : ({1,2,3,4}:Finset (Fin 5)).erase 4 = {1,2,3} := by decide
  have x188 : ({0,1,2,3,4}:Finset (Fin 5)).erase 0 = {1,2,3,4} := by decide
  have x189 : ({0,1,2,3,4}:Finset (Fin 5)).erase 1 = {0,2,3,4} := by decide
  have x190 : ({0,1,2,3,4}:Finset (Fin 5)).erase 2 = {0,1,3,4} := by decide
  have x191 : ({0,1,2,3,4}:Finset (Fin 5)).erase 3 = {0,1,2,4} := by decide
  have x192 : ({0,1,2,3,4}:Finset (Fin 5)).erase 4 = {0,1,2,3} := by decide
  rw [fockToOct_expand]
  apply CHermVector.ext
  · simp (config := {decide := true}) only [spinorSquareC, hermTraceRevC, CHermVector.smul_a, CHermVector.smul_b, CHermVector.smul_y,
      gammaBilinear, iotaV, Fin.sum_univ_five, nullVecE, nullVecF, normSqC, normSq, dotOct, octConjC,
      fockToOct, chevalleyPairing, chevalleySign, shuffleInversions, contract, wedge, opSign,
      belowCount, octImage, if_true, if_false, sum_finset_fin5,
      COctSpinor.add_fst, COctSpinor.add_snd, COctSpinor.smul_fst, COctSpinor.smul_snd,
      ComplexOctonion.add_re, ComplexOctonion.add_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im, ComplexOctonion.zero_re, ComplexOctonion.zero_im,
      x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52,x53,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69,x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x80,x81,x82,x83,x84,x85,x86,x87,x88,x89,x90,x91,x92,x93,x94,x95,x96,x97,x98,x99,x100,x101,x102,x103,x104,x105,x106,x107,x108,x109,x110,x111,x112,x113,x114,x115,x116,x117,x118,x119,x120,x121,x122,x123,x124,x125,x126,x127,x128,x129,x130,x131,x132,x133,x134,x135,x136,x137,x138,x139,x140,x141,x142,x143,x144,x145,x146,x147,x148,x149,x150,x151,x152,x153,x154,x155,x156,x157,x158,x159,x160,x161,x162,x163,x164,x165,x166,x167,x168,x169,x170,x171,x172,x173,x174,x175,x176,x177,x178,x179,x180,x181,x182,x183,x184,x185,x186,x187,x188,x189,x190,x191,x192,
      e0,e1,e2,e3,e4,e012,e013,e014,e023,e024,e034,e123,e124,e134,e234,e01234]
    repeat first
      | rw [Even.neg_one_pow (by decide)]
      | rw [Odd.neg_one_pow (by decide)]
    apply Complex.ext <;> simp [Complex.ext_iff] <;> ring
  · simp (config := {decide := true}) only [spinorSquareC, hermTraceRevC, CHermVector.smul_a, CHermVector.smul_b, CHermVector.smul_y,
      gammaBilinear, iotaV, Fin.sum_univ_five, nullVecE, nullVecF, normSqC, normSq, dotOct, octConjC,
      fockToOct, chevalleyPairing, chevalleySign, shuffleInversions, contract, wedge, opSign,
      belowCount, octImage, if_true, if_false, sum_finset_fin5,
      COctSpinor.add_fst, COctSpinor.add_snd, COctSpinor.smul_fst, COctSpinor.smul_snd,
      ComplexOctonion.add_re, ComplexOctonion.add_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im, ComplexOctonion.zero_re, ComplexOctonion.zero_im,
      x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52,x53,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69,x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x80,x81,x82,x83,x84,x85,x86,x87,x88,x89,x90,x91,x92,x93,x94,x95,x96,x97,x98,x99,x100,x101,x102,x103,x104,x105,x106,x107,x108,x109,x110,x111,x112,x113,x114,x115,x116,x117,x118,x119,x120,x121,x122,x123,x124,x125,x126,x127,x128,x129,x130,x131,x132,x133,x134,x135,x136,x137,x138,x139,x140,x141,x142,x143,x144,x145,x146,x147,x148,x149,x150,x151,x152,x153,x154,x155,x156,x157,x158,x159,x160,x161,x162,x163,x164,x165,x166,x167,x168,x169,x170,x171,x172,x173,x174,x175,x176,x177,x178,x179,x180,x181,x182,x183,x184,x185,x186,x187,x188,x189,x190,x191,x192,
      e0,e1,e2,e3,e4,e012,e013,e014,e023,e024,e034,e123,e124,e134,e234,e01234]
    repeat first
      | rw [Even.neg_one_pow (by decide)]
      | rw [Odd.neg_one_pow (by decide)]
    apply Complex.ext <;> simp [Complex.ext_iff] <;> ring
  · apply ComplexOctonion.ext <;> ext <;>
    · simp (config := {decide := true}) only [spinorSquareC, hermTraceRevC, CHermVector.smul_a, CHermVector.smul_b, CHermVector.smul_y,
      gammaBilinear, iotaV, Fin.sum_univ_five, nullVecE, nullVecF, normSqC, normSq, dotOct, octConjC,
      fockToOct, chevalleyPairing, chevalleySign, shuffleInversions, contract, wedge, opSign,
      belowCount, octImage, if_true, if_false, sum_finset_fin5,
      COctSpinor.add_fst, COctSpinor.add_snd, COctSpinor.smul_fst, COctSpinor.smul_snd,
      ComplexOctonion.add_re, ComplexOctonion.add_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im, ComplexOctonion.zero_re, ComplexOctonion.zero_im,
        x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52,x53,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69,x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x80,x81,x82,x83,x84,x85,x86,x87,x88,x89,x90,x91,x92,x93,x94,x95,x96,x97,x98,x99,x100,x101,x102,x103,x104,x105,x106,x107,x108,x109,x110,x111,x112,x113,x114,x115,x116,x117,x118,x119,x120,x121,x122,x123,x124,x125,x126,x127,x128,x129,x130,x131,x132,x133,x134,x135,x136,x137,x138,x139,x140,x141,x142,x143,x144,x145,x146,x147,x148,x149,x150,x151,x152,x153,x154,x155,x156,x157,x158,x159,x160,x161,x162,x163,x164,x165,x166,x167,x168,x169,x170,x171,x172,x173,x174,x175,x176,x177,x178,x179,x180,x181,x182,x183,x184,x185,x186,x187,x188,x189,x190,x191,x192,
        e0,e1,e2,e3,e4,e012,e013,e014,e023,e024,e034,e123,e124,e134,e234,e01234]
      repeat first
        | rw [Even.neg_one_pow (by decide)]
        | rw [Odd.neg_one_pow (by decide)]
      simp [Complex.ext_iff]
      ring

/-- **Target 10 (helper)**: the vector bridge is injective. -/
theorem iotaV_eq_zero_iff (v : V10) : iotaV v = 0 ↔ v = 0 := by
  constructor
  · intro h
    rw [← iotaVinv_iotaV v, h, iotaVinv_zero]
  · intro h; subst h
    simp only [iotaV, Fin.sum_univ_five, nullVecE, nullVecF]
    apply CHermVector.ext <;> simp

/-! ## Payoff theorems (derivations complete modulo the targets) -/

/-- **The purity correspondence**: an even Fock spinor lies on the Cartan
purity quadric iff its bioctonionic image satisfies the rank-one
(`spinorSquareC = 0`) condition. -/
theorem purity_iff_spinorSquareC {ψ : FockSpinor} (h : IsEvenSpinor ψ) :
    gammaBilinear ψ ψ = 0 ↔ spinorSquareC (fockToOct ψ) = 0 := by
  rw [spinorSquareC_fockToOct h]
  constructor
  · intro h0
    rw [h0]
    have : iotaV (0 : V10) = 0 := (iotaV_eq_zero_iff 0).mpr rfl
    rw [this]
    unfold hermTraceRevC
    ext1 <;> simp
  · intro h0
    have h2 : hermTraceRevC (iotaV (gammaBilinear ψ ψ)) = 0 := by
      have := smul_eq_zero.mp h0
      rcases this with h' | h'
      · exact absurd h' two_ne_zero
      · exact h'
    have h3 : iotaV (gammaBilinear ψ ψ) = 0 := by
      have := congrArg hermTraceRevC h2
      rw [hermTraceRevC_hermTraceRevC] at this
      rw [this]
      unfold hermTraceRevC
      ext1 <;> simp
    exact (iotaV_eq_zero_iff _).mp h3

/-- **The Fierz identity, re-derived from the octonions**. -/
theorem fierz_clifford_via_octonions {ψ : FockSpinor} (h : IsEvenSpinor ψ) :
    cliffordAction (gammaBilinear ψ ψ) ψ = 0 := by
  -- The bioctonionic Fierz identity at the image point.
  have hb := fierz_bioctonionic (fockToOct ψ)
  -- Rewrite its vector argument through the quadric bridge.
  rw [spinorSquareC_fockToOct h, hermTraceRevC_smul,
    hermTraceRevC_hermTraceRevC, hermActionC_smul_vec] at hb
  -- Cancel the factor 2.
  have hb2 : hermActionC (iotaV (gammaBilinear ψ ψ)) (fockToOct ψ) = 0 := by
    rcases smul_eq_zero.mp hb with h' | h'
    · exact absurd h' two_ne_zero
    · exact h'
  -- Pull back through the even intertwining and the odd injectivity.
  rw [← fockToOct_cliffordAction_even _ h] at hb2
  exact (fockToOct_eq_zero_iff_odd (h.cliffordAction _)).mp hb2

end PhysicsSM.Draft.SpinorTenfoldOctonionBridge

end
