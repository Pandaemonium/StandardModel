import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster

/-!
# Move-1 BRICK - the PAIR master identity (Krein-enabling generalization of brick 2b)

Generalizes `weitzenbock_master` (brick 2b) from `D0^2` to a bilinear pairing of two
independent transport families `m, n : E -> B`. The point (Fable-5 call-02 CRACK): the
banked cross-cancellation lemmas `sum_sym_antisym_zero` / `sum_antisym_sym_zero` are
already stated for ARBITRARY `F G : E -> E -> B`, so the master proof re-runs verbatim
with `G e f := m e * n f`. Setting `m e := star (nabla e)`, `n := nabla` this becomes
the Krein square `star D0 * D0` - the bridge from `D0^2` to `D0^# D0`.

>   `4 • ((sum_e m_e gamma_e) * (sum_f gamma_f n_f))`
>     `= sum_e sum_f g e f • (m_e n_f + m_f n_e)`              -- Q_A(m,n)
>     `+ sum_e sum_f [gamma_e,gamma_f] (m_e n_f - m_f n_e)`    -- Q_C(m,n)

Diagonal `m = n = nabla` recovers `weitzenbock_master` (via `hcomm` to flip
`nabla_e gamma_e`). The `m_e n_f + m_f n_e` block for `m = star nabla`, `n = nabla` is a
sum of `star X * X`-shaped terms - the positivity-carrying `Q_A^#` the Krein brick needs.

## Scope / honesty (draft)

Abstract algebraic identity over a `CommRing`; `gamma, m, n, g` arbitrary satisfying
`hcl` + the two commutation hypotheses. NO Krein `#` here yet - this is the algebraic
generalization that MAKES the `#` upgrade a corollary. Provenance: Fable-5 call-02.

Proof handoff (for Aristotle): this is a near-verbatim re-run of the `weitzenbock_master`
proof in `WeitzenbockMaster.lean`, replacing `nabla e * nabla f` by `m e * n f`:
- (1) expand `(sum_e m_e gamma_e)(sum_f gamma_f n_f) = sum_e sum_f m_e gamma_e gamma_f n_f`
  (`Finset.sum_mul_sum`); this already has `gamma_e gamma_f` in the middle (no `hcomm`
  needed to bring the two gammas together - that is the whole reason the pair form is
  clean). Use `hcommM`/`hcommN` only to position `m_e` left and `n_f` right.
- (2) the pure ring identity `4 (m gg n) = ...` splitting `gamma_e gamma_f` into
  `{gamma_e,gamma_f}` + `[gamma_e,gamma_f]` and pairing with the sym/antisym of
  `(m_e n_f, m_f n_e)`; apply the two banked cancellation lemmas `sum_sym_antisym_zero`
  (with `F := fun e f => algebraMap (g e f)` central, `G := fun e f => m e * n f`) and
  `sum_antisym_sym_zero` for the cross terms; rewrite `{gamma_e,gamma_f} = algebraMap (g e f)`
  via `hcl` for the `Q_A` block. The one fiddly step is again the index-swap in the
  cancellation lemmas - but those lemmas are ALREADY PROVED and general; just apply them.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- **The pair master identity.**  A bilinear generalization of `weitzenbock_master`:
for two transport families `m, n` each commuting with the soldered generators, the
soldered bilinear form `(sum_e m_e gamma_e)(sum_f gamma_f n_f)` decomposes into the
aperture block (symmetric in `m,n`, weighted by the Gram datum `g`) plus the closure
block (the Clifford commutators against the `m,n`-antisymmetrization). -/
theorem weitzenbock_master_pair (gamma m n : E → B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcommM : ∀ e f, gamma e * m f = m f * gamma e)
    (hcommN : ∀ e f, gamma e * n f = n f * gamma e) :
    (4 : R) • ((∑ e, m e * gamma e) * (∑ f, gamma f * n f))
      = (∑ e, ∑ f, g e f • (m e * n f + m f * n e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (m e * n f - m f * n e)) := by
  sorry

end PhysicsSM.Draft.NullEdge.Carrier
