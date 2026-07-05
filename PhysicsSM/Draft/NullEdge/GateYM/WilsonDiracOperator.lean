import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

set_option maxHeartbeats 4000000

/-!
# QMF4b: the Wilson-Dirac operator, gamma5-hermiticity, paired-flavor positivity

Second rung of QMF4 on the QCD mass-formalism ladder. Builds on the proved
Euclidean gamma matrices (`EuclideanGamma`, all six Clifford/gamma5 lemmas
kernel-checked) to define the finite lattice Wilson-Dirac operator and prove
its two STRUCTURAL properties, both numerically pre-verified by the oracle
`Scripts/oracle/validate_wilson_dirac.py` (21/21):

* **gamma5-hermiticity** `Γ5 * D * Γ5 = Dᴴ`, where `Γ5` is `gamma5` lifted to the
  full (site x spin x color) space. THIS IS THE REAL CONTENT: it holds because
  `gamma5 (r - gamma_mu) gamma5 = r + gamma_mu` pairs the forward hop with the
  (daggered) backward hop.
* **paired-flavor determinant positivity**: `gamma5`-hermiticity forces
  `det D` to be REAL, so two degenerate flavors give `det(D)^2 >= 0` (the
  Wilson determinant of a mass-degenerate pair is nonnegative). Equivalently
  `(Dᴴ * D).PosSemidef` (generic Gram fact) together with `det D` real.

Everything is finite-lattice, fixed-coupling, fixed-volume - NO continuum.

## Convention (oracle-pinned; do not drift)

Euclidean, spacing `a = 1`, Wilson parameter `r = 1`. Lattice
`Site := Fin 4 → Fin L` (4D periodic; direction `mu : Fin 4`). Full index
`Idx := Site × Fin 4 × Fin nc` (site, Dirac spin in `Fin 4`, color in `Fin nc`).
Link field `U mu x : Matrix (Fin nc) (Fin nc) ℂ`, assumed UNITARY. Operator:

    D (x,s,c) (y,t,d)
      = (m + 4) • [x=y, s=t, c=d]
        - (1/2) Σ_mu [ [y = x+mu] * (1 - γ_mu) s t * (U mu x) c d
                     + [y = x-mu] * (1 + γ_mu) s t * (U mu (x-mu))ᴴ c d ]

with `x+mu`/`x-mu` the periodic neighbor in direction `mu`. (`γ_mu` here is the
`EuclideanGamma.γ mu`; `[P]` is the 0/1 indicator.)

## Status: statement-design + proof target

The scaffold below fixes the types, the unitarity hypothesis, and states the
two theorems as `s o r r y`. YOU (Aristotle) may keep or refine the `wilsonDirac`
definition - but the two theorem SHAPES and the oracle convention must be
preserved. If a cleaner operator encoding makes the proofs shorter, use it, as
long as it is the same operator (check against the oracle: on `L=2`, `nc=1`,
`m=0.3`, gamma5-hermiticity holds and `det D` is real).

## Provenance and status (QMF4 rung 2 - COMPLETES QMF4)

Convention oracle-pinned by `Scripts/oracle/validate_wilson_dirac.py` (21/21);
builds on the proved `EuclideanGamma` Clifford lemmas. All three theorems PROVED
by Aristotle (Harmonic), project `7a2a0f40-78f4-4199-8453-26ceb8113e20`, from
the statement-freeze scaffold in
`AgentTasks/aristotle-standalone/qmf4b-wilson-dirac-20260704/` (prompt
`AgentTasks/aristotle-prompts/qmf4b-wilson-dirac-20260704.prompt.md`).
INDEPENDENTLY VERIFIED against this project's pinned toolchain: `lake env lean`
clean (0 errors, after re-homing under the `PhysicsSM...GateYM` namespace with
`EuclideanGamma` as a sibling so the returned proofs replay verbatim), axioms
`[propext, Classical.choice, Quot.sound]` on all three, `s o r r y`-free, and the
`wilsonDirac`/`Γ5` definitions + the three theorem shapes UNCHANGED from the
frozen scaffold. A finding from the proof (confirmed by the Aristotle triage):
`gamma5_hermiticity` does NOT use link unitarity `hU` - it is purely a property
of the gamma structure; `hU` is retained in the signature for physical fidelity.
Claim label: **finite identity**. This closes the QMF4 rung (Wilson fermion
action + determinant-level doubling audit) of the QCD mass-formalism ladder;
the SUCCESSOR is QMF5 (fermionic reflection positivity).
-/

open scoped Matrix BigOperators

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace Qmf4bWilson

variable {L nc : ℕ}

/-- 4D periodic lattice sites. -/
abbrev Site (L : ℕ) := Fin 4 → Fin L

/-- Full Wilson-fermion index: site, Dirac spin (`Fin 4`), colour (`Fin nc`). -/
abbrev Idx (L nc : ℕ) := Site L × Fin 4 × Fin nc

/-- Periodic neighbour one step up in direction `mu`. -/
def shiftUp [NeZero L] (mu : Fin 4) (x : Site L) : Site L := Function.update x mu (x mu + 1)

/-- Periodic neighbour one step down in direction `mu`. -/
def shiftDn [NeZero L] (mu : Fin 4) (x : Site L) : Site L := Function.update x mu (x mu - 1)

/-- The finite lattice Wilson-Dirac operator (Euclidean, `r = 1`), as a matrix on
`Idx L nc`. Mass `m`, unitary link field `U`. -/
noncomputable def wilsonDirac [NeZero L] (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) :
    Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun (I J : Idx L nc) =>
    let x := I.1; let s := I.2.1; let c := I.2.2
    let y := J.1; let t := J.2.1; let d := J.2.2
    ((m : ℂ) + 4) * (if x = y ∧ s = t ∧ c = d then 1 else 0)
      - (1 / 2) * ∑ mu : Fin 4,
          ((if y = shiftUp mu x then (1 - EuclideanGamma.γ mu) s t * U mu x c d else 0)
            + (if y = shiftDn mu x then (1 + EuclideanGamma.γ mu) s t * (U mu (shiftDn mu x))ᴴ c d else 0))

/-- `gamma5` lifted to the full `Idx` space (acts on the Dirac spin factor only). -/
noncomputable def Γ5 (L nc : ℕ) : Matrix (Idx L nc) (Idx L nc) ℂ :=
  Matrix.of fun I J =>
    (if I.1 = J.1 ∧ I.2.2 = J.2.2 then EuclideanGamma.γ5 I.2.1 J.2.1 else 0)

/-- Shifting up then down (periodically) is the identity. -/
lemma shiftUp_shiftDn [NeZero L] (mu : Fin 4) (x : Site L) :
    shiftUp mu (shiftDn mu x) = x := by
  unfold shiftUp shiftDn
  rw [Function.update_idem, Function.update_self, sub_add_cancel,
    Function.update_eq_self]

/-- Shifting down then up (periodically) is the identity. -/
lemma shiftDn_shiftUp [NeZero L] (mu : Fin 4) (x : Site L) :
    shiftDn mu (shiftUp mu x) = x := by
  unfold shiftUp shiftDn
  rw [Function.update_idem, Function.update_self, add_sub_cancel_right,
    Function.update_eq_self]

/-- `y = x + mu` iff `y - mu = x` (periodic). -/
lemma shiftUp_eq_iff [NeZero L] (mu : Fin 4) (x y : Site L) :
    y = shiftUp mu x ↔ shiftDn mu y = x := by
  constructor
  · rintro rfl; exact shiftDn_shiftUp mu x
  · rintro rfl; exact (shiftUp_shiftDn mu y).symm

/-- `y = x - mu` iff `y + mu = x` (periodic). -/
lemma shiftDn_eq_iff [NeZero L] (mu : Fin 4) (x y : Site L) :
    y = shiftDn mu x ↔ shiftUp mu y = x := by
  constructor
  · rintro rfl; exact shiftUp_shiftDn mu x
  · rintro rfl; exact (shiftDn_shiftUp mu y).symm

/-- `gamma5` conjugation flips the Wilson forward projector to the backward one:
`γ5 (1 - γ_mu) γ5 = 1 + γ_mu`. -/
lemma γ5_conj_one_sub (mu : Fin 4) :
    EuclideanGamma.γ5 * (1 - EuclideanGamma.γ mu) * EuclideanGamma.γ5
      = 1 + EuclideanGamma.γ mu := by
  have h5 := EuclideanGamma.γ5_sq
  have hac := EuclideanGamma.γ5_anticomm mu
  have hcomm : EuclideanGamma.γ5 * EuclideanGamma.γ mu
      = - (EuclideanGamma.γ mu * EuclideanGamma.γ5) :=
    eq_neg_of_add_eq_zero_left hac
  rw [mul_sub, mul_one, sub_mul, h5, hcomm, neg_mul, mul_assoc, h5, mul_one]
  abel

/-- `γ5 (1 + γ_mu) γ5 = 1 - γ_mu`. -/
lemma γ5_conj_one_add (mu : Fin 4) :
    EuclideanGamma.γ5 * (1 + EuclideanGamma.γ mu) * EuclideanGamma.γ5
      = 1 - EuclideanGamma.γ mu := by
  have h5 := EuclideanGamma.γ5_sq
  have hac := EuclideanGamma.γ5_anticomm mu
  have hcomm : EuclideanGamma.γ5 * EuclideanGamma.γ mu
      = - (EuclideanGamma.γ mu * EuclideanGamma.γ5) :=
    eq_neg_of_add_eq_zero_left hac
  rw [mul_add, mul_one, add_mul, h5, hcomm, neg_mul, mul_assoc, h5, mul_one]
  abel

/-
`Γ5` squares to the identity on the full index space.
-/
lemma Γ5_mul_Γ5 [NeZero L] : Γ5 L nc * Γ5 L nc = 1 := by
  ext ⟨ x, s, c ⟩ ⟨ y, t, d ⟩ ; by_cases hy : x = y <;> by_cases hd : d = c <;> simp +decide [ *, Matrix.mul_apply ] ;
  · simp_all +decide [ Matrix.one_apply, Γ5 ];
    rw [ Finset.sum_ite ] ; simp +decide [ Finset.filter_and ] ;
    rw [ show ( Finset.filter ( fun a : Site L × Fin 4 × Fin nc => a.1 = y ) Finset.univ ∩ Finset.filter ( fun a : Site L × Fin 4 × Fin nc => a.2.2 = c ) Finset.univ ) = Finset.image ( fun a : Fin 4 => ( y, a, c ) ) Finset.univ from ?_ ];
    · rw [ Finset.sum_image ] <;> simp +decide;
      · convert congr_fun ( congr_fun ( EuclideanGamma.γ5_sq ) s ) t using 1;
      · aesop_cat;
    · ext ⟨ a, b, c ⟩ ; aesop;
  · simp +decide [ *, Γ5, Matrix.one_apply ];
    rw [ Finset.sum_eq_zero ] <;> aesop;
  · unfold Γ5; aesop;
  · rw [ Finset.sum_eq_zero ] ; intros ; simp_all +decide [ Γ5 ]

/-- The common closed form that both `Γ5 D Γ5` and `Dᴴ` reduce to entrywise. -/
noncomputable def wdCF [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) (I J : Idx L nc) : ℂ :=
  ((m : ℂ) + 4) * (if I.1 = J.1 ∧ I.2.1 = J.2.1 ∧ I.2.2 = J.2.2 then 1 else 0)
    - (1 / 2) * ∑ mu : Fin 4,
        ((if J.1 = shiftUp mu I.1 then
            (1 + EuclideanGamma.γ mu) I.2.1 J.2.1 * U mu I.1 I.2.2 J.2.2 else 0)
          + (if J.1 = shiftDn mu I.1 then
            (1 - EuclideanGamma.γ mu) I.2.1 J.2.1
              * (U mu (shiftDn mu I.1))ᴴ I.2.2 J.2.2 else 0))

/-
Conjugating a spin-only matrix by `γ5` on both sides, entrywise as a double sum.
-/
lemma spin_conj (A : Matrix (Fin 4) (Fin 4) ℂ) (s t : Fin 4) :
    ∑ s' : Fin 4, ∑ t' : Fin 4,
        EuclideanGamma.γ5 s s' * A s' t' * EuclideanGamma.γ5 t' t
      = (EuclideanGamma.γ5 * A * EuclideanGamma.γ5) s t := by
  simp +decide only [Matrix.mul_apply];
  exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => by rw [ Finset.sum_mul _ _ _ ] )

/-
STEP 1: collapse the two `Γ5` factors, leaving a double spin sum.
-/
lemma gamma5_D_gamma5_apply [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) (I J : Idx L nc) :
    (Γ5 L nc * wilsonDirac m U * Γ5 L nc) I J
      = ∑ s' : Fin 4, ∑ t' : Fin 4,
          EuclideanGamma.γ5 I.2.1 s'
            * wilsonDirac m U (I.1, s', I.2.2) (J.1, t', J.2.2)
            * EuclideanGamma.γ5 t' J.2.1 := by
  rw [ Matrix.mul_assoc, Matrix.mul_apply ];
  rw [ ← Finset.sum_subset ( Finset.subset_univ ( Finset.image ( fun s' : Fin 4 => ( I.1, s', I.2.2 ) ) Finset.univ ) ) ];
  · simp +decide [ Matrix.mul_apply, Γ5 ];
    rw [ Finset.sum_image ] <;> simp +decide [ Finset.sum_ite ];
    · rw [ Finset.sum_congr rfl ];
      intro x hx; rw [ Finset.mul_sum _ _ _ ] ; rw [ show ( Finset.filter ( fun x_1 : Site L × Fin 4 × Fin nc => x_1.1 = J.1 ∧ x_1.2.2 = J.2.2 ) Finset.univ ) = Finset.image ( fun t' : Fin 4 => ( J.1, t', J.2.2 ) ) Finset.univ from ?_ ] ; rw [ Finset.sum_image ] <;> simp +decide [ Finset.sum_mul _ _ _ ] ;
      · simp +decide only [mul_assoc];
      · aesop_cat;
      · ext ⟨ x, y, z ⟩ ; aesop;
    · norm_num [ Function.Injective ];
  · unfold Γ5; aesop;

/-- STEP 2: the LHS reduces to the common closed form `wdCF`. -/
lemma gamma5_D_gamma5_eq_wdCF [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) (I J : Idx L nc) :
    (Γ5 L nc * wilsonDirac m U * Γ5 L nc) I J = wdCF m U I J := by
  rw [ gamma5_D_gamma5_apply ];
  unfold wilsonDirac wdCF;
  simp +decide only [mul_comm, Finset.mul_sum _ _ _];
  simp +decide only [Matrix.of_apply, mul_sub, Finset.sum_sub_distrib];
  congr! 1;
  · split_ifs <;> simp_all +decide [ Finset.sum_ite, Finset.filter_eq, Finset.filter_and ];
    · have := congr_fun ( congr_fun EuclideanGamma.γ5_sq J.2.1 ) J.2.1; simp_all +decide [ Matrix.mul_apply, Finset.sum_ite ] ;
      convert congr_arg ( fun x : ℂ => x * ( m + 4 ) ) this using 1 <;> ring;
      simp +decide [ mul_comm, Finset.mul_sum _ _ _, Finset.sum_add_distrib ] ; ring;
    · split_ifs <;> simp_all +decide [ Finset.sum_ite ];
      have := EuclideanGamma.γ5_sq; simp_all +decide [ ← mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul ] ;
      replace this := congr_fun ( congr_fun this I.2.1 ) J.2.1; simp_all +decide [ Matrix.mul_apply, Finset.sum_ite ] ;
      exact Or.inl ( by simpa only [ mul_comm ] using this );
  · simp +decide only [mul_add, Finset.mul_sum _ _ _];
    simp +decide only [Finset.sum_add_distrib];
    congr! 1;
    · have h_simp : ∀ x_2 : Fin 4, ∑ x : Fin 4, ∑ x_1 : Fin 4, EuclideanGamma.γ5 x_1 J.2.1 * (EuclideanGamma.γ5 I.2.1 x * (if J.1 = shiftUp x_2 I.1 then U x_2 I.1 I.2.2 J.2.2 * (1 - EuclideanGamma.γ x_2) x x_1 else 0)) = (if J.1 = shiftUp x_2 I.1 then U x_2 I.1 I.2.2 J.2.2 * (1 + EuclideanGamma.γ x_2) I.2.1 J.2.1 else 0) := by
        intro x_2
        by_cases h : J.1 = shiftUp x_2 I.1;
        · simp +decide [ h, ← mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, ← Matrix.mul_apply, ← Matrix.mul_assoc, γ5_conj_one_sub ];
          convert congr_arg ( fun x : Matrix ( Fin 4 ) ( Fin 4 ) ℂ => U x_2 I.1 I.2.2 J.2.2 * x I.2.1 J.2.1 ) ( γ5_conj_one_sub x_2 ) using 1;
          simp +decide [ Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul ];
          exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring );
        · simp [h];
      simp +decide only [← Finset.mul_sum _ _ _, ← Finset.sum_comm, ← h_simp];
      simp +decide only [Finset.mul_sum _ _ _, mul_left_comm];
    · have h_simp : ∀ x_2 : Fin 4, ∑ x : Fin 4, ∑ x_1 : Fin 4, EuclideanGamma.γ5 x_1 J.2.1 * (EuclideanGamma.γ5 I.2.1 x * (if J.1 = shiftDn x_2 I.1 then (1 + EuclideanGamma.γ x_2) x x_1 * (U x_2 (shiftDn x_2 I.1))ᴴ I.2.2 J.2.2 else 0)) = (if J.1 = shiftDn x_2 I.1 then (1 - EuclideanGamma.γ x_2) I.2.1 J.2.1 * (U x_2 (shiftDn x_2 I.1))ᴴ I.2.2 J.2.2 else 0) := by
        intro x_2
        by_cases h : J.1 = shiftDn x_2 I.1;
        · simp only [if_pos h]
          rw [show (∑ x : Fin 4, ∑ x_1 : Fin 4, EuclideanGamma.γ5 x_1 J.2.1 * (EuclideanGamma.γ5 I.2.1 x * ((1 + EuclideanGamma.γ x_2) x x_1 * (U x_2 (shiftDn x_2 I.1))ᴴ I.2.2 J.2.2)))
              = (∑ x : Fin 4, ∑ x_1 : Fin 4, EuclideanGamma.γ5 I.2.1 x * (1 + EuclideanGamma.γ x_2) x x_1 * EuclideanGamma.γ5 x_1 J.2.1) * (U x_2 (shiftDn x_2 I.1))ᴴ I.2.2 J.2.2 from by
            rw [Finset.sum_mul]; refine Finset.sum_congr rfl fun _ _ => ?_
            rw [Finset.sum_mul]; refine Finset.sum_congr rfl fun _ _ => ?_; ring]
          rw [spin_conj, γ5_conj_one_add]
        · simp [h];
      simp +decide only [← Finset.mul_sum _ _ _, ← Finset.sum_comm, ← h_simp];
      simp +decide only [Finset.mul_sum _ _ _, mul_left_comm]

/-
STEP 3+4: the conjugate transpose also reduces to `wdCF`; here the periodic
shift bookkeeping pairs the forward hop with the daggered backward hop.
-/
lemma wilsonDiracH_eq_wdCF [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) (I J : Idx L nc) :
    (wilsonDirac m U)ᴴ I J = wdCF m U I J := by
  apply Eq.symm; exact (by
    have h_eq : ∀ (mu : Fin 4), (1 - EuclideanGamma.γ mu)ᴴ = 1 - EuclideanGamma.γ mu := by
      simp +decide [ Matrix.conjTranspose_sub, EuclideanGamma.γ_herm ]
    unfold wdCF wilsonDirac;
    simp +decide [ Matrix.conjTranspose_apply, Finset.sum_add_distrib, mul_add, add_mul, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_comm, mul_left_comm, Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ];
    congr! 1;
    · split_ifs <;> simp_all +decide [ eq_comm ];
      norm_num [ Complex.ext_iff ];
    · rw [ show ( Finset.filter ( fun x => J.1 = shiftUp x I.1 ) Finset.univ ) = Finset.filter ( fun x => I.1 = shiftDn x J.1 ) Finset.univ from ?_, show ( Finset.filter ( fun x => J.1 = shiftDn x I.1 ) Finset.univ ) = Finset.filter ( fun x => I.1 = shiftUp x J.1 ) Finset.univ from ?_ ];
      · rw [ add_comm ];
        congr! 1;
        · refine' Finset.sum_congr rfl fun x hx => _;
          simp_all +decide [ Matrix.one_apply, mul_comm ];
          rw [ show shiftDn x ( shiftUp x J.1 ) = J.1 from ?_ ];
          · simp +decide [ eq_comm, mul_comm ];
            have := congr_fun ( congr_fun ( h_eq x ) J.2.1 ) I.2.1; simp_all +decide [ Matrix.conjTranspose_apply ] ;
            rw [ ← this ] ; ring;
            rw [ Complex.conj_conj ] ; ring;
          · grind +suggestions;
        · refine' congrArg₂ ( · + · ) ( Finset.sum_congr rfl fun x hx => _ ) ( Finset.sum_congr rfl fun x hx => _ ) <;> simp_all +decide [ Matrix.one_apply, mul_assoc, mul_comm, mul_left_comm ];
          · grind +revert;
          · simp_all +decide [ ← Matrix.ext_iff, Matrix.mul_apply, Matrix.conjTranspose_apply ];
            ring;
      · grind +suggestions;
      · grind +suggestions
  )

/-- **gamma5-hermiticity of the Wilson-Dirac operator.** `Γ5 D Γ5 = Dᴴ`.
The structural fact underlying reality of the Wilson determinant.

Proof handoff: expand `Γ5 * D * Γ5` and `Dᴴ` entrywise; the diagonal mass term
commutes with `Γ5` and is real; on the hop terms use
`gamma5 (1 - γ_mu) gamma5 = 1 + γ_mu` (from `EuclideanGamma.γ5_anticomm` +
`γ5_sq`) and unitarity/`conjTranspose` bookkeeping so the forward hop maps to the
(daggered) backward hop. -/
theorem gamma5_hermiticity [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    Γ5 L nc * wilsonDirac m U * Γ5 L nc = (wilsonDirac m U)ᴴ := by
  ext I J
  rw [gamma5_D_gamma5_eq_wdCF, wilsonDiracH_eq_wdCF]

/-
**Reality of the Wilson determinant** (consequence of gamma5-hermiticity).
Since `Γ5^2 = 1`, `det (Dᴴ) = det (Γ5 D Γ5) = det D`, while
`det (Dᴴ) = conj (det D)`; hence `det D` is real.
-/
theorem det_wilsonDirac_real [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    (wilsonDirac m U).det.im = 0 := by
  have h_det_conjTranspose : ((Qmf4bWilson.wilsonDirac m U)ᴴ).det = star ((Qmf4bWilson.wilsonDirac m U).det) := by
    grind +suggestions;
  rw [ ← gamma5_hermiticity m U hU ] at h_det_conjTranspose;
  rw [ Matrix.det_mul, Matrix.det_mul ] at h_det_conjTranspose;
  -- Since $\Gamma_5^2 = I$, we have $\det(\Gamma_5) = \pm 1$.
  have h_det_gamma5 : (Γ5 L nc).det = 1 ∨ (Γ5 L nc).det = -1 := by
    exact mul_self_eq_one_iff.mp ( by rw [ ← Matrix.det_mul, Γ5_mul_Γ5 ] ; norm_num );
  rcases h_det_gamma5 with h | h <;> norm_num [ h ] at h_det_conjTranspose <;> norm_num [ Complex.ext_iff ] at h_det_conjTranspose <;> linarith

/-
**Paired-flavor determinant positivity.** For two mass-degenerate flavors the
Wilson determinant is `det(D)^2`, which is `>= 0` because `det D` is real.
-/
theorem pairedFlavor_det_nonneg [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    0 ≤ ((wilsonDirac m U).det ^ 2).re ∧ ((wilsonDirac m U).det ^ 2).im = 0 := by
  -- Let $z$ be the real determinant.
  set z := (wilsonDirac m U).det
  have hz_im : z.im = 0 := det_wilsonDirac_real m U hU
  simp_all +decide [ sq ]
  exact mul_self_nonneg _

end Qmf4bWilson
end PhysicsSM.Draft.NullEdge.GateYM
