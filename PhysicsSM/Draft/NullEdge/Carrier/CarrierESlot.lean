import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster

/-!
# Move-1 BRICK E-slot - the soldering-gradient (gravity) remainder

Makes the `E = 0` regime of the assembly an honest THEOREM rather than a scoping note
(Fable-5 call-02 CRACK 2). Without assuming `hcomm` (soldering commutes with transport),
the soldered square carries an extra **soldering-gradient defect** term `E`:

>   `4 • D0^2 = Q_A + Q_C + 4 • E`,
>   `E = sum_e sum_f gamma_e (nabla_e gamma_f - gamma_f nabla_e) nabla_f`.

`E` is the discrete spin-connection / tetrad-gradient (gravity) slot of the generalized
Lichnerowicz formula (arXiv:hep-th/9503153); it vanishes termwise when `hcomm`
holds (constant soldering), recovering `weitzenbock_master`. On a torus with
position-dependent soldering `gamma_f = M(gamma-field)`, `nabla_e gamma_f - gamma_f nabla_e`
is the covariant lattice gradient of the frame (the discrete tetrad postulate).

## Scope / honesty (draft)

Abstract algebra over a `CommRing`. `soldered_square_defect` is a hypothesis-free ring
identity; `weitzenbock_master_varying` drops `hcomm` and names `E`. NO Krein `#`, NO
positivity. The positive/geometric characterization of `E` (tetrad postulate) is a
separate torus theorem. Provenance: Fable-5 call-02.

Proof handoff (for Aristotle):
- `soldered_square_defect`: pure ring identity, no hypotheses. Expand
  `(sum_e gamma_e nabla_e)^2 = sum_e sum_f gamma_e nabla_e gamma_f nabla_f`
  (`Finset.sum_mul_sum`, `pow_two`); insert-and-subtract `gamma_e gamma_f nabla_e nabla_f`
  in each term: `gamma_e nabla_e gamma_f nabla_f = gamma_e gamma_f nabla_e nabla_f
  + gamma_e (nabla_e gamma_f - gamma_f nabla_e) nabla_f`; then `Finset.sum_add_distrib`.
- `weitzenbock_master_varying`: from `soldered_square_defect`, apply the pure ring
  4-split (the SAME identity used in `weitzenbock_master`) to the first sum
  `sum_e sum_f gamma_e gamma_f (nabla_e nabla_f)` to get `Q_A + Q_C` (reuse
  `sum_sym_antisym_zero`/`sum_antisym_sym_zero` + `hcl`), leaving `4 • E` from the
  defect sum. No `hcomm` anywhere. The hard step is shared with the banked master proof.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- The named `E`-slot: the soldering-gradient defect measuring failure of the
soldering generators to commute with transport.  In the discrete-teleparallel
reading this is the algebraic frame-gradient remainder; no positivity or
continuum field equation is asserted here. -/
def solderingGradientDefect (gamma nabla : E → B) : B :=
  ∑ e, ∑ f, gamma e * (nabla e * gamma f - gamma f * nabla e) * nabla f

/-- **The soldering-gradient defect identity** (hypothesis-free).  The soldered square
splits into the `gamma`-ordered block plus the frame-gradient defect
`gamma_e (nabla_e gamma_f - gamma_f nabla_e) nabla_f`. -/
theorem soldered_square_defect (gamma nabla : E → B) :
    (solderedNC gamma nabla) ^ 2
      = (∑ e, ∑ f, gamma e * gamma f * (nabla e * nabla f))
        + solderingGradientDefect gamma nabla := by
  simp only [solderedNC, solderingGradientDefect, pow_two, Finset.sum_mul_sum]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro e _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro f _
  noncomm_ring

/-- The `E`-slot vanishes under constant soldering.  This is the exact finite
version of the "discrete tetrad postulate" used by the carrier assembly: if each
`gamma f` commutes with each transport `nabla e`, the soldering-gradient defect
has no contribution. -/
theorem solderingGradientDefect_eq_zero_of_comm (gamma nabla : E → B)
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e) :
    solderingGradientDefect gamma nabla = 0 := by
  unfold solderingGradientDefect
  apply Finset.sum_eq_zero
  intro e _
  apply Finset.sum_eq_zero
  intro f _
  have h : nabla e * gamma f = gamma f * nabla e := (hcomm f e).symm
  simp [h]

/-- **The E-carrying (varying-soldering) master identity.**  Dropping `hcomm`, the
soldered square is `Q_A + Q_C` plus the soldering-gradient gravity slot `4 • E`.  With
`hcomm` the defect vanishes termwise and this reduces to `weitzenbock_master`. -/
theorem weitzenbock_master_varying (gamma nabla : E → B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f)) :
    (4 : R) • (solderedNC gamma nabla) ^ 2
      = (∑ e, ∑ f, g e f • (nabla e * nabla f + nabla f * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (nabla e * nabla f - nabla f * nabla e))
        + (4 : R) • solderingGradientDefect gamma nabla := by
  rw [soldered_square_defect, smul_add]
  congr 1
  -- Remaining goal: `4 • (∑ e ∑ f gamma e * gamma f * (nabla e * nabla f)) = Q_A + Q_C`.
  -- This is exactly the `hcl`-only half of `weitzenbock_master` (no `hcomm`).
  have hsum : ∑ e, ∑ f, (4 : R) • ((gamma e * gamma f) * (nabla e * nabla f)) =
    (∑ e, ∑ f, (gamma e * gamma f + gamma f * gamma e) * (nabla e * nabla f + nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f + gamma f * gamma e) * (nabla e * nabla f - nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e) * (nabla e * nabla f + nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e) * (nabla e * nabla f - nabla f * nabla e)) := by
      simp +decide only [← Finset.sum_add_distrib] ; congr ; ext e ; congr ; ext f ; ring;
      simp +decide only [mul_add, add_mul, mul_sub, sub_mul] ; abel_nf;
      norm_cast;
  have hstep : (4 : R) • (∑ e, ∑ f, gamma e * gamma f * (nabla e * nabla f))
      = ∑ e, ∑ f, (4 : R) • ((gamma e * gamma f) * (nabla e * nabla f)) := by
    rw [Finset.smul_sum]; apply Finset.sum_congr rfl; intro e _; rw [Finset.smul_sum]
  rw [hstep, hsum]
  simp +decide only [Algebra.smul_def, hcl];
  simp +decide [ add_assoc, sum_antisym_sym_zero ];
  exact sum_sym_antisym_zero _ _ fun e f => by simp +decide [ ← hcl ] ; abel

end PhysicsSM.Draft.NullEdge.Carrier
