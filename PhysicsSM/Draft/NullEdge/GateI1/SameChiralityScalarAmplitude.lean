import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus

/-!
# Q10 same-chirality scalar-amplitude: spectrum -> invariant-form obstruction

This module supplies the missing *connective* kernel lemma for the Q10-L6
same-chirality scalar mass-amplitude cut, plus a statement-first strategy note
for the next steps toward a genuine Spin/Weyl classification.

## 1. Audit -- what the existing Q10 declarations already imply

The finite Q10 stack already proves, kernel-checked and `s o r r y`-free:

* `MassAmplitudeCensus.eps2_SL2_invariant` -- the rank-two antisymmetric form
  `eps2` is `SL(2)`-invariant.  This is the positive `d = 4` corner: a
  same-chirality scalar amplitude (the epsilon wedge) exists and is invariant.
* `MassAmplitudeCensus.weyl_symmetric_d4`, `weyl_not_symmetric_d6`,
  `weyl_not_symmetric_d10` -- the finite weight-parity substitute: the doubled
  Cartan-weight multiset of the even-chirality Weyl avatar is negation-symmetric
  for `n = 2` (`d = 4`) and fails to be for `n = 3, 5` (`d = 6, 10`).
* `MassAmplitudeCensus.charpoly_negSymmetric_of_invariant_form` -- the bridge:
  an invertible infinitesimal self-duality intertwiner `B` for a generator `M`
  (`Mᵀ B + B M = 0`) forces `M.charpoly.comp (-X) = (-1)^m * M.charpoly`, i.e.
  the spectrum of `M` is symmetric under negation.
* `SplitSignatureMass.det_outerSum` and `SignatureSelection.*` -- the split
  `(2,2)` tachyon / frustrated-triple witnesses (mass-positivity and retardation
  failures away from Lorentzian signature).
* `LorentzianTransitivity.lorentzian_pos_pairing_trans` /
  `lorentzian_pos_pairing_rigidity` -- the Lorentzian positive-null-pairing
  transitivity and its collinearity rigidity clause.
* `SylvesterInertiaBridge.*` -- the basis-free upgrade of the frustrated triple
  to any real symmetric bilinear form of inertia containing a `(2,2)` block.

What was not yet connected: the census had the two endpoints -- a spectrum
obstruction (`weyl_not_symmetric_d6/d10`) and a bridge from an invariant form to
spectrum symmetry (`charpoly_negSymmetric_of_invariant_form`) -- but nothing
linking them into a single statement of the form "non-symmetric spectrum implies
no invariant self-dual form".  That contrapositive is exactly the
same-chirality scalar-amplitude obstruction, and it is what this file adds.

## 2. Proposed Lean-ready statements toward real Spin/Weyl classification

The following are the minimal bridge targets (statement-first; those marked
PROVED are discharged in this file, the rest are the honest open work).

* PROVED `diag_spec_negSymmetric_of_invariant_form` -- spectrum of a diagonal
  generator admitting an invariant self-dual form is negation-symmetric.
* PROVED `no_invariant_selfdual_form_of_spec_not_negSymmetric` -- the
  contrapositive obstruction.
* PROVED `census_no_invariant_selfdual_form` -- census-driven instance: whenever
  a diagonal generator realizes a Q10 weight multiset that is not
  negation-symmetric, it carries no invariant self-dual form.
* PROVED `weyl_no_invariant_selfdual_form_d6`, `..._d10` -- the explicit `d = 6`
  and `d = 10` same-chirality scalar-amplitude obstructions.
* OPEN `weyl_invariant_selfdual_form_d4` -- construct the `d = 4` invariant form
  (the epsilon intertwiner) realizing the positive corner as an existence
  statement matching the obstruction's shape.
* OPEN `spin_weyl_module` / `spin_weyl_selfdual_iff` -- replace the finite
  diagonal Cartan avatar with the actual minimal Weyl module of `Spin(1, d-1)`
  and prove `Hom_Spin(S ⊗ S, 1) ≠ 0 ↔ d = 4` (the true representation-theoretic
  statement; the diagonal spectrum here is the Cartan shadow of that Hom-space).

## 3. Claim boundary -- finite real algebra vs. physics

Strictly PROVED here is finite real/complex linear algebra: a diagonal complex
generator whose eigenvalue multiset is not closed under negation admits no
invertible bilinear intertwiner `B` with `Mᵀ B + B M = 0`.  Instantiated at the
Q10 census weight data this yields the `d = 6, 10` obstructions.

Not claimed here, and deliberately separated:

* Physical dimension selection.  The `n -> d` reading (`n = 2 <-> d = 4`,
  `n = 3 <-> d = 6`, `n = 5 <-> d = 10`) is the memo's interpretation; nothing
  below proves that spacetime dimension is `4`.
* Lorentzian continuum signatures.  The generators here are finite diagonal
  Cartan avatars, not the Clifford algebra of a continuum Lorentzian form; the
  signature story lives in `LorentzianTransitivity` / `SignatureSelection`.
* Standard Model representation content.  No `Spin(1,3)`/`Spin(10)` module,
  chirality grading, or SM matter assignment is constructed; the weight
  multiset is a finite stand-in for the Cartan weights of the true Weyl module.

Provenance: Aristotle project
`05fdd744-2daa-447f-b865-2e81e615069a`
(`ne-solo-lane-q10-spinweyl-scalar-amplitude-classification-strategy-20260707`),
extending `MassAmplitudeCensus.lean` from Q10-L6 and
`AgentTasks/fable_parallel/Q10_answer.md` items L6 and section 2.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude

open scoped BigOperators
open Matrix Polynomial
open PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus

/-! ## Spectrum of a diagonal generator via characteristic-polynomial roots -/

/-- The roots of the characteristic polynomial of a diagonal complex matrix are
its diagonal entries (with multiplicity). -/
theorem diagonal_charpoly_roots {m : ℕ} (d : Fin m → ℂ) :
    (diagonal d).charpoly.roots = Finset.univ.val.map d := by
  have h : (diagonal d).charpoly
      = ((Finset.univ.val.map d).map (fun a => X - C a)).prod := by
    rw [Matrix.charpoly_diagonal, Multiset.map_map]; rfl
  rw [h, Polynomial.roots_multiset_prod_X_sub_C]

/-- The roots of `charpoly.comp (-X)` for a diagonal matrix are the negated
diagonal entries (with multiplicity). -/
theorem diagonal_charpoly_comp_neg_roots {m : ℕ} (d : Fin m → ℂ) :
    ((diagonal d).charpoly.comp (-X)).roots
      = (Finset.univ.val.map d).map (fun x => -x) := by
  have hchar : (diagonal d).charpoly
      = ((Finset.univ.val.map d).map (fun a => X - C a)).prod := by
    rw [Matrix.charpoly_diagonal, Multiset.map_map]; rfl
  have hcard : Multiset.card (Finset.univ.val.map d) = m := by simp
  rw [hchar, Polynomial.multiset_prod_comp, Multiset.map_map]
  have hfun : ((fun p => p.comp (-X)) ∘ fun a : ℂ => X - C a)
      = (fun a : ℂ => (-1 : ℂ[X]) * (X - C (-a))) := by
    funext a; simp [Function.comp, sub_comp]; ring
  rw [hfun, Multiset.prod_map_mul]
  have h1 : ((Finset.univ.val.map d).map (fun _ : ℂ => (-1 : ℂ[X]))).prod
      = (-1 : ℂ[X]) ^ m := by
    rw [Multiset.map_const', Multiset.prod_replicate, hcard]
  have h2 : ((Finset.univ.val.map d).map (fun a : ℂ => X - C (-a)))
      = (((Finset.univ.val.map d).map (fun x => -x)).map (fun a => X - C a)) := by
    simp only [Multiset.map_map, Function.comp]
  rw [h1, h2]
  have hne : ((-1 : ℂ) ^ m) ≠ 0 := pow_ne_zero _ (by norm_num)
  have hC : ((-1 : ℂ[X]) ^ m) = C ((-1 : ℂ) ^ m) := by rw [map_pow, map_neg, map_one]
  rw [hC, ← smul_eq_C_mul, Polynomial.roots_smul_nonzero _ hne,
    Polynomial.roots_multiset_prod_X_sub_C]

/-! ## The connective obstruction -/

/--
Spectrum negation-symmetry from an invariant self-dual form.  If a diagonal
complex generator `diagonal d` admits an invertible infinitesimal self-duality
intertwiner `B` (`(diagonal d)ᵀ * B + B * (diagonal d) = 0`), then its spectrum
(the diagonal-entry multiset) is symmetric under negation.

This is the diagonal specialization of the census bridge
`charpoly_negSymmetric_of_invariant_form`, made into a statement about the
eigenvalue multiset by taking characteristic-polynomial roots.
-/
theorem diag_spec_negSymmetric_of_invariant_form {m : ℕ} (d : Fin m → ℂ)
    (B : Matrix (Fin m) (Fin m) ℂ) (hB : IsUnit B.det)
    (hinv : (diagonal d).transpose * B + B * diagonal d = 0) :
    (Finset.univ.val.map d).map (fun x => -x) = Finset.univ.val.map d := by
  have hbridge := charpoly_negSymmetric_of_invariant_form m (diagonal d) B hB hinv
  have hne : ((-1 : ℂ) ^ m) ≠ 0 := pow_ne_zero _ (by norm_num)
  have hC : ((-1 : ℂ[X]) ^ m) = C ((-1 : ℂ) ^ m) := by rw [map_pow, map_neg, map_one]
  have hroots : ((diagonal d).charpoly.comp (-X)).roots
      = ((-1 : ℂ[X]) ^ m * (diagonal d).charpoly).roots := by rw [hbridge]
  rw [diagonal_charpoly_comp_neg_roots, hC, ← smul_eq_C_mul,
    Polynomial.roots_smul_nonzero _ hne, diagonal_charpoly_roots] at hroots
  exact hroots

/--
The obstruction, as a contrapositive.  A diagonal complex generator whose
spectrum multiset is not symmetric under negation admits no invertible
infinitesimal self-duality intertwiner -- equivalently, no invariant
same-chirality scalar amplitude of that self-dual shape.
-/
theorem no_invariant_selfdual_form_of_spec_not_negSymmetric {m : ℕ} (d : Fin m → ℂ)
    (hspec : ¬ ((Finset.univ.val.map d).map (fun x => -x) = Finset.univ.val.map d)) :
    ¬ ∃ B : Matrix (Fin m) (Fin m) ℂ, IsUnit B.det ∧
        (diagonal d).transpose * B + B * diagonal d = 0 := by
  rintro ⟨B, hB, hinv⟩
  exact hspec (diag_spec_negSymmetric_of_invariant_form d B hB hinv)

/-! ## Census-driven instances -/

/-- Casting an integer multiset by `ℤ → ℂ` preserves failure of negation
symmetry: if the cast multiset were negation-symmetric, so would the original be. -/
theorem negSymmetric_of_cast_negSymmetric (M : Multiset ℤ)
    (h : (M.map (Int.cast : ℤ → ℂ)).map (fun x => -x) = M.map (Int.cast : ℤ → ℂ)) :
    negSymmetric M := by
  have hcomp : (M.map (fun x => -x)).map (Int.cast : ℤ → ℂ) =
      M.map (Int.cast : ℤ → ℂ) := by
    rw [Multiset.map_map]
    rw [show ((Int.cast : ℤ → ℂ) ∘ fun x => -x) =
        (fun x => -x) ∘ (Int.cast : ℤ → ℂ) by
      funext x; simp]
    rw [← Multiset.map_map]
    exact h
  exact Multiset.map_injective (fun a b hab => by exact_mod_cast hab) hcomp

/--
Census-driven obstruction.  Let `v : Fin m → ℤ` realize a Q10 even-chirality
weight multiset `weylWeights n` that is not negation-symmetric.  Then the
complex diagonal Cartan generator `diagonal (fun i => (v i : ℂ))` carries no
invariant self-dual form.  This is the finite same-chirality scalar-amplitude
obstruction attached directly to the census weight data.
-/
theorem census_no_invariant_selfdual_form {m n : ℕ} (v : Fin m → ℤ)
    (hv : Finset.univ.val.map v = weylWeights n)
    (hn : ¬ negSymmetric (weylWeights n)) :
    ¬ ∃ B : Matrix (Fin m) (Fin m) ℂ, IsUnit B.det ∧
        (diagonal (fun i => (v i : ℂ))).transpose * B
          + B * diagonal (fun i => (v i : ℂ)) = 0 := by
  apply no_invariant_selfdual_form_of_spec_not_negSymmetric
  intro hspec
  apply hn
  have hcast : Finset.univ.val.map (fun i => (v i : ℂ))
      = (Finset.univ.val.map v).map (Int.cast : ℤ → ℂ) := by
    rw [Multiset.map_map]; rfl
  rw [hcast, hv] at hspec
  exact negSymmetric_of_cast_negSymmetric (weylWeights n) hspec

/-- The explicit `d = 6` (`n = 3`) diagonal Cartan generator, doubled weights
`(-3, 1, 1, 1)`. -/
def weylCartanVec6 : Fin 4 → ℤ := ![-3, 1, 1, 1]

/-- The explicit `d = 10` (`n = 5`) diagonal Cartan generator, doubled weights
`(-5, -1 x 10, 3 x 5)`. -/
def weylCartanVec10 : Fin 16 → ℤ :=
  ![-5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 3, 3, 3, 3, 3]

/-- The `d = 6` Cartan vector realizes the census weight multiset `weylWeights 3`. -/
theorem weylCartanVec6_spec : Finset.univ.val.map weylCartanVec6 = weylWeights 3 := by
  decide

/-- The `d = 10` Cartan vector realizes the census weight multiset `weylWeights 5`. -/
theorem weylCartanVec10_spec : Finset.univ.val.map weylCartanVec10 = weylWeights 5 := by
  decide

/--
`d = 6` same-chirality scalar-amplitude obstruction.  The complex diagonal
Cartan generator of the `d = 6` even-chirality Weyl avatar carries no invariant
self-dual form -- the finite substitute for "no same-chirality scalar mass
amplitude in `d = 6`".
-/
theorem weyl_no_invariant_selfdual_form_d6 :
    ¬ ∃ B : Matrix (Fin 4) (Fin 4) ℂ, IsUnit B.det ∧
        (diagonal (fun i => (weylCartanVec6 i : ℂ))).transpose * B
          + B * diagonal (fun i => (weylCartanVec6 i : ℂ)) = 0 :=
  census_no_invariant_selfdual_form weylCartanVec6 weylCartanVec6_spec
    weyl_not_symmetric_d6

/--
`d = 10` same-chirality scalar-amplitude obstruction.  The complex diagonal
Cartan generator of the `d = 10` even-chirality Weyl avatar carries no invariant
self-dual form -- the finite substitute for "no same-chirality scalar mass
amplitude in `d = 10`".
-/
theorem weyl_no_invariant_selfdual_form_d10 :
    ¬ ∃ B : Matrix (Fin 16) (Fin 16) ℂ, IsUnit B.det ∧
        (diagonal (fun i => (weylCartanVec10 i : ℂ))).transpose * B
          + B * diagonal (fun i => (weylCartanVec10 i : ℂ)) = 0 :=
  census_no_invariant_selfdual_form weylCartanVec10 weylCartanVec10_spec
    weyl_not_symmetric_d10

/-! ## Footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude.diag_spec_negSymmetric_of_invariant_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diag_spec_negSymmetric_of_invariant_form

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude.no_invariant_selfdual_form_of_spec_not_negSymmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_invariant_selfdual_form_of_spec_not_negSymmetric

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude.weyl_no_invariant_selfdual_form_d6' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_no_invariant_selfdual_form_d6

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude.weyl_no_invariant_selfdual_form_d10' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_no_invariant_selfdual_form_d10

end PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude
