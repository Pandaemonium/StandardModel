import Mathlib

/-!
# Qubit fixed-energy maximum entropy

Focused `DYN-MODULAR-001` target. The intended mathematical statement is the
full two-level density-matrix variational geometry, not a commuting-only
restriction: fixing the expectation of `sigmaX` fixes the longitudinal Bloch
coordinate, while transverse coordinates can only increase the Bloch radius
and lower binary entropy.

The target deliberately separates three layers:

1. exact `2 x 2` Bloch-matrix identities;
2. strict entropy maximization on the whole Bloch ball at fixed energy;
3. the equality condition, which removes every transverse coherence.

The later in-repository composition must still identify this radial entropy
with `VonNeumannEntropyBound.vonNeumannEntropy` and the unique optimizer with
the normalized Gibbs state of the supplied Pluecker pair generator.

Reference search: Mathlib `Real.binEntropy_strictAntiOn`; PhysLean
`CanonicalEnsemble.twoState_entropy_eq` is only an informal declaration in the
consulted version and is not imported or copied.

## Trust and provenance

Draft-trust by kernel: all displayed theorems are proof-hole-free. The focused
statement set was independently attacked by Aristotle audit project `8fd19c81`,
which found no sign error, hidden commuting restriction, positivity-boundary
omission, or entropy-equality loophole. Proof search was Aristotle project
`4ef06d09`; Codex compared the returned statements with the preregistered target
and replayed the result under the pinned toolchain.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy

open Matrix Set
open scoped ComplexOrder

/-- The Pauli X generator, equal to the live pair block `Bz 1`. -/
def sigmaX : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]

/-- A trace-one Hermitian qubit matrix in Bloch coordinates. The coordinate
`e` is longitudinal to `sigmaX`; `u` and `v` are transverse. -/
def pairBloch (e u v : Real) : Matrix (Fin 2) (Fin 2) Complex :=
  (2 : Complex)⁻¹ •
    !![((1 + v : Real) : Complex), (e : Complex) - Complex.I * (u : Complex);
       (e : Complex) + Complex.I * (u : Complex), ((1 - v : Real) : Complex)]

/-- Euclidean Bloch radius. -/
def blochRadius (e u v : Real) : Real := Real.sqrt (e ^ 2 + u ^ 2 + v ^ 2)

/-- Qubit entropy as binary entropy of the larger eigenvalue. -/
def radialEntropy (r : Real) : Real := Real.binEntropy ((1 + r) / 2)

/-- Entropy of the Bloch-coordinate qubit. -/
def pairEntropy (e u v : Real) : Real := radialEntropy (blochRadius e u v)

/-- A `2 x 2` real quadratic-form nonnegativity certificate, square-root free.
With `a = 1 + v`, `b = 1 - v`, `p = |z|²`, `q = |w|²`, `s + i t = conj z * w`,
this is exactly the positivity of the Bloch quadratic form. -/
lemma quad_form_nonneg (a b p q s t e u : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hp : 0 ≤ p) (hq : 0 ≤ q) (hst : s ^ 2 + t ^ 2 ≤ p * q) (heu : e ^ 2 + u ^ 2 ≤ a * b) :
    0 ≤ a * p + b * q + 2 * (e * s + u * t) := by
  have hab : 0 ≤ a * b := mul_nonneg ha hb
  have hpq : 0 ≤ p * q := mul_nonneg hp hq
  have hst0 : 0 ≤ s ^ 2 + t ^ 2 := by positivity
  have hcs : (e * s + u * t) ^ 2 ≤ (e ^ 2 + u ^ 2) * (s ^ 2 + t ^ 2) := by
    nlinarith [sq_nonneg (e * t - u * s)]
  have h2 : (e ^ 2 + u ^ 2) * (s ^ 2 + t ^ 2) ≤ (a * b) * (s ^ 2 + t ^ 2) := by nlinarith
  have h3 : (a * b) * (s ^ 2 + t ^ 2) ≤ (a * b) * (p * q) := by nlinarith
  have h4 : 4 * ((a * b) * (p * q)) ≤ (a * p + b * q) ^ 2 := by
    nlinarith [sq_nonneg (a * p - b * q)]
  have hkey : 4 * (e * s + u * t) ^ 2 ≤ (a * p + b * q) ^ 2 := by nlinarith
  have hS : 0 ≤ a * p + b * q := by positivity
  nlinarith [hkey, hS, sq_nonneg (a * p + b * q + 2 * (e * s + u * t)),
    sq_nonneg (a * p + b * q - 2 * (e * s + u * t))]

/-- The Bloch matrix is Hermitian without any commuting assumption. -/
theorem pairBloch_isHermitian (e u v : Real) :
    (pairBloch e u v).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ pairBloch, Complex.ext_iff ] ;

/-- Every Bloch matrix in this family has trace one. -/
theorem pairBloch_trace (e u v : Real) :
    (pairBloch e u v).trace = 1 := by
  norm_num [ pairBloch ];
  ring

/-- The variational family exhausts all Hermitian trace-one qubit matrices. -/
theorem pairBloch_surjective (rho : Matrix (Fin 2) (Fin 2) Complex)
    (hrho : rho.IsHermitian) (htrace : rho.trace = 1) :
    ∃ e u v : Real, rho = pairBloch e u v := by
  simp_all +decide [ Fin.sum_univ_two, Matrix.trace ];
  obtain ⟨e, u, v, h_rho⟩ : ∃ e u v : ℝ, rho 0 0 = (1 + v) / 2 ∧ rho 1 1 = (1 - v) / 2 ∧ rho 0 1 = (e - Complex.I * u) / 2 ∧ rho 1 0 = (e + Complex.I * u) / 2 := by
    obtain ⟨e, u, h_rho⟩ : ∃ e u : ℝ, rho 0 1 = (e - Complex.I * u) / 2 := by
      exact ⟨ rho 0 1 |> Complex.re * 2, -rho 0 1 |> Complex.im * 2, by simp +decide [ Complex.ext_iff ] ⟩;
    refine ⟨ e, u, ( rho 0 0 |> Complex.re ) * 2 - 1, ?_, ?_, h_rho, ?_ ⟩ <;>
      norm_num [ Complex.ext_iff ] at *;
    · have := congr_fun ( congr_fun hrho 0 ) 0; norm_num [ Complex.ext_iff ] at this; linarith;
    · have := congr_fun ( congr_fun hrho 1 ) 1; norm_num [ Complex.ext_iff ] at this; constructor <;> linarith;
    · have := congr_fun ( congr_fun hrho 1 ) 0; norm_num [ Complex.ext_iff ] at this; constructor <;> linarith;
  exact ⟨ e, u, v, by ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, pairBloch ] <;> ring ⟩

/-- On the Bloch ball, the family consists of genuine density matrices
(positive semidefinite). -/
theorem pairBloch_posSemidef (e u v : Real) (hball : e ^ 2 + u ^ 2 + v ^ 2 <= 1) :
    (pairBloch e u v).PosSemidef := by
  refine ⟨ ?_, ?_ ⟩
  · grind +suggestions;
  · intro x
    simp [pairBloch];
    norm_num [ Finsupp.sum_fintype, Fin.sum_univ_succ ];
    convert quad_form_nonneg ( 1 + v ) ( 1 - v ) ( Complex.normSq ( x 0 ) ) ( Complex.normSq ( x 1 ) ) ( Complex.re ( star ( x 0 ) * x 1 ) ) ( Complex.im ( star ( x 0 ) * x 1 ) ) e u ?_ ?_ ?_ ?_ ?_ ?_ using 1 <;> norm_num [ Complex.normSq, Complex.ext_iff ];
    any_goals nlinarith;
    norm_num [ Complex.ext_iff, Complex.le_def ] ; ring_nf;
    exact ⟨ fun h => by linarith, fun h => ⟨ by linarith, trivial ⟩ ⟩

/-- Positive semidefiniteness is exactly the Bloch-ball condition. -/
theorem pairBloch_posSemidef_iff (e u v : Real) :
    (pairBloch e u v).PosSemidef <-> e ^ 2 + u ^ 2 + v ^ 2 <= 1 := by
  refine ⟨ ?_, fun h => pairBloch_posSemidef e u v h ⟩
  intro hpsd
  have h_det : (pairBloch e u v).det = (((1 - (e ^ 2 + u ^ 2 + v ^ 2)) / 4 : ℝ) : ℂ) := by
    rw [Matrix.det_fin_two, pairBloch]
    simp only [Matrix.smul_apply, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one, smul_eq_mul]
    have hI : Complex.I * Complex.I = -1 := Complex.I_mul_I
    push_cast
    linear_combination (2⁻¹ * 2⁻¹ * (u : ℂ) ^ 2) * hI
  have hdet := hpsd.det_nonneg
  rw [h_det] at hdet
  norm_cast at hdet
  linarith

/-- The expectation of `sigmaX` is exactly the longitudinal coordinate `e`. -/
theorem pairBloch_sigmaX_expectation (e u v : Real) :
    ((pairBloch e u v) * sigmaX).trace.re = e := by
  unfold pairBloch sigmaX; norm_num [ Matrix.mul_apply, Matrix.trace ] ; ring;

/-- The longitudinal radius is no larger than the full Bloch radius. -/
theorem abs_longitudinal_le_radius (e u v : Real) :
    |e| <= blochRadius e u v := by
  exact Real.abs_le_sqrt ( by nlinarith [ sq_nonneg u, sq_nonneg v ] )

/-- On the Bloch ball, radial entropy is maximized by removing transverse
coherences while preserving the displayed nontrivial energy expectation. -/
theorem pairEntropy_le_fixedEnergy (e u v : Real)
    (hball : e ^ 2 + u ^ 2 + v ^ 2 <= 1) :
    pairEntropy e u v <= pairEntropy e 0 0 := by
  -- Let `r := blochRadius e u v = Real.sqrt (e^2+u^2+v^2)` and `r0 := blochRadius e 0 0`.
  set r := blochRadius e u v
  set r0 := blochRadius e 0 0;
  -- By definition of $r$ and $r0$, we know that $r0 \leq r$ and $0 \leq r0 \leq 1$.
  have hr0_le_r : r0 ≤ r := by
    exact Real.sqrt_le_sqrt <| by nlinarith;
  have hr0_nonneg : 0 ≤ r0 := by
    exact Real.sqrt_nonneg _
  have hr_nonneg : 0 ≤ r := by
    exact Real.sqrt_nonneg _
  have hr_le_one : r ≤ 1 := by
    exact Real.sqrt_le_iff.mpr ⟨ by positivity, by linarith ⟩;
  -- Apply the strict decreasing property of the binary entropy function.
  have h_entropy_decreasing : StrictAntiOn Real.binEntropy (Set.Icc (1 / 2) 1) := by
    convert Real.binEntropy_strictAntiOn using 1 ; norm_num [ StrictAntiOn ];
  exact h_entropy_decreasing.antitoneOn ⟨ by linarith, by linarith ⟩ ⟨ by linarith, by linarith ⟩ ( by linarith )

/-- Strict uniqueness: equality at fixed energy occurs exactly when both
transverse coordinates vanish. This is the anti-hollow control. -/
theorem pairEntropy_eq_fixedEnergy_iff (e u v : Real)
    (hball : e ^ 2 + u ^ 2 + v ^ 2 <= 1) :
    pairEntropy e u v = pairEntropy e 0 0 <-> u = 0 ∧ v = 0 := by
  constructor <;> intro h;
  · -- From the equality of entropies, we get $r = r_0$, i.e., $\sqrt{e^2 + u^2 + v^2} = \sqrt{e^2}$.
    have hr : Real.sqrt (e^2 + u^2 + v^2) = Real.sqrt (e^2) := by
      have h_eq : (1 + Real.sqrt (e^2 + u^2 + v^2)) / 2 = (1 + Real.sqrt (e^2)) / 2 := by
        apply StrictAntiOn.injOn ( Real.binEntropy_strictAntiOn );
        · constructor <;> norm_num <;> nlinarith [ Real.sqrt_nonneg ( e ^ 2 + u ^ 2 + v ^ 2 ), Real.mul_self_sqrt ( by positivity : 0 ≤ e ^ 2 + u ^ 2 + v ^ 2 ) ];
        · constructor <;> nlinarith [ Real.sqrt_nonneg ( e ^ 2 ), Real.mul_self_sqrt ( sq_nonneg e ), show e ^ 2 ≤ 1 by nlinarith ];
        · convert h using 1;
          unfold pairEntropy radialEntropy blochRadius; norm_num;
      linarith;
    rw [ Real.sqrt_inj ( by positivity ) ( by positivity ) ] at hr ; constructor <;> nlinarith;
  · aesop

/-- Noncommuting strict control at zero energy: a transverse pure direction
has strictly less entropy than the zero-energy maximizer. -/
theorem transverse_strict_control :
    pairEntropy 0 1 0 < pairEntropy 0 0 0 := by
  have h1 : pairEntropy 0 1 0 = 0 := by
    unfold pairEntropy radialEntropy blochRadius; norm_num
  have h2 : (0 : ℝ) < pairEntropy 0 0 0 := by
    unfold pairEntropy radialEntropy blochRadius
    norm_num
    exact Real.binEntropy_pos (by norm_num) (by norm_num)
  rw [h1]; exact h2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy.pairBloch_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairBloch_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy.pairBloch_posSemidef_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairBloch_posSemidef_iff

/-- info: 'PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy.pairEntropy_eq_fixedEnergy_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairEntropy_eq_fixedEnergy_iff

/-- info: 'PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy.transverse_strict_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transverse_strict_control

end PhysicsSM.Draft.NullEdge.QubitFixedEnergyMaxEntropy
