import Mathlib

/-!
# Gauge-twisted magnetic decoder: intertwiners, cocycle invariance, and a genuine escape

This standalone target carries out a genuinely new escape test against the
pi-flux magnetic-translation doubling no-go established in
`PiFlux3Plus1Census`/`PiFluxCocycleDecoder`.  The prior verdict was: keeping
*all* naked magnetic translations as exact symmetries forces every invariant
walk eigenspace to have at least two-fold degeneracy.  Here we ask
whether *gauge-covariant intertwiners* — dressing a naked translation with an
onsite gauge — can escape, and give an exact, machine-checked answer on the
smallest cocycle-carrying finite cell.

## Contents

### 1. Gauge-covariant intertwiners (classification)
`GaugeIntertwiner U A B A' B'` bundles `U ∘ A = A' ∘ U` and `U ∘ B = B' ∘ U`.
We classify: for surjective `U` the target pair `A', B'` is *uniquely*
determined (`intertwiner_target_unique`), and for bijective `U` an intertwined
target *exists* (`intertwiner_target_exists`), namely the conjugate
`U ∘ A ∘ U⁻¹`.

### 2. The central cocycle sign is an invariant (no-go for opposite classes)
`cocycle_sign_preserved`: if `U` is invertible and intertwines `(A,B)` with
`(A',B')`, and `A ∘ B = ε • (B ∘ A)`, `A' ∘ B' = ε' • (B' ∘ A')`, then
`ε = ε'`.  Hence `no_invertible_decoder_opposite`: two projective
representations with *opposite* central cocycle signs (e.g. a commuting pair
and a pi-flux anticommuting pair) admit *no* invertible decoder.

### 3. Equivalent exact projective representations transport degeneracy
`transport_involutions`: an invertible intertwiner sends anticommuting
involutions to anticommuting involutions.  `transport_degeneracy`: therefore
any walk commuting with the *transported* pair is still doubled — equivalence
moves the degeneracy, it does not remove it.

### 4. The escape construction and a complete +1 / -1 census
On the smallest cocycle cell `Site := (ZMod 2)²` we build an explicit finite
involutive (hence invertible) update `W` that

* **breaks** the naked magnetic translations `Tx` and `Ty`
  (`W_not_comm_Tx`, `W_not_comm_Ty`), yet
* **preserves** the *combined gauge-covariant translation* `S = G ∘ Tx`
  (`W_comm_S`), where `G` is the onsite gauge `(-1)^x`.

`S` is a genuine translation dressed by a gauge; with the plain `y`-shift `T0`
it forms an **abelian** retained symmetry (`S_comm_T0`), so the retained
generators carry a *trivial* cocycle even though `S` still anticommutes with the
broken `Ty`.  On this reduced finite cell we prove the **complete** `±1`
eigenspace census of `W`:

* `W_p1` with `p1 ≠ 0`: an explicit `+1` eigenvector;
* `zero_crossing_nondegenerate`: the `+1` eigenspace is **one-dimensional**
  (every `+1` eigenvector is a scalar multiple of `p1`);
* `W_p2`, `W_p3`, `W_p4` with `pi_eigvecs_independent`: three independent
  `-1` eigenvectors, so the `-1` eigenspace is
  three-dimensional; together with `p1` they form a basis (`census_basis`),
  completing the finite-cell census `1 ⊕ 3`.

The non-degenerate `+1` eigenline is **tagged** by the retained abelian symmetry:
`crossing_tag` records `S p1 = i • p1` and `T0 p1 = p1`, so the symmetry
eigenvalues `(S,T0)` label the unique `+1` eigenline.

## Verdict
This is a genuine finite-cell **escape witness**: the `+1` eigenspace is
one-dimensional rather than symmetry-doubled.  The other three basis directions
lie in the `-1` eigenspace.  This separation is bought by
trading the naked anticommuting pair `(Tx,Ty)` (central sign `-1`) for the
abelian retained pair `(S,T0)` (central sign `+1`); by
`no_invertible_decoder_opposite` this change of cocycle class is *exactly* why
no invertible decoder could have achieved it while keeping the naked
symmetries.  The scoped no-go persists sharply: `keeping_Ty_forces_doubling`
shows that any walk which retains *both* the combined `S` (via `R = -i·S`) and
the naked `Ty` is doubled again.  **No momentum-dependent family, linear Weyl
dispersion, local topological charge, infinite-lattice Brillouin-zone claim, or
3+1-dimensional construction is proved here**; this is a finite reduced-cell
census and an exact algebraic control for those later targets.

Provenance: clean-room finite construction extending `PiFluxCocycleDecoder`.
No external code copied.  Standard axiom footprint enforced by `#guard_msgs`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder

/-! ## Part 1: gauge-covariant intertwiners and their classification -/

/-- A gauge-covariant intertwiner: `U` conjugates the source translations
`A, B` into the target translations `A', B'`. -/
structure GaugeIntertwiner {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A B A' B' : V →ₗ[F] V) : Prop where
  onA : U.comp A = A'.comp U
  onB : U.comp B = B'.comp U

/--
**Classification (uniqueness).**  If `U` is surjective, the intertwined
target operator is uniquely determined by the source operator.
-/
theorem intertwiner_target_unique
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A A' A'' : V →ₗ[F] V) (hU : Function.Surjective U)
    (h1 : U.comp A = A'.comp U) (h2 : U.comp A = A''.comp U) :
    A' = A'' := by
  exact LinearMap.ext fun x => by obtain ⟨ y, rfl ⟩ := hU x; simpa using congr_arg ( fun f => f y ) ( h1.symm.trans h2 ) ;

/--
**Classification (existence).**  If `U` is bijective, every source operator
`A` has an intertwined target `A'` (the conjugate `U ∘ A ∘ U⁻¹`).
-/
theorem intertwiner_target_exists
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A : V →ₗ[F] V) (hU : Function.Bijective U) :
    ∃ A' : V →ₗ[F] V, U.comp A = A'.comp U := by
  refine' ⟨ _, _ ⟩;
  exact ( U.comp A ).comp ( LinearEquiv.symm ( LinearEquiv.ofBijective U hU ) |> LinearEquiv.toLinearMap );
  ext; simp +decide [ hU.injective.eq_iff ] ;

/-! ## Part 2: the central cocycle sign is an intertwiner invariant -/

/--
**Cocycle-sign invariance.**  An invertible gauge-covariant intertwiner
preserves the central cocycle scalar: if `A ∘ B = ε • (B ∘ A)` on the source
and `A' ∘ B' = ε' • (B' ∘ A')` on the target, then `ε = ε'`.  (Needs a nonzero
witness through the injective source operators.)
-/
theorem cocycle_sign_preserved
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A B A' B' : V →ₗ[F] V) (ε ε' : F)
    (hU : Function.Bijective U)
    (hA : Function.Injective A) (hB : Function.Injective B)
    (hUA : U.comp A = A'.comp U) (hUB : U.comp B = B'.comp U)
    (hcoc : A.comp B = ε • (B.comp A))
    (hcoc' : A'.comp B' = ε' • (B'.comp A'))
    (x : V) (hx : x ≠ 0) :
    ε = ε' := by
  simp_all +decide [ funext_iff, LinearMap.ext_iff ];
  -- Apply the hypothesis `hcoc` and `hcoc'` to the element `x`.
  have h_eq : A' (B' (U x)) = ε • B' (A' (U x)) := by
    simp +decide [ ← hUA, ← hUB, hcoc ];
  by_cases h : B' ( A' ( U x ) ) = 0 <;> simp_all +decide [ smul_smul ];
  have h_contra : B (A x) = 0 := by
    exact hU.injective ( by aesop );
  have := hB ( by aesop : B ( A x ) = B 0 ) ; aesop;

/--
**No invertible decoder between opposite cocycle classes.**  Two projective
representations whose central cocycle signs differ (e.g. a commuting pair,
`ε = 1`, and a pi-flux anticommuting pair, `ε' = -1`) admit no invertible
gauge-covariant intertwiner.
-/
theorem no_invertible_decoder_opposite
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (A B A' B' : V →ₗ[F] V) (ε ε' : F) (hne : ε ≠ ε')
    (hA : Function.Injective A) (hB : Function.Injective B)
    (hcoc : A.comp B = ε • (B.comp A))
    (hcoc' : A'.comp B' = ε' • (B'.comp A'))
    (x : V) (hx : x ≠ 0) :
    ¬ ∃ U : V →ₗ[F] V, Function.Bijective U ∧
        U.comp A = A'.comp U ∧ U.comp B = B'.comp U := by
  rintro ⟨ U, hUbij, hUA, hUB ⟩ ; exact hne ( cocycle_sign_preserved U A B A' B' ε ε' hUbij hA hB hUA hUB hcoc hcoc' x hx ) ;

/-! ## Part 3: equivalence transports degeneracy (it does not remove it) -/

/--
**Transport of the projective relations.**  An invertible intertwiner sends
anticommuting involutions to anticommuting involutions.
-/
theorem transport_involutions
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A B A' B' : V →ₗ[F] V)
    (hU : Function.Bijective U)
    (hUA : U.comp A = A'.comp U) (hUB : U.comp B = B'.comp U)
    (hAinv : A.comp A = LinearMap.id) (hBinv : B.comp B = LinearMap.id)
    (hAB : A.comp B = - (B.comp A)) :
    A'.comp A' = LinearMap.id ∧ B'.comp B' = LinearMap.id ∧
      A'.comp B' = - (B'.comp A') := by
  refine' ⟨ _, _, _ ⟩ <;> ext x <;> have := hU.2 x <;> simp_all +decide [ LinearMap.ext_iff ]; all_goals grind

/-- **The abstract doubling mechanism.**  Over a field of characteristic `≠ 2`,
if `A, B` are anticommuting involutions both commuting with `U`, then every
`U`-eigenvector has a linearly independent eigen-partner at the same
eigenvalue. -/
theorem magnetic_doubling
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (A B U : V →ₗ[F] V)
    (hchar : (2 : F) ≠ 0)
    (hA : A.comp A = LinearMap.id)
    (hB : B.comp B = LinearMap.id)
    (hAB : A.comp B = - (B.comp A))
    (hUA : U.comp A = A.comp U)
    (hUB : U.comp B = B.comp U)
    (lam : F) (v : V) (hv : v ≠ 0) (hUv : U v = lam • v) :
    ∃ w, U w = lam • w ∧ LinearIndependent F ![v, w] := by
  have hAinv : ∀ x, A (A x) = x := fun x => congrArg (fun f : V →ₗ[F] V => f x) hA
  have hBinv : ∀ x, B (B x) = x := fun x => congrArg (fun f : V →ₗ[F] V => f x) hB
  have hAvne : A v ≠ 0 := by
    intro h; apply hv; have := hAinv v; rw [h, map_zero] at this; exact this.symm
  have hBvne : B v ≠ 0 := by
    intro h; apply hv; have := hBinv v; rw [h, map_zero] at this; exact this.symm
  have hAv : U (A v) = lam • (A v) := by
    have := congrArg (fun f : V →ₗ[F] V => f v) hUA
    simp only [LinearMap.comp_apply] at this
    rw [this, hUv, map_smul]
  have hBv : U (B v) = lam • (B v) := by
    have := congrArg (fun f : V →ₗ[F] V => f v) hUB
    simp only [LinearMap.comp_apply] at this
    rw [this, hUv, map_smul]
  by_cases hAdep : ∀ c : F, A v ≠ c • v
  · refine ⟨A v, hAv, ?_⟩
    rw [linearIndependent_fin2]
    refine ⟨by simpa using hAvne, ?_⟩
    intro a ha
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one] at ha
    apply hAdep a
    have h := congrArg A ha
    rw [map_smul, hAinv] at h
    exact h.symm
  · push_neg at hAdep
    obtain ⟨d, hd⟩ := hAdep
    by_cases hBdep : ∀ c : F, B v ≠ c • v
    · refine ⟨B v, hBv, ?_⟩
      rw [linearIndependent_fin2]
      refine ⟨by simpa using hBvne, ?_⟩
      intro a ha
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one] at ha
      apply hBdep a
      have h := congrArg B ha
      rw [map_smul, hBinv] at h
      exact h.symm
    · exfalso
      push_neg at hBdep
      obtain ⟨e, he⟩ := hBdep
      have hkey := congrArg (fun f : V →ₗ[F] V => f v) hAB
      simp only [LinearMap.comp_apply, LinearMap.neg_apply] at hkey
      rw [he, hd, map_smul, map_smul, hd, he] at hkey
      rw [smul_smul, smul_smul] at hkey
      have hz : (e * d + d * e) • v = 0 := by
        rw [add_smul, hkey]; ring_nf; rw [neg_add_cancel]
      have h2 : (2 * (e * d)) • v = 0 := by
        rw [show 2 * (e * d) = e * d + d * e by ring]; exact hz
      rw [smul_eq_zero] at h2
      rcases h2 with h2 | h2
      · rcases mul_eq_zero.mp h2 with h2 | h2
        · exact hchar h2
        · rcases mul_eq_zero.mp h2 with h2 | h2
          · apply hBvne; rw [he, h2, zero_smul]
          · apply hAvne; rw [hd, h2, zero_smul]
      · exact hv h2

/--
**Transport of degeneracy.**  If `U` invertibly intertwines the
anticommuting involutions `(A,B)` into `(A',B')`, then any walk `W` commuting
with the *transported* pair `A', B'` still has every eigenvalue doubled.  So an
equivalence of exact projective representations transports the degeneracy rather
than removing it.
-/
theorem transport_degeneracy
    {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (U A B A' B' W : V →ₗ[F] V)
    (hchar : (2 : F) ≠ 0)
    (hU : Function.Bijective U)
    (hUA : U.comp A = A'.comp U) (hUB : U.comp B = B'.comp U)
    (hAinv : A.comp A = LinearMap.id) (hBinv : B.comp B = LinearMap.id)
    (hAB : A.comp B = - (B.comp A))
    (hWA' : W.comp A' = A'.comp W) (hWB' : W.comp B' = B'.comp W)
    (lam : F) (v : V) (hv : v ≠ 0) (hWv : W v = lam • v) :
    ∃ w, W w = lam • w ∧ LinearIndependent F ![v, w] := by
  obtain ⟨hA', hB', hAB'⟩ : A'.comp A' = LinearMap.id ∧ B'.comp B' = LinearMap.id ∧ A'.comp B' = - (B'.comp A') := transport_involutions U A B A' B' hU hUA hUB hAinv hBinv hAB;
  convert magnetic_doubling A' B' W hchar hA' hB' hAB' hWA' hWB' lam v hv hWv using 1

/-! ## Part 4: the escape construction on the smallest cocycle cell -/

/-- The smallest periodic cell carrying a nontrivial central cocycle. -/
abbrev Site := ZMod 2 × ZMod 2

/-- Complex amplitudes on the finite cell. -/
abbrev St := Site → ℂ

/-- The onsite sign `(-1)^x`. -/
def sgn (x : ZMod 2) : ℂ := if x = 0 then 1 else -1

theorem sgn_flip (x : ZMod 2) : sgn (x + 1) = - sgn x := by
  fin_cases x <;> simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

theorem sgn_sq (x : ZMod 2) : sgn x * sgn x = 1 := by
  unfold sgn; split <;> norm_num

/-- Naked magnetic translation in `x` (ordinary shift). -/
def Tx : St →ₗ[ℂ] St where
  toFun ψ := fun p => ψ (p.1 + 1, p.2)
  map_add' a b := by funext p; simp
  map_smul' c a := by funext p; simp

/-- Naked magnetic translation in `y`, twisted by `(-1)^x`. -/
def Ty : St →ₗ[ℂ] St where
  toFun ψ := fun p => sgn p.1 * ψ (p.1, p.2 + 1)
  map_add' a b := by funext p; simp; ring
  map_smul' c a := by funext p; simp; ring

/-- Onsite gauge `(-1)^x`. -/
def G : St →ₗ[ℂ] St where
  toFun ψ := fun p => sgn p.1 * ψ p
  map_add' a b := by funext p; simp; ring
  map_smul' c a := by funext p; simp; ring

/-- Plain (ungauged) translation in `y`. -/
def T0 : St →ₗ[ℂ] St where
  toFun ψ := fun p => ψ (p.1, p.2 + 1)
  map_add' a b := by funext p; simp
  map_smul' c a := by funext p; simp

/-- The **combined gauge-covariant translation** `S = G ∘ Tx`:
`S ψ (x,y) = (-1)^x ψ (x+1,y)`. -/
def S : St →ₗ[ℂ] St := G.comp Tx

/-- `R = -i · S`: the involutive form of the combined translation
(eigenvalue `+1` on the `S = i` sheet, `-1` on the `S = -i` sheet). -/
def R : St →ₗ[ℂ] St := (-Complex.I) • S

/-- The escape update `W = ½ (R + T0 + R∘T0 - id)`. Its involution and complete
eigenspace census are proved below. -/
def W : St →ₗ[ℂ] St := (1/2 : ℂ) • (R + T0 + R.comp T0 - LinearMap.id)

/-! ### Algebra of the naked and combined translations -/

theorem Tx_involutive : Tx.comp Tx = LinearMap.id := by
  ext ψ p; simp [Tx];
  fin_cases p <;> aesop

theorem Ty_involutive : Ty.comp Ty = LinearMap.id := by
  ext ψ p; simp [Ty];
  unfold sgn; simp +decide [ Pi.single_apply ] ;
  fin_cases p <;> simp +decide [ ZMod ]

theorem T0_involutive : T0.comp T0 = LinearMap.id := by
  -- By definition of $T0$, we know that $T0 \circ T0 = \text{id}$.
  ext ψ p; simp [T0];
  grind +extAll

theorem G_involutive : G.comp G = LinearMap.id := by
  ext ψ p; simp [G];
  fin_cases p <;> simp +decide [ sgn ]

/--
`Tx` and `Ty` anticommute: pi flux (central sign `-1`).
-/
theorem TxTy_anti : Tx.comp Ty = - (Ty.comp Tx) := by
  ext ψ p; simp [Tx, Ty]; ring;
  fin_cases p <;> simp +decide [ sgn ]

/--
The combined translation squares to `-1`.
-/
theorem S_sq : S.comp S = - LinearMap.id := by
  apply LinearMap.ext; intro ψ; funext p; obtain ⟨x, y⟩ := p
  simp only [LinearMap.comp_apply, S, G, Tx, LinearMap.neg_apply, Pi.neg_apply,
    LinearMap.id_apply, LinearMap.coe_mk, AddHom.coe_mk]
  fin_cases x <;> simp [sgn, show ((1 : ZMod 2) + 1) = 0 from by decide]

/--
`R` is an involution.
-/
theorem R_involutive : R.comp R = LinearMap.id := by
  convert congr_arg ( fun f : St →ₗ[ℂ] St => ( -Complex.I ) • ( -Complex.I ) • f ) S_sq using 1;
  · ext; simp [R, S];
  · ext; norm_num [ Complex.ext_iff ] ;

/--
`S` (hence `R`) still anticommutes with the naked `Ty`.
-/
theorem S_anti_Ty : S.comp Ty = - (Ty.comp S) := by
  ext ψ p; simp [S, G, Tx, Ty]; ring;
  fin_cases p <;> simp +decide [ sgn ]

theorem R_anti_Ty : R.comp Ty = - (Ty.comp R) := by
  ext ψ p; simp [R, S, G, Tx, Ty]; ring;
  fin_cases p <;> simp +decide [ sgn ]

/--
The retained pair `(S, T0)` is **abelian**: trivial central cocycle.
-/
theorem S_comm_T0 : S.comp T0 = T0.comp S := by
  ext ψ p;
  simp +decide [ S, G, Tx, T0 ]

theorem R_comm_T0 : R.comp T0 = T0.comp R := by
  -- By definition of $R$, we know that $R = (-i) • S$.
  simp [R];
  ext; simp +decide [ S, G, Tx, T0 ]

/-! ### `W` breaks the naked translations but preserves the combined one -/

/--
`W` **preserves** the combined gauge-covariant translation `S`.
-/
theorem W_comm_S : W.comp S = S.comp W := by
  ext ψ p; simp +decide [ W, R, S, G, Tx, T0, sgn ] ;
  grind

/--
`W` also commutes with the plain `y`-shift `T0` (the second retained abelian
generator).
-/
theorem W_comm_T0 : W.comp T0 = T0.comp W := by
  ext ψ p; simp +decide [ W, R, S, G, Tx, T0 ] ;

/--
`W` **breaks** the naked magnetic translation `Tx`.
-/
theorem W_not_comm_Tx : W.comp Tx ≠ Tx.comp W := by
  intro h; have := congrFun ( congrArg ( fun f => f ( fun q => if q = ( 0, 0 ) then 1 else 0 ) ) h ) ( 0, 0 ) ; simp +decide [ W, R, S, G, Tx, T0 ] at this;
  unfold sgn at this; norm_num at this;

/--
`W` **breaks** the naked magnetic translation `Ty`.
-/
theorem W_not_comm_Ty : W.comp Ty ≠ Ty.comp W := by
  intro h; have := congrFun ( congrArg ( fun f => f ( fun q => if q = ( 0, 0 ) then 1 else 0 ) ) h ) ( 1, 0 ) ; simp +decide [ W, R, S, G, Tx, T0, sgn ] at this;
  simp +decide [ Ty, sgn ] at this ; norm_num [ Complex.ext_iff ] at this;

/--
`W` is an involution, hence an invertible finite linear update. Unitarity with
respect to a specified inner product is not asserted by this theorem.
-/
theorem W_involutive : W.comp W = LinearMap.id := by
  unfold W R S G Tx T0; ext; norm_num; ring;
  rename_i x; fin_cases x <;> simp +decide [ Pi.single_apply ] ;
  · rename_i x; fin_cases x <;> simp +decide [ sgn ] ;
    · norm_num;
    · norm_num;
    · ring;
  · rename_i x; fin_cases x <;> simp +decide [ Pi.single_apply ] ;
    · norm_num [ sgn ];
    · norm_num [ sgn ];
    · ring;
  · rename_i i; fin_cases i <;> simp +decide [ sgn ] ;
    · ring;
    · norm_num;
    · norm_num;
  · rename_i x; fin_cases x <;> simp +decide [ sgn ] ;
    · ring;
    · norm_num;
    · norm_num

theorem W_bijective : Function.Bijective W := by
  have h : Function.Involutive W := fun ψ =>
    congrArg (fun f : St →ₗ[ℂ] St => f ψ) W_involutive
  exact h.bijective

/-! ### The complete `+1 / -1` eigenspace census -/

/-- The distinguished `+1` eigenvector: `p1 (x,y) = i^x`. -/
def p1 : St := fun p => if p.1 = 0 then 1 else Complex.I

/-- A `-1` eigenvector on the `S = i` sheet. -/
def p2 : St := fun p => (if p.1 = 0 then 1 else Complex.I) * sgn p.2

/-- A `-1` eigenvector on the `S = -i` sheet. -/
def p3 : St := fun p => if p.1 = 0 then 1 else -Complex.I

/-- A `-1` eigenvector on the `S = -i` sheet. -/
def p4 : St := fun p => (if p.1 = 0 then 1 else -Complex.I) * sgn p.2

theorem p1_ne_zero : p1 ≠ 0 := by
  -- To prove that p1 is not the zero function, we can evaluate it at the point (0,0).
  intro h
  have := congr_fun h (0, 0)
  simp [p1] at this

theorem p2_ne_zero : p2 ≠ 0 := by
  -- To prove that p2 is not the zero function, we can evaluate it at the point (0,0).
  intro h
  have := congr_fun h (0, 0)
  simp [p2, sgn] at this

theorem p3_ne_zero : p3 ≠ 0 := by
  -- To prove that p3 is not the zero function, we can evaluate it at the point (0,0).
  intro h
  have := congr_fun h (0, 0)
  simp [p3] at this

theorem p4_ne_zero : p4 ≠ 0 := by
  -- To prove that p4 is not the zero function, we can evaluate it at the point (0, 0).
  intro h
  have := congr_fun h (0, 0)
  simp [p4, sgn] at this

/--
`p1` is a `+1` eigenvector of `W`.
-/
theorem W_p1 : W p1 = p1 := by
  ext ⟨x, y⟩; simp [W, R, S, G, Tx, T0, p1];
  fin_cases x <;> simp +decide [ sgn ] <;> norm_num [ Complex.ext_iff ]

/--
`p2` is a `-1` eigenvector of `W`.
-/
theorem W_p2 : W p2 = -p2 := by
  unfold W R S G Tx T0 p2; ext; norm_num; ring;
  rename_i x; fin_cases x <;> simp +decide [ sgn ] ;
  · norm_num;
  · norm_num;
  · ring;
  · ring

/--
`p3` is a `-1` eigenvector of `W`.
-/
theorem W_p3 : W p3 = -p3 := by
  ext ⟨x, y⟩; simp [W, R, S, G, Tx, T0, p3];
  fin_cases x <;> simp +decide [ sgn ] <;> norm_num [ Complex.ext_iff ]

/--
`p4` is a `-1` eigenvector of `W`.
-/
theorem W_p4 : W p4 = -p4 := by
  ext ⟨x, y⟩; simp [W, R, S, G, Tx, T0, p4];
  fin_cases x <;> fin_cases y <;> simp +decide [ sgn ] <;> ring

/--
**The census basis.**  `{p1, p2, p3, p4}` is a basis of the finite cell.
-/
theorem census_basis : LinearIndependent ℂ ![p1, p2, p3, p4] := by
  rw [ Fintype.linearIndependent_iff ];
  intro g hg i; fin_cases i <;> have := congr_fun hg ( 0, 0 ) <;> have := congr_fun hg ( 1, 0 ) <;> have := congr_fun hg ( 0, 1 ) <;> have := congr_fun hg ( 1, 1 ) <;> norm_num [ Fin.sum_univ_succ, Pi.single_apply ] at *;
  · simp_all +decide [ p1, p2, p3, p4, sgn ];
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith;
  · simp_all +decide [ p1, p2, p3, p4, sgn ];
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith;
  · simp_all +decide [ p1, p2, p3, p4, sgn ];
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith;
  · simp_all +decide [ p1, p2, p3, p4, sgn ];
    norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith

/--
The three pi-eigenvectors are independent: the `-1` eigenspace is
three-dimensional.
-/
theorem pi_eigvecs_independent : LinearIndependent ℂ ![p2, p3, p4] := by
  rw [ Fintype.linearIndependent_iff ];
  intro g hg i; fin_cases i <;> have := congr_fun hg ( 0, 0 ) <;> have := congr_fun hg ( 1, 0 ) <;> have := congr_fun hg ( 0, 1 ) <;> norm_num [ Fin.sum_univ_succ, p2, p3, p4, sgn ] at * <;> norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith!;

/--
**Non-degenerate zero eigenline (main finite-cell escape result).**  The `+1`
eigenspace of `W` is one-dimensional: every `+1` eigenvector is a
scalar multiple of `p1`.  Combined with `W_p1`/`p1_ne_zero`, this gives one
nonzero `+1` eigenline.  It does not by itself define or prove a Weyl crossing;
that requires a momentum-dependent family and a nonzero local charge.
-/
theorem zero_crossing_nondegenerate (v : St) (hv : W v = v) :
    ∃ c : ℂ, v = c • p1 := by
      simp +decide [ funext_iff, St, W, R, S, G, Tx, T0, p1 ] at hv ⊢;
      simp +decide [ ZMod, sgn ] at hv ⊢;
      grobner

/--
**Symmetry tag.**  The retained abelian symmetry `(S, T0)` labels the unique
`+1` eigenline: `S p1 = i • p1` and `T0 p1 = p1`.
-/
theorem crossing_tag : S p1 = Complex.I • p1 ∧ T0 p1 = p1 := by
  constructor;
  · ext ⟨x, y⟩; simp [S, G,Tx, p1,sgn] ;
    fin_cases x <;> simp +decide;
  · ext ⟨ x, y ⟩ ; fin_cases x <;> fin_cases y <;> simp +decide [ T0, p1 ] ;

/-! ### The scoped no-go still bites if the naked `Ty` is retained -/

/-- **Persistence of the no-go.**  Any walk that retains *both* the combined
translation (through `R = -i·S`) and the naked `Ty` is doubled again: keeping
`Ty` re-forms an anticommuting involution pair with `R`.  This is exactly the
symmetry assumption the escape `W` had to drop (`W_not_comm_Ty`). -/
theorem keeping_Ty_forces_doubling
    (U : St →ₗ[ℂ] St)
    (hUR : U.comp R = R.comp U) (hUy : U.comp Ty = Ty.comp U)
    (lam : ℂ) (v : St) (hv : v ≠ 0) (hUv : U v = lam • v) :
    ∃ w, U w = lam • w ∧ LinearIndependent ℂ ![v, w] :=
  magnetic_doubling R Ty U two_ne_zero R_involutive Ty_involutive
    R_anti_Ty hUR hUy lam v hv hUv

/-! ## Build-enforced assumption-footprint guards

Each headline theorem is pinned to the standard axiom footprint
(`propext`, `Classical.choice`, `Quot.sound`). -/

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.cocycle_sign_preserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cocycle_sign_preserved

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.no_invertible_decoder_opposite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_invertible_decoder_opposite

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.transport_degeneracy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transport_degeneracy

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.W_comm_S' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms W_comm_S

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.W_not_comm_Tx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms W_not_comm_Tx

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.W_not_comm_Ty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms W_not_comm_Ty

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.zero_crossing_nondegenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_crossing_nondegenerate

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.census_basis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms census_basis

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.crossing_tag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossing_tag

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder.keeping_Ty_forces_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms keeping_Ty_forces_doubling

end PhysicsSM.Draft.NullEdge.GaugeTwistedMagneticDecoder
