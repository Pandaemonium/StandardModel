import Mathlib
import PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy
import PhysicsSM.Draft.NullEdge.VNEntropyPurity

/-!
# Bridge 1: qubit radial entropy equals von Neumann entropy

Draft module (DYN-MODULAR-001 operator-level S2, "Bridge 1"). Identifies the
qubit Bloch-ball `radialEntropy` (binary entropy of the larger eigenvalue) with
the spectral von Neumann entropy `sum_i negMulLog(lambda_i)` of the same density
matrix. This connects the qubit fixed-energy max-entropy geometry to the
canonical entropy functional.

## Scope (anti-overclaim; local vs canonical)

The definitions here are LOCAL restatements, byte-identical to the in-repo
canonical ones (`QubitFixedEnergyMaxEntropy.pairBloch`/`radialEntropy`/
`blochRadius`, `VNEntropyPurity.vonNeumannEntropy`). Because the matrix literal
and the entropy sum are definitionally identical, the result transports to the
canonical symbols by `rfl`; that trivial canonical corollary is a noted pending
wiring step, NOT yet stated here. Per the cross-family lesson on local-vs-
canonical (Codex red-team, full-Fock), this module is scoped as the bridge over
its own definitions; do not read it as already stated over the canonical
`QubitFixedEnergyMaxEntropy`/`VNEntropyPurity` declarations until that corollary
lands. It is Bridge 1 of the qubit operator-level S2 (Bridge 2 core =
`ThermalBzEuler`).

Proof route (from Codex spectral-API pointers, verified for v4.28): the `2x2`
Hermitian `rho = pairBloch e u v` has `trace = 1` and
`det = (1 - (e^2+u^2+v^2))/4 = (1 - r^2)/4` with `r = blochRadius e u v`. Hence
its two eigenvalues are the roots of `x^2 - x + (1-r^2)/4`, i.e. the UNORDERED
pair `{(1+r)/2, (1-r)/2}`. Do NOT assume a `Fin 2` pointwise ordering of
`IsHermitian.eigenvalues` (they are reindexed by `Fintype.equivOfCardEq`); use
`trace_eq_sum_eigenvalues` (sum = 1) and `det_eq_prod_eigenvalues`
(prod = (1-r^2)/4) to pin the two-element multiset, then finish with the
symmetry of the two-term `negMulLog` sum (equivalently
`Real.binEntropy p = Real.binEntropy (1 - p)`). Useful:
`Matrix.charpoly_fin_two`, `Matrix.IsHermitian.charpoly_eq`,
`Matrix.det_fin_two`, `Matrix.trace_fin_two`, `Real.binEntropy`,
`Real.negMulLog`.

## Trust status

Draft-trust by kernel: `pairEntropy_eq_vonNeumannEntropy` is `sorry`-free and
depends only on `[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR-001 Bridge 1).
Proof search by Aristotle (project
`ef25af64-9e66-4ef9-9858-68c8032d8da8`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Route (Codex
spectral pointers): `trace = 1` and `det = (1 - r^2)/4` pin the two eigenvalues
(sum 1, product `(1-r^2)/4`) as the UNORDERED pair `{(1+r)/2, (1-r)/2}`; the
final entropy equality uses `Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub`
and symmetry of the two-term `negMulLog` sum, handling BOTH eigenvalue orderings
(no `Fin 2` ordering assumption). Clean-room formalization from the mathematical
statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.QubitEntropyBridge

open Matrix
open scoped ComplexOrder

/-- A trace-one Hermitian qubit matrix in Bloch coordinates (`e` longitudinal to
`sigmaX`; `u`, `v` transverse). Mirrors `QubitFixedEnergyMaxEntropy.pairBloch`. -/
def pairBloch (e u v : Real) : Matrix (Fin 2) (Fin 2) Complex :=
  (2 : Complex)⁻¹ •
    !![((1 + v : Real) : Complex), (e : Complex) - Complex.I * (u : Complex);
       (e : Complex) + Complex.I * (u : Complex), ((1 - v : Real) : Complex)]

/-- Euclidean Bloch radius. -/
def blochRadius (e u v : Real) : Real := Real.sqrt (e ^ 2 + u ^ 2 + v ^ 2)

/-- Qubit entropy as binary entropy of the larger eigenvalue. -/
def radialEntropy (r : Real) : Real := Real.binEntropy ((1 + r) / 2)

/-- Von Neumann entropy `sum_i negMulLog(lambda_i)` (mirrors
`VNEntropyPurity.vonNeumannEntropy`). -/
def vonNeumannEntropy (ρ : Matrix (Fin 2) (Fin 2) Complex) (hρ : ρ.IsHermitian) : Real :=
  ∑ i, Real.negMulLog (hρ.eigenvalues i)

/-
The Bloch matrix is Hermitian.
-/
theorem pairBloch_isHermitian (e u v : Real) : (pairBloch e u v).IsHermitian := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ pairBloch ] ; ring!;

/-
**TARGET (the hole): Bridge 1.** The von Neumann entropy of the Bloch qubit
equals its radial (binary) entropy.
-/
theorem pairEntropy_eq_vonNeumannEntropy (e u v : Real) :
    vonNeumannEntropy (pairBloch e u v) (pairBloch_isHermitian e u v)
      = radialEntropy (blochRadius e u v) := by
  -- By definition of $vonNeumannEntropy$, we know that
  have h_vonNeumannEntropy : vonNeumannEntropy (pairBloch e u v) (pairBloch_isHermitian e u v) = ∑ i, Real.negMulLog (Matrix.IsHermitian.eigenvalues (pairBloch_isHermitian e u v) i) := by
    rfl
  rw [h_vonNeumannEntropy];
  -- From the properties of the Bloch matrix, we know that its eigenvalues are $\frac{1 \pm r}{2}$.
  have h_eigenvalues : ∃ (lam0 lam1 : ℝ), Matrix.IsHermitian.eigenvalues (pairBloch_isHermitian e u v) 0 = lam0 ∧ Matrix.IsHermitian.eigenvalues (pairBloch_isHermitian e u v) 1 = lam1 ∧ lam0 + lam1 = 1 ∧ lam0 * lam1 = (1 - (blochRadius e u v)^2) / 4 := by
    have h_trace_det : Matrix.trace (pairBloch e u v) = 1 ∧ Matrix.det (pairBloch e u v) = (1 - (blochRadius e u v)^2) / 4 := by
      unfold pairBloch blochRadius; norm_num [ Complex.ext_iff, sq ] ; ring;
      exact ⟨ trivial, by rw [ Real.sq_sqrt <| by positivity ] ; ring, trivial ⟩;
    have h_eigenvalues_sum : ∑ i, Matrix.IsHermitian.eigenvalues (pairBloch_isHermitian e u v) i = 1 := by
      have := Matrix.IsHermitian.trace_eq_sum_eigenvalues ( pairBloch_isHermitian e u v );
      norm_num [ Complex.ext_iff ] at * ; linarith!;
    have h_eigenvalues_prod : ∏ i, Matrix.IsHermitian.eigenvalues (pairBloch_isHermitian e u v) i = (1 - (blochRadius e u v)^2) / 4 := by
      have := Matrix.IsHermitian.det_eq_prod_eigenvalues ( pairBloch_isHermitian e u v );
      rw [ ← Complex.ofReal_inj ] ; aesop;
    simp_all +decide [ Fin.sum_univ_two, Fin.prod_univ_two ];
  obtain ⟨lam0, lam1, hlam0, hlam1, hsum, hprod⟩ := h_eigenvalues
  have h_eigenvalues_eq : lam0 = (1 + blochRadius e u v) / 2 ∧ lam1 = (1 - blochRadius e u v) / 2 ∨ lam0 = (1 - blochRadius e u v) / 2 ∧ lam1 = (1 + blochRadius e u v) / 2 := by
    grind;
  have hbin : Real.binEntropy ((1 + blochRadius e u v) / 2)
      = Real.negMulLog ((1 + blochRadius e u v) / 2)
        + Real.negMulLog ((1 - blochRadius e u v) / 2) := by
    have harg : (1 : ℝ) - (1 + blochRadius e u v) / 2 = (1 - blochRadius e u v) / 2 := by ring
    rw [Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub, harg]
  rw [Fin.sum_univ_two, hlam0, hlam1, radialEntropy, hbin]
  rcases h_eigenvalues_eq with (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩) <;> ring

/-- **Canonical corollary.** The same Bridge-1 identity stated over the
repository's canonical `QubitFixedEnergyMaxEntropy.pairBloch` and
`VNEntropyPurity.vonNeumannEntropy` (the local defs above are byte-identical, so
this holds by definitional transport; `IsHermitian` proofs match by proof
irrelevance). Removes the local-vs-canonical gap. -/
theorem pairEntropy_eq_vonNeumannEntropy_canonical (e u v : Real) :
    VNEntropyPurity.vonNeumannEntropy
        (QubitFixedEnergyMaxEntropy.pairBloch e u v)
        (QubitFixedEnergyMaxEntropy.pairBloch_isHermitian e u v)
      = QubitFixedEnergyMaxEntropy.pairEntropy e u v :=
  pairEntropy_eq_vonNeumannEntropy e u v

end PhysicsSM.Draft.NullEdge.QubitEntropyBridge

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy

/--
info: 'PhysicsSM.Draft.NullEdge.QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy_canonical' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy_canonical
