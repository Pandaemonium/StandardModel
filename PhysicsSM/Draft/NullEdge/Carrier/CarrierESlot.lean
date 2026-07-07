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
Lichnerowicz formula (arXiv:hep-th/9503153); it vanishes termwise exactly when `hcomm`
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

/-- **The soldering-gradient defect identity** (hypothesis-free).  The soldered square
splits into the `gamma`-ordered block plus the frame-gradient defect
`gamma_e (nabla_e gamma_f - gamma_f nabla_e) nabla_f`. -/
theorem soldered_square_defect (gamma nabla : E → B) :
    (solderedNC gamma nabla) ^ 2
      = (∑ e, ∑ f, gamma e * gamma f * (nabla e * nabla f))
        + (∑ e, ∑ f, gamma e * (nabla e * gamma f - gamma f * nabla e) * nabla f) := by
  sorry

/-- **The E-carrying (varying-soldering) master identity.**  Dropping `hcomm`, the
soldered square is `Q_A + Q_C` plus the soldering-gradient gravity slot `4 • E`.  With
`hcomm` the defect vanishes termwise and this reduces to `weitzenbock_master`. -/
theorem weitzenbock_master_varying (gamma nabla : E → B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f)) :
    (4 : R) • (solderedNC gamma nabla) ^ 2
      = (∑ e, ∑ f, g e f • (nabla e * nabla f + nabla f * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (nabla e * nabla f - nabla f * nabla e))
        + (4 : R) • (∑ e, ∑ f, gamma e * (nabla e * gamma f - gamma f * nabla e) * nabla f) := by
  sorry

end PhysicsSM.Draft.NullEdge.Carrier
