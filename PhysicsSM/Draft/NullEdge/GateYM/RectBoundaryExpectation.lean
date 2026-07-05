import PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryLasso

/-!
# Gate YM1: boundary-circuit expectation target

This focused Aristotle target asks for the final Q11/YM1 bridge from the
rectangular boundary-circuit Wilson observable to the already proved
`RectTreeGauge.rect_wilson_loop_expectation_area_law`.

## Why the proof is a gauge-orbit reduction, not a pointwise identity

The pointwise class-function identity
`chi (hol U (rectBoundaryWalk)) = chi (reversedRowMajorPlaquetteProd U)`
is FALSE at general link fields: the boundary holonomy is an ordered product of
plaquettes each conjugated by its own comb-tree tail, which is genuinely not a
single conjugate of the reversed-row-major product in a nonabelian group.  The
expectation identity nevertheless holds because summing over the tree links
gauge-averages every field onto the comb tree slice, where the tree-slice lasso
identity (`RectBoundaryLasso`) does apply.

The proof therefore:
1. writes the boundary numerator as a sum over link fields of a gauge-invariant
   summand (`bSummand`, gauge invariant via `productWeight_gauge` and
   `classFunction_hol_gauge_closed`);
2. reduces that sum to `|G| ^ card(tree links)` times the sum over the comb tree
   slice, using a fixed-per-tree-value comb-tree gauge (`combGaugeField`) that
   trivializes the tree links, and a conjugation bijection on plaquette
   coordinates (`treeSlice_sum_indep_t`);
3. identifies the tree-slice sum with the independent-plaquette
   `loopNumerator` via the tree-slice lasso and the coordinatization;
4. concludes with `IndependentPlaquetteEnsemble.wilson_loop_expectation_area_law`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace RectBoundaryExpectation

open scoped Matrix

open GaugeCoreGeneral PlaquetteCore RectTreeGauge RectBoundaryLasso TreeGaugeBridge
  IndependentPlaquetteEnsemble FusionConvolution
open CategoryTheory

variable {G : Type} [Group G]

/-! ## The comb reindexing embedding and the flattening identity -/

/-- Reindex `Fin (Lx * Ly)` as `Fin Lx x Fin Ly` in reversed-row-major order:
`k = i + Lx * j` maps to `(i.rev, j)`.  This is the comb order in which the
`reversedRowMajorPlaquetteProd` multiplies plaquettes. -/
def combEquiv (Lx Ly : Nat) : Fin (Lx * Ly) ≃ Fin Lx × Fin Ly :=
  ((finCongr (Nat.mul_comm Lx Ly)).trans finProdFinEquiv.symm).trans
    ((Equiv.prodComm (Fin Ly) (Fin Lx)).trans
      (Equiv.prodCongr Fin.revPerm (Equiv.refl (Fin Ly))))

/-- The comb reindexing embedding. -/
def combEmbed (Lx Ly : Nat) : Fin (Lx * Ly) ↪ Fin Lx × Fin Ly :=
  (combEquiv Lx Ly).toEmbedding

/-
General flattening of a nested `List.ofFn` product into a single ordered
product over the standard `finProdFinEquiv` product index (outer `j : Fin a`,
inner `i : Fin b`).
-/
theorem prod_nested_ofFn {M : Type*} [Monoid M] (a b : Nat) (g : Fin a → Fin b → M) :
    (List.ofFn fun j : Fin a => (List.ofFn fun i : Fin b => g j i).prod).prod
      = (List.ofFn fun p : Fin (a * b) =>
          g (finProdFinEquiv.symm p).1 (finProdFinEquiv.symm p).2).prod := by
  induction' a with a ih;
  · simp +decide [ zero_mul ];
  · rw [ List.ofFn_succ' ] ; simp +decide [ ih ] ;
    rw [ ← List.prod_append ];
    refine' congr_arg _ ( List.ext_get _ _ ) <;> simp +decide;
    · ring_nf;
    · intro n hn hn'; by_cases h : n < a * b <;> simp_all +decide;
      · congr! 1;
      · congr 2 <;> norm_num [ Fin.ext_iff, Fin.val_add, Fin.val_mul ];
        · exact Eq.symm ( Nat.le_antisymm ( Nat.le_of_lt_succ <| Nat.div_lt_of_lt_mul <| by linarith ) ( Nat.le_div_iff_mul_le ( Nat.pos_of_ne_zero <| by aesop_cat ) |>.2 <| by linarith ) );
        · rw [ Nat.mod_eq_sub_mul_div ];
          rw [ show n / b = a by nlinarith [ Nat.div_mul_le_self n b, Nat.div_add_mod n b, Nat.mod_lt n ( by nlinarith : 0 < b ) ] ] ; ring_nf

/-
Flattening identity (pointwise, all link fields): the reversed-row-major
plaquette product equals the ordered product over the comb reindexing.  This is
a pure combinatorial reindexing of the same (order-sensitive) product.
-/
theorem reversedRowMajor_eq_orderedProd (Lx Ly : Nat)
    (U : (rectLattice Lx Ly).LinkField (G := G)) :
    reversedRowMajorPlaquetteProd Lx Ly U
      = orderedProd (fun k => (rectPlaquette Lx Ly (combEmbed Lx Ly k)).hol U) := by
  unfold reversedRowMajorPlaquetteProd orderedProd;
  convert prod_nested_ofFn Ly Lx _ using 2;
  refine' List.ext_get _ _ <;> simp +decide [ combEmbed, combEquiv ];
  ring_nf

/-! ## The comb-tree gauge -/

/-- The comb-tree path gauge of a link field: `combGaugeField U (i, j)` is the
holonomy of the comb-tree path from the base vertex `(0,0)` up the leftmost
column to `(0, j)` and then right along row `j` to `(i, j)`.  It reads `U` only
on tree links (horizontals and the leftmost vertical column). -/
def combGaugeField (Lx Ly : Nat) (U : (rectLattice Lx Ly).LinkField (G := G)) :
    (rectLattice Lx Ly).V → G :=
  fun v =>
    OrientedLattice.hol U
        (rectVerticalWalkAux Lx Ly (0 : Fin (Lx + 1)) v.2.1 (Nat.le_of_lt_succ v.2.2))
      * OrientedLattice.hol U
          (rectHorizontalWalkAux Lx Ly v.2 v.1.1 (Nat.le_of_lt_succ v.1.2))

/-
Peeling the last step of an initial horizontal walk.
-/
theorem rectHorizontalWalkAux_hol_succ {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (j : Fin (Ly + 1)) (k : Nat)
    (hk : k + 1 ≤ Lx) :
    OrientedLattice.hol U (rectHorizontalWalkAux Lx Ly j (k + 1) hk)
      = OrientedLattice.hol U (rectHorizontalWalkAux Lx Ly j k (Nat.le_of_succ_le hk))
        * U (Sum.inl (⟨k, Nat.lt_of_succ_le hk⟩, j)) := by
  convert OrientedLattice.hol_append _ _ _ using 2;
  -- Use the definition of hol for the `cons` case and the fact that `Step.castEndpoints` does not change `stepHol` (and the `nil` walk's hol is 1).
  · -- Expand the definitions of `OrientedLattice.hol` for the `cons` and at `nil`.
    simp [OrientedLattice.hol, OrientedLattice.stepHol, OrientedLattice.Step.castEndpoints]

/-
Peeling the last step of an initial vertical walk.
-/
theorem rectVerticalWalkAux_hol_succ {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (i : Fin (Lx + 1)) (k : Nat)
    (hk : k + 1 ≤ Ly) :
    OrientedLattice.hol U (rectVerticalWalkAux Lx Ly i (k + 1) hk)
      = OrientedLattice.hol U (rectVerticalWalkAux Lx Ly i k (Nat.le_of_succ_le hk))
        * U (Sum.inr (i, ⟨k, Nat.lt_of_succ_le hk⟩)) := by
  rw [rectVerticalWalkAux];
  rw [OrientedLattice.hol_append];
  simp +decide [ OrientedLattice.hol, OrientedLattice.stepHol_castEndpoints ];
  rfl

/-
Horizontal recursion of the comb gauge along a row.
-/
theorem combGaugeField_horiz {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (i : Fin Lx) (j : Fin (Ly + 1)) :
    combGaugeField Lx Ly U (i.succ, j)
      = combGaugeField Lx Ly U (i.castSucc, j) * U (Sum.inl (i, j)) := by
  unfold combGaugeField;
  simp +decide [ mul_assoc, rectHorizontalWalkAux_hol_succ ]

/-
Vertical recursion of the comb gauge along the leftmost column.
-/
theorem combGaugeField_vleft {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) (j : Fin Ly) :
    combGaugeField Lx Ly U ((0 : Fin (Lx + 1)), j.succ)
      = combGaugeField Lx Ly U ((0 : Fin (Lx + 1)), j.castSucc)
        * U (Sum.inr ((0 : Fin (Lx + 1)), j)) := by
  unfold combGaugeField;
  simp +decide [ rectHorizontalWalkAux, rectVerticalWalkAux_hol_succ ];
  simp +decide [OrientedLattice.hol]

/-
The comb gauge trivializes all tree links: `gauge (combGaugeField U) U` is a
comb tree slice.
-/
theorem combGauge_treeSlice {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G)) :
    IsCombTreeSlice Lx Ly ((rectLattice Lx Ly).gauge (combGaugeField Lx Ly U) U) := by
  intro t; cases t <;> simp +decide [*, treeLink, rectLattice] ;
  · rename_i h;
    have := combGaugeField_horiz U h.1 h.2; simp_all +decide [ mul_assoc, OrientedLattice.gauge ] ;
  · simp +decide [ *, GaugeCoreGeneral.OrientedLattice.gauge ];
    rename_i j; rw [ combGaugeField_vleft ] ; group;

/-
The comb gauge depends only on the tree links.
-/
theorem combGaugeField_tree_indep {Lx Ly : Nat}
    (U U' : (rectLattice Lx Ly).LinkField (G := G))
    (h : ∀ s : RectTree Lx Ly, U (treeLink Lx Ly s) = U' (treeLink Lx Ly s)) :
    combGaugeField Lx Ly U = combGaugeField Lx Ly U' := by
  funext v;
  -- By definition of `combGaugeField`, we can write it as a product of holonomies along vertical and horizontal paths.
  simp [combGaugeField];
  rw [ rectVerticalWalkAux_hol, rectVerticalWalkAux_hol ];
  congr! 1;
  · congr! 1;
    refine' List.ext_get _ _ <;> aesop;
  · -- By induction on the length of the horizontal walk, we can show that the holonomies are equal.
    have h_ind : ∀ k hk, OrientedLattice.hol U (rectHorizontalWalkAux Lx Ly v.2 k hk) = OrientedLattice.hol U' (rectHorizontalWalkAux Lx Ly v.2 k hk) := by
      intro k hk; induction' k with k ih <;> simp_all +decide [ rectHorizontalWalkAux_hol_succ ] ;
      · rfl;
      · exact h.1 _ _;
    exact h_ind _ _

/-! ## The boundary summand and its gauge invariance -/

/-- The boundary Wilson numerator summand: the plaquette product weight times the
character of the full boundary holonomy. -/
def bSummand (Lx Ly : Nat) (w chi : G → ℂ)
    (U : (rectLattice Lx Ly).LinkField (G := G)) : ℂ :=
  (∏ i, w ((rectPlaquette Lx Ly i).hol U))
    * chi (OrientedLattice.hol U (rectBoundaryWalk Lx Ly))

/-
The boundary summand is gauge invariant when `w` and `chi` are class
functions.
-/
theorem bSummand_gauge_inv {Lx Ly : Nat} (w chi : G → ℂ)
    (hw : IsClassFunction w) (hchi : ∀ a b : G, chi (a * b * a⁻¹) = chi b)
    (g : (rectLattice Lx Ly).V → G) (U : (rectLattice Lx Ly).LinkField (G := G)) :
    bSummand Lx Ly w chi ((rectLattice Lx Ly).gauge g U) = bSummand Lx Ly w chi U := by
  convert congr_arg₂ ( fun x y => x * y ) ( Finset.prod_congr rfl ?_ ) ( OrientedLattice.classFunction_hol_gauge_closed chi hchi g U ( rectBoundaryWalk Lx Ly ) ) using 1;
  intro p _; exact Plaquette.classFunction_hol_gauge ( rectPlaquette Lx Ly p ) w hw g U;

/-! ## Gauge-orbit reduction to the comb tree slice -/

/-- The residual (tree) coordinate of a link field reads off its tree links.
Definitional unfolding of `rectCoordinatization`. -/
theorem coord_snd_apply {Lx Ly : Nat} [Fintype G]
    (W : (rectLattice Lx Ly).LinkField (G := G)) (s : RectTree Lx Ly) :
    ((rectCoordinatization Lx Ly G).coord W).2 s = W (treeLink Lx Ly s) := rfl

/-
For a fixed tree value `t`, the sum of the gauge-invariant boundary summand
over all plaquette coordinates is independent of `t`; in particular it equals the
value at `t = 1` (the comb tree slice).  This is the per-tree-value gauge-orbit
reindexing.
-/
theorem treeSlice_sum_indep_t {Lx Ly : Nat} [Fintype G] (w chi : G → ℂ)
    (hw : IsClassFunction w) (hchi : ∀ a b : G, chi (a * b * a⁻¹) = chi b)
    (t : RectTree Lx Ly → G) :
    (∑ V : Fin Lx × Fin Ly → G,
        bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, t)))
      = ∑ V : Fin Lx × Fin Ly → G,
          bSummand Lx Ly w chi
            ((rectCoordinatization Lx Ly G).coord.symm (V, (1 : RectTree Lx Ly → G))) := by
  set C := rectCoordinatization Lx Ly G
  set coord := C.coord
  set coord_inv := C.coord.symm
  set g_t := combGaugeField Lx Ly (coord_inv (1, t));
  -- By definition of `beta_t`, it reindexes plaquette coordinates after gauge fixing.
  set beta_t : (Fin Lx × Fin Ly → G) → (Fin Lx × Fin Ly → G) := fun V => (coord ((rectLattice Lx Ly).gauge g_t (coord_inv (V, t)))).1;
  -- The gauge-fixed field has tree coordinates equal to `1`.
  have h_gauge : ∀ V : Fin Lx × Fin Ly → G, (rectLattice Lx Ly).gauge g_t (coord_inv (V, t)) = coord_inv (beta_t V, 1) := by
    intro V
    have h_treeSlice : IsCombTreeSlice Lx Ly ((rectLattice Lx Ly).gauge g_t (coord_inv (V, t))) := by
      have h_g_t : g_t = combGaugeField Lx Ly (coord_inv (V, t)) := by
        apply combGaugeField_tree_indep;
        intro s; have := coord_snd_apply ( coord_inv ( 1, t ) ) s; have := coord_snd_apply ( coord_inv ( V, t ) ) s; aesop;
      exact h_g_t.symm ▸ combGauge_treeSlice _;
    have h_treeSlice : (coord ((rectLattice Lx Ly).gauge g_t (coord_inv (V, t)))).2 = 1 := by
      exact funext fun s => by simpa using h_treeSlice s |> Eq.trans ( coord_snd_apply _ _ ) ;
    grind +revert;
  -- By definition of `beta_t`, it is injective.
  have h_beta_inj : Function.Injective beta_t := by
    intro V V' h_eq
    have h_gauge_eq : (rectLattice Lx Ly).gauge g_t (coord_inv (V, t)) = (rectLattice Lx Ly).gauge g_t (coord_inv (V', t)) := by
      rw [ h_gauge V, h_gauge V', h_eq ];
    have h_gauge_eq : coord_inv (V, t) = coord_inv (V', t) := by
      exact (rectLattice Lx Ly).gaugeEquiv g_t |>.injective h_gauge_eq;
    exact congr_arg Prod.fst ( coord_inv.injective h_gauge_eq );
  -- Finite injective maps are bijective.
  have h_beta_bij : Function.Bijective beta_t := by
    exact ⟨ h_beta_inj, Finite.injective_iff_surjective.mp h_beta_inj ⟩;
  conv_rhs => rw [ ← Equiv.sum_comp ( Equiv.ofBijective beta_t h_beta_bij ) ] ;
  exact Finset.sum_congr rfl fun _ _ => h_gauge _ ▸ bSummand_gauge_inv w chi hw hchi g_t _ ▸ rfl

/-
On the comb tree slice, the boundary summand collapses to the
independent-plaquette summand: the tree-slice lasso identity turns the boundary
holonomy into the ordered product of plaquette coordinates.
-/
theorem treeSlice_summand_eq {Lx Ly : Nat} [Fintype G] (w chi : G → ℂ)
    (V : Fin Lx × Fin Ly → G) :
    bSummand Lx Ly w chi
        ((rectCoordinatization Lx Ly G).coord.symm (V, (1 : RectTree Lx Ly → G)))
      = (∏ i, w (V i)) * chi (orderedProd (fun k => V (combEmbed Lx Ly k))) := by
  -- Apply the tree-slice lasso identity to rewrite the holonomy.
  have h_hol : OrientedLattice.hol ((rectCoordinatization Lx Ly G).coord.symm (V, 1)) (rectBoundaryWalk Lx Ly) = reversedRowMajorPlaquetteProd Lx Ly ((rectCoordinatization Lx Ly G).coord.symm (V, 1)) := by
    apply rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice;
    intro s; exact (by
    exact Eq.symm ( by exact (by
      have := coord_snd_apply ((rectCoordinatization Lx Ly G).coord.symm (V, 1)) s;
      exact this ▸ by simp +decide ;
    ) ));
  convert congr_arg₂ ( · * · ) ( Finset.prod_congr rfl fun i _ => rfl ) ( congr_arg chi h_hol ) using 2;
  · exact Finset.prod_congr rfl fun _ _ => by erw [ rectCoordinatization Lx Ly G |>.hol_coord ] ; simp +decide ;
  · rw [ reversedRowMajor_eq_orderedProd ];
    congr! 2;
    ext k; exact (by
    exact Eq.symm ( by simpa using ( rectCoordinatization Lx Ly G ).hol_coord ( ( rectCoordinatization Lx Ly G ).coord.symm ( V, 1 ) ) ( combEmbed Lx Ly k ) ))

/-
The boundary link numerator is `|G| ^ card(tree links)` times the
independent-plaquette loop numerator.
-/
theorem linkNumerator_boundary_eq {Lx Ly : Nat} [Fintype G] (w chi : G → ℂ)
    (hw : IsClassFunction w) (hchi : ∀ a b : G, chi (a * b * a⁻¹) = chi b) :
    linkNumerator (rectPlaquette Lx Ly) w
        (fun U => chi (OrientedLattice.hol U (rectBoundaryWalk Lx Ly)))
      = (Fintype.card G : ℂ) ^ Fintype.card (RectTree Lx Ly)
        * loopNumerator w chi (combEmbed Lx Ly) := by
  have h_reindex : ∑ U : (rectLattice Lx Ly).LinkField, bSummand Lx Ly w chi U = ∑ V : Fin Lx × Fin Ly → G, ∑ t : RectTree Lx Ly → G, bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, t)) := by
    rw [ ← Finset.sum_product' ];
    refine' Finset.sum_bij ( fun U _ => ( ( rectCoordinatization Lx Ly G ).coord U |>.1, ( rectCoordinatization Lx Ly G ).coord U |>.2 ) ) _ _ _ _ <;> simp +decide;
    exact fun a b => ⟨ _, Equiv.apply_symm_apply _ _ ⟩;
  have h_swap : ∑ t : RectTree Lx Ly → G, ∑ V : Fin Lx × Fin Ly → G, bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, t)) = (Fintype.card G : ℂ) ^ Fintype.card (RectTree Lx Ly) * ∑ V : Fin Lx × Fin Ly → G, bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, 1)) := by
    have h_swap : ∀ t : RectTree Lx Ly → G, ∑ V : Fin Lx × Fin Ly → G, bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, t)) = ∑ V : Fin Lx × Fin Ly → G, bSummand Lx Ly w chi ((rectCoordinatization Lx Ly G).coord.symm (V, 1)) := by
      convert treeSlice_sum_indep_t w chi hw hchi using 1;
    simp +decide [ h_swap, Fintype.card_pi ];
  convert h_reindex.trans ( Finset.sum_comm.trans h_swap ) using 1;
  exact congrArg _ ( Finset.sum_congr rfl fun _ _ => treeSlice_summand_eq w chi _ ▸ rfl )

/-
The boundary link expectation equals the independent-plaquette loop
expectation.
-/
theorem linkExpectation_boundary_eq {Lx Ly : Nat} [Fintype G] (w chi : G → ℂ)
    (hw : IsClassFunction w) (hchi : ∀ a b : G, chi (a * b * a⁻¹) = chi b) :
    linkExpectation (rectPlaquette Lx Ly) w
        (fun U => chi (OrientedLattice.hol U (rectBoundaryWalk Lx Ly)))
      = loopExpectation w chi (combEmbed Lx Ly) := by
  unfold linkExpectation loopExpectation
  rw [linkNumerator_boundary_eq w chi hw hchi,
    linkPartition_eq (rectCoordinatization Lx Ly G) w,
    mul_div_mul_left _ _ (pow_ne_zero _ (Nat.cast_ne_zero.mpr Fintype.card_ne_zero))]

/-! ## The final bridge -/

/--
Final rectangular boundary-circuit form of YM1/Theorem 2.

On the concrete open `Lx x Ly` rectangle, the link-ensemble Wilson expectation
of the character evaluated on the full counterclockwise boundary holonomy is
the exact finite area law with area `Lx * Ly`.
-/
theorem rect_boundary_wilson_loop_expectation_area_law {n : Nat} [Fintype G]
    (Lx Ly : Nat) (beta : Real)
    (rho : G -> Matrix (Fin n) (Fin n) Complex)
    (hmul : forall g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : forall g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep Complex G) [Simple R] :
    TreeGaugeBridge.linkExpectation (rectPlaquette Lx Ly)
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => R.character
          (OrientedLattice.hol U (rectBoundaryWalk Lx Ly)))
      = R.character 1
        * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ (Lx * Ly) := by
  have hw : IsClassFunction (Theorem2AreaLaw.wilsonLocalWeightC beta rho) :=
    Theorem2AreaLaw.wilsonLocalWeightC_class beta rho hmul hone
  have hchi : ∀ a b : G, R.character (a * b * a⁻¹) = R.character b :=
    fun a b => FDRep.char_conj R b a
  rw [linkExpectation_boundary_eq (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
    R.character hw hchi]
  have hcard : Fintype.card (Fin Lx × Fin Ly) = Lx * Ly := by
    simp [Fintype.card_prod, Fintype.card_fin]
  have := IndependentPlaquetteEnsemble.wilson_loop_expectation_area_law
    (ν := Fin Lx × Fin Ly) beta rho hmul hone hunit R
    (m := Lx * Ly) (hcard.ge) (combEmbed Lx Ly)
  exact this

end RectBoundaryExpectation
end GateYM
end NullEdge
end Draft
end PhysicsSM
