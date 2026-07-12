/-
Provenance: Aristotle job 5e105f5f (fable-24h-walkforce), harvested
2026-07-12 ~03:50 PDT. KERNEL-ONLY (0 native). The 'to 7' upgrade for
Paper A: the covariance group of the derived mass-operator family
{B_z = !![0,z;conj z,0]} IS the chiral phase circle (mod scalars) plus
the orientation flip, so the selection theorem's constraint set is
FORCED, not chosen. T3 (blockOf_gauge_forced) composes with carblock's
Dfock/blockOf correspondence. HONEST BOUNDARY (in the module docstring):
this is the STATIC-family covariance, not yet the dynamical walk
commutant. Oracle: hand algebra (two-probe z=1,i complete).
-/
import Mathlib

/-!
# The constraint-forcing theorem for the derived mass-operator family

This module upgrades Paper A's selection result from "unique *given* the gauge
action" to "the gauge action is itself *forced*".  Concretely, we classify the
unitary `2×2` matrices that are **covariant** for the derived mass-operator
family

`B z = massOperator z = !![0, z; conj z, 0]`

in the sense that conjugation by the unitary maps each `B z` back into the
family: `W * B z * Wᴴ = B (f z)` for some map `f` of the spectral parameter.

## Hand-verified algebra (the engine of the classification)

Writing `W = !![a, b; c, d]`, the covariance equation `W * B z = B w * W`
(equivalent to `W * B z * Wᴴ = B w` when `W` is unitary, since `Wᴴ * W = 1`)
reads, entrywise,

* `(0,0)`:  `b * conj z = w * c`
* `(0,1)`:  `a * z      = w * d`
* `(1,0)`:  `d * conj z = conj w * a`
* `(1,1)`:  `c * z      = conj w * b`.

Instantiating at `z = 1` (so `conj z = 1`) and `z = i` (so `conj z = -i`) and
calling the two resulting spectral images `w1`, `w2`:

* **Case `c ≠ 0`.**  From `b = w1 c` (z=1, (0,0)) and `-i b = w2 c` (z=i, (0,0))
  we get `w2 = -i w1`.  From `a = w1 d` (z=1,(0,1)) and `i a = w2 d = -i w1 d`
  (z=i,(0,1)) we get `2 i (w1 d) = 0`, i.e. `w1 d = 0`.  If `w1 = 0` then
  `b = w1 c = 0` and `a = w1 d = 0`, but then `c = conj w1 * b = 0`,
  contradicting `c ≠ 0`; hence `w1 ≠ 0`, so `d = 0` and then `a = w1 d = 0`.
  Thus `W` is **antidiagonal** and the induced action is the
  orientation-**flip** `f z = u * conj z` with `u = b * conj c`.
* **Case `c = 0`.**  Then `b = w1 * c = 0` directly, so `W` is **diagonal** and
  the induced action is the orientation-**preserving** `f z = u * z` with
  `u = a * conj d`.

Every case of this hand algebra checks out, so the classification below is the
stated one (no correction was needed).

## Targets

* `classification` (**T1**, completeness): a unitary `W` admitting `w1, w2` with
  `W * B 1 * Wᴴ = B w1` and `W * B i * Wᴴ = B w2` is diagonal or antidiagonal;
  and correspondingly (`orientation_preserving` / `orientation_flip`) it
  satisfies for **all** `z` either `W * B z * Wᴴ = B (u z)` with `u = a conj d`
  or `W * B z * Wᴴ = B (u conj z)` with `u = b conj c`.
* `covariance_group_eq_chiralPhase` (**T2**, mod-scalar identification): every
  orientation-preserving covariance unitary equals `λ • chiralPhase u` for a
  unimodular `λ` and `u = a conj d`; the covariance group of the derived
  mass-operator family, mod global phase and orientation, **is** the chiral
  phase circle.
* `conj_orientation_eq_Dphase` / `blockOf_gauge_forced` (**T3**, forcing
  corollary): via the `Dfock`/`blockOf` correspondence conventions copied from
  `CARBlockReduction`, the pair-block gauge action induced by an
  orientation-preserving covariance is exactly conjugation by `Dphase u` —
  i.e. the selection theorem's constraint set is the covariance constraint of
  the derived family, not a choice.
* `chiralPhase_unitary_and_covariant` (**T4**, non-vacuity control) and
  `rotation_not_covariant` (**T4**, load-bearing completeness control): the
  chiral phase satisfies the covariance for every unimodular `u`; and an
  explicit unitary that is neither diagonal nor antidiagonal (the
  Gaussian-rational rotation `!![3/5, 4/5; -4/5, 3/5]`) **fails** the
  covariance already at `z = 1`.

## Honest boundary

This classifies the covariances of the **static** derived family `{B z}`.
Identifying this covariance group with the dynamical walk commutant is a further
step and is **not** claimed here.

All results are elementary `2×2` complex-matrix algebra (kernel-only expected).
-/

noncomputable section

namespace MassCovarianceForcing

open Matrix Complex
open scoped Matrix ComplexConjugate

/-- The odd Hermitian rest / mass operator `B z = !![0, z; conj z, 0]`
(reproduced verbatim from `PlueckerPhaseObservable`). -/
def massOperator (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- The diagonal chiral phase unitary `!![u, 0; 0, 1]`
(reproduced verbatim from `PlueckerPhaseObservable`). -/
def chiralPhase (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![u, 0; 0, 1]

/-- `W` is diagonal (off-diagonal entries vanish). -/
def IsDiagonal (W : Matrix (Fin 2) (Fin 2) ℂ) : Prop := W 0 1 = 0 ∧ W 1 0 = 0

/-- `W` is antidiagonal (diagonal entries vanish). -/
def IsAntidiagonal (W : Matrix (Fin 2) (Fin 2) ℂ) : Prop := W 0 0 = 0 ∧ W 1 1 = 0

/-! ## T1 — classification / completeness -/

/--
**T1 (classification).**  A unitary `W` covariant for `B` at the two probes
`z = 1` and `z = i` (i.e. admitting spectral images `w1, w2`) is diagonal or
antidiagonal.
-/
theorem classification (W : Matrix (Fin 2) (Fin 2) ℂ) (hW : W * Wᴴ = 1)
    (w1 w2 : ℂ) (h1 : W * massOperator 1 * Wᴴ = massOperator w1)
    (h2 : W * massOperator Complex.I * Wᴴ = massOperator w2) :
    IsDiagonal W ∨ IsAntidiagonal W := by
  simp_all +decide [ IsDiagonal, IsAntidiagonal, massOperator ];
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
  norm_num [ Complex.ext_iff ] at *;
  grind +ring

/-- **T1 (orientation-preserving branch).**  A diagonal matrix is covariant for
**every** `z`, with the orientation-preserving action `f z = (a * conj d) * z`.
(Unitarity is not needed for this algebraic identity, so it is omitted.) -/
theorem orientation_preserving (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hd : IsDiagonal W) (z : ℂ) :
    W * massOperator z * Wᴴ = massOperator ((W 0 0 * (starRingEnd ℂ) (W 1 1)) * z) := by
  simp_all +decide [ IsDiagonal, massOperator ]
  ext i j ; fin_cases i <;> fin_cases j <;>
    simp +decide [ *, Matrix.mul_apply, Matrix.conjTranspose_apply ] <;> ring

/--
**T1 (orientation-flip branch).**  An antidiagonal matrix is covariant for
**every** `z`, with the orientation-flipping action `f z = (b * conj c) * conj z`.
(Unitarity is not needed for this algebraic identity, so it is omitted.)
-/
theorem orientation_flip (W : Matrix (Fin 2) (Fin 2) ℂ)
    (ha : IsAntidiagonal W) (z : ℂ) :
    W * massOperator z * Wᴴ =
      massOperator ((W 0 1 * (starRingEnd ℂ) (W 1 0)) * (starRingEnd ℂ) z) := by
  unfold IsAntidiagonal at ha; simp_all +decide [ massOperator ] ;
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, Matrix.mul_apply ] <;> ring!;

/-! ## T2 — mod-scalar identification with the chiral phase circle -/

/--
**T2 (mod-scalar identification).**  Every orientation-preserving covariance
unitary (a diagonal unitary) equals `λ • chiralPhase u` for a unimodular scalar
`λ = d` and phase `u = a * conj d`.  Mod global phase, the covariance group of
`{B z}` is the chiral phase circle.
-/
theorem covariance_group_eq_chiralPhase (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) :
    ∃ lam : ℂ, ‖lam‖ = 1 ∧
      W = lam • chiralPhase (W 0 0 * (starRingEnd ℂ) (W 1 1)) := by
  refine' ⟨ W 1 1, _, _ ⟩;
  · replace hW := congr_fun ( congr_fun hW 1 ) 1; simp_all +decide [ Matrix.mul_apply ] ;
    simp_all +decide [ Complex.ext_iff, IsDiagonal ];
    norm_num [ Complex.normSq, Complex.norm_def, hW ];
  · ext i j;
    fin_cases i <;> fin_cases j <;> simp_all +decide [ hd.1, hd.2, chiralPhase ];
    replace hW := congr_fun ( congr_fun hW 1 ) 1 ; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ];
    have := hd.2; simp_all +decide [ Complex.ext_iff ] ;
    grind

/-! ## Copied `Dfock`/`blockOf` machinery (verbatim from `CARBlockReduction`) -/

section Copied

/-- Fermionic Fock space in the occupation-number basis. -/
abbrev Fock (ι : Type*) := Finset ι -> Complex

/-- Occupation-basis vector for four fermionic modes. -/
def basisVec (S : Finset (Fin 4)) : Fock (Fin 4) := fun T =>
  if T = S then 1 else 0

def lowPair : Finset (Fin 4) := {0, 1}

def highPair : Finset (Fin 4) := {2, 3}

/-- The type of `ℂ`-linear Fock operators on four modes. -/
abbrev FockOp := Fock (Fin 4) →ₗ[ℂ] Fock (Fin 4)

/-- The two distinguished pair states, in the basis order `(lowPair, highPair)`. -/
def pairIdx : Fin 2 → Finset (Fin 4) := ![lowPair, highPair]

@[simp] theorem pairIdx_zero : pairIdx 0 = lowPair := rfl
@[simp] theorem pairIdx_one : pairIdx 1 = highPair := rfl

/-- The reduction reading a 2×2 block off any Fock operator. -/
def blockOf (H : FockOp) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j => H (basisVec (pairIdx j)) (pairIdx i)

/-- The block gauge action of the site-local chiral phase. -/
def Dphase (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![u, 0; 0, 1]

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

/-- The block shadow of `Dfock u` is `Dphase u`: for unimodular `u` and any
linear `H`, block-conjugation by `Dfock u` is matrix conjugation by `Dphase u`.
(Verbatim from `CARBlockReduction`.) -/
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
          have h_Dfock_inv : Dfock u⁻¹ (basisVec lowPair) = u⁻¹ • basisVec lowPair := by
            ext S; simp [Dfock, basisVec];
            split_ifs <;> simp_all +decide [ lowPair ];
          simp_all +decide [ mul_comm, vecHead, vecTail ];
          exact Or.inl ( by rw [ Complex.inv_def ] ; simp +decide [ Complex.normSq_eq_norm_sq, hu ] );
        · simp +decide [ blockOf, Matrix.vecMul, Matrix.mul_apply, Fin.sum_univ_succ ];
          convert congr_arg ( fun x => H x highPair ) ( show Dfock u⁻¹ ( basisVec highPair ) = basisVec highPair from _ ) using 1;
          ext S; simp +decide [ Dfock, basisVec ] ;
          fin_cases S <;> simp +decide

end Copied

/-! ## T3 — the forcing corollary -/

/--
**T3 (matrix core).**  For an orientation-preserving covariance (a diagonal
unitary) `W`, conjugation by `W` coincides with conjugation by the chiral phase
block `Dphase u` where `u = a * conj d`.  The global scalar cancels in the
conjugation, so the gauge action is forced to be `Dphase u`, not a choice.
-/
theorem conj_orientation_eq_Dphase (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) (M : Matrix (Fin 2) (Fin 2) ℂ) :
    W * M * Wᴴ =
      Dphase (W 0 0 * (starRingEnd ℂ) (W 1 1)) * M *
        (Dphase (W 0 0 * (starRingEnd ℂ) (W 1 1)))ᴴ := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, Dphase, Matrix.mul_apply, Fin.sum_univ_succ ] ; ring; (
  replace hW := congr_fun ( congr_fun hW 1 ) 1 ; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ; ring;
  simp_all +decide [ IsDiagonal, Matrix.vecMul ] ; ring_nf at * ;
  exact ⟨ by rw [ show ( W 1 1 |> Complex.re ) ^ 2 = 1 - ( W 1 1 |> Complex.im ) ^ 2 by linarith ] ; ring!, by rw [ show ( W 1 1 |> Complex.re ) ^ 2 = 1 - ( W 1 1 |> Complex.im ) ^ 2 by linarith ] ; ring! ⟩ ;);
  · simp_all +decide [ IsDiagonal, Matrix.vecMul ];
    ring!;
  · simp_all +decide [ IsDiagonal, Matrix.vecMul ] ; ring!;
  · simp_all +decide [ Matrix.vecMul, Matrix.mul_apply, Complex.ext_iff, IsDiagonal ];
    have := congr_fun ( congr_fun hW 1 ) 1; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ; ring_nf;
    exact ⟨ by rw [ show vecHead ( vecTail M ) 1 = M 1 1 from rfl ] ; linear_combination' this.1 * ( M 1 1 |> Complex.re ), by rw [ show vecHead ( vecTail M ) 1 = M 1 1 from rfl ] ; linear_combination' this.1 * ( M 1 1 |> Complex.im ) ⟩

/-- **T3 (Fock-level forcing).**  Composing with the `Dfock`/`blockOf`
correspondence: the pair-block gauge action induced by an orientation-preserving
covariance `W` is exactly block-conjugation by the Fock unitary `Dfock u`
(`u = a * conj d`).  The selection theorem's constraint is therefore the
covariance constraint of the derived family. -/
theorem blockOf_gauge_forced (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) (H : FockOp) :
    blockOf (DfockL (W 0 0 * (starRingEnd ℂ) (W 1 1)) ∘ₗ H ∘ₗ
        DfockL (W 0 0 * (starRingEnd ℂ) (W 1 1))⁻¹)
      = W * blockOf H * Wᴴ := by
  rw [ blockOf_conj_Dfock ]
  · exact (conj_orientation_eq_Dphase W hW hd (blockOf H)).symm
  · simp_all +decide [ IsDiagonal, Complex.norm_def, Complex.normSq ]
    have := congr_fun ( congr_fun hW 0 ) 0
    have := congr_fun ( congr_fun hW 1 ) 1
    simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ]

/-! ## T4 — controls -/

/--
**T4 (non-vacuity).**  For every unimodular `u`, `chiralPhase u` is unitary
and covariant for `B` at every `z`, with action `f z = u z`.
-/
theorem chiralPhase_unitary_and_covariant (u : ℂ) (hu : ‖u‖ = 1) :
    chiralPhase u * (chiralPhase u)ᴴ = 1 ∧
      ∀ z : ℂ, chiralPhase u * massOperator z * (chiralPhase u)ᴴ =
        massOperator (u * z) := by
  constructor;
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, chiralPhase, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply ];
    simp +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq, hu ];
  · intro z; unfold chiralPhase massOperator; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, Matrix.conjTranspose_apply ] ; ring;

/-- The Gaussian-rational rotation, unitary but neither diagonal nor
antidiagonal. -/
def rotation : Matrix (Fin 2) (Fin 2) ℂ := !![3/5, 4/5; -4/5, 3/5]

/--
**T4 (completeness is load-bearing).**  The rotation `!![3/5,4/5;-4/5,3/5]`
is unitary and neither diagonal nor antidiagonal, yet it is **not** covariant:
already at `z = 1` there is no `w` with `rotation * B 1 * rotationᴴ = B w`
(its `(0,0)` entry is `24/25 ≠ 0`, while every `B w` has `(0,0) = 0`).
-/
theorem rotation_not_covariant :
    rotation * rotationᴴ = 1 ∧ ¬ IsDiagonal rotation ∧ ¬ IsAntidiagonal rotation ∧
      ¬ ∃ w : ℂ, rotation * massOperator 1 * rotationᴴ = massOperator w := by
  refine' ⟨ _, _, _, _ ⟩;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ rotation, Matrix.mul_apply, Matrix.conjTranspose_apply ];
    · norm_num [ Complex.ext_iff, div_eq_mul_inv ];
    · norm_num [ Complex.ext_iff, div_eq_mul_inv ];
    · grind +suggestions;
    · grind +suggestions;
  · exact fun h => by have := h.1; norm_num [ rotation ] at this;
  · unfold rotation; norm_num [ IsAntidiagonal ] ;
  · rintro ⟨ w, hw ⟩;
    have := congr_fun ( congr_fun hw 0 ) 0 ; norm_num [ rotation, massOperator, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply ] at this;
    norm_num [ Complex.ext_iff, div_eq_mul_inv ] at this

end MassCovarianceForcing
