import Mathlib

/-!
# The finite Fock/Gupta–Bleuler quotient bridge (Q08 target T-F2)

This module formalizes the *finite perfect-pairing bridge* underlying the Q08
claim that second quantization (the exterior/Fock functor `Λ`) commutes with the
Gupta–Bleuler quotient: at each fixed particle number `n`,

  `rad(Λⁿ h) = ker(Λⁿ q)`  and  `Λⁿ(W)/rad ≅ Λⁿ(W')`  isometrically,

where `q : W → W'` is a surjection and `h = q* h' q` is the pullback of a
**nondegenerate** form `h'` on `W'`.  Taking `W' = W/N` with `N = rad(h)` gives
the degree-by-degree kernel-of-projection form of the Fock quotient bridge.  The
literal graded `ideal(N)` identification and assembly across all particle
numbers remain follow-up rungs.

The mathematical heart is the **perfect-pairing bridge**
`exteriorForm_nondegenerate`: the Gram-determinant form induced on `⋀ⁿ W` by a
nondegenerate form on a finite-dimensional space is again nondegenerate.  This is
the "k-th compound of an invertible Gram matrix is invertible" (Cauchy–Binet)
fact.  We obtain it cleanly from Mathlib's exterior-power/dual pairing
`exteriorPower.pairingDual`, which we show is a linear isomorphism in finite
dimension (this bijectivity is not in Mathlib and is the reusable core lemma
`pairingDual_bijective`).

Claim boundary (per Q08 discipline): this is finite multilinear algebra over a
field only.  **No positivity and no Hilbert-space completion is claimed.**  The
forms here are indefinite/Krein-agnostic; positivity of the induced quotient form
is the separate open crux (Q1) and is deliberately not touched.

Provenance: clean-room formalization of `Q08_answer.md` target `T-F2` /
ladder `L-Q8-5`, using Mathlib's `exteriorPower.pairingDual` machinery.
-/

open scoped ExteriorAlgebra
open exteriorPower

namespace PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing

/-! ## The induced Gram-determinant form on an exterior power -/

section Defs
variable {K W : Type*} [Field K] [AddCommGroup W] [Module K W]

/-- The Gram-determinant form induced by a bilinear form `B` on the `n`-th
exterior power.  On decomposables it is the determinant of the Gram matrix
`det[B(uᵢ, vⱼ)]`.  As a linear map it is `pairingDual ∘ Λⁿ(B)`, where `B` is
viewed as the map `W → Dual K W`. -/
noncomputable def exteriorForm (n : ℕ) (B : LinearMap.BilinForm K W) :
    LinearMap.BilinForm K (⋀[K]^n W) :=
  exteriorPower.pairingDual K W n ∘ₗ exteriorPower.map n B

/-- Gram-determinant formula for `exteriorForm` on decomposable states. -/
theorem exteriorForm_apply_ιMulti (n : ℕ) (B : LinearMap.BilinForm K W)
    (v w : Fin n → W) :
    exteriorForm n B (ιMulti K n v) (ιMulti K n w)
      = (Matrix.of fun i j => B (v j) (w i)).det := by
  unfold exteriorForm
  simp [map_apply_ιMulti, pairingDual_ιMulti_ιMulti]

end Defs

/-! ## The perfect-pairing bridge: `pairingDual` is an isomorphism in finite dim -/

section PerfectPairing
variable {K W : Type*} [Field K] [AddCommGroup W] [Module K W]
variable {I : Type*} [LinearOrder I] [Finite I]

/-
`pairingDual` sends the exterior-power basis built from the dual basis to the
dual of the exterior-power basis built from `b`.  This is the explicit witness
that the exterior-power/dual pairing is *perfect* in finite dimension.
-/
theorem pairingDual_maps_basis (b : Module.Basis I K W) (n : ℕ)
    (s : Set.powersetCard I n) :
    pairingDual K W n ((b.dualBasis).exteriorPower n s)
      = (b.exteriorPower n).dualBasis s := by
  simp +decide [ pairingDual, exteriorPower.basis_coord ];
  unfold alternatingMapLinearEquiv ιMultiDual ; aesop;

/-
**Perfect-pairing bridge (core).**  For a finite-dimensional space the
canonical pairing `⋀ⁿ(Dual W) → Dual(⋀ⁿ W)` is a linear isomorphism.
-/
theorem pairingDual_bijective (b : Module.Basis I K W) (n : ℕ) :
    Function.Bijective (pairingDual K W n) := by
  have h_dim : FiniteDimensional K W := by
    exact Module.Basis.finiteDimensional_of_finite b;
  have h_pairingDual_bijective : LinearMap.range (pairingDual K W n) = ⊤ := by
    refine' Submodule.eq_top_iff'.mpr fun x => _;
    -- By definition of $x$, we can write it as a linear combination of the dual basis elements.
    obtain ⟨c, hc⟩ : ∃ c : Set.powersetCard I n → K, x = ∑ s ∈ Finset.univ, c s • (b.exteriorPower n).dualBasis s := by
      exact ⟨ _, Eq.symm ( ( b.exteriorPower n ).dualBasis.sum_repr x ) ⟩;
    exact hc.symm ▸ Submodule.sum_mem _ fun s _ => Submodule.smul_mem _ _ ⟨ _, pairingDual_maps_basis b n s ⟩;
  have h_pairingDual_bijective : LinearMap.ker (pairingDual K W n) = ⊥ := by
    have h_pairingDual_bijective : Module.finrank K (⋀[K]^n (Module.Dual K W)) = Module.finrank K (Module.Dual K (⋀[K]^n W)) := by
      simp +decide [ Module.finrank_eq_card_basis ( b.exteriorPower n ), Module.finrank_eq_card_basis ( b.dualBasis.exteriorPower n ) ];
    have := LinearMap.finrank_range_add_finrank_ker ( pairingDual K W n );
    rw [ ‹LinearMap.range ( pairingDual K W n ) = ⊤›, finrank_top ] at this ; aesop;
  exact ⟨ LinearMap.ker_eq_bot.mp h_pairingDual_bijective, LinearMap.range_eq_top.mp ‹_› ⟩

end PerfectPairing

/-! ## The perfect-pairing bridge: nondegeneracy propagates to exterior powers -/

section Nondegenerate
variable {K W : Type*} [Field K] [AddCommGroup W] [Module K W]

/-
**Perfect-pairing bridge.**  If `B` is a nondegenerate form on a
finite-dimensional space, then the induced Gram-determinant form on `⋀ⁿ W` is
nondegenerate.  (Cauchy–Binet: the `n`-th compound of an invertible Gram matrix
is invertible.)  No positivity is used or claimed.
-/
theorem exteriorForm_nondegenerate [FiniteDimensional K W] (n : ℕ)
    {B : LinearMap.BilinForm K W} (hB : B.Nondegenerate) :
    (exteriorForm n B).Nondegenerate := by
  convert LinearMap.BilinForm.nondegenerate_iff_ker_eq_bot.mpr _;
  · infer_instance;
  · infer_instance;
  · infer_instance;
  · have h_injective : Function.Injective (exteriorPower.map n B) := by
      convert exteriorPower.map_injective_field _;
      intro x y hxy;
      exact sub_eq_zero.mp ( hB.left _ fun z => by simpa [ sub_eq_zero ] using congr_arg ( fun f => f z ) ( sub_eq_zero.mpr hxy ) );
    have h_bijective : Function.Bijective (pairingDual K W n) := by
      convert pairingDual_bijective ( Module.Free.chooseBasis K W ) n;
      exact IsWellFounded.wellOrderExtension emptyWf.rel;
    exact LinearMap.ker_eq_bot_of_injective ( h_bijective.injective.comp h_injective )

end Nondegenerate

/-! ## Naturality and the pullback form -/

section Pullback
variable {K W W' : Type*} [Field K] [AddCommGroup W] [Module K W]
  [AddCommGroup W'] [Module K W']

/-
Naturality of `pairingDual` under `dualMap`.
-/
theorem pairingDual_naturality (q : W →ₗ[K] W') (n : ℕ) :
    pairingDual K W n ∘ₗ map n q.dualMap
      = (map n q).dualMap ∘ₗ pairingDual K W' n := by
  ext; simp +decide [ pairingDual_ιMulti_ιMulti, map_apply_ιMulti ]

/-
The exterior form of a pulled-back bilinear form is the pullback of the
exterior form: `Λⁿ(q* h' q) = (Λⁿ q)* (Λⁿ h') (Λⁿ q)`, on values.
-/
theorem exteriorForm_pullback_value (q : W →ₗ[K] W')
    (h' : LinearMap.BilinForm K W') (n : ℕ) (x y : ⋀[K]^n W) :
    exteriorForm n (q.dualMap ∘ₗ h' ∘ₗ q) x y
      = exteriorForm n h' (map n q x) (map n q y) := by
  have := pairingDual_naturality q n;
  convert congr_arg ( fun f => f ( exteriorPower.map n h' ( exteriorPower.map n q x ) ) y ) this using 1;
  simp +decide [ exteriorForm, map_comp ]

end Pullback

/-! ## The quotient bridge (T-F2 at fixed particle number) -/

section Quotient
variable {K W W' : Type*} [Field K] [AddCommGroup W] [Module K W]
  [AddCommGroup W'] [Module K W']

/-
**Radical = kernel of the Fock projection.**  For a surjection `q : W → W'`
and a nondegenerate form `h'` on the finite-dimensional target, the radical of
the pulled-back exterior form on `⋀ⁿ W` is exactly `ker(Λⁿ q)`.
-/
theorem exteriorForm_ker_eq [FiniteDimensional K W'] (q : W →ₗ[K] W')
    (hq : Function.Surjective q) (h' : LinearMap.BilinForm K W')
    (hh' : h'.Nondegenerate) (n : ℕ) :
    LinearMap.ker (exteriorForm n (q.dualMap ∘ₗ h' ∘ₗ q))
      = LinearMap.ker (map n q) := by
  ext x;
  constructor <;> intro hx;
  · have h_surj : Function.Surjective (exteriorPower.map n q) :=
      exteriorPower.map_surjective hq
    obtain ⟨y, hy⟩ : ∃ y : ⋀[K]^n W', exteriorPower.map n q x = y := by
      exact ⟨ _, rfl ⟩;
    have h_nondeg : ∀ z : ⋀[K]^n W', (exteriorForm n h') y z = 0 := by
      intro z
      obtain ⟨w, hw⟩ : ∃ w : ⋀[K]^n W, exteriorPower.map n q w = z := h_surj z;
      have := exteriorForm_pullback_value q h' n x w; aesop;
    have h_nondeg : y = 0 := by
      apply (exteriorForm_nondegenerate n hh').1 y h_nondeg;
    aesop;
  · ext y;
    simp_all +decide [ exteriorForm_pullback_value ]

/-- **Fock quotient bridge (T-F2, degree `n`).**  The Fock projection `Λⁿ q`
descends to a linear isomorphism `Λⁿ(W)/rad ≅ Λⁿ(W')`. -/
noncomputable def fockQuotientEquiv [FiniteDimensional K W'] (q : W →ₗ[K] W')
    (hq : Function.Surjective q) (h' : LinearMap.BilinForm K W')
    (hh' : h'.Nondegenerate) (n : ℕ) :
    ((⋀[K]^n W) ⧸ LinearMap.ker (exteriorForm n (q.dualMap ∘ₗ h' ∘ₗ q)))
      ≃ₗ[K] ⋀[K]^n W' :=
  (Submodule.quotEquivOfEq _ _ (exteriorForm_ker_eq q hq h' hh' n)).trans
    (LinearMap.quotKerEquivOfSurjective (map n q) (map_surjective hq))

/-- The quotient isomorphism is an **isometry** of induced forms: the exterior
form on `⋀ⁿ W` is the pullback along `Λⁿ q` of the (nondegenerate) exterior form
on `⋀ⁿ W'`.  Combined with `exteriorForm_ker_eq` and surjectivity of `Λⁿ q`,
this is the finite statement `Fock(W)/rad ≅ Fock(W')` as form spaces. -/
theorem fockQuotient_isometry (q : W →ₗ[K] W') (h' : LinearMap.BilinForm K W')
    (n : ℕ) (x y : ⋀[K]^n W) :
    exteriorForm n (q.dualMap ∘ₗ h' ∘ₗ q) x y
      = exteriorForm n h' (map n q x) (map n q y) :=
  exteriorForm_pullback_value q h' n x y

end Quotient

/-! ## Specialization to the radical: `rad(Λⁿ h) = ker(Λⁿ mkQ_N)` with `N = rad(h)`

This instantiates the pullback bridge at `W' = W/N`, `N = rad(h)`, giving the
Q08 headline that the radical of the second-quantized form at particle number `n`
is exactly the kernel of the Fock projection onto `Λⁿ(W/N)`.  We work with a
symmetric form so that its (two-sided) radical is `ker h` and it descends to a
nondegenerate form on `W/N`. -/

section Radical
variable {K W : Type*} [Field K] [AddCommGroup W] [Module K W] [FiniteDimensional K W]

/-- The nondegenerate form induced by a symmetric form `h` on the quotient by its
radical `N = ker h`.  Concretely `h̄(x̄, ȳ) = h(x, y)`, well-defined because `N`
is the radical. -/
noncomputable def radicalQuotientForm (h : LinearMap.BilinForm K W) (hsymm : h.IsSymm) :
    LinearMap.BilinForm K (W ⧸ LinearMap.ker h) :=
  (LinearMap.ker h).liftQ
    ((Submodule.dualQuotEquivDualAnnihilator (LinearMap.ker h)).symm.toLinearMap ∘ₗ
      h.codRestrict (LinearMap.ker h).dualAnnihilator (by
        intro x
        rw [Submodule.mem_dualAnnihilator]
        intro n hn
        have hn0 : h n = 0 := by simpa [LinearMap.mem_ker] using hn
        have hsx : (h x) n = (h n) x := hsymm.eq x n
        rw [hsx, hn0, LinearMap.zero_apply]))
    (by
      intro n hn
      simp only [LinearMap.mem_ker, LinearMap.comp_apply]
      have hn0 : h n = 0 := by simpa [LinearMap.mem_ker] using hn
      apply (Submodule.dualQuotEquivDualAnnihilator (LinearMap.ker h)).symm.map_eq_zero_iff.mpr
      ext y
      simp [LinearMap.codRestrict, hn0])

-- `radicalQuotientForm` recovers `h` as a pullback along the radical quotient map.
omit [FiniteDimensional K W] in
theorem radicalQuotientForm_pullback (h : LinearMap.BilinForm K W) (hsymm : h.IsSymm)
    (x y : W) :
    h x y = radicalQuotientForm h hsymm ((LinearMap.ker h).mkQ x) ((LinearMap.ker h).mkQ y) := by
  rfl

-- As a composition of linear maps, `h` is the pullback of `radicalQuotientForm h`
-- along the radical quotient map.
omit [FiniteDimensional K W] in
theorem radicalQuotientForm_pullback_comp (h : LinearMap.BilinForm K W) (hsymm : h.IsSymm) :
    h = (LinearMap.ker h).mkQ.dualMap ∘ₗ radicalQuotientForm h hsymm ∘ₗ (LinearMap.ker h).mkQ := by
  ext x y; exact (radicalQuotientForm_pullback h hsymm x y).symm;

/-
The induced form on `W/rad(h)` is nondegenerate.
-/
theorem radicalQuotientForm_nondegenerate (h : LinearMap.BilinForm K W) (hsymm : h.IsSymm) :
    (radicalQuotientForm h hsymm).Nondegenerate := by
  convert LinearMap.BilinForm.nondegenerate_iff_ker_eq_bot.mpr _;
  · infer_instance;
  · infer_instance;
  · infer_instance;
  · rw [ LinearMap.ker_eq_bot' ];
    intro m hm; obtain ⟨ x, rfl ⟩ := Submodule.mkQ_surjective _ m; simp_all +decide [ LinearMap.ext_iff ] ;
    intro y; specialize hm ( Submodule.Quotient.mk y ) ; simp_all +decide [ radicalQuotientForm_pullback ] ;

/-
**T-F2 headline (degree `n`): `rad(Λⁿ h) = ker(Λⁿ mkQ_N)`.**  For a symmetric
form `h` with radical `N = ker h`, the radical of the induced Gram form on `Λⁿ W`
is exactly the kernel of the Fock projection `Λⁿ(mkQ_N) : Λⁿ W → Λⁿ(W/N)`.  Hence
`Λⁿ(W)/rad ≅ Λⁿ(W/N)` (via `fockQuotientEquiv`), the second-quantized
Gupta–Bleuler quotient at particle number `n`.
-/
theorem exteriorForm_radical_eq (h : LinearMap.BilinForm K W) (hsymm : h.IsSymm) (n : ℕ) :
    LinearMap.ker (exteriorForm n h)
      = LinearMap.ker (map n (LinearMap.ker h).mkQ) := by
  convert exteriorForm_ker_eq ( LinearMap.ker h ).mkQ ( Submodule.mkQ_surjective _ ) ( radicalQuotientForm h hsymm ) ( radicalQuotientForm_nondegenerate h hsymm ) n using 1

end Radical

end PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing
