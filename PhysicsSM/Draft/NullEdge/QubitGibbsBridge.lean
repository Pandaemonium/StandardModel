import PhysicsSM.Draft.NullEdge.ThermalBzEuler
import PhysicsSM.Draft.NullEdge.PairModularSelection
import PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy

/-!
# Bridge 2: the zero-transverse qubit maximizer is the canonical Gibbs state

Draft module (DYN-MODULAR-001 operator-level S2, "Bridge 2"). Composes the landed
thermal Euler / Gibbs closed form (`ThermalBzEuler.gibbs_bz_closed_form`) with the
canonical objects to identify the fixed-energy entropy maximizer of the
non-commuting qubit Bloch geometry
(`QubitFixedEnergyMaxEntropy.pairBloch e 0 0`) with the normalized Gibbs state of
the LIVE pair generator `Bz 1` (`= sigmaX`) at an EXPLICIT inverse temperature
`beta = -Real.artanh e`.

`ModularSelection.gibbsState B beta = (trace exp(-beta . B))⁻¹ . exp(-beta . B)`.
Specializing `ThermalBzEuler.gibbs_bz_closed_form` at `z = 1` gives
`gibbsState (Bz 1) beta = (1/2).1 - (tanh beta / 2).Bz 1`, and at
`beta = -artanh e` (`|e| < 1`, `Real.tanh_artanh` so `tanh(-artanh e) = -e`) this
is `(1/2).1 + (e/2).Bz 1 = pairBloch e 0 0`. This closes operator-level S2: the
selected maximizer IS the canonical Gibbs state of the supplied generator, with
`e` and `beta` displayed supplied inputs (not fitted).

## Trust status

Draft-trust by kernel: `pairBloch_zero_eq_gibbsState` is `sorry`-free and depends
only on `[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end. The
statement is over the CANONICAL symbols (`QubitFixedEnergyMaxEntropy.pairBloch`,
`ModularSelection.gibbsState`, `PairModularSelection.Bz`) - there is no
local-vs-canonical gap, since `gibbsState (Bz 1) beta` is definitionally the
normalized Gibbs weight and the `Bz`/`pairBloch` identifications hold by `rfl` /
`ext`.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR-001 Bridge 2
composition). Reuses in-repo `ThermalBzEuler.gibbs_bz_closed_form`,
`PairModularSelection.Bz`, `QubitFixedEnergyMaxEntropy.pairBloch`,
`ModularSelection.gibbsState`. Analytic core proved by Aristotle (focused
project `fd8c1dc1-78d4-42ba-bdb1-8564ac17fe7a`, `Real.tanh_artanh` +
`gibbs_bz_closed_form` at `z = 1`), ported here to the canonical objects and
independently re-checked (`lake env lean`; axiom footprint kernel-only).
Clean-room composition.
-/

noncomputable section

open PhysicsSM.Draft.NullEdge

namespace PhysicsSM.Draft.NullEdge.QubitGibbsBridge

/-- **Bridge 2.** The zero-transverse fixed-energy entropy maximizer
`pairBloch e 0 0` equals the normalized Gibbs state of the canonical live pair
generator `Bz 1` at inverse temperature `-Real.artanh e`. -/
theorem pairBloch_zero_eq_gibbsState (e : Real) (he : |e| < 1) :
    QubitFixedEnergyMaxEntropy.pairBloch e 0 0
      = ModularSelection.gibbsState (PairModularSelection.Bz 1) (-Real.artanh e) := by
  -- `ModularSelection.gibbsState (Bz 1) β` is definitionally the normalized Gibbs
  -- weight `(trace exp(-(β).Bz 1))⁻¹ • exp(-(β).Bz 1)`; `PairModularSelection.Bz 1`
  -- is `ThermalBzEuler.Bz 1` by `rfl`. Proof ported from Aristotle `fd8c1dc1`.
  have hmem : e ∈ Set.Ioo (-1 : ℝ) 1 := by rw [Set.mem_Ioo, ← abs_lt]; exact he
  have htanh : Complex.tanh (-(Real.artanh e : ℂ)) = -(e : ℂ) := by
    rw [← Complex.ofReal_neg, ← Complex.ofReal_tanh, Real.tanh_neg,
      Real.tanh_artanh hmem, Complex.ofReal_neg]
  have key := ThermalBzEuler.gibbs_bz_closed_form 1 (-Real.artanh e) one_ne_zero
  simp only [Complex.ofReal_neg, norm_one, Complex.ofReal_one, mul_one] at key
  show QubitFixedEnergyMaxEntropy.pairBloch e 0 0
      = ((NormedSpace.exp ((-((-Real.artanh e : ℝ) : ℂ)) • ThermalBzEuler.Bz 1)).trace)⁻¹ •
          NormedSpace.exp ((-((-Real.artanh e : ℝ) : ℂ)) • ThermalBzEuler.Bz 1)
  simp only [Complex.ofReal_neg] at *
  rw [key, htanh]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [QubitFixedEnergyMaxEntropy.pairBloch, ThermalBzEuler.Bz] <;> ring

end PhysicsSM.Draft.NullEdge.QubitGibbsBridge

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.QubitGibbsBridge.pairBloch_zero_eq_gibbsState' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QubitGibbsBridge.pairBloch_zero_eq_gibbsState
