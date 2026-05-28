import CodeLatticeE8.Octonion.Basic
import CodeLatticeE8.E8.RootBridge
import CodeLatticeE8.E8.Span

/-!
# Octavian unit shell from Hamming Construction A

This module connects the Cayley-Dickson coordinate multiplication to the
Hamming Construction A short shell.

The short shell `hammingE8ShortShell` consists of integer coordinate vectors
`z : Fin 8 -> Z` with unscaled squared norm `4`.  Interpreting such a vector
as the octonion `z / 2`, these are the 240 norm-one integral octonion units in
Coxeter's model.

The product of two represented units is

```text
(x / 2) * (y / 2) = mulInt x y / 4.
```

To return to doubled coordinates, we therefore define

```text
octavianUnitMul x y = mulInt x y / 2.
```

The closure of the short shell under `octavianUnitMul` is proved in three
structural stages:

1. **Divisibility** (`two_dvd_mulInt_of_hammingConstructionA`): structural proof
   using the explicit Hamming Construction A basis and bilinearity.
2. **Lattice closure** (`octavianUnitMul_mem_hammingConstructionA`): use
   bilinearity, the explicit Hamming Construction A basis, and an 8 by 8
   basis-product certificate. This proves closure of the full octavian order,
   not just closure of the 240 unit shell.
3. **Squared norm** (`octavianUnitMul_sqNorm`): algebraic proof using
   `normSqInt_mulInt` together with exact division by `2`.

Sources and convention notes:
- Coxeter, "Integral Cayley numbers", for the classical octavian-unit
  interpretation.
- Baez, "The Octonions", for the octonion background and terminology.
- Conway and Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7-8, for the
  E8/Construction A lattice normalization.

The multiplication convention is the signed-XOR Cayley-Dickson convention fixed
in `CodeLatticeE8.Octonion.CayleyDickson`; the proof below does not import a
separate octonion algebra or assume associativity.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Octonion

open CodeLatticeE8.Code
open CodeLatticeE8.ConstructionA
open CodeLatticeE8.E8
open CodeLatticeE8.E8.RootBridge

/-! ## Normalized product on doubled coordinates -/

/-- Normalized product on doubled coordinates for the octavian unit shell.

If `x` and `y` represent octonions `x / 2` and `y / 2`, then
`octavianUnitMul x y` represents their product in the same doubled-coordinate
format. -/
def octavianUnitMul (x y : Coords ℤ) : Coords ℤ :=
  fun k => mulInt x y k / 2

/-! ## Bilinearity of the Cayley-Dickson coordinate product -/

theorem mulInt_add_left (x₁ x₂ y : Coords ℤ) :
    mulInt (x₁ + x₂) y = mulInt x₁ y + mulInt x₂ y := by
  ext k
  fin_cases k <;> simp [mulInt, Pi.add_apply] <;> ring

theorem mulInt_add_right (x y₁ y₂ : Coords ℤ) :
    mulInt x (y₁ + y₂) = mulInt x y₁ + mulInt x y₂ := by
  ext k
  fin_cases k <;> simp [mulInt, Pi.add_apply] <;> ring

theorem mulInt_smul_left (c : ℤ) (x y : Coords ℤ) :
    mulInt (c • x) y = c • mulInt x y := by
  ext k
  fin_cases k <;> simp [mulInt, Pi.smul_apply] <;> ring

theorem mulInt_smul_right (c : ℤ) (x y : Coords ℤ) :
    mulInt x (c • y) = c • mulInt x y := by
  ext k
  fin_cases k <;> simp [mulInt, Pi.smul_apply] <;> ring

theorem mulInt_sum_left {ι : Type _} (s : Finset ι) (f : ι → Coords ℤ)
    (y : Coords ℤ) :
    mulInt (∑ i ∈ s, f i) y = ∑ i ∈ s, mulInt (f i) y := by
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a s ha ih => simp [Finset.sum_cons, mulInt_add_left, ih]

theorem mulInt_sum_right {ι : Type _} (s : Finset ι) (x : Coords ℤ)
    (g : ι → Coords ℤ) :
    mulInt x (∑ j ∈ s, g j) = ∑ j ∈ s, mulInt x (g j) := by
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a s ha ih => simp [Finset.sum_cons, mulInt_add_right, ih]

/-! ## Basis-level closure certificate -/

private instance hammingConstructionA_decidableMem (z : Fin 8 → ℤ) :
    Decidable (z ∈ hammingConstructionA) := by
  rw [mem_hammingConstructionA_iff_parityCheck]
  exact decEq _ _

set_option maxRecDepth 4096 in
set_option maxHeartbeats 800000 in
-- The finite certificate checks the 8 by 8 basis products, coordinate by
-- coordinate, for exact divisibility by `2`.
private theorem two_dvd_mulInt_basis :
    ∀ i j : Fin 8, ∀ k : Fin 8,
      (2 : ℤ) ∣ mulInt (hammingConstructionBasis i) (hammingConstructionBasis j) k := by
  decide

set_option maxRecDepth 4096 in
set_option maxHeartbeats 3200000 in
-- The finite certificate checks the normalized products of the 8 by 8 displayed
-- Construction A basis vectors.
private theorem octavianUnitMul_basis_mem :
    ∀ i j : Fin 8,
      octavianUnitMul (hammingConstructionBasis i) (hammingConstructionBasis j) ∈
        hammingConstructionA := by
  decide

/-! ## Lattice membership of the product -/

/-- The Cayley-Dickson product of two Hamming Construction A vectors has even
integer coordinates. -/
theorem two_dvd_mulInt_of_hammingConstructionA {x y : Coords ℤ}
    (hx : x ∈ hammingConstructionA) (hy : y ∈ hammingConstructionA)
    (k : Fin 8) :
    (2 : ℤ) ∣ mulInt x y k := by
  have hx_span := hammingConstructionBasis_spans x hx
  have hy_span := hammingConstructionBasis_spans y hy
  rw [Submodule.mem_span_range_iff_exists_fun] at hx_span hy_span
  obtain ⟨a, ha⟩ := hx_span
  obtain ⟨b, hb⟩ := hy_span
  rw [← ha, ← hb, mulInt_sum_left]
  simp only [Finset.sum_apply]
  apply Finset.dvd_sum
  intro i _
  rw [mulInt_smul_left, Pi.smul_apply, smul_eq_mul]
  apply dvd_mul_of_dvd_right
  rw [mulInt_sum_right, Finset.sum_apply]
  apply Finset.dvd_sum
  intro j _
  rw [mulInt_smul_right, Pi.smul_apply, smul_eq_mul]
  apply dvd_mul_of_dvd_right
  exact two_dvd_mulInt_basis i j k

/-- Alias for the global Construction A parity theorem in this concrete
Hamming Construction A model. -/
theorem two_dvd_mulInt_of_constructionA {x y : Coords ℤ}
    (hx : x ∈ hammingConstructionA) (hy : y ∈ hammingConstructionA)
    (k : Fin 8) :
    (2 : ℤ) ∣ mulInt x y k :=
  two_dvd_mulInt_of_hammingConstructionA hx hy k

/-- For lattice vectors, dividing `mulInt x y` by two is exact coordinatewise. -/
theorem two_mul_octavianUnitMul_eq_mulInt {x y : Coords ℤ}
    (hx : x ∈ hammingConstructionA) (hy : y ∈ hammingConstructionA)
    (k : Fin 8) :
    2 * octavianUnitMul x y k = mulInt x y k := by
  unfold octavianUnitMul
  have h := two_dvd_mulInt_of_constructionA hx hy k
  omega

private theorem mulInt_basis_expand (a b : Fin 8 → ℤ) :
    mulInt (∑ i : Fin 8, a i • hammingConstructionBasis i)
        (∑ j : Fin 8, b j • hammingConstructionBasis j) =
      ∑ i : Fin 8, ∑ j : Fin 8,
        (a i * b j) • mulInt (hammingConstructionBasis i)
          (hammingConstructionBasis j) := by
  rw [mulInt_sum_left]
  congr 1
  funext i
  rw [mulInt_smul_left, mulInt_sum_right, Finset.smul_sum]
  congr 1
  funext j
  rw [mulInt_smul_right, smul_smul, mul_comm]

/-- The normalized doubled-coordinate product of two Hamming Construction A
lattice vectors is again in the Hamming Construction A lattice. -/
theorem octavianUnitMul_mem_hammingConstructionA {x y : Coords ℤ}
    (hx : x ∈ hammingConstructionA) (hy : y ∈ hammingConstructionA) :
    octavianUnitMul x y ∈ hammingConstructionA := by
  have hx_span := hammingConstructionBasis_spans x hx
  have hy_span := hammingConstructionBasis_spans y hy
  rw [Submodule.mem_span_range_iff_exists_fun] at hx_span hy_span
  obtain ⟨a, ha⟩ := hx_span
  obtain ⟨b, hb⟩ := hy_span
  suffices heq : octavianUnitMul x y =
      ∑ i : Fin 8, ∑ j : Fin 8,
        (a i * b j) • octavianUnitMul (hammingConstructionBasis i)
          (hammingConstructionBasis j) by
    rw [heq]
    apply hammingConstructionA.sum_mem
    intro i _
    apply hammingConstructionA.sum_mem
    intro j _
    exact hammingConstructionA.zsmul_mem (octavianUnitMul_basis_mem i j) _
  funext k
  have lhs2 : 2 * octavianUnitMul x y k = mulInt x y k :=
    two_mul_octavianUnitMul_eq_mulInt hx hy k
  have mulInt_eq := mulInt_basis_expand a b
  have mulInt_k : mulInt x y k =
      ∑ i : Fin 8, ∑ j : Fin 8,
        a i * b j * mulInt (hammingConstructionBasis i)
          (hammingConstructionBasis j) k := by
    rw [← ha, ← hb, mulInt_eq]
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  have rhs2 : 2 * (∑ i : Fin 8, ∑ j : Fin 8,
        (a i * b j) • octavianUnitMul (hammingConstructionBasis i)
          (hammingConstructionBasis j)) k =
      ∑ i : Fin 8, ∑ j : Fin 8,
        a i * b j * mulInt (hammingConstructionBasis i)
          (hammingConstructionBasis j) k := by
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
    rw [Finset.mul_sum]
    congr 1
    ext i
    rw [Finset.mul_sum]
    congr 1
    ext j
    rw [show
        2 * (a i * b j * octavianUnitMul (hammingConstructionBasis i)
          (hammingConstructionBasis j) k) =
          a i * b j * (2 * octavianUnitMul (hammingConstructionBasis i)
            (hammingConstructionBasis j) k) by ring,
      two_mul_octavianUnitMul_eq_mulInt
        (hammingConstructionBasis_mem i) (hammingConstructionBasis_mem j)]
  linarith

/-! ## Squared norm and short-shell closure -/

/-- For two vectors in the short shell, the squared norm of their normalized
product is four.

**Proof**: Since `2 ∣ mulInt x y k` for all `k` (structural), we have
`normSqInt(mulInt x y) = 4 * normSqInt(octavianUnitMul x y)`.  The left side
equals `normSqInt x * normSqInt y = 4 * 4 = 16`, so the right side is `4`. -/
theorem octavianUnitMul_sqNorm {x y : Coords ℤ}
    (hx : x ∈ hammingE8ShortShell) (hy : y ∈ hammingE8ShortShell) :
    sqNorm (octavianUnitMul x y) = 4 := by
  have hdvd : ∀ k : Fin 8, 2 ∣ mulInt x y k :=
    fun k => two_dvd_mulInt_of_hammingConstructionA hx.1 hy.1 k
  have hscale : normSqInt (mulInt x y) = 4 * sqNorm (octavianUnitMul x y) := by
    simp only [normSqInt, sqNorm, octavianUnitMul]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _
    obtain ⟨q, hq⟩ := hdvd k
    rw [hq, show (2 * q : ℤ) / 2 = q by omega]
    ring
  have h16 : normSqInt (mulInt x y) = 16 := by
    rw [normSqInt_mulInt,
        show normSqInt x = 4 from hx.2,
        show normSqInt y = 4 from hy.2]
    norm_num
  linarith [hscale.symm.trans h16]

/-- Specialisation of the even-coordinate theorem to the short shell. -/
theorem two_dvd_mulInt_of_shortShell {x y : Coords ℤ}
    (hx : x ∈ hammingE8ShortShell) (hy : y ∈ hammingE8ShortShell)
    (k : Fin 8) :
    (2 : ℤ) ∣ mulInt x y k :=
  two_dvd_mulInt_of_hammingConstructionA hx.1 hy.1 k

/-- The normalized Cayley-Dickson product closes on the 240-element short shell.

For any two vectors representing unit octonions `x/2` and `y/2`, the product
`(x/2)*(y/2) = (octavianUnitMul x y)/2` is again a unit octonion.

**Proof**: from `octavianUnitMul_sqNorm` (norm = 4) and
`octavianUnitMul_mem_hammingConstructionA` (order closure). -/
theorem octavianUnitMul_mem_shortShell {x y : Coords ℤ}
    (hx : x ∈ hammingE8ShortShell) (hy : y ∈ hammingE8ShortShell) :
    octavianUnitMul x y ∈ hammingE8ShortShell :=
  ⟨octavianUnitMul_mem_hammingConstructionA hx.1 hy.1, octavianUnitMul_sqNorm hx hy⟩

/-! ## Coordinate-unit subcase (retained for reference) -/

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Kernel-verified finite check over the 16 coordinate units.
private theorem coordinateShortVectorList_octavianUnitMul_mem :
    coordinateShortVectorList.Forall (fun x =>
      coordinateShortVectorList.Forall (fun y =>
        octavianUnitMul x y ∈ hammingE8ShortShell)) := by
  decide

/-- The normalized Cayley-Dickson product closes on the 16 coordinate units in
the Hamming Construction A short shell.

This is a special case of `octavianUnitMul_mem_shortShell`, retained as an
independent kernel-verified certificate for the coordinate-unit subfamily. -/
theorem octavianUnitMul_mem_shortShell_of_mem_coordinateShortVectorList
    {x y : Coords ℤ}
    (hx : x ∈ coordinateShortVectorList) (hy : y ∈ coordinateShortVectorList) :
    octavianUnitMul x y ∈ hammingE8ShortShell := by
  have hxall := List.forall_iff_forall_mem.mp
    coordinateShortVectorList_octavianUnitMul_mem x hx
  exact List.forall_iff_forall_mem.mp hxall y hy

end CodeLatticeE8.Octonion
