import Mathlib

/-!
# The CAR-to-block reduction and the Fock-level gauge tie

Closes the last recorded boundary of the selection-uniqueness theorem
("the reduction from the CAR quartic class to the 2x2 block is
definitional packaging, not a theorem") and the remaining audit item
(tying the block gauge `Dphase` to a genuine Fock-space operator).

The four genuine targets are stated and proved below (T1–T4).  The
context files are reference-only; all needed definitions are copied
verbatim into the `Copied` section.

## Documented corrections / precise packaging

* **T1 dependence condition.**  The reduction isomorphism is between the
  space of *pair-block operators* and `Matrix (Fin 2) (Fin 2) ℂ`.  A
  pair-block operator is a `ℂ`-linear map `H : Fock (Fin 4) →ₗ Fock (Fin 4)`
  with (i) support `⊆ {lowPair, highPair}` and (ii) output depending only
  on the two pair amplitudes `(psi lowPair, psi highPair)`.  Condition (ii)
  is stated in the extensional form actually needed for the isomorphism:
  if two inputs agree on `lowPair` and `highPair`, the outputs agree.  This
  is exactly the dependence condition that makes `blockOf`/`matToOp` a
  linear equivalence.  We package the reduction as the explicit
  `blockEquiv : Matrix (Fin 2) (Fin 2) ℂ ≃ₗ[ℂ] pairBlock` (forward map
  `matToOp`, inverse `blockOf`), and prove the Hermitian tie
  `hermitian_iff`.

* **T2 `Kop` bundling.**  `Kop z` in the source is a bare function, not a
  bundled `LinearMap`.  We bundle it as `KopL z := matToOp !![0,z; conj z,0]`
  and prove `KopL_eq_Kop : KopL z psi = Kop z psi`, so `KopL z` genuinely
  *is* the CAR generator, now a pair-block operator, and
  `blockOf (KopL z) = !![0, z; conj z, 0]` — the selection family member at
  `a = 1`.

* **T3 conjugation direction.**  The block shadow of the Fock unitary
  `Dfock u` (phase on mode `0`) is `Dphase u`, and for unimodular `u`
  block-conjugation by `Dfock u` is matrix conjugation
  `M ↦ Dphase u * M * (Dphase u)ᴴ`.  Stated for a general linear `H`
  (strictly more general than, hence implying, the pair-block case).

All proofs are kernel-only (finite Finset-indexed algebra and 2×2 matrix
arithmetic; no `native_decide`).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CARBlockReduction

open Finset Matrix Polynomial Complex

/-! ## Copied definitions (verbatim from the reference context files) -/

section Copied

/-- Fermionic Fock space in the occupation-number basis. -/
abbrev Fock (ι : Type*) := Finset ι -> Complex

variable {ι : Type*} [DecidableEq ι] [LinearOrder ι]

def belowCount (i : ι) (S : Finset ι) : Nat :=
  (S.filter fun j => j < i).card

def opSign (i : ι) (S : Finset ι) : Complex :=
  (-1 : Complex) ^ belowCount i S

/-- Creation operator at mode `i`. -/
def create (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then opSign i S * psi (S.erase i) else 0

/-- Annihilation operator at mode `i`. -/
def annihilate (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then 0 else opSign i S * psi (insert i S)

end Copied

/-- Occupation-basis vector for four fermionic modes. -/
def basisVec (S : Finset (Fin 4)) : Fock (Fin 4) := fun T =>
  if T = S then 1 else 0

/-- Quartic transfer from the occupied pair `{2,3}` to `{0,1}`. -/
def pairForward (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  create 0 (create 1 (annihilate 3 (annihilate 2 psi)))

/-- Reverse quartic transfer from `{0,1}` to `{2,3}`. -/
def pairBackward (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  create 2 (create 3 (annihilate 1 (annihilate 0 psi)))

def lowPair : Finset (Fin 4) := {0, 1}

def highPair : Finset (Fin 4) := {2, 3}

theorem lowPair_ne_highPair : lowPair ≠ highPair := by decide

theorem highPair_ne_lowPair : highPair ≠ lowPair := lowPair_ne_highPair.symm

/-- Standard conjugate-linear-in-the-first-slot occupation-basis form. -/
def fockInner (psi phi : Fock (Fin 4)) : Complex :=
  ∑ S : Finset (Fin 4), (starRingEnd Complex) (psi S) * phi S

/-- The forward quartic word has exactly one nonzero occupation transition. -/
theorem pairForward_apply (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    pairForward psi S = if S = lowPair then psi highPair else 0 := by
  classical
  fin_cases S <;>
    simp +decide [pairForward, highPair, create, annihilate, opSign, belowCount]
  all_goals congr 1

/-- The backward quartic word is the reverse occupation transition. -/
theorem pairBackward_apply (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    pairBackward psi S = if S = highPair then psi lowPair else 0 := by
  classical
  fin_cases S <;>
    simp +decide [pairBackward, lowPair, create, annihilate, opSign, belowCount]
  all_goals congr 1

/-- The Hermitian quartic pair-transfer generator: forward amplitude `z`,
reverse `conj z`. -/
def Kop (z : Complex) (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  z • pairForward psi + (starRingEnd Complex) z • pairBackward psi

theorem Kop_apply (z : Complex) (psi : Fock (Fin 4)) (S : Finset (Fin 4)) :
    Kop z psi S =
      if S = lowPair then z * psi highPair
      else if S = highPair then (starRingEnd Complex) z * psi lowPair
      else 0 := by
  unfold Kop
  split_ifs <;> simp_all +decide [pairForward_apply, pairBackward_apply]

/-- The block gauge action of the site-local chiral phase. -/
def Dphase (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![u, 0; 0, 1]

/-! ## The reduction: bundled operators and the 2×2 block -/

/-- The type of `ℂ`-linear Fock operators on four modes. -/
abbrev FockOp := Fock (Fin 4) →ₗ[ℂ] Fock (Fin 4)

/-- Evaluation-at-`S` functional, a `ℂ`-linear map. -/
def evL (S : Finset (Fin 4)) : Fock (Fin 4) →ₗ[ℂ] ℂ := LinearMap.proj S

@[simp] theorem evL_apply (S : Finset (Fin 4)) (psi : Fock (Fin 4)) :
    evL S psi = psi S := rfl

/-- The two distinguished pair states, in the basis order `(lowPair, highPair)`. -/
def pairIdx : Fin 2 → Finset (Fin 4) := ![lowPair, highPair]

@[simp] theorem pairIdx_zero : pairIdx 0 = lowPair := rfl
@[simp] theorem pairIdx_one : pairIdx 1 = highPair := rfl

/-- The forward direction of the reduction: a 2×2 matrix `M` becomes the
pair-block operator acting by `M` on `(psi lowPair, psi highPair)` and by
zero elsewhere. -/
def matToOp (M : Matrix (Fin 2) (Fin 2) ℂ) : FockOp :=
  (M 0 0 • evL lowPair + M 0 1 • evL highPair).smulRight (basisVec lowPair)
    + (M 1 0 • evL lowPair + M 1 1 • evL highPair).smulRight (basisVec highPair)

/-- The reduction reading a 2×2 block off any Fock operator:
`blockOf H i j` is the `(pairIdx i)`-amplitude of `H` applied to the
`(pairIdx j)`-basis state. -/
def blockOf (H : FockOp) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j => H (basisVec (pairIdx j)) (pairIdx i)

/-- A pair-block operator: support in the two pair states, output depending
only on the two pair amplitudes. -/
def IsPairBlock (H : FockOp) : Prop :=
  (∀ (psi : Fock (Fin 4)) (S : Finset (Fin 4)),
      S ≠ lowPair → S ≠ highPair → H psi S = 0) ∧
  (∀ psi phi : Fock (Fin 4),
      psi lowPair = phi lowPair → psi highPair = phi highPair → H psi = H phi)

theorem matToOp_apply (M : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fock (Fin 4))
    (S : Finset (Fin 4)) :
    matToOp M psi S =
      if S = lowPair then M 0 0 * psi lowPair + M 0 1 * psi highPair
      else if S = highPair then M 1 0 * psi lowPair + M 1 1 * psi highPair
      else 0 := by
  unfold matToOp;
  unfold evL basisVec; split_ifs <;> simp_all +decide ;

theorem isPairBlock_zero : IsPairBlock (0 : FockOp) := by
  constructor <;> aesop

theorem isPairBlock_add (H1 H2 : FockOp) (h1 : IsPairBlock H1)
    (h2 : IsPairBlock H2) : IsPairBlock (H1 + H2) := by
      refine' ⟨ _, _ ⟩ <;> intro psi S <;> simp_all +decide [ IsPairBlock ];
      exact fun h3 h4 => congr_arg₂ ( · + · ) ( h1.2 _ _ h3 h4 ) ( h2.2 _ _ h3 h4 )

theorem isPairBlock_smul (c : ℂ) (H : FockOp) (h : IsPairBlock H) :
    IsPairBlock (c • H) := by
      constructor;
      · intro psi S hS₁ hS₂; specialize h; have := h.1 psi S hS₁ hS₂; aesop;
      · exact fun psi phi hpsi hphi => funext fun x => by have := h.2 psi phi hpsi hphi; aesop;

theorem matToOp_isPairBlock (M : Matrix (Fin 2) (Fin 2) ℂ) :
    IsPairBlock (matToOp M) := by
      constructor;
      · intro psi S hS₁ hS₂; rw [ matToOp_apply ] ; aesop;
      · intro psi phi hpsi hphi; ext S; simp +decide [ matToOp_apply, hpsi, hphi ] ;

theorem matToOp_add (M N : Matrix (Fin 2) (Fin 2) ℂ) :
    matToOp (M + N) = matToOp M + matToOp N := by
      ext psi S; simp +decide [ *, matToOp_apply ] ;
      split_ifs <;> ring

theorem matToOp_smul (c : ℂ) (M : Matrix (Fin 2) (Fin 2) ℂ) :
    matToOp (c • M) = c • matToOp M := by
      unfold matToOp;
      ext; simp +decide [ mul_assoc, smul_add, add_smul ] ;

/-
`blockOf` is a left inverse to `matToOp`.
-/
theorem blockOf_matToOp (M : Matrix (Fin 2) (Fin 2) ℂ) :
    blockOf (matToOp M) = M := by
      ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, blockOf ] ;
      · simp +decide [ matToOp_apply, basisVec ];
      · convert matToOp_apply M ( basisVec highPair ) lowPair using 1 ; simp +decide [ basisVec ];
      · convert matToOp_apply M ( basisVec lowPair ) highPair using 1 ; simp +decide [ basisVec ];
      · unfold matToOp; simp +decide [ basisVec ] ;

/-
On pair-block operators, `matToOp` reconstructs the operator from its
block.  This is where condition (ii) of `IsPairBlock` is load-bearing.
-/
theorem matToOp_blockOf (H : FockOp) (hH : IsPairBlock H) :
    matToOp (blockOf H) = H := by
      refine' LinearMap.ext fun psi => _;
      -- By definition of $blockOf$, we know that $H psi = psi lowPair • H (basisVec lowPair) + psi highPair • H (basisVec highPair)$.
      have hH_psi : H psi = psi lowPair • H (basisVec lowPair) + psi highPair • H (basisVec highPair) := by
        convert hH.2 psi ( psi lowPair • basisVec lowPair + psi highPair • basisVec highPair ) _ using 1;
        · simp +decide [ lowPair, highPair, basisVec ];
        · simp +decide [ basisVec ];
      ext S;
      by_cases hS : S = lowPair <;> by_cases hS' : S = highPair <;> simp_all +decide [ matToOp_apply ];
      · unfold blockOf; simp +decide [ mul_comm ] ;
      · unfold blockOf; simp +decide [ mul_comm ] ;
      · have := hH.1 ( basisVec lowPair ) S; have := hH.1 ( basisVec highPair ) S; aesop;

/-- **T1 (submodule of pair-block operators).** -/
def pairBlock : Submodule ℂ FockOp where
  carrier := {H | IsPairBlock H}
  zero_mem' := isPairBlock_zero
  add_mem' := fun {a b} ha hb => isPairBlock_add a b ha hb
  smul_mem' := fun c {a} ha => isPairBlock_smul c a ha

/-- **T1 (the reduction isomorphism).**  The space of pair-block operators
is linearly isomorphic to `Matrix (Fin 2) (Fin 2) ℂ`, via `matToOp`
(forward) and `blockOf` (inverse). -/
def blockEquiv : Matrix (Fin 2) (Fin 2) ℂ ≃ₗ[ℂ] pairBlock where
  toFun M := ⟨matToOp M, matToOp_isPairBlock M⟩
  map_add' M N := by apply Subtype.ext; exact matToOp_add M N
  map_smul' c M := by apply Subtype.ext; exact matToOp_smul c M
  invFun H := blockOf (H : FockOp)
  left_inv M := blockOf_matToOp M
  right_inv H := by apply Subtype.ext; exact matToOp_blockOf (H : FockOp) H.2

/-- Fock-space Hermiticity of an operator for `fockInner`. -/
def IsFockHermitian (H : FockOp) : Prop :=
  ∀ psi phi : Fock (Fin 4), fockInner (H psi) phi = fockInner psi (H phi)

/-
**T1 (the Hermitian tie).**  A pair-block operator is `fockInner`-Hermitian
iff its 2×2 block is a Hermitian matrix.
-/
theorem hermitian_iff (M : Matrix (Fin 2) (Fin 2) ℂ) :
    IsFockHermitian (matToOp M) ↔ M.IsHermitian := by
      constructor <;> intro h;
      · ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ IsFockHermitian, fockInner ] ;
        · specialize h ( basisVec lowPair ) ( basisVec lowPair ) ; simp_all +decide [ matToOp_apply, basisVec ];
        · specialize h ( basisVec lowPair ) ( basisVec highPair ) ; simp_all +decide [ lowPair, highPair, matToOp_apply, basisVec ] ;
        · specialize h ( basisVec highPair ) ( basisVec lowPair ) ; simp_all +decide [ matToOp_apply ] ;
          simp_all +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', basisVec ];
        · specialize h ( basisVec highPair ) ( basisVec highPair ) ; simp_all +decide [ matToOp_apply, basisVec ];
          simp +decide [ Finset.sum_ite, lowPair, highPair ];
      · intro psi phi; simp +decide [ fockInner, matToOp_apply ] ;
        rw [ Finset.sum_eq_add ( lowPair ) ( highPair ) ] <;> simp +decide [ Finset.sum_ite ] ; ring!;
        · rw [ Finset.sum_eq_single lowPair ] <;> simp +decide [ mul_comm, mul_left_comm ] ; ring!;
          have := congr_fun ( congr_fun h 0 ) 0; have := congr_fun ( congr_fun h 0 ) 1; have := congr_fun ( congr_fun h 1 ) 0; have := congr_fun ( congr_fun h 1 ) 1; simp_all +decide [ Matrix.IsHermitian ] ;
        · aesop

/-! ## T2 — the CAR generator is the selection family member -/

/-- The bundled CAR generator, defined as the pair-block operator of the
selection family matrix at `a = 1`. -/
def KopL (z : Complex) : FockOp := matToOp !![0, z; (starRingEnd Complex) z, 0]

/-
The bundled generator agrees with the source function `Kop z`.
-/
theorem KopL_eq_Kop (z : Complex) (psi : Fock (Fin 4)) :
    KopL z psi = Kop z psi := by
      convert matToOp_apply !![0, z; (starRingEnd ℂ) z, 0] psi using 1;
      simp_all +decide [ funext_iff, KopL, Kop_apply ]

/-- **T2.**  The CAR generator is a pair-block operator. -/
theorem KopL_isPairBlock (z : Complex) : IsPairBlock (KopL z) :=
  matToOp_isPairBlock _

/-- **T2.**  Under the reduction the CAR generator is exactly the selection
family member (`a = 1`): `blockOf (Kop z) = !![0, z; conj z, 0]`. -/
theorem blockOf_KopL (z : Complex) :
    blockOf (KopL z) = !![0, z; (starRingEnd Complex) z, 0] :=
  blockOf_matToOp _

/-! ## T3 — the Fock-level gauge tie -/

/-- Second quantization of the one-particle phase on mode `0` alone. -/
def Dfock (u : Complex) (psi : Fock (Fin 4)) : Fock (Fin 4) :=
  fun S => (if (0 : Fin 4) ∈ S then u else 1) * psi S

/-- The bundled (linear) version of `Dfock u`. -/
def DfockL (u : Complex) : FockOp where
  toFun := Dfock u
  map_add' psi phi := by funext S; simp [Dfock, mul_add]
  map_smul' c psi := by
    funext S
    simp only [Dfock, Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

@[simp] theorem DfockL_apply (u : Complex) (psi : Fock (Fin 4)) :
    DfockL u psi = Dfock u psi := rfl

/-
**T3(a).**  For unimodular `u`, `Dfock u` preserves `fockInner`.
-/
theorem Dfock_preserves_fockInner (u : Complex) (hu : ‖u‖ = 1)
    (psi phi : Fock (Fin 4)) :
    fockInner (Dfock u psi) (Dfock u phi) = fockInner psi phi := by
      refine' Finset.sum_congr rfl fun S _ => _;
      by_cases h : 0 ∈ S <;> simp +decide [ h, Dfock ];
      simp +decide [ mul_assoc, mul_comm ( starRingEnd ℂ u ) ];
      simp +decide [ mul_left_comm u, Complex.mul_conj, Complex.normSq_eq_norm_sq, hu ]

/-
**T3(b).**  The block shadow of `Dfock u` is `Dphase u`: for unimodular
`u` and any linear `H`, block-conjugation by `Dfock u` is matrix conjugation
by `Dphase u`.  (Stated for general `H`; specializes to pair-block `H`.)
-/
theorem blockOf_conj_Dfock (u : Complex) (hu : ‖u‖ = 1) (H : FockOp) :
    blockOf (DfockL u ∘ₗ H ∘ₗ DfockL u⁻¹)
      = Dphase u * blockOf H * (Dphase u)ᴴ := by
        unfold Dphase;
        ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, DfockL, Dfock, blockOf ] ;
        · simp +decide [ Matrix.vecMul, Matrix.mul_apply, blockOf ];
          have h_basis : Dfock u⁻¹ (basisVec lowPair) = (starRingEnd ℂ u) • basisVec lowPair := by
            ext S; simp +decide [ Dfock, basisVec ] ;
            split_ifs <;> simp_all +decide [ Complex.inv_def, Complex.normSq_eq_norm_sq ];
          simp_all +decide [ vecHead ];
          exact Or.inl <| mul_comm _ _;
        · simp +decide [ Matrix.vecMul, Matrix.mul_apply, blockOf ];
          unfold Dfock; simp +decide [ basisVec, lowPair, highPair, pairIdx ] ;
          exact Or.inl ( congr_arg ( fun f => H f { 0, 1 } ) ( funext fun S => by aesop ) );
        · simp +decide [ Matrix.vecMul, Matrix.mul_apply, blockOf ];
          -- By definition of $Dfock$, we know that $Dfock u⁻¹ (basisVec lowPair) = u⁻¹ • basisVec lowPair$.
          have h_Dfock_inv : Dfock u⁻¹ (basisVec lowPair) = u⁻¹ • basisVec lowPair := by
            ext S; simp [Dfock, basisVec];
            split_ifs <;> simp_all +decide [ lowPair ];
          simp_all +decide [ mul_comm, vecHead, vecTail ];
          exact Or.inl ( by rw [ Complex.inv_def ] ; simp +decide [ Complex.normSq_eq_norm_sq, hu ] );
        · simp +decide [ blockOf, Matrix.vecMul, Matrix.mul_apply, Fin.sum_univ_succ ];
          convert congr_arg ( fun x => H x highPair ) ( show Dfock u⁻¹ ( basisVec highPair ) = basisVec highPair from _ ) using 1;
          ext S; simp +decide [ Dfock, basisVec ] ;
          fin_cases S <;> simp +decide

/-
**T3(c).**  Exact equivariance of the CAR generator under the Fock
phase gauge, for unimodular `u`:
`Kop (u * z) = Dfock u ∘ Kop z ∘ Dfock u⁻¹`.
-/
theorem Kop_equivariance (u z : Complex) (hu : ‖u‖ = 1) (psi : Fock (Fin 4)) :
    Kop (u * z) psi = Dfock u (Kop z (Dfock u⁻¹ psi)) := by
      funext S; simp +decide [ Kop_apply, Dfock ] ;
      split_ifs <;> simp_all +decide [ Finset.ext_iff, mul_assoc ];
      rw [ Complex.inv_def ] ; simp +decide [ Complex.normSq_eq_norm_sq, hu ] ; ring;

/-! ## T4 — the bundled sharpener -/

/-
A `2×2` unitary whose characteristic polynomial is `(X - 1)^2` is the
identity.
-/
theorem sharpener_pos (U : Matrix (Fin 2) (Fin 2) ℂ) (hU : U * Uᴴ = 1)
    (hc : U.charpoly = (X - 1) ^ 2) : U = 1 := by
      simp_all +decide [ Matrix.charpoly, Matrix.det_fin_two ];
      have h_trace : U 0 0 + U 1 1 = 2 := by
        have h₁ := congr_arg ( Polynomial.eval 0 ) hc; have h₂ := congr_arg ( Polynomial.eval 1 ) hc; norm_num [ Complex.ext_iff ] at *; constructor <;> linarith;
      have h_diag : U 0 0 = 1 ∧ U 1 1 = 1 := by
        have h_diag : Complex.normSq (U 0 0) ≤ 1 ∧ Complex.normSq (U 1 1) ≤ 1 := by
          have := congr_fun ( congr_fun hU 0 ) 0; have := congr_fun ( congr_fun hU 1 ) 1; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ;
          exact ⟨ by norm_num [ Complex.normSq ] ; nlinarith only [ this, ‹ ( U 0 0 |> Complex.re ) * ( U 0 0 |> Complex.re ) + ( U 0 0 |> Complex.im ) * ( U 0 0 |> Complex.im ) + ( ( U 0 1 |> Complex.re ) * ( U 0 1 |> Complex.re ) + ( U 0 1 |> Complex.im ) * ( U 0 1 |> Complex.im ) ) = 1 ∧ _› ], by norm_num [ Complex.normSq ] ; nlinarith only [ this, ‹ ( U 0 0 |> Complex.re ) * ( U 0 0 |> Complex.re ) + ( U 0 0 |> Complex.im ) * ( U 0 0 |> Complex.im ) + ( ( U 0 1 |> Complex.re ) * ( U 0 1 |> Complex.re ) + ( U 0 1 |> Complex.im ) * ( U 0 1 |> Complex.im ) ) = 1 ∧ _› ] ⟩;
        norm_num [ Complex.normSq, Complex.ext_iff ] at *;
        constructor <;> constructor <;> nlinarith [ sq_nonneg ( ( U 0 0 |> Complex.re ) - 1 ), sq_nonneg ( ( U 0 0 |> Complex.im ) - 0 ), sq_nonneg ( ( U 1 1 |> Complex.re ) - 1 ), sq_nonneg ( ( U 1 1 |> Complex.im ) - 0 ) ];
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two ];
      simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ]

/-
A `2×2` unitary whose characteristic polynomial is `(X + 1)^2` is minus
the identity.
-/
theorem sharpener_neg (U : Matrix (Fin 2) (Fin 2) ℂ) (hU : U * Uᴴ = 1)
    (hc : U.charpoly = (X + 1) ^ 2) : U = -1 := by
      have h_trace : U 0 0 + U 1 1 = -2 := by
        have := congr_arg ( Polynomial.eval 0 ) hc; norm_num [ Matrix.charpoly, Matrix.det_fin_two ] at this; ( have := congr_arg ( Polynomial.eval 1 ) hc; norm_num [ Matrix.charpoly, Matrix.det_fin_two ] at this; ( norm_num [ Complex.ext_iff ] at *; constructor <;> linarith; ) );
      have h_diag : Complex.normSq (U 0 0) ≤ 1 ∧ Complex.normSq (U 1 1) ≤ 1 := by
        have := congr_fun ( congr_fun hU 0 ) 0; have := congr_fun ( congr_fun hU 1 ) 1; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ;
        exact ⟨ by norm_num [ Complex.normSq ] ; nlinarith only [ this, ‹ ( U 0 0 |> Complex.re ) * ( U 0 0 |> Complex.re ) + ( U 0 0 |> Complex.im ) * ( U 0 0 |> Complex.im ) + ( ( U 0 1 |> Complex.re ) * ( U 0 1 |> Complex.re ) + ( U 0 1 |> Complex.im ) * ( U 0 1 |> Complex.im ) ) = 1 ∧ _› ], by norm_num [ Complex.normSq ] ; nlinarith only [ this, ‹ ( U 0 0 |> Complex.re ) * ( U 0 0 |> Complex.re ) + ( U 0 0 |> Complex.im ) * ( U 0 0 |> Complex.im ) + ( ( U 0 1 |> Complex.re ) * ( U 0 1 |> Complex.re ) + ( U 0 1 |> Complex.im ) * ( U 0 1 |> Complex.im ) ) = 1 ∧ _› ] ⟩;
      have h_diag : U 0 0 = -1 ∧ U 1 1 = -1 := by
        norm_num [ Complex.normSq, Complex.ext_iff ] at *;
        constructor <;> constructor <;> nlinarith [ sq_nonneg ( ( U 0 0 |> Complex.re ) + 1 ), sq_nonneg ( ( U 0 0 |> Complex.im ) - 0 ), sq_nonneg ( ( U 1 1 |> Complex.re ) + 1 ), sq_nonneg ( ( U 1 1 |> Complex.im ) - 0 ) ];
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two ];
      simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ]

/-- **T4 (bundled sharpener).**  A `2×2` unitary with a single eigenvalue of
algebraic multiplicity two is the corresponding scalar matrix. -/
theorem sharpener (U : Matrix (Fin 2) (Fin 2) ℂ) (hU : U * Uᴴ = 1) :
    (U.charpoly = (X - 1) ^ 2 → U = 1) ∧
      (U.charpoly = (X + 1) ^ 2 → U = -1) :=
  ⟨sharpener_pos U hU, sharpener_neg U hU⟩

end PhysicsSM.Draft.NullEdge.CARBlockReduction
