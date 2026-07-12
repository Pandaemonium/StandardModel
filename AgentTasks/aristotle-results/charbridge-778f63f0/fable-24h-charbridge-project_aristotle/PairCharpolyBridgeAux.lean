import Mathlib

/-!
# Generic auxiliary lemmas for the characteristic-polynomial bridge

These are data-independent lemmas used by `PairCharpolyBridge`:
* `companion_charpoly` — a companion-style characterization of the characteristic
  polynomial via annihilation and a cyclic standard-basis vector;
* `coeff_comp_C_mul_X` — coefficients of `p.comp (C a * X)`;
* `charpoly_smul` — the characteristic polynomial of a nonzero scalar multiple.
-/

noncomputable section
open Matrix Polynomial

namespace PhysicsSM.Draft.NullEdge.PairCharpolyBridge

/-! ### Shared small data definitions (used by the main module too) -/
def g (a b : ℤ) : GaussianInt := ⟨a, b⟩
def diag16f : Fin 16 → GaussianInt := ![g 25 0,g 25 0,g 25 0,g 25 0,g (-25) 0,g (-25) 0,g (-7) 24,g (-7) (-24),g 15 20,g 15 20,g 15 (-20),g 15 (-20),g (-15) 20,g (-15) 20,g (-15) (-20),g (-15) (-20)]
def P6aZ : Polynomial GaussianInt := Polynomial.C (g (-195312500) (-146484375)) * Polynomial.X ^ 0 + Polynomial.C (g 0 0) * Polynomial.X ^ 1 + Polynomial.C (g 165625 18750) * Polynomial.X ^ 2 + Polynomial.C (g 0 0) * Polynomial.X ^ 3 + Polynomial.C (g (-230) (-135)) * Polynomial.X ^ 4 + Polynomial.C (g 0 0) * Polynomial.X ^ 5 + Polynomial.C (g 1 0) * Polynomial.X ^ 6
def P6bZ : Polynomial GaussianInt := Polynomial.C (g (-195312500) 146484375) * Polynomial.X ^ 0 + Polynomial.C (g 0 0) * Polynomial.X ^ 1 + Polynomial.C (g 165625 (-18750)) * Polynomial.X ^ 2 + Polynomial.C (g 0 0) * Polynomial.X ^ 3 + Polynomial.C (g (-230) 135) * Polynomial.X ^ 4 + Polynomial.C (g 0 0) * Polynomial.X ^ 5 + Polynomial.C (g 1 0) * Polynomial.X ^ 6
def Rpoly : Polynomial GaussianInt := Polynomial.C (g 1387778780781445675529539585113525390625 0) * Polynomial.X ^ 0 + Polynomial.C (g (-79936057773011270910501480102539062500) 0) * Polynomial.X ^ 1 + Polynomial.C (g (-1634248292248230427503585815429687500) 0) * Polynomial.X ^ 2 + Polynomial.C (g 78784978541079908609390258789062500 0) * Polynomial.X ^ 3 + Polynomial.C (g 8275264917756430804729461669921875 0) * Polynomial.X ^ 4 + Polynomial.C (g (-232335878536105155944824218750000) 0) * Polynomial.X ^ 5 + Polynomial.C (g (-29623624868690967559814453125000) 0) * Polynomial.X ^ 6 + Polynomial.C (g 1069111749529838562011718750000 0) * Polynomial.X ^ 7 + Polynomial.C (g 37508779205381870269775390625 0) * Polynomial.X ^ 8 + Polynomial.C (g (-340921908617019653320312500) 0) * Polynomial.X ^ 9 + Polynomial.C (g (-116357318162918090820312500) 0) * Polynomial.X ^ 10 + Polynomial.C (g 988464403152465820312500 0) * Polynomial.X ^ 11 + Polynomial.C (g 230116958141326904296875 0) * Polynomial.X ^ 12 + Polynomial.C (g (-3050244140625000000000) 0) * Polynomial.X ^ 13 + Polynomial.C (g (-252828356933593750000) 0) * Polynomial.X ^ 14 + Polynomial.C (g (-4880390625000000000) 0) * Polynomial.X ^ 15 + Polynomial.C (g 589099412841796875 0) * Polynomial.X ^ 16 + Polynomial.C (g 4048750195312500 0) * Polynomial.X ^ 17 + Polynomial.C (g (-762559320312500) 0) * Polynomial.X ^ 18 + Polynomial.C (g (-3574825312500) 0) * Polynomial.X ^ 19 + Polynomial.C (g 629292890625 0) * Polynomial.X ^ 20 + Polynomial.C (g 28698750000 0) * Polynomial.X ^ 21 + Polynomial.C (g (-1272325000) 0) * Polynomial.X ^ 22 + Polynomial.C (g (-15966000) 0) * Polynomial.X ^ 23 + Polynomial.C (g 909875 0) * Polynomial.X ^ 24 + Polynomial.C (g 13860 0) * Polynomial.X ^ 25 + Polynomial.C (g (-460) 0) * Polynomial.X ^ 26 + Polynomial.C (g (-36) 0) * Polynomial.X ^ 27 + Polynomial.C (g 1 0) * Polynomial.X ^ 28


/-
If `p` is monic of degree `m`, annihilates `Cm`, and the standard basis vector
`e₀ = Pi.single 0 1` is cyclic with `Cm ^ k • e₀ = e_k`, then `p` is the
characteristic polynomial of `Cm`.
-/
theorem companion_charpoly {m : ℕ} [NeZero m] (Cm : Matrix (Fin m) (Fin m) GaussianInt)
    (p : Polynomial GaussianInt) (hmon : p.Monic) (hdeg : p.natDegree = m)
    (haeval : (Polynomial.aeval Cm) p = 0)
    (hcyc : ∀ k : Fin m,
      (Cm ^ (k : ℕ)).mulVec (Pi.single (0 : Fin m) (1 : GaussianInt)) = Pi.single k 1) :
    Cm.charpoly = p := by
  -- By definition of $D$, we know that its coefficients are all zero.
  have hD_zero_coeffs : ∀ k : ℕ, k < m → (Cm.charpoly - p).coeff k = 0 := by
    intro k hk_lt_m
    have hD_eval : ((Cm.charpoly - p).aeval Cm).mulVec (Pi.single 0 1) = 0 := by
      simp_all +decide [ funext_iff ];
      simp_all +decide [ Matrix.aeval_self_charpoly ];
    -- By definition of $D$, we know that its coefficients are all zero. We can expand $D$ as a sum of its coefficients times powers of $Cm$.
    have hD_expand : ((Cm.charpoly - p).aeval Cm).mulVec (Pi.single 0 1) = ∑ k ∈ Finset.range m, (Cm.charpoly - p).coeff k • (Cm ^ k).mulVec (Pi.single 0 1) := by
      rw [ Polynomial.aeval_eq_sum_range' ];
      any_goals exact m;
      · simp +decide [ funext_iff ];
        simp +decide [ Matrix.sum_apply ];
      · have h_deg : (Cm.charpoly - p).degree < m := by
          convert Polynomial.degree_sub_lt _ _ _ <;> norm_num [ Matrix.charpoly_degree_eq_dim, hdeg ];
          · rw [ Polynomial.degree_eq_natDegree ] <;> aesop;
          · exact Matrix.charpoly_monic Cm |> fun h => h.ne_zero;
          · rw [ Matrix.charpoly_monic, hmon ];
        contrapose! h_deg;
        rw [ Polynomial.degree_eq_natDegree ] <;> aesop;
    simp_all +decide [ Finset.sum_range ];
    replace hD_expand := congr_arg ( fun x => x ( ⟨ k, hk_lt_m ⟩ : Fin m ) ) hD_expand ; simp_all +decide [ Finset.sum_apply, Pi.single_apply ];
  refine' Polynomial.eq_of_degree_sub_lt_of_eval_finset_eq _ _ _;
  exact { 0 };
  · rw [ Polynomial.degree_lt_iff_coeff_zero ];
    intro k hk; rcases lt_trichotomy k m with hk' | rfl | hk' <;> simp_all +decide [ Polynomial.coeff_eq_zero_of_natDegree_lt ] ;
    have := Matrix.charpoly_monic Cm; simp_all +decide [ Polynomial.Monic.def, Polynomial.leadingCoeff, Polynomial.natDegree_eq_of_degree_eq_some ] ;
  · specialize hD_zero_coeffs 0 ; simp_all +decide [ Polynomial.coeff_zero_eq_eval_zero ];
    exact eq_of_sub_eq_zero ( hD_zero_coeffs ( NeZero.pos m ) )

theorem coeff_comp_C_mul_X {K : Type*} [CommRing K] (p : Polynomial K) (a : K) (k : ℕ) :
    (p.comp (Polynomial.C a * Polynomial.X)).coeff k = p.coeff k * a ^ k := by
  simp +decide [ * ]

/-
Characteristic polynomial under nonzero scalar multiplication (over a field).
-/
theorem charpoly_smul {K : Type*} [Field K] [Infinite K] {m : ℕ} (c : K) (hc : c ≠ 0)
    (A : Matrix (Fin m) (Fin m) K) :
    (c • A).charpoly
      = Polynomial.C (c ^ m) * (A.charpoly).comp (Polynomial.C c⁻¹ * Polynomial.X) := by
  refine' Polynomial.funext fun r => _;
  -- Evaluate both sides at `r`:
  have h_eval : Matrix.det (Matrix.scalar (Fin m) r - c • A) = c ^ m * Matrix.det (Matrix.scalar (Fin m) (c⁻¹ * r) - A) := by
    rw [ show ( scalar ( Fin m ) ) r - c • A = c • ( ( scalar ( Fin m ) ) ( c⁻¹ * r ) - A ) from ?_, Matrix.det_smul ] ; aesop;
    ext i j ; by_cases hi : i = j <;> simp +decide [ *, mul_sub ];
  convert h_eval using 1 <;> simp +decide [ Matrix.charpoly, Matrix.det_apply' ];
  · simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Matrix.charmatrix, Matrix.diagonal ];
    exact Finset.sum_congr rfl fun _ _ => by congr; ext; split_ifs <;> simp +decide [ * ] ;
  · simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_X, Polynomial.eval_C, Matrix.diagonal_apply ];
    exact Or.inl ( Finset.sum_congr rfl fun _ _ => by congr; ext; aesop )

/-
If integer (Gaussian) matrices satisfy `S*T = d•1`, `T*S = d•1`, `T*V*S = d•B`
with `d` mapping to a nonzero complex number, then `V` and `B` have the same
characteristic polynomial (they are conjugate over `ℂ`).
-/
theorem charpoly_conj_of_scaled {n : ℕ} (S T V B : Matrix (Fin n) (Fin n) GaussianInt)
    (d : GaussianInt) (hd : GaussianInt.toComplex d ≠ 0)
    (hST : S * T = d • 1) (hTS : T * S = d • 1) (hconj : T * V * S = d • B) :
    V.charpoly = B.charpoly := by
  -- Set `Sc := S.map φ`, `Tc := T.map φ`, `Vc := V.map φ`, `Bc := B.map φ`, and `e := φ d` (so `e ≠ 0` by `hd`).
  set Sc : Matrix (Fin n) (Fin n) ℂ := S.map GaussianInt.toComplex
  set Tc : Matrix (Fin n) (Fin n) ℂ := T.map GaussianInt.toComplex
  set Vc : Matrix (Fin n) (Fin n) ℂ := V.map GaussianInt.toComplex
  set Bc : Matrix (Fin n) (Fin n) ℂ := B.map GaussianInt.toComplex
  set e : ℂ := GaussianInt.toComplex d;
  -- By `Matrix.charpoly_units_conj' U Vc`, we have `((↑U⁻¹) * Vc * (↑U)).charpoly = Vc.charpoly`.
  have h_charpoly_conj : (e⁻¹ • Tc * Vc * Sc).charpoly = Vc.charpoly := by
    -- Since `e ≠ 0`, `Sc` is invertible with inverse `e⁻¹ • Tc`.
    have h_inv : Sc * (e⁻¹ • Tc) = 1 ∧ (e⁻¹ • Tc) * Sc = 1 := by
      have h_inv : Sc * Tc = e • 1 ∧ Tc * Sc = e • 1 := by
        convert And.intro ( congr_arg ( fun m => m.map GaussianInt.toComplex ) hST ) ( congr_arg ( fun m => m.map GaussianInt.toComplex ) hTS ) using 1 <;> simp +decide;
        · simp +zetaDelta at *;
          simp +decide [ ← Matrix.ext_iff, Matrix.smul_eq_diagonal_mul ];
        · simp +zetaDelta at *;
          simp +decide [ ← Matrix.ext_iff, Matrix.smul_eq_diagonal_mul ];
      simp_all +decide [ smul_smul ];
    convert Matrix.charpoly_units_conj' ( ⟨ Sc, e⁻¹ • Tc, h_inv.1, h_inv.2 ⟩ : ( Matrix ( Fin n ) ( Fin n ) ℂ )ˣ ) Vc using 1;
  -- Since `e⁻¹ • Tc * Vc * Sc = Bc`, we have `Bc.charpoly = Vc.charpoly`.
  have h_charpoly_eq : Bc.charpoly = Vc.charpoly := by
    have h_eq : Tc * Vc * Sc = e • Bc := by
      convert congr_arg ( fun m => m.map GaussianInt.toComplex ) hconj using 1;
      · ext i j ; simp +decide [ Matrix.mul_apply ];
        rfl;
      · ext i j; simp +decide [ Bc, e ] ;
    simp_all +decide [ mul_assoc, smul_smul ];
  -- Since `Polynomial.map φ` is injective (from `φ` injective, `Polynomial.map_injective`), conclude `V.charpoly = B.charpoly`.
  have h_injective : Function.Injective (Polynomial.map (GaussianInt.toComplex : GaussianInt →+* ℂ)) := by
    exact Polynomial.map_injective _ GaussianInt.toComplex_injective;
  exact h_injective <| by rw [ ← Matrix.charpoly_map V, ← Matrix.charpoly_map B, h_charpoly_eq ] ;

theorem prod_eq_Rpoly :
    (∏ i : Fin 16, (Polynomial.X - Polynomial.C (diag16f i))) * P6aZ * P6bZ = Rpoly := by
  have h_eval : ∀ r : ℂ, Polynomial.eval r (Polynomial.map GaussianInt.toComplex ((∏ x : Fin 16, (Polynomial.X - Polynomial.C (diag16f x))) * P6aZ * P6bZ)) = Polynomial.eval r (Polynomial.map GaussianInt.toComplex Rpoly) := by
    unfold P6aZ P6bZ Rpoly;
    intro r;
    simp +decide [ Fin.prod_univ_succ, diag16f, Matrix.cons_val_zero, Matrix.cons_val_succ, Matrix.cons_val_fin_one, eval_mul, eval_sub, eval_pow, eval_X, GaussianInt.toComplex_def ];
    simp +decide [ g ] at * ; ring_nf at *;
    norm_num [ show Complex.I ^ 4 = Complex.I ^ 2 * Complex.I ^ 2 by ring, show Complex.I ^ 6 = Complex.I ^ 4 * Complex.I ^ 2 by ring, show Complex.I ^ 8 = Complex.I ^ 6 * Complex.I ^ 2 by ring, show Complex.I ^ 10 = Complex.I ^ 8 * Complex.I ^ 2 by ring, show Complex.I ^ 12 = Complex.I ^ 10 * Complex.I ^ 2 by ring ] at * ; ring_nf at *;
  refine' Polynomial.map_injective GaussianInt.toComplex GaussianInt.toComplex_injective <| Polynomial.funext fun x => by aesop;

end PhysicsSM.Draft.NullEdge.PairCharpolyBridge

end
