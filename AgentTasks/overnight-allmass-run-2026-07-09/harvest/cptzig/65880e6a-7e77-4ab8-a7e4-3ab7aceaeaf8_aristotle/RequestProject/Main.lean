import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# CPT and the antiparticle as the CPT-mirror zigzag

A massive fermion is modelled as a *zigzag* of two null Weyl pieces coupled by mass.
Its antiparticle is the CPT-conjugate zigzag: the antiunitary `Theta = C · Γ_rev · #`
swaps the left and right Weyl components and conjugates.  Particle and antiparticle are
thus the two CPT-orientations of the *same* null-edge pair, with conjugate-paired spectra.

We give a fully explicit finite matrix model on `ℂ⁴` (chiral basis).

* `gamma5 = diag(+1,+1,-1,-1)` is the chirality operator; `+1` is the left (`psiL`) Weyl
  subspace, `-1` the right (`psiR`) one.
* `Rmat` is the real, orthogonal, involutive block-swap `[[0, I₂],[I₂, 0]]`; it anticommutes
  with `gamma5`.
* `Dmat m = [[A, m·I₂],[m·I₂, A]]` with `A = [[0,1],[-1,0]]` is the Dirac operator: the
  diagonal blocks are the two null Weyl kinetic pieces, the off-diagonal `m·I₂` is the
  mass coupling of the zigzag.
* `Theta v = Rmat · (conj v)` is the antiunitary CPT operator.

All entries are rational/`Complex.I` constants; every proof is `ring`/`simp`/`fin_cases`.
-/

namespace CPTAntiparticleZigzag

open Matrix

/-- Chirality operator `γ₅ = diag(+1,+1,-1,-1)`. `+1`-eigenspace = left Weyl piece
`psiL`, `-1`-eigenspace = right Weyl piece `psiR`. -/
noncomputable def gamma5 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The real, orthogonal, involutive block-swap `R = [[0, I₂],[I₂, 0]]`.
It anticommutes with `gamma5`, so `Theta` will exchange the two null Weyl pieces. -/
noncomputable def Rmat : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

/-- The Dirac operator `D(m) = [[A, m·I₂],[m·I₂, A]]`, `A = [[0,1],[-1,0]]`.
Diagonal blocks = two null Weyl kinetic pieces; off-diagonal `m·I₂` = mass coupling.
For real `m` the entries are real, so `D(m)` is CPT-even. -/
noncomputable def Dmat (m : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,1,m,0; -1,0,0,m; m,0,0,1; 0,m,-1,0]

/-- The antiunitary CPT operator `Θ v = R · conj v`. -/
noncomputable def Theta (v : Fin 4 → ℂ) : Fin 4 → ℂ :=
  Rmat.mulVec (fun i => star (v i))

/-- Workhorse: expand a `Fin 4` vector identity into its four concrete complex-arithmetic
components and close them. -/
local macro "crunch" : tactic =>
  `(tactic| (funext i; fin_cases i <;>
    simp [Theta, gamma5, Rmat, Dmat, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val, star_star,
      Pi.add_apply, Pi.smul_apply, Pi.zero_apply]))

/-! ## Basic algebraic facts about `Theta` -/

/-- `Theta` is additive. -/
lemma Theta_add (v w : Fin 4 → ℂ) : Theta (v + w) = Theta v + Theta w := by
  crunch

/-- `Theta` is conjugate-linear: `Theta (c • v) = (conj c) • Theta v`. -/
lemma Theta_smul (c : ℂ) (v : Fin 4 → ℂ) :
    Theta (c • v) = (starRingEnd ℂ c) • Theta v := by
  crunch

/-- `Theta` is an involution: `Theta (Theta v) = v`. -/
lemma Theta_involutive (v : Fin 4 → ℂ) : Theta (Theta v) = v := by
  crunch

/-- `Theta` fixes the zero vector. -/
lemma Theta_zero : Theta (0 : Fin 4 → ℂ) = 0 := by
  crunch

/-- `Theta` is injective on nonzero vectors: it never sends a nonzero vector to `0`. -/
lemma Theta_ne_zero {v : Fin 4 → ℂ} (hv : v ≠ 0) : Theta v ≠ 0 := by
  intro h
  apply hv
  have hinv := Theta_involutive v
  rw [h, Theta_zero] at hinv
  exact hinv.symm

/-- `Theta` is chirality-odd: it anticommutes with `gamma5`. -/
lemma gamma5_Theta_odd (v : Fin 4 → ℂ) :
    gamma5.mulVec (Theta v) = - Theta (gamma5.mulVec v) := by
  crunch

/-- `Theta` commutes with the (real-`m`) Dirac operator: `D · Θ = Θ · D`.
This is the operator form of `Θ D Θ⁻¹ = D♯ = D` (CPT-even mass coupling). -/
lemma D_Theta_comm (m : ℝ) (v : Fin 4 → ℂ) :
    (Dmat (m : ℂ)).mulVec (Theta v) = Theta ((Dmat (m : ℂ)).mulVec v) := by
  funext i; fin_cases i <;>
    simp [Theta, Dmat, Rmat, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val] <;> ring

/-! ## Target 1: `Theta` is antiunitary (antilinear involution) -/

/-- **`theta_antiunitary`.** `Theta` is antilinear (additive + conjugate-homogeneous)
and an involution. -/
theorem theta_antiunitary :
    (∀ v w : Fin 4 → ℂ, Theta (v + w) = Theta v + Theta w) ∧
    (∀ (c : ℂ) (v : Fin 4 → ℂ), Theta (c • v) = (starRingEnd ℂ c) • Theta v) ∧
    (∀ v : Fin 4 → ℂ, Theta (Theta v) = v) :=
  ⟨Theta_add, Theta_smul, Theta_involutive⟩

/-! ## Target 2: `Theta` swaps the two null Weyl pieces (chirality-odd) -/

/-- **`theta_swaps_weyl`.** `Theta` is chirality-odd (`gamma5 (Theta v) = - Theta (gamma5 v)`),
so CPT exchanges the two null pieces of the zigzag.  Non-degeneracy: on the explicit nonzero
left vector `e₀ = (1,0,0,0)` (chirality `+1`, since `gamma5 e₀ = e₀`), the image
`Theta e₀ = (0,0,1,0) ≠ 0` has chirality `-1` (`gamma5 (Theta e₀) = - Theta e₀`): a right vector. -/
theorem theta_swaps_weyl :
    (∀ v : Fin 4 → ℂ, gamma5.mulVec (Theta v) = - Theta (gamma5.mulVec v)) ∧
    -- explicit nonzero witness `e₀`, chirality `+1`, whose image is a nonzero chirality `-1` vector
    ((Theta ![(1 : ℂ), 0, 0, 0] ≠ 0) ∧
     gamma5.mulVec ![(1 : ℂ), 0, 0, 0] = ![(1 : ℂ), 0, 0, 0] ∧
     Theta ![(1 : ℂ), 0, 0, 0] = ![(0 : ℂ), 0, 1, 0] ∧
     gamma5.mulVec (Theta ![(1 : ℂ), 0, 0, 0]) = - Theta ![(1 : ℂ), 0, 0, 0]) := by
  refine ⟨gamma5_Theta_odd, ?_, ?_, ?_, ?_⟩
  · have : Theta ![(1 : ℂ), 0, 0, 0] = ![(0 : ℂ), 0, 1, 0] := by crunch
    rw [this]
    intro h
    have := congrArg (fun f => f 2) h
    simp at this
  · crunch
  · crunch
  · crunch

/-! ## Target 3: conjugate-paired spectra -/

/-- **`spectrum_conjugate_paired`.** If `D(m) v = λ v` with `v ≠ 0`, then
`D(m) (Θ v) = (conj λ) (Θ v)` and `Θ v ≠ 0`.  So the antiparticle (CPT mirror `Θ v`) has the
complex-conjugate eigenvalue: particle/antiparticle energies are conjugate-paired. -/
theorem spectrum_conjugate_paired (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ) (hv : v ≠ 0)
    (h : (Dmat (m : ℂ)).mulVec v = lam • v) :
    (Dmat (m : ℂ)).mulVec (Theta v) = (starRingEnd ℂ lam) • Theta v ∧ Theta v ≠ 0 := by
  refine ⟨?_, Theta_ne_zero hv⟩
  rw [D_Theta_comm, h, Theta_smul]

/-- **Concrete conjugate mirror pair** (non-degeneracy witness).  With `m = 1`,
`v = (1, i, 1, i)` is an eigenvector with eigenvalue `1 + i`, and its CPT mirror
`Θ v = (1, -i, 1, -i)` is an eigenvector with the conjugate eigenvalue `1 - i`; both nonzero. -/
theorem concrete_conjugate_pair :
    (Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
        = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
    (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
    Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] ∧
    (Dmat 1).mulVec (Theta ![1, Complex.I, 1, Complex.I])
        = (starRingEnd ℂ (1 + Complex.I)) • Theta ![1, Complex.I, 1, Complex.I] ∧
    Theta ![1, Complex.I, 1, Complex.I] ≠ 0 := by
  have heig : (Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
      = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] := by
    funext i; fin_cases i <;>
      simp [Dmat, Matrix.mulVec, dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
        Matrix.cons_val_one, Matrix.cons_val, Complex.ext_iff]
  have hne : (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 := by
    intro h
    have := congrArg (fun f => f 0) h
    simp at this
  have hmir : Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] := by
    crunch
  -- eigenvalue on the mirror is the conjugate, via the general theorem with m = 1
  have hspec := (spectrum_conjugate_paired 1 (1 + Complex.I) ![1, Complex.I, 1, Complex.I] hne
    (by simpa using heig))
  refine ⟨heig, hne, hmir, ?_, hspec.2⟩
  simpa using hspec.1

/-! ## Target 4: the antiparticle verdict -/

/-- **`antiparticle_verdict`.**  Matter and antimatter are the two CPT-orientations of the
*same* null-edge (Weyl) pair:

1. `Theta` is an antiunitary involution (CPT);
2. `Theta` is chirality-odd, i.e. CPT swaps the two null Weyl pieces of the zigzag;
3. the mass coupling is CPT-even — the *same* `m` governs both orientations (`Θ D Θ = D`);
4. spectra are conjugate-paired: an eigenpair `(λ, v)` maps to `(conj λ, Θ v)` with `Θ v ≠ 0`;
5. concretely, `(1+i, (1,i,1,i))` mirrors to `(1-i, (1,-i,1,-i))`, both nonzero.

So particle/antiparticle is the *orientation* of the null-edge zigzag, and matter–antimatter
asymmetry is a state/initial-condition question, not a law asymmetry.  (Honest scope: a finite
one-carrier CPT statement, not a baryogenesis mechanism.) -/
theorem antiparticle_verdict :
    -- (1) CPT is an antiunitary involution
    (∀ v : Fin 4 → ℂ, Theta (Theta v) = v) ∧
    -- (2) CPT swaps the two null Weyl pieces (chirality-odd)
    (∀ v : Fin 4 → ℂ, gamma5.mulVec (Theta v) = - Theta (gamma5.mulVec v)) ∧
    -- (3) mass coupling is CPT-even: same `m`, `Θ D Θ = D`
    (∀ (m : ℝ) (v : Fin 4 → ℂ),
        Theta ((Dmat (m : ℂ)).mulVec (Theta v)) = (Dmat (m : ℂ)).mulVec v) ∧
    -- (4) spectra are conjugate-paired
    (∀ (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ), v ≠ 0 →
        (Dmat (m : ℂ)).mulVec v = lam • v →
        (Dmat (m : ℂ)).mulVec (Theta v) = (starRingEnd ℂ lam) • Theta v ∧ Theta v ≠ 0) ∧
    -- (5) concrete conjugate mirror pair, both nonzero
    ((Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
        = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
     Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] ∧
     (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
     Theta ![1, Complex.I, 1, Complex.I] ≠ 0) := by
  refine ⟨Theta_involutive, gamma5_Theta_odd, ?_, spectrum_conjugate_paired, ?_⟩
  · intro m v
    rw [D_Theta_comm, Theta_involutive]
  · obtain ⟨h1, h2, h3, _, h5⟩ := concrete_conjugate_pair
    exact ⟨h1, h3, h2, h5⟩

/-! ## Axiom audit — every headline uses exactly `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'CPTAntiparticleZigzag.theta_antiunitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms theta_antiunitary

/-- info: 'CPTAntiparticleZigzag.theta_swaps_weyl' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms theta_swaps_weyl

/-- info: 'CPTAntiparticleZigzag.spectrum_conjugate_paired' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spectrum_conjugate_paired

/-- info: 'CPTAntiparticleZigzag.concrete_conjugate_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms concrete_conjugate_pair

/-- info: 'CPTAntiparticleZigzag.antiparticle_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms antiparticle_verdict

end CPTAntiparticleZigzag
