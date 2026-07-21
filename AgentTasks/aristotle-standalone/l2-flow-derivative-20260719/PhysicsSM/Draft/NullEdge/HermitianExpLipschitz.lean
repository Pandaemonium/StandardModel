import Mathlib

/-!
# Sharp Lipschitz control for finite Hermitian evolution

For Hermitian four-by-four matrices `H` and `K`, this module proves the sharp
Duhamel estimate

`||exp(-i t H) - exp(-i t K)|| <= |t| * ||H - K||`.

The absence of exponential growth in the generator norms is load-bearing for
the changing-momentum-cell program, whose active momentum window grows during
refinement.

Provenance: target authored in-project for `CONT-MULT-001`. Proof completed by
Aristotle project `d36236e4-143f-476f-96e4-5df2a27cb908`, returned with the
target unchanged, and independently replayed under the pinned toolchain on
2026-07-12.
-/

noncomputable section

open Matrix Complex Real NormedSpace
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HermitianExpLipschitz

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Hermitian matrix evolution is one-Lipschitz in its generator, with elapsed
time as the exact scale factor. -/
theorem hermitian_exp_lipschitz (H K : Mat4)
    (hH : H.IsHermitian) (hK : K.IsHermitian) (t : Real) :
    ‖NormedSpace.exp ((-(t : Complex)) • (Complex.I • H)) -
        NormedSpace.exp ((-(t : Complex)) • (Complex.I • K))‖ <=
      |t| * ‖H - K‖ := by
  classical
  let +nondep : NormedAlgebra Rat Mat4 := .restrictScalars Rat Complex Mat4
  set A : Mat4 := (-(t : Complex)) • (Complex.I • H) with hA
  set B : Mat4 := (-(t : Complex)) • (Complex.I • K) with hB
  set C : Real := |t| * ‖H - K‖ with hC
  set g : Real -> Mat4 := fun s =>
    NormedSpace.exp (s • A) * NormedSpace.exp ((1 - s) • B) with hg
  have hnormExp : forall (M : Mat4), M.IsHermitian -> forall (r : Real),
      ‖NormedSpace.exp (r • ((-(t : Complex)) • (Complex.I • M)))‖ = 1 := by
    intro M hM r
    have hsa : IsSelfAdjoint M := isHermitian_iff_isSelfAdjoint.mp hM
    have key : r • ((-(t : Complex)) • (Complex.I • M)) =
        ((((-(r * t) : Real)) : Complex) * Complex.I) • M := by
      rw [← Complex.coe_smul, smul_smul, smul_smul]
      congr 1
      push_cast
      ring
    rw [key]
    apply CStarRing.norm_of_mem_unitary
    apply exp_mem_unitary_of_mem_skewAdjoint
    apply IsSelfAdjoint.smul_mem_skewAdjoint _ hsa
    rw [skewAdjoint.mem_iff]
    simp [Complex.conj_I, mul_comm]
  have hderiv : forall s : Real, HasDerivAt g
      (NormedSpace.exp (s • A) * (A - B) *
        NormedSpace.exp ((1 - s) • B)) s := by
    intro s
    have h1 : HasDerivAt (fun u : Real => NormedSpace.exp (u • A))
        (NormedSpace.exp (s • A) * A) s := hasDerivAt_exp_smul_const A s
    have hin : HasDerivAt (fun u : Real => (1 : Real) - u) (-1) s := by
      simpa using (hasDerivAt_id s).const_sub 1
    have hout : HasDerivAt (fun u : Real => NormedSpace.exp (u • B))
        (NormedSpace.exp ((1 - s) • B) * B) (1 - s) :=
      hasDerivAt_exp_smul_const B (1 - s)
    have h2 : HasDerivAt (fun u : Real => NormedSpace.exp ((1 - u) • B))
        ((-1 : Real) • (NormedSpace.exp ((1 - s) • B) * B)) s :=
      hout.scomp s hin
    have hcomm : NormedSpace.exp ((1 - s) • B) * B =
        B * NormedSpace.exp ((1 - s) • B) :=
      (((Commute.refl B).smul_left (1 - s)).exp_left).eq
    have hmul := h1.mul h2
    convert hmul using 1
    rw [neg_one_smul, mul_neg, mul_sub, sub_mul, hcomm, sub_eq_add_neg]
    noncomm_ring
  have hnd : forall s : Real,
      ‖NormedSpace.exp (s • A) * (A - B) *
        NormedSpace.exp ((1 - s) • B)‖ <= C := by
    intro s
    have e1 : ‖NormedSpace.exp (s • A)‖ = 1 := hnormExp H hH s
    have e2 : ‖NormedSpace.exp ((1 - s) • B)‖ = 1 :=
      hnormExp K hK (1 - s)
    have eAB : A - B = (-(t : Complex)) • (Complex.I • (H - K)) := by
      rw [hA, hB, smul_sub, smul_sub]
    have enAB : ‖A - B‖ = |t| * ‖H - K‖ := by
      rw [eAB, norm_smul, norm_smul]
      simp [Complex.norm_I, Complex.norm_real]
    calc
      ‖NormedSpace.exp (s • A) * (A - B) *
          NormedSpace.exp ((1 - s) • B)‖ <=
          ‖NormedSpace.exp (s • A) * (A - B)‖ *
            ‖NormedSpace.exp ((1 - s) • B)‖ := l2_opNorm_mul _ _
      _ <= (‖NormedSpace.exp (s • A)‖ * ‖A - B‖) *
          ‖NormedSpace.exp ((1 - s) • B)‖ := by
        gcongr
        exact l2_opNorm_mul _ _
      _ = C := by rw [e1, e2, enAB, hC]; ring
  have hmv := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    (f := g)
    (f' := fun s => NormedSpace.exp (s • A) * (A - B) *
      NormedSpace.exp ((1 - s) • B))
    (s := Set.univ) (C := C)
    (fun x _ => (hderiv x).hasDerivWithinAt) (fun x _ => hnd x) convex_univ
    (Set.mem_univ 0) (Set.mem_univ 1)
  have hg1 : g 1 = NormedSpace.exp A := by simp [hg]
  have hg0 : g 0 = NormedSpace.exp B := by simp [hg]
  rw [hg1, hg0] at hmv
  simpa [hA, hB, hC] using hmv

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianExpLipschitz.hermitian_exp_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hermitian_exp_lipschitz

end PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
