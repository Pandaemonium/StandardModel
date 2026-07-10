import PhysicsSM.Draft.NullEdge.FiniteZModPlancherel

/-!
# Iterated vector-valued Plancherel on a finite three-torus

This module lifts the inverse-DFT energy identity on `ZMod N` to the finite
three-torus `ZMod N x ZMod N x ZMod N`.  The transform is defined in three
explicit stages, one coordinate at a time.  Repeated application of the
landed one-dimensional theorem gives the exact reciprocal energy scaling
`1 / N^3` without re-expanding characters or reproving orthogonality.

The final theorems transfer modewise vector and operator errors to exact
finite position-space wave-packet bounds with coefficient `eps^2 / N^3`.
These are finite normalized identities; no continuum or infinite-volume
limit is asserted.

Provenance: clean-room iteration of
`FiniteZModPlancherel.invDFT_energy`, whose transform convention is
Mathlib's `ZMod.dft`.  The staging and normalization are fixed explicitly
below and checked under the project's pinned Lean 4 toolchain.
-/

noncomputable section

open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel

variable {N : Nat} [NeZero N]
variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace Complex E]

/-- The finite three-dimensional momentum or position torus. -/
abbrev Torus3 (N : Nat) :=
  Prod (ZMod N) (Prod (ZMod N) (ZMod N))

/-- Total squared norm, written as staged sums in the `x`, `y`, `z` order. -/
def energy3 (f : Torus3 N -> E) : Real :=
  ∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N, ‖f (x, y, z)‖ ^ 2

/-- Apply the inverse DFT in the third coordinate while holding the first two
coordinates fixed. -/
def invDFTAlongZ (f : Torus3 N -> E) : Torus3 N -> E :=
  fun q =>
    (ZMod.dft.symm (fun kz : ZMod N => f (q.1, q.2.1, kz))) q.2.2

/-- Apply the inverse DFT in the second coordinate while holding the first and
third coordinates fixed. -/
def invDFTAlongY (f : Torus3 N -> E) : Torus3 N -> E :=
  fun q =>
    (ZMod.dft.symm (fun ky : ZMod N => f (q.1, ky, q.2.2))) q.2.1

/-- Apply the inverse DFT in the first coordinate while holding the final two
coordinates fixed. -/
def invDFTAlongX (f : Torus3 N -> E) : Torus3 N -> E :=
  fun q =>
    (ZMod.dft.symm (fun kx : ZMod N => f (kx, q.2.1, q.2.2))) q.1

/-- The iterated inverse DFT, staged in the order `z`, then `y`, then `x`. -/
def invDFT3 (f : Torus3 N -> E) : Torus3 N -> E :=
  invDFTAlongX (invDFTAlongY (invDFTAlongZ f))

/-- Inverting the third Fourier coordinate contributes one factor `1 / N` to
the total energy. -/
theorem invDFTAlongZ_energy (f : Torus3 N -> E) :
    energy3 (invDFTAlongZ f) =
      (1 / (N : Real)) * energy3 f := by
  unfold energy3 invDFTAlongZ
  simp_rw [FiniteZModPlancherel.invDFT_energy]
  simp [Finset.mul_sum]

/-- Inverting the second Fourier coordinate contributes one factor `1 / N`
to the total energy. -/
theorem invDFTAlongY_energy (f : Torus3 N -> E) :
    energy3 (invDFTAlongY f) =
      (1 / (N : Real)) * energy3 f := by
  unfold energy3 invDFTAlongY
  calc
    (∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N,
        ‖(ZMod.dft.symm (fun ky : ZMod N => f (x, ky, z))) y‖ ^ 2) =
        ∑ x : ZMod N, ∑ z : ZMod N, ∑ y : ZMod N,
          ‖(ZMod.dft.symm (fun ky : ZMod N => f (x, ky, z))) y‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [Finset.sum_comm]
    _ = ∑ x : ZMod N, ∑ z : ZMod N,
        (1 / (N : Real)) * ∑ y : ZMod N, ‖f (x, y, z)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro x hx
      apply Finset.sum_congr rfl
      intro z hz
      exact FiniteZModPlancherel.invDFT_energy
        (fun y : ZMod N => f (x, y, z))
    _ = (1 / (N : Real)) *
        ∑ x : ZMod N, ∑ z : ZMod N, ∑ y : ZMod N,
          ‖f (x, y, z)‖ ^ 2 := by
      simp [Finset.mul_sum]
    _ = (1 / (N : Real)) *
        ∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N,
          ‖f (x, y, z)‖ ^ 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro x hx
      rw [Finset.sum_comm]

/-- Inverting the first Fourier coordinate contributes one factor `1 / N` to
the total energy. -/
theorem invDFTAlongX_energy (f : Torus3 N -> E) :
    energy3 (invDFTAlongX f) =
      (1 / (N : Real)) * energy3 f := by
  unfold energy3 invDFTAlongX
  calc
    (∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N,
        ‖(ZMod.dft.symm (fun kx : ZMod N => f (kx, y, z))) x‖ ^ 2) =
        ∑ y : ZMod N, ∑ z : ZMod N, ∑ x : ZMod N,
          ‖(ZMod.dft.symm (fun kx : ZMod N => f (kx, y, z))) x‖ ^ 2 := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro y hy
      rw [Finset.sum_comm]
    _ = ∑ y : ZMod N, ∑ z : ZMod N,
        (1 / (N : Real)) * ∑ x : ZMod N, ‖f (x, y, z)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro y hy
      apply Finset.sum_congr rfl
      intro z hz
      exact FiniteZModPlancherel.invDFT_energy
        (fun x : ZMod N => f (x, y, z))
    _ = (1 / (N : Real)) *
        ∑ y : ZMod N, ∑ z : ZMod N, ∑ x : ZMod N,
          ‖f (x, y, z)‖ ^ 2 := by
      simp [Finset.mul_sum]
    _ = (1 / (N : Real)) *
        ∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N,
          ‖f (x, y, z)‖ ^ 2 := by
      congr 1
      calc
        (∑ y : ZMod N, ∑ z : ZMod N, ∑ x : ZMod N,
            ‖f (x, y, z)‖ ^ 2) =
            ∑ y : ZMod N, ∑ x : ZMod N, ∑ z : ZMod N,
              ‖f (x, y, z)‖ ^ 2 := by
          apply Finset.sum_congr rfl
          intro y hy
          rw [Finset.sum_comm]
        _ = ∑ x : ZMod N, ∑ y : ZMod N, ∑ z : ZMod N,
              ‖f (x, y, z)‖ ^ 2 := by
          rw [Finset.sum_comm]

/-- Exact three-axis inverse-DFT Plancherel scaling. -/
theorem invDFT3_energy (f : Torus3 N -> E) :
    energy3 (invDFT3 f) =
      (1 / (N : Real) ^ 3) * energy3 f := by
  unfold invDFT3
  rw [invDFTAlongX_energy, invDFTAlongY_energy, invDFTAlongZ_energy]
  simp only [one_div]
  calc
    (N : Real)⁻¹ * ((N : Real)⁻¹ * ((N : Real)⁻¹ * energy3 f)) =
        ((N : Real)⁻¹) ^ 3 * energy3 f := by ring
    _ = ((N : Real) ^ 3)⁻¹ * energy3 f := by rw [inv_pow]

/-- A modewise relative vector error gives an exact normalized three-torus
position-space wave-packet bound. -/
theorem inverseDFT3_wavepacket_error
    (approx exact coeff : Torus3 N -> E) (eps : Real)
    (herr : forall k, ‖approx k - exact k‖ <= eps * ‖coeff k‖) :
    energy3 (invDFT3 (fun k => approx k - exact k)) <=
      (eps ^ 2 / (N : Real) ^ 3) * energy3 coeff := by
  have hmode :
      energy3 (fun k => approx k - exact k) <= eps ^ 2 * energy3 coeff := by
    unfold energy3
    simp only [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro x hx
    apply Finset.sum_le_sum
    intro y hy
    apply Finset.sum_le_sum
    intro z hz
    convert pow_le_pow_left₀ (norm_nonneg (approx (x, y, z) - exact (x, y, z)))
      (herr (x, y, z)) 2 using 1
    all_goals ring
  calc
    energy3 (invDFT3 (fun k => approx k - exact k)) =
        (1 / (N : Real) ^ 3) *
          energy3 (fun k => approx k - exact k) := invDFT3_energy _
    _ <= (1 / (N : Real) ^ 3) * (eps ^ 2 * energy3 coeff) :=
      mul_le_mul_of_nonneg_left hmode (by positivity)
    _ = (eps ^ 2 / (N : Real) ^ 3) * energy3 coeff := by ring

/-- A uniform modewise operator-norm error acts on every finite three-torus
wave packet with the exact normalized coefficient `eps^2 / N^3`. -/
theorem inverseDFT3_operator_wavepacket_error
    (approx exact : Torus3 N -> (E →L[Complex] E))
    (coeff : Torus3 N -> E) (eps : Real)
    (herr : forall k, ‖approx k - exact k‖ <= eps) :
    energy3 (invDFT3
      (fun k => approx k (coeff k) - exact k (coeff k))) <=
      (eps ^ 2 / (N : Real) ^ 3) * energy3 coeff := by
  apply inverseDFT3_wavepacket_error
    (fun k => approx k (coeff k))
    (fun k => exact k (coeff k)) coeff eps
  intro k
  calc
    ‖approx k (coeff k) - exact k (coeff k)‖ =
        ‖(approx k - exact k) (coeff k)‖ := by
      rw [ContinuousLinearMap.sub_apply]
    _ <= ‖approx k - exact k‖ * ‖coeff k‖ :=
      (approx k - exact k).le_opNorm (coeff k)
    _ <= eps * ‖coeff k‖ :=
      mul_le_mul_of_nonneg_right (herr k) (norm_nonneg _)

end PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel.invDFT3_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel.invDFT3_energy

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel.inverseDFT3_operator_wavepacket_error' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTorus3Plancherel.inverseDFT3_operator_wavepacket_error
