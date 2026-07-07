import Mathlib

/-!
# Move-1 BRICK 2b - the abstract discrete Weitzenbock master identity

**The heart of Move 1 of the null-edge Weitzenbock-carrier program.**

Working in a SINGLE associative algebra `B` (no tensor product), with abstract
soldered Clifford generators `gamma e` and covariant differences `nabla e`, the
square of the soldered operator `D0 = sum_e gamma e * nabla e` splits into exactly
two graded pieces:

* a **symmetric x symmetric** part built from the Gram/polar data `g` and the
  anticommutators of the `nabla` - the **aperture form `Q_A`**;
* an **antisymmetric x antisymmetric** part built from the Clifford commutators and
  the transport commutators `[nabla e, nabla f]` - the **closure form `Q_C`**.

The sym x antisym cross terms cancel identically (a scalar-times-antisymmetric sum
over an unordered index pair), so:

>   `4 • D0^2 = sum_e sum_f g e f • {nabla e, nabla f}`
>             `+ sum_e sum_f [gamma e, gamma f] * [nabla e, nabla f]`

where `{a,b} = a*b + b*a` and `[a,b] = a*b - b*a`. The `4 •` on the left keeps the
identity **fully characteristic-free** (no division, any `CommRing R`, any `Ring B`).

## Why this is the master brick

- Landed brick 2a (`SolderedSquareGram`) is the COROLLARY `[nabla e, nabla f] = 0
  ==> Q_C = 0` (commuting/scalar weights kill the closure term). This module is the
  general statement of which 2a is the flat shadow - the right dependency direction.
- The two structural hypotheses are exactly: `hcl` (Clifford anticommutator = the
  scalar polar/Gram datum `g`) and `hcomm` (soldering commutes with transport,
  `[gamma e, nabla f] = 0`). Only `hcomm` is a genuine geometric axiom; on the
  intended `Z2 x Z2` gauge-torus model it is `add_comm` of the shifts (kernel-free).

## Provenance

Structure from the Fable-5 call-01 CRACK (`AgentTasks/twoday-carrier-run-2026-07-07/
fable-calls/call-01-packet.md` + the logged answer); the fully characteristic-free
`4 •` symmetrized form was verified by hand and is shipped in preference to the
displayed char-free ordered form (which carried a diagonal factor slip). Continuum
backing: the generalized Lichnerowicz formula (arXiv:hep-th/9503153), where the
curvature endomorphism is the `Q_C` term; discrete home: gauge networks
(arXiv:1301.3480).

## Scope / honesty (draft)

Abstract algebraic identity over a `CommRing`; `gamma`, `nabla`, `g` are arbitrary
data satisfying `hcl`/`hcomm`. NO Krein `#`-adjoint, NO potential, NO 2-complex yet -
those are later bricks. `Q_A`/`Q_C` here are the grade-0/grade-2 blocks named by the
program; identifying them with the lane functionals is Move-2.

Proof handoff (for Aristotle):
- Goal: the displayed identity.
- Route: (1) `D0^2 = sum_e sum_f gamma e * gamma f * (nabla e * nabla f)` using
  `hcomm` to move each `nabla e` left past `gamma f` (`Finset.sum_mul_sum` then
  `hcomm`); (2) write `gamma e * gamma f = 2⁻¹`-free via the split
  `4 (ab)(cd) = {a,b}{c,d} + {a,b}[c,d] + [a,b]{c,d} + [a,b][c,d]` applied with
  `a=gamma e, b=gamma f, c=nabla e, d=nabla f` (pure ring identity, `ring`/`noncomm_ring`);
  (3) the two mixed sums vanish under `Finset.sum` swap `e <-> f` (each is a
  scalar-symmetric times antisymmetric, or antisymmetric times symmetric, block:
  use `Finset.sum_comm`/an involution and `hcl` to see `{gamma e, gamma f}` is central);
  (4) `{gamma e, gamma f} = algebraMap (g e f)` via `hcl`, and pull the central scalar
  out to `g e f • {nabla e, nabla f}`. The one genuinely fiddly step is (3) - the
  cross-term cancellation via the index-swap involution.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- The soldered operator `D0 = sum_e gamma e * nabla e` for abstract soldered
Clifford generators `gamma` and covariant differences `nabla` in one algebra `B`. -/
def solderedNC (gamma nabla : E → B) : B := ∑ e, gamma e * nabla e

/-
A double sum of `(symmetric F) * (antisymmetrized G)` vanishes, characteristic-free
(no factor of `2` is inverted): the two halves become equal after relabelling `e ↔ f`.
-/
lemma sum_sym_antisym_zero (F G : E → E → B) (hF : ∀ e f, F e f = F f e) :
    (∑ e, ∑ f, F e f * (G e f - G f e)) = 0 := by
  simp +decide [ mul_sub, Finset.sum_sub_distrib ];
  rw [ ← Finset.sum_comm ] ; exact sub_eq_zero_of_eq ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ hF ] ) ;

/-
A double sum of `(antisymmetric F) * (symmetrized G)` vanishes, characteristic-free.
-/
lemma sum_antisym_sym_zero (F G : E → E → B) (hF : ∀ e f, F e f = - F f e) :
    (∑ e, ∑ f, F e f * (G e f + G f e)) = 0 := by
  simp +decide [ mul_add, Finset.sum_add_distrib ];
  rw [ add_eq_zero_iff_eq_neg ];
  rw [ ← Finset.sum_neg_distrib, ← Finset.sum_comm ];
  exact Finset.sum_congr rfl fun i hi => by rw [ ← Finset.sum_neg_distrib ] ; exact Finset.sum_congr rfl fun j hj => by rw [ hF ] ; simp +decide ;

/-
**The discrete Weitzenbock master identity (brick 2b).**  With the Clifford
anticommutator relation `hcl` (the anticommutator of two soldered generators is the
central scalar image of the Gram/polar datum `g e f`) and the soldering-transport
commutation `hcomm` (`gamma e` commutes with every `nabla f`), the square of the
soldered operator decomposes as the aperture `Q_A` block (symmetric, built from `g`
and the `nabla`-anticommutators) plus the closure `Q_C` block (the product of the
Clifford commutators with the transport commutators):

`4 • D0^2 = sum_e sum_f g e f • (nabla e * nabla f + nabla f * nabla e)
          + sum_e sum_f (gamma e * gamma f - gamma f * gamma e)
                        * (nabla e * nabla f - nabla f * nabla e).`

Characteristic-free (the `4 •` avoids all division).
-/
theorem weitzenbock_master (gamma nabla : E → B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e) :
    (4 : R) • (solderedNC gamma nabla) ^ 2
      = (∑ e, ∑ f, g e f • (nabla e * nabla f + nabla f * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (nabla e * nabla f - nabla f * nabla e)) := by
  -- Apply the noncommutative ring identity to each term in the sum.
  have hsum : ∑ e, ∑ f, (4 : R) • ((gamma e * gamma f) * (nabla e * nabla f)) =
    (∑ e, ∑ f, (gamma e * gamma f + gamma f * gamma e) * (nabla e * nabla f + nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f + gamma f * gamma e) * (nabla e * nabla f - nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e) * (nabla e * nabla f + nabla f * nabla e)) +
    (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e) * (nabla e * nabla f - nabla f * nabla e)) := by
      simp +decide only [← Finset.sum_add_distrib] ; congr ; ext e ; congr ; ext f ; ring;
      simp +decide only [mul_add, add_mul, mul_sub, sub_mul] ; abel_nf;
      norm_cast;
  convert hsum using 1;
  · simp +decide only [solderedNC, pow_two];
    simp +decide only [Finset.sum_mul _ _ _, Finset.mul_sum];
    simp +decide only [Finset.smul_sum];
    refine' Finset.sum_congr rfl fun e _ => Finset.sum_congr rfl fun f _ => _;
    grind;
  · simp +decide only [Algebra.smul_def, hcl];
    simp +decide [ add_assoc, sum_antisym_sym_zero ];
    exact sum_sym_antisym_zero _ _ fun e f => by simp +decide [ ← hcl ] ; abel;

end PhysicsSM.Draft.NullEdge.Carrier
